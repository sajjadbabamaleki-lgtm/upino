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

String _tag(BuildContext context) => Localizations.localeOf(context).toString();

/// `28 October`, or its equivalent.
String formatDate(BuildContext context, LocalDate date) =>
    DateFormat.MMMMd(_tag(context)).format(DateTime(date.year, date.month, date.day));

/// `28 Oct 2026`, or its equivalent.
String formatDateShort(BuildContext context, LocalDate date) =>
    DateFormat.yMMMd(_tag(context)).format(DateTime(date.year, date.month, date.day));
