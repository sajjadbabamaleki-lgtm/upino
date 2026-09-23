// An income given as a range (§13, INV-20).
//
// Real income is not one number — freelance work, commission, and any
// volatile currency make "2,000 to 3,000" the honest answer. The plan is
// built on the lower end and never the midpoint: a plan built on an average
// breaks in every month that comes in below average, and not breaking is the
// whole claim this product makes.

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

AppState withIncome(String low, {String? high, PlanStore? store}) => AppState(
      now: DateTime.utc(2026, 10, 1, 10),
      utcOffset: const Duration(hours: 2),
      store: store,
    )..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur('1000.00')
          ..incomeAmount = eur(low)
          ..incomeUpperAmount = high == null ? null : eur(high)
          ..nextIncomeDate = LocalDate.parse('2026-10-28')
          ..payCycleDays = 30,
      );

void main() {
  group('INV-20 — the upper end enters no calculation', () {
    test('a range plans exactly as its lower end alone would', () {
      final fixed = withIncome('2000.00');
      final range = withIncome('2000.00', high: '3000.00');

      expect(range.snapshot.safeToSpendNow, fixed.snapshot.safeToSpendNow);
      expect(
        range.snapshot.projectedSafeToSpend,
        fixed.snapshot.projectedSafeToSpend,
        reason: 'the projection must not borrow from the optimistic end',
      );
      expect(range.snapshot.protectedTotal, fixed.snapshot.protectedTotal);
      expect(
        range.snapshot.mandatoryFundingGap,
        fixed.snapshot.mandatoryFundingGap,
      );
    });

    test('the midpoint is never used', () {
      // If an average were used anywhere, this would sit between the two.
      final range = withIncome('2000.00', high: '3000.00');
      final low = withIncome('2000.00');
      final mid = withIncome('2500.00');
      expect(range.snapshot.projectedSafeToSpend,
          low.snapshot.projectedSafeToSpend,);
      expect(range.snapshot.projectedSafeToSpend,
          isNot(mid.snapshot.projectedSafeToSpend),);
    });

    test('a range still keeps expected income out of the now figure', () {
      // INV-04 holds whichever end is read: neither belongs to today.
      final range = withIncome('2000.00', high: '3000.00');
      expect(range.snapshot.safeToSpendNow, eur('1000.00'));
    });
  });

  group('the range itself', () {
    test('is carried so the user can see what they entered', () {
      final state = withIncome('2000.00', high: '3000.00');
      expect(state.nextIncome!.expectedAmount, eur('2000.00'));
      expect(state.nextIncome!.expectedUpperAmount, eur('3000.00'));
      expect(state.nextIncome!.isRange, isTrue);
    });

    test('a fixed income is not a range', () {
      expect(withIncome('2000.00').nextIncome!.isRange, isFalse);
      // An upper end equal to the amount is a fixed income written twice.
      expect(withIncome('2000.00', high: '2000.00').nextIncome!.isRange,
          isFalse,);
    });

    test('an upper end below the amount is refused, not silently swapped', () {
      expect(
        () => IncomeEvent(
          id: 'x',
          expectedAmount: eur('3000.00'),
          expectedUpperAmount: eur('2000.00'),
          expectedDate: LocalDate.parse('2026-10-28'),
          state: IncomeState.expected,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('raising the amount past a stored upper end drops the range', () {
      // Otherwise the plan would carry a range running backwards.
      final state = withIncome('2000.00', high: '3000.00')
        ..setExpectedIncome(amount: eur('3500.00'));
      expect(state.nextIncome!.expectedUpperAmount, isNull);
      expect(state.nextIncome!.isRange, isFalse);
    });

    test('can be cleared back to a fixed income', () {
      final state = withIncome('2000.00', high: '3000.00')
        ..setExpectedIncome(clearUpper: true);
      expect(state.nextIncome!.expectedUpperAmount, isNull);
      expect(state.nextIncome!.expectedAmount, eur('2000.00'));
    });

    test('survives a restart', () async {
      final store = InMemoryPlanStore();
      withIncome('2000.00', high: '3000.00', store: store);

      final second = AppState(
        now: DateTime.utc(2026, 10, 1, 10),
        utcOffset: const Duration(hours: 2),
        store: store,
      );
      await second.restore();
      expect(second.nextIncome!.expectedUpperAmount, eur('3000.00'));
    });

    test('a plan stored before ranges existed still opens', () {
      final state = withIncome('2000.00');
      expect(state.nextIncome!.expectedUpperAmount, isNull);
    });
  });
}
