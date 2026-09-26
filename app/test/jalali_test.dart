// The Solar Hijri calendar shown to Persian readers.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/l10n/app_localizations.dart';
import 'package:upino/l10n/dates.dart';
import 'package:upino/l10n/jalali.dart';

void main() {
  group('conversion', () {
    test('Nowruz falls where it should', () {
      expect(JalaliDate.fromGregorian(2025, 3, 21), const JalaliDate(1404, 1, 1));
      expect(JalaliDate.fromGregorian(2026, 3, 21), const JalaliDate(1405, 1, 1));
      // 1403 is a leap year, so Nowruz 1403 was on 20 March.
      expect(JalaliDate.fromGregorian(2024, 3, 20), const JalaliDate(1403, 1, 1));
    });

    test('the last day of a leap Esfand exists', () {
      expect(JalaliDate.fromGregorian(2025, 3, 20), const JalaliDate(1403, 12, 30));
    });

    test('months change length after Shahrivar', () {
      expect(JalaliDate.fromGregorian(2026, 9, 22), const JalaliDate(1405, 6, 31));
      expect(JalaliDate.fromGregorian(2026, 9, 23), const JalaliDate(1405, 7, 1));
      expect(JalaliDate.fromGregorian(2026, 10, 28), const JalaliDate(1405, 8, 6));
    });

    test('a long run of days never skips or repeats one', () {
      var previous = JalaliDate.fromGregorian(2020, 1, 1);
      var day = DateTime.utc(2020, 1, 2);
      final end = DateTime.utc(2035, 1, 1);
      while (day.isBefore(end)) {
        final j = JalaliDate.fromGregorian(day.year, day.month, day.day);
        final sameMonth = j.year == previous.year && j.month == previous.month;
        if (sameMonth) {
          expect(j.day, previous.day + 1, reason: '$day');
        } else {
          expect(j.day, 1, reason: '$day');
          expect(previous.day, inInclusiveRange(29, 31), reason: '$day');
        }
        previous = j;
        day = day.add(const Duration(days: 1));
      }
    });
  });

  test('digits are written in Persian', () {
    expect(persianDigits('1405/8/6'), '۱۴۰۵/۸/۶');
  });

  group('formatting', () {
    Future<String> format(WidgetTester tester, Locale locale) async {
      late String out;
      await tester.pumpWidget(MaterialApp(
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(builder: (context) {
          out = formatDateShort(context, LocalDate.parse('2026-10-28'));
          return const SizedBox();
        },),
      ),);
      await tester.pumpAndSettle();
      return out;
    }

    testWidgets('Persian shows the Jalali date', (tester) async {
      expect(await format(tester, const Locale('fa')), '۶ آبان ۱۴۰۵');
    });

    testWidgets('other languages keep the Gregorian date', (tester) async {
      expect(await format(tester, const Locale('en')), 'Oct 28, 2026');
    });
  });
}
