/// What a goal will really cost on its date, when prices keep rising.
///
/// A goal is entered in today's money. Where prices climb by a third a year,
/// a target that looks reachable is quietly out of reach by the time it is
/// due, and a plan that says otherwise is the kind of wrong this product
/// exists to avoid. The rate is the person's own estimate: the app has no
/// network and no official figure to fetch, and would not trust one blindly.
///
/// The arithmetic stays in integers (§5): whole years compound, the part of
/// a year left over grows linearly, and each step rounds half-even.
library;

import '../engine/money.dart';

/// [amount] grown by [basisPoints] a year (3500 = 35%) over [days].
Money inflated(Money amount, int basisPoints, int days) {
  if (basisPoints <= 0 || days <= 0) return amount;
  final scale = BigInt.from(10000);
  final rate = BigInt.from(basisPoints);
  var value = BigInt.from(amount.minor);

  BigInt halfEven(BigInt n, BigInt d) {
    final q = n ~/ d;
    final r = n.remainder(d) * BigInt.two;
    if (r > d || (r == d && q.isOdd)) return q + BigInt.one;
    return q;
  }

  for (var y = 0; y < days ~/ 365; y++) {
    value = halfEven(value * (scale + rate), scale);
  }
  final rest = BigInt.from(days % 365);
  value += halfEven(value * rate * rest, scale * BigInt.from(365));
  return Money(value.toInt(), amount.currency);
}

/// `35` or `35.5` — a rate in basis points as a person would write it.
String formatRate(int basisPoints) {
  final whole = basisPoints ~/ 100;
  final part = basisPoints % 100;
  if (part == 0) return '$whole';
  final digits = part.toString().padLeft(2, '0');
  return '$whole.${digits.endsWith('0') ? digits[0] : digits}';
}

/// The reverse of [formatRate]; null for anything that is not a rate.
int? parseRate(String text) {
  final m = RegExp(r'^\s*(\d{1,4})(?:[.,](\d{1,2}))?\s*%?\s*$').firstMatch(text);
  if (m == null) return null;
  final part = (m.group(2) ?? '').padRight(2, '0');
  return int.parse(m.group(1)!) * 100 + int.parse(part);
}
