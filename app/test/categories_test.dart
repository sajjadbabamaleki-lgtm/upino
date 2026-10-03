// What a spend was for, and where the money went.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

Money eur(String v) => Money.parse(v, 'EUR');

Future<AppState> funded(PlanStore store, {DateTime? at}) async {
  final state = AppState(now: at ?? now, utcOffset: cest, store: store);
  await state.restore();
  if (!state.isOnboarded) {
    state.completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur('1000.00')
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-28'),
    );
  }
  return state;
}

void main() {
  group('the record', () {
    test('a category changes no figure', () async {
      final a = await funded(InMemoryPlanStore());
      final b = await funded(InMemoryPlanStore());
      a.recordExpense(eur('40.00'), category: SpendCategory.food);
      b.recordExpense(eur('40.00'));
      expect(a.snapshot.safeToSpendNow, b.snapshot.safeToSpendNow);
    });

    test('spending is grouped, largest first, unsorted kept apart', () async {
      final state = await funded(InMemoryPlanStore());
      state
        ..recordExpense(eur('10.00'), category: SpendCategory.food)
        ..recordExpense(eur('25.00'), category: SpendCategory.food)
        ..recordExpense(eur('50.00'), category: SpendCategory.bills)
        ..recordExpense(eur('5.00'));

      final rows = state.spendingByCategory();
      expect(rows.map((r) => r.category),
          [SpendCategory.bills, SpendCategory.food, null],);
      expect(rows[1].total, eur('35.00'));
    });

    test('a removed spend no longer counts toward it', () async {
      final state = await funded(InMemoryPlanStore());
      state.recordExpense(eur('10.00'), category: SpendCategory.food);
      state.removeEvent(state.activity.single.eventId);
      expect(state.spendingByCategory(), isEmpty);
    });

    test('sorting afterwards, and taking it back', () async {
      final state = await funded(InMemoryPlanStore());
      state.recordExpense(eur('10.00'));
      final id = state.activity.single.eventId;
      state.setCategory(id, SpendCategory.health);
      expect(state.categoryFor(id), SpendCategory.health);
      state.setCategory(id, null);
      expect(state.categoryFor(id), isNull);
    });

    test('only the last 30 days are counted', () async {
      final store = InMemoryPlanStore();
      (await funded(store)).recordExpense(
        eur('10.00'),
        category: SpendCategory.food,
      );
      final later = await funded(store, at: now.add(const Duration(days: 31)));
      expect(later.spendingByCategory(), isEmpty);
    });

    test('survives closing and reopening', () async {
      final store = InMemoryPlanStore();
      (await funded(store))
          .recordExpense(eur('10.00'), category: SpendCategory.transport);
      final reopened = await funded(store);
      expect(reopened.restoreFailure, isNull);
      expect(reopened.spendingByCategory().single.category,
          SpendCategory.transport,);
    });

    test('an unknown category refuses the document', () {
      final json = (PlanDocument(
        currency: 'EUR',
        openingBalance: eur('0.00'),
        events: const [],
        claims: const [],
        incomeEvents: const [],
        onboarded: true,
        categories: const {'e1': SpendCategory.food},
      ).toJson())
        ..['categories'] = {'e1': 'crypto'};
      expect(() => PlanDocument.fromJson(json), throwsA(anything));
    });

    test('starting over forgets categories with the log', () async {
      final state = await funded(InMemoryPlanStore());
      state.recordExpense(eur('10.00'), category: SpendCategory.fun);
      await state.startOver();
      expect(state.categoryFor('e1'), isNull);
    });
  });

  group('the screens', () {
    Future<AppState> open(WidgetTester tester) async {
      final state = await funded(InMemoryPlanStore());
      tester.view
        ..physicalSize = const Size(420, 1500)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('a spend can be sorted as it is recorded', (tester) async {
      final state = await open(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Record a spend'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '12');
      await tester.tap(find.byKey(const Key('category-food')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(state.categoryFor(state.activity.single.eventId),
          SpendCategory.food,);
    });

    testWidgets('Activity shows where it went', (tester) async {
      final state = await open(tester);
      state.recordExpense(eur('12.00'), category: SpendCategory.bills);
      await tester.tap(find.byKey(const Key('nav-3')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('where-it-went')), findsOneWidget);
      expect(find.text('Bills'), findsWidgets);
    });
  });
}
