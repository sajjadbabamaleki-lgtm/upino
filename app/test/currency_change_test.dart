// Changing the currency after onboarding.
//
// Onboarding asks the currency first and nothing let a person change it
// afterwards short of deleting the plan. The change relabels: every amount
// keeps its number, nothing is converted at a rate.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
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
        ..incomeUpperAmount = eur('2500.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-28')
        ..rent = eur('600.00')
        ..goalAmount = eur('50.00'),
    );
}

void main() {
  group('relabelling an amount', () {
    test('keeps the number between currencies with the same decimals', () {
      expect(eur('12.50').relabelled('USD'), Money.parse('12.50', 'USD'));
    });

    test('rounds half-even into a currency with fewer decimals', () {
      expect(eur('12.50').relabelled('JPY'), Money.parse('12', 'JPY'));
      expect(eur('13.50').relabelled('JPY'), Money.parse('14', 'JPY'));
    });

    test('pads into a currency with more decimals', () {
      expect(eur('1.50').relabelled('OMR'), Money.parse('1.500', 'OMR'));
    });
  });

  group('the plan', () {
    test('keeps every figure and takes the new currency', () async {
      final state = await funded(InMemoryPlanStore());
      state.recordExpense(eur('40.00'));
      final before = state.snapshot.safeToSpendNow;

      state.changeCurrency('USD');

      expect(state.currency, 'USD');
      expect(state.openingBalance, Money.parse('1000.00', 'USD'));
      expect(state.snapshot.safeToSpendNow, Money(before.minor, 'USD'));
      expect(state.nextIncome!.expectedUpperAmount,
          Money.parse('2500.00', 'USD'),);
      expect(state.goals.single.target.currency, 'USD');
      expect(state.activity.single.amount, Money.parse('40.00', 'USD'));
    });

    test('survives closing and reopening', () async {
      final store = InMemoryPlanStore();
      (await funded(store)).changeCurrency('IRR');

      final reopened = AppState(now: now, utcOffset: cest, store: store);
      await reopened.restore();
      expect(reopened.restoreFailure, isNull);
      expect(reopened.currency, 'IRR');
      expect(reopened.openingBalance, Money.parse('1000', 'IRR'));
    });

    test('ignores an unknown code or the one already in use', () async {
      final state = await funded(InMemoryPlanStore());
      state
        ..changeCurrency('EUR')
        ..changeCurrency('XYZ');
      expect(state.currency, 'EUR');
    });
  });

  group('the profile row', () {
    Future<AppState> openProfile(WidgetTester tester) async {
      final state = await funded(InMemoryPlanStore());
      tester.view
        ..physicalSize = const Size(420, 1500)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('top-profile')));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('opens the picker and switches after confirming',
        (tester) async {
      final state = await openProfile(tester);

      await tester.tap(find.byKey(const Key('profile-currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('currency-USD')));
      await tester.pumpAndSettle();

      // Nothing has changed until the dialog is answered.
      expect(state.currency, 'EUR');
      await tester.tap(find.byKey(const Key('currency-change-confirm')));
      await tester.pumpAndSettle();

      expect(state.currency, 'USD');
    });

    testWidgets('cancelling leaves the plan as it was', (tester) async {
      final state = await openProfile(tester);

      await tester.tap(find.byKey(const Key('profile-currency')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('currency-USD')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(state.currency, 'EUR');
    });
  });
}
