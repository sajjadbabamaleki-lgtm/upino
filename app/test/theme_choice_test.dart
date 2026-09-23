// Choosing light or dark.
//
// The choice has to outlive the app, and it is a preference rather than plan
// data, so deleting the plan must not reset it.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/data/serialization.dart';
import 'package:upino/design/tokens.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

Money eur(String v) => Money.parse(v, 'EUR');

Future<AppState> funded(PlanStore store) async {
  final state = AppState(now: now, utcOffset: cest, store: store);
  await state.restore();
  return state
    ..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur('1000.00')
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-28'),
    );
}

void main() {
  group('the preference', () {
    test('defaults to following the phone', () {
      expect(AppState(now: now, utcOffset: cest).themeChoice, ThemeChoice.system);
    });

    test('survives closing and reopening', () async {
      final store = InMemoryPlanStore();
      (await funded(store)).setThemeChoice(ThemeChoice.light);

      final reopened = AppState(now: now, utcOffset: cest, store: store);
      await reopened.restore();
      expect(reopened.themeChoice, ThemeChoice.light);
    });

    test('is kept when the plan is deleted, because it is not plan data',
        () async {
      final store = InMemoryPlanStore();
      final state = await funded(store);
      state.setThemeChoice(ThemeChoice.dark);
      await state.startOver();
      expect(state.themeChoice, ThemeChoice.dark);
      expect(state.isOnboarded, isFalse);
    });

    test('persists by name, so adding a choice cannot reinterpret it', () {
      final json = PlanDocument(
        currency: 'EUR',
        openingBalance: eur('0.00'),
        events: const [],
        claims: const [],
        incomeEvents: const [],
        onboarded: false,
        themeChoice: ThemeChoice.dark,
      ).toJson();
      expect(json['themeChoice'], 'dark');
      expect(json['schemaVersion'], schemaVersion);
    });

    test('a version 1 document without the field still loads', () {
      final document = PlanDocument.fromJson({
        'schemaVersion': 1,
        'currency': 'EUR',
        'openingBalance': {'minor': 0, 'currency': 'EUR'},
        'onboarded': true,
      });
      expect(document.themeChoice, ThemeChoice.system);
      expect(document.onboarded, isTrue);
    });
  });

  group('the picker', () {
    Future<AppState> openProfile(WidgetTester tester) async {
      final state = await funded(InMemoryPlanStore());
      tester.view
        ..physicalSize = const Size(420, 1500)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-4')));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('choosing light actually lights the app up', (tester) async {
      final state = await openProfile(tester);

      await tester.tap(find.byKey(const Key('theme-light')));
      await tester.pumpAndSettle();

      expect(state.themeChoice, ThemeChoice.light);

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(
        Theme.of(tester.element(find.byType(Scaffold).first)).brightness,
        Brightness.light,
      );
      expect(scaffold.backgroundColor ?? UpinoTokens.surfacePage,
          UpinoTokens.surfacePage,);
    });

    testWidgets('choosing dark applies the dark page colour', (tester) async {
      final state = await openProfile(tester);

      await tester.tap(find.byKey(const Key('theme-dark')));
      await tester.pumpAndSettle();

      expect(state.themeChoice, ThemeChoice.dark);
      expect(
        Theme.of(tester.element(find.byType(Scaffold).first)).scaffoldBackgroundColor,
        UpinoTokens.darkSurfacePage,
      );
    });

    testWidgets('all three options are offered', (tester) async {
      await openProfile(tester);
      // By key, not by word: the language card offers its own "Phone" too,
      // and both are right — each means "follow the phone".
      for (final choice in ThemeChoice.values) {
        expect(
          find.byKey(Key('theme-${choice.name}')),
          findsOneWidget,
          reason: choice.name,
        );
      }
      expect(
        find.descendant(
          of: find.byKey(const Key('theme-system')),
          matching: find.text('Phone'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('theme-light')),
          matching: find.text('Light'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('theme-dark')),
          matching: find.text('Dark'),
        ),
        findsOneWidget,
      );
    });
  });
}
