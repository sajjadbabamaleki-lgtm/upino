/// Money, currency and the normative rounding policy (§5, §5.1).
///
/// Authoritative amounts are integer minor units. Binary floating point is
/// never used for a monetary value.
library;

import 'currencies.dart';

class Currency {
  const Currency(this.code, this.exponent, {this.symbol = ''});

  final String code;
  final int exponent;
  final String symbol;

  static const eur = Currency('EUR', 2, symbol: '€');
  static const usd = Currency('USD', 2, symbol: r'$');
  static const gbp = Currency('GBP', 2, symbol: '£');
  static const jpy = Currency('JPY', 0, symbol: '¥');

  /// Built from the generated table, so the exponent the engine rounds to and
  /// the one the picker offered are the same number by construction.
  static final Map<String, Currency> _registry = {
    for (final c in currencyCatalogue)
      c.code: Currency(c.code, c.exponent, symbol: c.symbol),
  };

  static Currency of(String code) {
    final c = _registry[code];
    if (c == null) throw ArgumentError('Unknown currency: $code');
    return c;
  }

  static bool isKnown(String code) => _registry.containsKey(code);
}

/// An exact monetary amount held as integer minor units.
class Money implements Comparable<Money> {
  const Money(this.minor, this.currency);

  final int minor;
  final String currency;

  static Money zero(String currency) => Money(0, currency);

  /// Parse a major-unit decimal string, e.g. `'1200.00'`.
  factory Money.parse(String major, String currency) {
    final c = Currency.of(currency);
    final m = RegExp(r'^(-?)(\d+)(?:\.(\d+))?$').firstMatch(major.trim());
    if (m == null) throw ArgumentError('Malformed amount: $major');
    final sign = m.group(1) == '-' ? -1 : 1;
    final whole = m.group(2)!;
    final frac = m.group(3) ?? '';
    if (frac.length > c.exponent) {
      throw ArgumentError('$major exceeds the precision $currency defines');
    }
    final padded = frac.padRight(c.exponent, '0');
    final scale = _pow10(c.exponent);
    final value = int.parse(whole) * scale + (padded.isEmpty ? 0 : int.parse(padded));
    return Money(sign * value, currency);
  }

  void _same(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Currency mismatch: $currency vs ${other.currency}. '
        '§16 forbids implicit netting across currencies.',
      );
    }
  }

  Money operator +(Money other) {
    _same(other);
    return Money(minor + other.minor, currency);
  }

  Money operator -(Money other) {
    _same(other);
    return Money(minor - other.minor, currency);
  }

  Money operator -() => Money(-minor, currency);

  bool operator <(Money other) {
    _same(other);
    return minor < other.minor;
  }

  bool operator >(Money other) {
    _same(other);
    return minor > other.minor;
  }

  bool operator <=(Money other) => !(this > other);
  bool operator >=(Money other) => !(this < other);

  @override
  int compareTo(Money other) {
    _same(other);
    return minor.compareTo(other.minor);
  }

  @override
  bool operator ==(Object other) =>
      other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  bool get isZero => minor == 0;
  bool get isNegative => minor < 0;

  /// The same face value written in [code]: `12.50 EUR` becomes `12.50 USD`.
  ///
  /// This relabels, it does not convert — there is no exchange rate here. It
  /// exists for correcting the currency a plan is kept in, and only rescales
  /// the minor units where the two currencies disagree about how many there
  /// are. Precision the target cannot hold is rounded half-even (§5.1), so
  /// `12.50 EUR` in yen is `¥12`.
  Money relabelled(String code) {
    final from = Currency.of(currency).exponent;
    final to = Currency.of(code).exponent;
    if (to >= from) return Money(minor * _pow10(to - from), code);
    return Money(divideRoundHalfEven(minor, _pow10(from - to)), code);
  }

  /// Floors at zero — the published Safe-to-Spend is never negative (INV-05).
  Money get clampedAtZero => isNegative ? Money.zero(currency) : this;

  static Money min(Money a, Money b) => a < b ? a : b;
  static Money max(Money a, Money b) => a > b ? a : b;

  static Money sum(Iterable<Money> items, String currency) =>
      items.fold(Money.zero(currency), (a, b) => a + b);

  /// `1800.00 EUR` — used by tests and logs, not by the interface.
  @override
  String toString() => '${_digits()} $currency';

  /// `€1,800.00` — grouped for display, never abbreviated (§32.8).
  String display({bool withSymbol = true, bool grouped = true}) {
    final c = Currency.of(currency);
    var text = _digits(grouped: grouped);
    // whole amounts read as whole: €1,200, not €1,200.00
    if (c.exponent > 0 && minor % _pow10(c.exponent) == 0) text = text.substring(0, text.length - c.exponent - 1);
    return withSymbol ? '${c.symbol}$text' : text;
  }

  String _digits({bool grouped = false}) {
    final c = Currency.of(currency);
    final negative = minor < 0;
    final abs = minor.abs();
    final scale = _pow10(c.exponent);
    final whole = (abs ~/ scale).toString();
    final frac = c.exponent == 0
        ? ''
        : '.${(abs % scale).toString().padLeft(c.exponent, '0')}';
    return '${negative ? '-' : ''}${grouped ? _group(whole) : whole}$frac';
  }

  static String _group(String whole) {
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }
    return buffer.toString();
  }

  static int _pow10(int e) {
    var r = 1;
    for (var i = 0; i < e; i++) {
      r *= 10;
    }
    return r;
  }
}

/// ROUND_HALF_EVEN — the normative quantization mode (§5.1).
int divideRoundHalfEven(int numerator, int denominator) {
  if (denominator == 0) throw ArgumentError('Division by zero');
  final negative = (numerator < 0) != (denominator < 0);
  final n = numerator.abs();
  final d = denominator.abs();

  final q = n ~/ d;
  final r = n % d;
  final twice = r * 2;

  final int result;
  if (twice > d) {
    result = q + 1;
  } else if (twice < d) {
    result = q;
  } else {
    result = q.isEven ? q : q + 1;
  }
  return negative ? -result : result;
}

/// Equal periodic contributions where the final cycle absorbs the exact
/// residual, so the schedule sums to the target (§5.1, INV-17).
///
/// €1,200 across 11 cycles → ten of €109.09 and a final €109.10.
List<Money> contributionSchedule(Money total, int cycles) {
  if (cycles <= 0) throw ArgumentError('Cycle count must be positive');
  final standard = Money(divideRoundHalfEven(total.minor, cycles), total.currency);
  final schedule = List<Money>.filled(cycles - 1, standard, growable: true)
    ..add(Money(total.minor - standard.minor * (cycles - 1), total.currency));
  return schedule;
}

Money requiredContribution(Money remaining, int cyclesRemaining) =>
    contributionSchedule(remaining, cyclesRemaining).first;
