/// Dates as words, in the reader's own language.
///
/// The month names used to be a hardcoded English list. `intl` carries the
/// names for every locale the app supports, so the format follows whatever
/// the app is currently showing rather than being fixed to one language —
/// and the order within the date follows it too, which is not the same
/// everywhere.
library;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../engine/clock.dart';
import 'jalali.dart';

String _tag(BuildContext context) => Localizations.localeOf(context).toString();

/// Persian readers get the Solar Hijri calendar, which is the one their pay
/// and rent actually fall on.
bool _jalali(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'fa';

JalaliDate _toJalali(LocalDate d) =>
    JalaliDate.fromGregorian(d.year, d.month, d.day);

/// `28 October`, or its equivalent — `۶ آبان` in Persian.
String formatDate(BuildContext context, LocalDate date) {
  if (_jalali(context)) {
    final j = _toJalali(date);
    return persianDigits('${j.day} ${j.monthName}');
  }
  return DateFormat.MMMMd(_tag(context))
      .format(DateTime(date.year, date.month, date.day));
}

/// `28 Oct 2026`, or its equivalent — `۶ آبان ۱۴۰۵` in Persian.
String formatDateShort(BuildContext context, LocalDate date) {
  if (_jalali(context)) {
    final j = _toJalali(date);
    return persianDigits('${j.day} ${j.monthName} ${j.year}');
  }
  return DateFormat.yMMMd(_tag(context))
      .format(DateTime(date.year, date.month, date.day));
}

/// `Oct`, or `مهر` in Persian: a month on a chart's axis.
String formatMonthShort(BuildContext context, LocalDate date) {
  if (_jalali(context)) return _toJalali(date).monthName;
  return DateFormat.MMM(_tag(context))
      .format(DateTime(date.year, date.month, date.day));
}

/// `M`, `T`… the narrowest weekday a chart's axis can hold.
String formatWeekdayNarrow(BuildContext context, LocalDate date) =>
    DateFormat.EEEEE(_tag(context))
        .format(DateTime(date.year, date.month, date.day));
