/// Reading a bank's text message as a spend.
///
/// In Iran, and in much of the world, every card payment is followed within
/// seconds by a text from the bank. Those messages already say what was
/// spent, so the person should not have to type it again. They are read on
/// the phone, never sent anywhere, and only ever turned into a *suggestion*:
/// nothing is recorded until the person taps to record it, because a parser
/// that guesses wrong must not be able to move the figure on Home.
///
/// Banks do not share a format, so this looks for the few things they all
/// say: a word for money going out, an amount, and often a balance that must
/// not be mistaken for the amount.
library;

import '../engine/money.dart';

/// What a bank message said was spent.
class BankSpend {
  const BankSpend(this.amount);
  final Money amount;
}

/// Money going out, in the words banks use.
final _debit = RegExp(
  r'برداشت|خرید|پرداخت|انتقال\s*از|کسر|'
  r'debit|debited|purchase|withdraw|spent|paid|payment|pos\b',
  caseSensitive: false,
);

/// Money coming in. A message that says only this is not a spend.
final _credit = RegExp(
  r'واریز|افزایش|دریافت|credit|credited|deposit|received|refund',
  caseSensitive: false,
);

/// Lines that carry a balance rather than the amount moved.
final _balance = RegExp(
  r'مانده|موجودی|balance|\bbal\b|avl|available',
  caseSensitive: false,
);

final _amount = RegExp(r'(\d{1,3}(?:,\d{3})+|\d+)(?:\.(\d{1,3}))?');

/// Persian and Arabic-Indic digits to ASCII, and their separators to commas.
String _normalise(String s) {
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final out = StringBuffer();
  for (final ch in s.split('')) {
    final p = persian.indexOf(ch);
    final a = arabic.indexOf(ch);
    if (p >= 0) {
      out.write(p);
    } else if (a >= 0) {
      out.write(a);
    } else if (ch == '٬' || ch == '،') {
      out.write(',');
    } else if (ch == '٫') {
      out.write('.');
    } else {
      out.write(ch);
    }
  }
  return out.toString();
}

/// The spend a message describes, in [planCurrency], or null when it does
/// not describe one this plan can record: not a debit, no amount, or an
/// amount in some other currency.
BankSpend? parseBankSms(String body, {required String planCurrency}) {
  final text = _normalise(body);
  // Each line up to where it starts talking about a balance. A line that
  // is only a balance becomes empty, and one that says "spent 45, balance
  // 1,200" keeps only the part about the spend.
  final lines = text
      .split(RegExp(r'[\n\r]+'))
      .map((l) {
        final b = _balance.firstMatch(l);
        return (b == null ? l : l.substring(0, b.start)).trim();
      })
      .toList();
  if (lines.every((l) => l.isEmpty)) return null;

  final debitLine = lines.indexWhere(_debit.hasMatch);
  // A minus sign next to a number marks money out in several banks' texts,
  // with no word for it at all.
  final minusLine = lines.indexWhere(
    (l) => RegExp(r'(^|[\s:])-\s?\d|\d\s?-(\s|$)').hasMatch(l),
  );
  if (debitLine < 0 && minusLine < 0) return null;
  // A bare minus sign in a message that also talks of money coming in is
  // too ambiguous to suggest.
  if (debitLine < 0 && _credit.hasMatch(text)) return null;

  // The amount is on the line that says money went out, or the line after
  // it when the bank puts the label and the figure on separate lines.
  final start = debitLine >= 0 ? debitLine : minusLine;
  String? figure;
  for (var i = start; i < lines.length && i <= start + 1; i++) {
    if (lines[i].isEmpty) break;
    // Card numbers are masked with stars, and account numbers are long
    // unbroken runs; neither is an amount.
    final cleaned = lines[i]
        .replaceAll(RegExp(r'\d*\*+[\d*]*'), ' ')
        .replaceAll(RegExp(r'\d{13,}'), ' ');
    final found = _amount.allMatches(cleaned).map((m) => m.group(0)!).toList();
    if (found.isNotEmpty) {
      // Banks group amounts with commas, so a grouped figure wins. Failing
      // that, the longest: a date or a time on the same line is shorter
      // than any real amount in rials.
      figure = found.firstWhere(
        (f) => f.contains(','),
        orElse: () => found.reduce((a, b) => b.length > a.length ? b : a),
      );
      break;
    }
  }
  if (figure == null) return null;

  final currency = _currencyOf(text);
  if (currency == null) return null;

  final digits = figure.replaceAll(',', '');
  if (currency.code == 'IRR' && planCurrency == 'IRR') {
    final whole = int.tryParse(digits.split('.').first);
    if (whole == null || whole <= 0) return null;
    return BankSpend(Money(whole * (currency.toman ? 10 : 1), 'IRR'));
  }
  if (currency.code != planCurrency) return null;
  try {
    final money = Money.parse(_fitDecimals(digits, planCurrency), planCurrency);
    return money.minor > 0 ? BankSpend(money) : null;
  } on ArgumentError {
    return null;
  }
}

/// Trims or pads a decimal so it parses in [currency]: a bank that writes
/// "45.5" in a two-decimal currency means 45.50.
String _fitDecimals(String digits, String currency) {
  final exponent = Currency.of(currency).exponent;
  final parts = digits.split('.');
  if (parts.length == 1 || exponent == 0) return parts.first;
  final frac = parts[1].length > exponent
      ? parts[1].substring(0, exponent)
      : parts[1];
  return '${parts.first}.$frac';
}

({String code, bool toman})? _currencyOf(String text) {
  if (text.contains('تومان')) return (code: 'IRR', toman: true);
  if (text.contains('ریال') || text.contains('ريال')) {
    return (code: 'IRR', toman: false);
  }
  for (final m in RegExp(r'\b([A-Z]{3})\b').allMatches(text)) {
    final code = m.group(1)!;
    if (Currency.isKnown(code)) return (code: code, toman: false);
  }
  if (RegExp(r'\bRs\.?\s?\d|₹').hasMatch(text)) {
    return (code: 'INR', toman: false);
  }
  // A Persian-language bank message with no currency named is in rials:
  // that is how Iranian banks write them.
  if (RegExp(r'[؀-ۿ]').hasMatch(text)) {
    return (code: 'IRR', toman: false);
  }
  return null;
}
