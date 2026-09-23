// The currency table is engine data, not decoration: amounts are stored as
// integer minor units, so a wrong exponent means a wrong amount. These check
// the table itself, the picker that offers it, and that the Dart and
// TypeScript engines were generated from the same source.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/engine/currencies.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/screens/currency_screen.dart';
import 'package:upino/state/app_state.dart';

void main() {
  group('the table', () {
    test('offers well over a hundred currencies', () {
      expect(currencyCatalogue.length, greaterThanOrEqualTo(100));
    });

    test('has no duplicate code', () {
      final codes = currencyCatalogue.map((c) => c.code).toList();
      expect(codes.toSet().length, codes.length);
    });

    test('every entry is one the engine can parse amounts in', () {
      for (final c in currencyCatalogue) {
        expect(Currency.isKnown(c.code), isTrue, reason: c.code);
        expect(Currency.of(c.code).exponent, c.exponent, reason: c.code);
      }
    });

    test('the currencies with no minor unit carry exponent 0', () {
      // A yen or a rial has no subunit, so an amount there is a whole number.
      for (final code in ['JPY', 'KRW', 'VND', 'CLP', 'ISK', 'IRR', 'XOF']) {
        expect(Currency.of(code).exponent, 0, reason: code);
      }
      expect(() => Money.parse('1200.50', 'JPY'), throwsArgumentError);
      expect(Money.parse('1200', 'JPY').minor, 1200);
    });

    test('the Gulf dinars carry three', () {
      for (final code in ['KWD', 'BHD', 'OMR', 'JOD', 'IQD', 'TND', 'LYD']) {
        expect(Currency.of(code).exponent, 3, reason: code);
      }
      // 1.5 dinars is 1500 fils, not 150.
      expect(Money.parse('1.500', 'OMR').minor, 1500);
      expect(Money.parse('1.500', 'OMR').display(), 'OMR1.500');
    });

    test('the ones the user asked for by name are all there', () {
      for (final code in ['USD', 'EUR', 'AED', 'OMR', 'SAR', 'IRR']) {
        expect(
          currencyCatalogue.any((c) => c.code == code),
          isTrue,
          reason: code,
        );
      }
    });

    test('the most-traded currencies come first', () {
      expect(
        currencyCatalogue.take(10).map((c) => c.code),
        containsAll(['USD', 'EUR', 'JPY', 'GBP', 'CNY']),
      );
    });

    test('a flag is two regional indicator letters', () {
      final usd = currencyCatalogue.firstWhere((c) => c.code == 'USD');
      expect(usd.flag.runes.length, 2);
      expect(usd.flag.runes.first, 0x1F1FA); // U
      expect(usd.flag.runes.last, 0x1F1F8); // S
    });
  });

  group('search', () {
    test('finds a currency by its code, country or name', () {
      for (final query in ['usd', 'United States', 'dollar']) {
        final hits = currencyCatalogue.where((c) => c.matches(query));
        expect(hits.map((c) => c.code), contains('USD'), reason: query);
      }
    });

    test('finds the Gulf ones the way someone would type them', () {
      expect(
        currencyCatalogue.where((c) => c.matches('oman')).map((c) => c.code),
        contains('OMR'),
      );
      expect(
        currencyCatalogue.where((c) => c.matches('dirham')).map((c) => c.code),
        contains('AED'),
      );
    });

    test('all three ways in work for the same currency', () {
      // Country, what the money is called, and the three-letter code.
      for (final query in ['Oman', 'Omani rial', 'OMR', 'omr']) {
        expect(
          currencyCatalogue.where((c) => c.matches(query)).map((c) => c.code),
          contains('OMR'),
          reason: query,
        );
      }
      for (final query in ['United Arab Emirates', 'UAE dirham', 'aed']) {
        expect(
          currencyCatalogue.where((c) => c.matches(query)).map((c) => c.code),
          contains('AED'),
          reason: query,
        );
      }
    });

    test('an accent can be typed or left off', () {
      // Nine rows carry accents. Someone reaching for the Turkish lira types
      // "turkiye", not "Türkiye", and has to find it either way.
      const pairs = {
        'turkiye': 'TRY',
        'Türkiye': 'TRY',
        'sao tome': 'STN',
        'São Tomé': 'STN',
        'zloty': 'PLN',
        'złoty': 'PLN',
        'curacao': 'ANG',
        'cordoba': 'NIO',
        'colon': 'CRC',
        'bolivar': 'VES',
        'krona': 'ISK',
      };
      pairs.forEach((query, code) {
        expect(
          currencyCatalogue.where((c) => c.matches(query)).map((c) => c.code),
          contains(code),
          reason: query,
        );
      });
    });

    test('every row can be found by each of the three', () {
      for (final c in currencyCatalogue) {
        expect(c.matches(c.code), isTrue, reason: '${c.code} by code');
        expect(c.matches(c.country), isTrue, reason: '${c.code} by country');
        expect(c.matches(c.name), isTrue, reason: '${c.code} by name');
      }
    });

    test('an empty query keeps the full list in its given order', () {
      final all = currencyCatalogue.where((c) => c.matches('  ')).toList();
      expect(all.length, currencyCatalogue.length);
      expect(all.first.code, currencyCatalogue.first.code);
    });
  });

  group('the picker', () {
    Future<void> pump(WidgetTester tester, void Function(String) onSelect) async {
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyPicker(selected: null, onSelect: onSelect),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    /// The country and the currency name are one text run, so they are read
    /// back as the spans of that run rather than as separate widgets.
    List<String> labelSpans(WidgetTester tester, String code) {
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byKey(Key('currency-$code')),
          matching: find.byType(Text),
        ).at(1),
      );
      final out = <String>[];
      (text.textSpan! as TextSpan).visitChildren((span) {
        if (span is TextSpan && span.text != null) out.add(span.text!);
        return true;
      });
      return out;
    }

    testWidgets('shows the important ones without scrolling', (tester) async {
      await pump(tester, (_) {});
      expect(find.byKey(const Key('currency-USD')), findsOneWidget);
      expect(find.byKey(const Key('currency-EUR')), findsOneWidget);
    });

    testWidgets('typing narrows the list to what matches', (tester) async {
      await pump(tester, (_) {});
      await tester.enterText(find.byKey(const Key('currency-search')), 'oman');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('currency-OMR')), findsOneWidget);
      expect(find.byKey(const Key('currency-USD')), findsNothing);
      expect(labelSpans(tester, 'OMR'), ['Oman', '  Omani rial']);
    });

    testWidgets('a search that matches nothing says so', (tester) async {
      await pump(tester, (_) {});
      await tester.enterText(
        find.byKey(const Key('currency-search')),
        'zzzzz',
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Nothing matches'), findsOneWidget);
    });

    testWidgets('a row is one line, the height of the search field',
        (tester) async {
      await pump(tester, (_) {});

      final search = tester.getSize(find.byKey(const Key('currency-search-bar')));
      final row = tester.getSize(find.byKey(const Key('currency-USD')));
      expect(row.height, closeTo(search.height, 0.01));

      // One line: the country and the currency name are one run, and the run
      // is capped at a single line rather than wrapping.
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const Key('currency-USD')),
          matching: find.byType(Text),
        ).at(1),
      );
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('the row reads flag, country, currency, code, symbol',
        (tester) async {
      await pump(tester, (_) {});

      // Within the run, reading order is span order.
      expect(labelSpans(tester, 'USD'), ['United States', '  US dollar']);

      final flag = tester.getRect(find.text('🇺🇸'));
      final label = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('currency-USD')),
          matching: find.byType(Text),
        ).at(1),
      );
      final code = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('currency-USD')),
          matching: find.text('USD'),
        ),
      );
      final symbol = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('currency-USD')),
          matching: find.text(r'$'),
        ),
      );
      final order = [flag.left, label.left, code.left, symbol.left];
      expect(
        order,
        orderedEquals(List<double>.from(order)..sort()),
        reason: 'left to right: flag, labels, code, symbol',
      );
    });

    testWidgets('a name is not clipped while there is room beside it',
        (tester) async {
      // Two flexed boxes split the width by ratio, which clipped
      // "Australian dollar" although the row was half empty.
      await pump(tester, (_) {});
      final text = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const Key('currency-AUD')),
          matching: find.byType(Text),
        ).at(1),
      );
      final painter = TextPainter(
        text: text.textSpan,
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: tester.getSize(find.byKey(const Key('currency-AUD'))).width);
      expect(painter.didExceedMaxLines, isFalse);
      expect(labelSpans(tester, 'AUD'), ['Australia', '  Australian dollar']);
    });

    testWidgets('the longest names fit the row rather than overflowing it',
        (tester) async {
      // Flutter reports a layout overflow through the error reporter rather
      // than by throwing, so a row that does not fit would pass unnoticed.
      String? reported;
      final previous = FlutterError.onError;
      FlutterError.onError = (details) {
        reported = details.exceptionAsString();
        previous?.call(details);
      };
      addTearDown(() => FlutterError.onError = previous);

      for (final query in [
        'São Tomé',
        'Trinidad',
        'Bosnia',
        'Papua',
        'Eastern Caribbean',
      ]) {
        await pump(tester, (_) {});
        await tester.enterText(find.byKey(const Key('currency-search')), query);
        await tester.pumpAndSettle();
        expect(reported, isNull, reason: '$query overflowed its row');
      }
    });

    testWidgets('a currency with no glyph of its own shows its code once',
        (tester) async {
      await pump(tester, (_) {});
      await tester.enterText(find.byKey(const Key('currency-search')), 'oman');
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byKey(const Key('currency-OMR')),
          matching: find.text('OMR'),
        ),
        findsOneWidget,
        reason: 'the code stood in for the symbol and was printed twice',
      );
    });

    testWidgets('tapping a row reports that code', (tester) async {
      String? picked;
      await pump(tester, (c) => picked = c);
      await tester.tap(find.byKey(const Key('currency-USD')));
      await tester.pump();
      expect(picked, 'USD');
    });
  });

  test('both engines were generated from the same table', () {
    // The TypeScript engine validates the same §24 fixtures. If the two
    // disagreed about an exponent the same input would mean different amounts
    // on each side, which no fixture would catch.
    final ts = File('../src/money/currency-table.ts');
    expect(ts.existsSync(), isTrue, reason: 'run tools/generate_currencies.py');

    final rows = RegExp(r"\['([A-Z]{3})', (\d)\]")
        .allMatches(ts.readAsStringSync())
        .map((m) => MapEntry(m.group(1)!, int.parse(m.group(2)!)))
        .toList();

    expect(rows.length, currencyCatalogue.length);
    for (var i = 0; i < rows.length; i++) {
      expect(rows[i].key, currencyCatalogue[i].code, reason: 'row $i');
      expect(rows[i].value, currencyCatalogue[i].exponent, reason: rows[i].key);
    }
  });

  group('onboarding', () {
    Future<AppState> pumpOnboarding(WidgetTester tester) async {
      tester.view
        ..physicalSize = const Size(400, 1400)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final state = AppState(now: DateTime.utc(2026, 10, 1, 10));
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('asks for the currency before anything else', (tester) async {
      await pumpOnboarding(tester);
      // The amount fields are not reachable until a currency is chosen,
      // because they would be storing minor units of an unknown size.
      expect(find.text('Which currency?'), findsOneWidget);
      expect(find.byKey(const Key('field-balance')), findsNothing);
    });

    testWidgets('nothing looks chosen before the user chooses', (tester) async {
      await pumpOnboarding(tester);
      // A highlighted row on the way in would claim a default nobody picked.
      expect(find.byType(CurrencyPicker), findsOneWidget);
      expect(
        tester.widget<CurrencyPicker>(find.byType(CurrencyPicker)).selected,
        isNull,
      );
    });

    testWidgets('picking closes the list at once, and reopening marks it',
        (tester) async {
      await pumpOnboarding(tester);
      await tester.tap(find.byKey(const Key('currency-JPY')));
      await tester.pump();

      // No animation to wait out: the list is gone on the next frame.
      expect(find.byType(CurrencyPicker), findsNothing);
      expect(find.byKey(const Key('field-balance')), findsOneWidget);

      await tester.tap(find.byKey(const Key('change-currency')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<CurrencyPicker>(find.byType(CurrencyPicker)).selected,
        'JPY',
        reason: 'coming back to change it is the one time the mark is read',
      );
    });

    testWidgets('reopening and picking the same one keeps what was typed',
        (tester) async {
      await pumpOnboarding(tester);
      await tester.tap(find.byKey(const Key('currency-USD')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('field-balance')), '2000');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change-currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('currency-USD')));
      await tester.pumpAndSettle();

      // Same currency, same scale, so there is nothing to reinterpret.
      final field = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('field-balance')),
          matching: find.byType(EditableText),
        ),
      );
      expect(field.controller.text, '2000');
    });

    testWidgets('choosing one moves on and carries into the plan',
        (tester) async {
      final state = await pumpOnboarding(tester);

      await tester.enterText(find.byKey(const Key('currency-search')), 'oman');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('currency-OMR')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('field-balance')), findsOneWidget);

      // A rial has three decimal places, so 1.5 rial is 1500 baisa.
      await tester.enterText(find.byKey(const Key('field-balance')), '1.500');
      await tester.enterText(find.byKey(const Key('field-income')), '1000');
      await tester.pumpAndSettle();
      await tester.tap(find.text('See what I can spend'));
      await tester.pumpAndSettle();

      expect(state.currency, 'OMR');
      expect(state.openingBalance.minor, 1500);
    });

    testWidgets('going back and changing it clears the amounts', (tester) async {
      await pumpOnboarding(tester);
      await tester.tap(find.byKey(const Key('currency-USD')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('field-balance')), '2000');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('change-currency')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('currency-search')), 'japan');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('currency-JPY')));
      await tester.pumpAndSettle();

      // 2000 dollars is not 2000 yen, so the figure is not carried over
      // under a new scale — it is asked for again.
      final field = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('field-balance')),
          matching: find.byType(EditableText),
        ),
      );
      expect(field.controller.text, isEmpty);
    });
  });
}
