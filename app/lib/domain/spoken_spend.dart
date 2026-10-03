/// Turning what someone said into an amount and, when the words give it
/// away, a category: "دویست و پنجاه هزار تومن نون" or "twelve fifty coffee".
///
/// The phone's recogniser returns text: sometimes digits, sometimes number
/// words, often a mix ("250 هزار"). This reads all three. Like a bank
/// message, the result only fills in the Quick Expense sheet; the person
/// sees it and taps Save, so a misheard number never reaches the plan.
library;

import '../engine/money.dart';
import 'category.dart';

class SpokenSpend {
  const SpokenSpend({this.amount, this.category});
  final Money? amount;
  final SpendCategory? category;

  bool get isEmpty => amount == null && category == null;
}

const _units = {
  'صفر': 0, 'یک': 1, 'یه': 1, 'دو': 2, 'سه': 3, 'چهار': 4, 'پنج': 5,
  'شش': 6, 'شیش': 6, 'هفت': 7, 'هشت': 8, 'نه': 9, 'ده': 10, 'یازده': 11,
  'دوازده': 12, 'سیزده': 13, 'چهارده': 14, 'پانزده': 15, 'پونزده': 15,
  'شانزده': 16, 'شونزده': 16, 'هفده': 17, 'هجده': 18, 'هیجده': 18,
  'نوزده': 19, 'بیست': 20, 'سی': 30, 'چهل': 40, 'پنجاه': 50, 'شصت': 60,
  'هفتاد': 70, 'هشتاد': 80, 'نود': 90, 'صد': 100, 'یکصد': 100,
  'دویست': 200, 'سیصد': 300, 'چهارصد': 400, 'پانصد': 500, 'پونصد': 500,
  'ششصد': 600, 'شیشصد': 600, 'هفتصد': 700, 'هشتصد': 800, 'نهصد': 900,
  //
  'zero': 0, 'one': 1, 'a': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
  'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10, 'eleven': 11,
  'twelve': 12, 'thirteen': 13, 'fourteen': 14, 'fifteen': 15,
  'sixteen': 16, 'seventeen': 17, 'eighteen': 18, 'nineteen': 19,
  'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60,
  'seventy': 70, 'eighty': 80, 'ninety': 90,
};

/// Words that multiply what came before them.
const _scales = {
  'هزار': 1000, 'میلیون': 1000000, 'ملیون': 1000000,
  'میلیارد': 1000000000,
  'thousand': 1000, 'k': 1000, 'million': 1000000, 'billion': 1000000000,
};

const _hundred = {'hundred'};
const _half = {'نیم', 'half'};
const _joiners = {'و', 'and'};
const _articles = {'a', 'یه', 'یک'};

/// "میلیونی", "هزاری", "تومنی": the adjective a price is said with, which
/// names the same number as the word without its ی.
String _stem(String t) {
  if (t.length > 2 && t.endsWith('ی')) {
    final stem = t.substring(0, t.length - 1);
    if (_scales.containsKey(stem) || _toman.contains(stem)) return stem;
  }
  return t;
}
const _counters = {'تا', 'عدد', 'دونه', 'بسته'};

const _toman = {'تومن', 'تومان', 'toman', 'tomans'};
const _rial = {'ریال', 'rial', 'rials'};

/// Words that name what a spend was for. Brand names count: nobody says
/// "transport" when they mean they took a Snapp.
const _categoryWords = <SpendCategory, List<String>>{
  SpendCategory.food: [
    'نان', 'نون', 'غذا', 'ناهار', 'نهار', 'شام', 'صبحانه', 'رستوران',
    'کافه', 'قهوه', 'سوپر', 'سوپرمارکت', 'میوه', 'بقالی', 'خوراکی',
    'گوشت', 'مرغ', 'food', 'lunch', 'dinner', 'breakfast', 'coffee',
    'restaurant', 'grocery', 'groceries', 'bread', 'cafe',
  ],
  SpendCategory.transport: [
    'اسنپ', 'تپسی', 'تاکسی', 'بنزین', 'مترو', 'اتوبوس', 'کرایه',
    'پارکینگ', 'taxi', 'uber', 'snapp', 'fuel', 'gas', 'petrol', 'bus',
    'metro', 'train', 'parking',
  ],
  SpendCategory.bills: [
    'قبض', 'برق', 'آب', 'گاز', 'اینترنت', 'شارژ', 'اجاره', 'bill',
    'bills', 'electricity', 'water', 'internet', 'rent', 'phone',
  ],
  SpendCategory.shopping: [
    'لباس', 'کفش', 'مانتو', 'shopping', 'clothes', 'shoes',
  ],
  SpendCategory.health: [
    'دارو', 'داروخانه', 'دکتر', 'پزشک', 'دندانپزشک', 'medicine',
    'pharmacy', 'doctor', 'dentist',
  ],
  SpendCategory.fun: [
    'سینما', 'فیلم', 'بازی', 'تفریح', 'کنسرت', 'cinema', 'movie', 'game',
    'concert',
  ],
};

String _normalise(String s) {
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final out = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    final p = persian.indexOf(ch);
    final a = arabic.indexOf(ch);
    if (p >= 0) {
      out.write(p);
    } else if (a >= 0) {
      out.write(a);
    } else if (ch == 'ي') {
      out.write('ی');
    } else if (ch == 'ك') {
      out.write('ک');
    } else if (ch == '٫') {
      out.write('.');
    } else if (ch == '٬' || ch == '،') {
      out.write(',');
    } else {
      out.write(ch);
    }
  }
  // "25k" and "۲۵۰هزار" arrive glued; the scale word needs its own token.
  return out
      .toString()
      .replaceAllMapped(RegExp(r'(\d)(k|هزار|میلیون)'), (m) => '${m[1]} ${m[2]}')
      .replaceAll(RegExp(r'[$€£]'), ' ');
}

