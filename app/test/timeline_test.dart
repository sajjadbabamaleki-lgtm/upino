// The financial timeline (Strategy §8). The past is the record; the future
// is the engine run forward on stated assumptions. These pin what the
// assumptions produce, so the chart cannot drift from the plan.

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/domain/bill.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/state/projection.dart';

Money eur(String v) => Money.parse(v, 'EUR');
final start = DateTime.utc(2026, 10, 1, 10);

/// 2000 in the bank, rent 900 and living 600 a period, pay 2000 in 30 days.
AppState plan() => AppState(now: start, utcOffset: Duration.zero)
  ..completeOnboarding(
    OnboardingDraft()
      ..currentBalance = eur('2000.00')
      ..incomeAmount = eur('2000.00')
      ..nextIncomeDate = LocalDate.parse('2026-10-31')
      ..payCycleDays = 30
      ..rent = eur('900.00')
      ..essentials = eur('600.00'),
  );

void main() {
  test('today is the plan as it stands', () {
    final state = plan();
    final t = state.timeline();
    expect(t.today.free, state.snapshot.safeToSpendNow);
    expect(t.today.free, eur('500.00'));
    expect(t.points.length, t.todayIndex + 61);
  });

  test('spending as planned keeps the room level until the pay', () {
    final t = plan().timeline();
    final mid = t.points[t.todayIndex + 15];
    expect(mid.projected, isTrue);
    expect(mid.balance, eur('1250.00'));
    expect(mid.free, eur('500.00'));
    expect(t.points[t.todayIndex + 29].free, eur('500.00'));
  });

  test('the pay lifts it, and the next period is set aside again', () {
    final t = plan().timeline();
    final payday = t.points[t.todayIndex + 30];
    expect(payday.day, LocalDate.parse('2026-10-31'));
    expect(payday.balance, eur('2500.00'));
    expect(payday.free, eur('1000.00'));
    expect(t.marks.where((m) => m.kind == TimelineMarkKind.pay), hasLength(2));
  });

  test('a bill is paid on its date and not held back after', () {
    final state = plan()
      ..addBill(
        name: 'Phone',
        amount: eur('40.00'),
        every: BillEvery.month,
        nextDue: LocalDate.parse('2026-10-10'),
      );
    final t = state.timeline();
    expect(t.today.free, eur('460.00'));
    final after = t.points[t.todayIndex + 10];
    expect(after.free, eur('460.00'));
    expect(after.balance, eur('2000.00') - eur('40.00') - eur('500.00'));
  });

  test('a purchase now lowers the whole path; after the pay, only from then',
      () {
    final state = plan();
    final now = state.timeline(purchase: eur('300.00'));
    final later = state.timeline(
      purchase: eur('300.00'),
      timing: PurchaseTiming.afterPay,
    );
    expect(now.today.free, eur('200.00'));
    expect(later.today.free, eur('500.00'));
    expect(later.points[later.todayIndex + 30].free, eur('700.00'));
    expect(now.points[now.todayIndex + 30].free, eur('700.00'));
  });

  test('a shortfall ahead is found', () {
    final state = plan();
    final t = state.timeline(purchase: eur('800.00'));
    expect(t.firstGap, isNotNull);
    expect(t.firstGap!.day, state.today);
  });

  test('the past is the record as it stood each day', () {
    final first = plan();
    final later = AppState(
      now: start.add(const Duration(days: 5)),
      utcOffset: Duration.zero,
    )..replaceWith(PlanDocument.decode(first.toDocument().encode()));
    later.recordExpense(eur('100.00'));
    final t = later.timeline();
    expect(t.todayIndex, 5);
    expect(t.points.first.balance, eur('2000.00'));
    expect(t.points.first.projected, isFalse);
    expect(t.points.first.free, isNull);
    expect(t.today.balance, eur('1900.00'));
  });
}
