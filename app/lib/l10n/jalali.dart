/// The Solar Hijri (Jalali) calendar, for showing dates to Persian readers.
///
/// Salaries, rent and bills in Iran fall on Jalali dates, so a Gregorian
/// "28 October" makes the reader convert in their head before the date means
/// anything. Only display changes: the engine keeps civil Gregorian dates,
/// and nothing stored depends on which calendar was on screen.
///
/// The conversion is the arithmetic of the widely used jalaali-js algorithm
/// (Borkowski's leap-year breaks), valid for Jalali years −61 to 3177.
library;

class JalaliDate {
  const JalaliDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;

  static const monthNames = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  String get monthName => monthNames[month - 1];

  factory JalaliDate.fromGregorian(int gy, int gm, int gd) =>
      _fromDayNumber(_gregorianToDayNumber(gy, gm, gd));

  @override
  bool operator ==(Object other) =>
      other is JalaliDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '$year/$month/$day';
}

/// Western digits to Persian ones, so a Jalali date reads as one script.
String persianDigits(String s) {
  const digits = '۰۱۲۳۴۵۶۷۸۹';
  final out = StringBuffer();
  for (final c in s.codeUnits) {
    out.write(c >= 48 && c <= 57 ? digits[c - 48] : String.fromCharCode(c));
  }
  return out.toString();
}

const _breaks = [
  -61, 9, 38, 199, 426, 686, 756, 818, 1111, 1181, 1210, //
  1635, 2060, 2097, 2192, 2262, 2324, 2394, 2456, 3178,
];

int _div(int a, int b) => a ~/ b;
int _mod(int a, int b) => a - _div(a, b) * b;

/// The Gregorian year and the day of March on which Farvardin 1 of [jy] falls.
({int leap, int gy, int march}) _jalCal(int jy) {
  final gy = jy + 621;
  var leapJ = -14;
  var jp = _breaks[0];
  var jump = 0;
  for (var i = 1; i < _breaks.length; i++) {
    final jm = _breaks[i];
    jump = jm - jp;
    if (jy < jm) break;
    leapJ += _div(jump, 33) * 8 + _div(_mod(jump, 33), 4);
    jp = jm;
  }
  var n = jy - jp;
  leapJ += _div(n, 33) * 8 + _div(_mod(n, 33) + 3, 4);
  if (_mod(jump, 33) == 4 && jump - n == 4) leapJ += 1;
  final leapG = _div(gy, 4) - _div((_div(gy, 100) + 1) * 3, 4) - 150;
  final march = 20 + leapJ - leapG;
  if (jump - n < 6) n = n - jump + _div(jump + 4, 33) * 33;
  var leap = _mod(_mod(n + 1, 33) - 1, 4);
  if (leap == -1) leap = 4;
  return (leap: leap, gy: gy, march: march);
}

int _gregorianToDayNumber(int gy, int gm, int gd) {
  var d = _div((gy + _div(gm - 8, 6) + 100100) * 1461, 4) +
      _div(153 * _mod(gm + 9, 12) + 2, 5) +
      gd -
      34840408;
  d = d - _div(_div(gy + 100100 + _div(gm - 8, 6), 100) * 3, 4) + 752;
  return d;
}

({int gy, int gm, int gd}) _dayNumberToGregorian(int jdn) {
  var j = 4 * jdn + 139361631;
  j = j + _div(_div(4 * jdn + 183187720, 146097) * 3, 4) * 4 - 3908;
  final i = _div(_mod(j, 1461), 4) * 5 + 308;
  final gd = _div(_mod(i, 153), 5) + 1;
  final gm = _mod(_div(i, 153), 12) + 1;
  final gy = _div(j, 1461) - 100100 + _div(8 - gm, 6);
  return (gy: gy, gm: gm, gd: gd);
}

JalaliDate _fromDayNumber(int jdn) {
  final gy = _dayNumberToGregorian(jdn).gy;
  var jy = gy - 621;
  final r = _jalCal(jy);
  final jdn1f = _gregorianToDayNumber(gy, 3, r.march);
  var k = jdn - jdn1f;
  if (k >= 0) {
    if (k <= 185) {
      return JalaliDate(jy, 1 + _div(k, 31), _mod(k, 31) + 1);
    }
    k -= 186;
  } else {
    jy -= 1;
    k += 179;
    if (r.leap == 1) k += 1;
  }
  return JalaliDate(jy, 7 + _div(k, 30), _mod(k, 30) + 1);
}
