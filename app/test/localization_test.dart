// Ten languages, and two of them run right to left. These check the parts
// that a screenshot cannot: that every message exists in every language with
// the same placeholders, that choosing a language actually changes the words,
// that it survives a restart, and that Arabic and Persian flip the layout.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/design/icon.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/l10n/app_localizations.dart';
import 'package:upino/main.dart';
import 'package:upino/screens/language_screen.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded({PlanStore? store}) => AppState(
      now: DateTime.utc(2026, 10, 1, 10),
      utcOffset: const Duration(hours: 2),
      store: store,
    )..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur('2000.00')
          ..incomeAmount = eur('2000.00')
          ..nextIncomeDate = LocalDate.parse('2026-10-31')
          ..payCycleDays = 30,
      );

const expected = ['ar', 'en', 'es', 'fa', 'fr', 'hi', 'pt', 'ru', 'tr', 'zh'];

Future<void> pumpApp(WidgetTester tester, AppState state) async {
  tester.view
    ..physicalSize = const Size(420, 1600)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UpinoApp(state: state));
  await tester.pumpAndSettle();
}

void main() {
  group('the catalogues', () {
    final files = Directory('lib/l10n')
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .toList();

    Map<String, Object?> read(String lang) => jsonDecode(
          File('lib/l10n/app_$lang.arb').readAsStringSync(),
        ) as Map<String, Object?>;

    test('all ten languages are shipped', () {
      expect(files.length, expected.length);
      expect(
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toList()
          ..sort(),
        expected,
      );
    });

    test('every language carries every message', () {
      final en = read('en').keys.where((k) => !k.startsWith('@')).toSet();
      expect(en.length, greaterThan(150));
      for (final lang in expected) {
        final keys = read(lang).keys.where((k) => !k.startsWith('@')).toSet();
        expect(keys, en, reason: lang);
      }
    });

    test('a message takes the same placeholders in every language', () {
      // A placeholder dropped in translation is a message that renders
      // without the number it was written to carry.
      final en = read('en');
      final holes = RegExp(r'\{(\w+)\}');
      for (final lang in expected) {
        final d = read(lang);
        for (final key in en.keys.where((k) => !k.startsWith('@'))) {
          expect(
            holes.allMatches(d[key]! as String).map((m) => m.group(1)).toSet(),
            holes.allMatches(en[key]! as String).map((m) => m.group(1)).toSet(),
            reason: '$lang · $key',
          );
        }
      }
    });
  });

  group('choosing a language', () {
    testWidgets('follows the phone until the user picks one', (tester) async {
      final state = funded();
      expect(state.languageCode, isNull);
      await pumpApp(tester, state);
      expect(find.text('Your plan'), findsOneWidget);
    });

    testWidgets('changes the words on screen at once', (tester) async {
      final state = funded();
      await pumpApp(tester, state);
      expect(find.text('Your plan'), findsOneWidget);

      state.setLanguageCode('fa');
      await tester.pumpAndSettle();

      expect(find.text('Your plan'), findsNothing);
      expect(find.text('برنامهٔ شما'), findsOneWidget);
    });

    testWidgets('reaches the bottom bar too', (tester) async {
      final state = funded()..setLanguageCode('tr');
      await pumpApp(tester, state);
      expect(find.text('Ana sayfa'), findsOneWidget);
    });

    testWidgets('is stored with the plan and read back', (tester) async {
      final store = InMemoryPlanStore();
      funded(store: store).setLanguageCode('es');

      final second = AppState(
        now: DateTime.utc(2026, 10, 1, 10),
        utcOffset: const Duration(hours: 2),
        store: store,
      );
      await second.restore();
      expect(second.languageCode, 'es');

      await pumpApp(tester, second);
      expect(find.text('Tu plan'), findsOneWidget);
    });
  });

  group('right to left', () {
    testWidgets('Persian and Arabic flip the layout', (tester) async {
      for (final lang in ['fa', 'ar']) {
        await pumpApp(tester, funded()..setLanguageCode(lang));
        final direction = Directionality.of(
          tester.element(find.byType(Scaffold).first),
        );
        expect(direction, TextDirection.rtl, reason: lang);
      }
    });

    testWidgets('the other eight stay left to right', (tester) async {
      for (final lang in ['en', 'zh', 'hi', 'es', 'fr', 'pt', 'ru', 'tr']) {
        await pumpApp(tester, funded()..setLanguageCode(lang));
        final direction = Directionality.of(
          tester.element(find.byType(Scaffold).first),
        );
        expect(direction, TextDirection.ltr, reason: lang);
      }
    });

    testWidgets('a right-to-left screen puts the heading on the right',
        (tester) async {
      // Mirroring is the whole point: nothing on a screen asks which way it
      // runs, so if Directionality did not reach the layout this would fail.
      await pumpApp(tester, funded()..setLanguageCode('en'));
      final ltr = tester.getTopLeft(find.text('Your plan')).dx;

      await pumpApp(tester, funded()..setLanguageCode('fa'));
      final rtl = tester.getTopRight(find.text('برنامهٔ شما')).dx;

      expect(ltr, lessThan(210));
      expect(rtl, greaterThan(210));
    });
  });

  group('the picker', () {
    testWidgets('opens from the setup screen and turns the app at once',
        (tester) async {
      final state = AppState(now: DateTime.utc(2026, 10, 1, 10));
      await pumpApp(tester, state);
      // The sheet is not up until the row is tapped: setup opens on the
      // screen the answers belong to, not on a question with no context.
      expect(find.byType(LanguagePicker), findsNothing);

      await tester.tap(find.byKey(const Key('change-language')));
      await tester.pumpAndSettle();
      expect(find.byType(LanguagePicker), findsOneWidget);

      await tester.tap(find.byKey(const Key('language-fa')));
      await tester.pumpAndSettle();
      expect(state.languageCode, 'fa');
      // The sheet leaves and the screen behind it is already in Persian,
      // including the currency question still waiting on it.
      expect(find.byType(LanguagePicker), findsNothing);
      expect(find.text('کدام واحد پول؟'), findsOneWidget);
    });

    testWidgets('names every language in itself', (tester) async {
      // Someone who cannot read the language currently showing still has to
      // find their own, so no row depends on the current one.
      await pumpApp(tester, AppState(now: DateTime.utc(2026, 10, 1, 10)));
      await tester.tap(find.byKey(const Key('change-language')));
      await tester.pumpAndSettle();
      for (final entry in languageNames.entries) {
        expect(
          find.byKey(Key('language-${entry.key}')),
          findsOneWidget,
          reason: entry.key,
        );
      }
      expect(find.textContaining('فارسی'), findsOneWidget);
      expect(find.textContaining('中文'), findsOneWidget);
      expect(find.textContaining('Русский'), findsOneWidget);
    });

    testWidgets('is reachable again from Profile', (tester) async {
      await pumpApp(tester, funded());
      await tester.tap(find.byKey(const Key('nav-4')));
      await tester.pumpAndSettle();

      final row = find.byKey(const Key('profile-language'));
      await tester.scrollUntilVisible(
        row,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(row);
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();

      // The same picker, not a second layout kept in step by hand.
      expect(find.byType(LanguagePicker), findsOneWidget);
      await tester.tap(find.byKey(const Key('language-tr')));
      await tester.pumpAndSettle();
      expect(find.text('Profil'), findsWidgets);
    });
  });

  group('labels stored in the plan', () {
    testWidgets('a built-in commitment is named in the current language',
        (tester) async {
      AppState withRent(String lang) => AppState(
            now: DateTime.utc(2026, 10, 1, 10),
            utcOffset: const Duration(hours: 2),
          )
            ..completeOnboarding(
              OnboardingDraft()
                ..currentBalance = eur('3000.00')
                ..incomeAmount = eur('2000.00')
                ..nextIncomeDate = LocalDate.parse('2026-10-28')
                ..rent = eur('1200.00')
                ..payCycleDays = 30,
            )
            ..setLanguageCode(lang);

      // The label is written into the plan at onboarding, in whatever
      // language was current. Reading it back by id is what lets the screen
      // follow a later change of language without rewriting the saved plan.
      await pumpApp(tester, withRent('en'));
      expect(find.text('Rent and bills'), findsWidgets);

      await pumpApp(tester, withRent('fa'));
      expect(find.text('Rent and bills'), findsNothing);
      expect(find.text('اجاره و قبض‌ها'), findsWidgets);
    });

    testWidgets('the forecast arrow does not mirror into a falling one',
        (tester) async {
      // Everything else on the screen mirrors in Persian. This one glyph
      // must not: a rising forecast drawn as a falling arrow is worse than
      // an arrow pointing the unexpected way.
      await pumpApp(tester, funded()..setLanguageCode('fa'));
      final icon = find.byWidgetPredicate((w) => w is UpinoIcon && w.name == 'trendingUp');
      expect(icon, findsOneWidget);
      expect(
        Directionality.of(tester.element(icon)),
        TextDirection.ltr,
        reason: 'the arrow inherited the mirrored direction',
      );
    });
  });

  group('dates', () {
    testWidgets('are written in the reader\'s own language', (tester) async {
      // The month names used to be a hardcoded English list.
      await pumpApp(tester, funded()..setLanguageCode('en'));
      expect(find.textContaining('October'), findsWidgets);

      await pumpApp(tester, funded()..setLanguageCode('fr'));
      expect(find.textContaining('octobre'), findsWidgets);

      await pumpApp(tester, funded()..setLanguageCode('ru'));
      expect(find.textContaining('октября'), findsWidgets);
    });
  });
}