/// What [text] says was spent, in [planCurrency]. Either part may be
/// missing: "coffee" alone gives a category and no amount.
SpokenSpend parseSpokenSpend(String text, {required String planCurrency}) {
  final tokens = _normalise(text)
      .split(RegExp(r'[\s‌]+'))
      .map((t) => t.replaceAll(RegExp(r'^[^\w؀-ۿ.,]+|[^\w؀-ۿ.,]+$'), ''))
      .where((t) => t.isNotEmpty)
      .toList();

  SpendCategory? category;
  for (final t in tokens) {
    for (final entry in _categoryWords.entries) {
      if (entry.value.contains(t)) {
        category ??= entry.key;
      }
    }
  }

  final amount = _amount(tokens, planCurrency);
  return SpokenSpend(amount: amount, category: category);
}

Money? _amount(List<String> tokens, String planCurrency) {
  final exponent = Currency.of(planCurrency).exponent;
  final scale = BigInt.from(10).pow(exponent);

  // Everything is counted in halves of a major unit, so "یک و نیم میلیون"
  // stays exact without a fraction anywhere.
  var total = BigInt.zero; // in halves of a major unit
  var current = BigInt.zero;
  var started = false;
  var ended = false;
  BigInt? decimalMinor; // an explicit "12.50" beats everything else
  var toman = false;
  var cents = BigInt.zero; // "twelve dollars fifty" → the fifty
  var inCents = false;

  for (var i = 0; i < tokens.length; i++) {
    final t = _stem(tokens[i]);
    if (_toman.contains(t)) {
      toman = true;
      continue;
    }
    if (_rial.contains(t)) continue;
    if (ended) continue;

    final digits = t.replaceAll(',', '');
    if (RegExp(r'^\d+\.\d+$').hasMatch(digits)) {
      try {
        final parts = digits.split('.');
        final frac = parts[1].padRight(exponent, '0').substring(0, exponent);
        decimalMinor = BigInt.parse(parts[0]) * scale +
            (exponent == 0 ? BigInt.zero : BigInt.parse(frac));
      } on FormatException {
        // Not a number after all; keep reading.
      }
      started = true;
      continue;
    }
    if (RegExp(r'^\d+$').hasMatch(digits)) {
      if (inCents) {
        cents += BigInt.parse(digits);
        continue;
      }
      current += BigInt.parse(digits) * BigInt.two;
      started = true;
      continue;
    }
    if (_units.containsKey(t)) {
      // "a half" is the half, said with an article.
      if (t == 'a' && i + 1 < tokens.length && _half.contains(tokens[i + 1])) {
        continue;
      }
      // "a", "یه" and "یک" are articles as often as numbers: they only
      // count as one in front of another number word. "یه گوشی" is a phone,
      // not one rial; "یک میلیون" is a million.
      final next = i + 1 < tokens.length ? _stem(tokens[i + 1]) : null;
      final countsAsOne = next != null &&
          (_scales.containsKey(next) ||
              _hundred.contains(next) ||
              _half.contains(next) ||
              _joiners.contains(next) ||
              _units.containsKey(next));
      if (_articles.contains(t) && !started && !countsAsOne) {
        continue;
      }
      if (t == 'a' &&
          !(i + 1 < tokens.length &&
              (_scales.containsKey(tokens[i + 1]) ||
                  _hundred.contains(tokens[i + 1])))) {
        if (started) ended = true;
        continue;
      }
      if (inCents) {
        cents += BigInt.from(_units[t]!);
        continue;
      }
      current += BigInt.from(_units[t]!) * BigInt.two;
      started = true;
      continue;
    }
    if (_hundred.contains(t)) {
      current = (current == BigInt.zero ? BigInt.two : current) *
          BigInt.from(100);
      started = true;
      continue;
    }
    if (_half.contains(t) && started) {
      current += BigInt.one;
      continue;
    }
    if (_scales.containsKey(t) && (started || t != 'k')) {
      final unit = current == BigInt.zero ? BigInt.two : current;
      total += unit * BigInt.from(_scales[t]!);
      current = BigInt.zero;
      started = true;
      continue;
    }
    if (_joiners.contains(t)) continue;
    // "دو تا شیر": the number just said was how many, not how much, so it
    // is dropped and the amount ends where it was.
    if (_counters.contains(t) && started) {
      current = BigInt.zero;
      ended = true;
      continue;
    }
    if (const {'dollar', 'dollars', 'euro', 'euros', 'pound', 'pounds'}
        .contains(t)) {
      // After the currency word, what follows is the cents: "twelve
      // dollars fifty".
      if (started && exponent > 0) {
        total += current;
        current = BigInt.zero;
        inCents = true;
      }
      continue;
    }
    if (t == 'cents') continue;
    // Any other word ends the number once one has begun: "نون ۲۰ هزار و
    // دو تا شیر" is twenty thousand, not twenty thousand and two.
    if (started) ended = true;
  }

  BigInt minor;
  if (decimalMinor != null) {
    minor = decimalMinor;
  } else {
    final halves = total + current;
    if (halves == BigInt.zero) return null;
    // Halves of a major unit into minor units. A leftover half only
    // survives where the currency has a minor unit to hold it.
    minor = halves * scale ~/ BigInt.two + cents;
  }
  if (toman && planCurrency == 'IRR') minor *= BigInt.from(10);
  if (minor <= BigInt.zero) return null;
  return Money(minor.toInt(), planCurrency);
}
