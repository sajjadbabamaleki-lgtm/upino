/// A plan to try the app with (sample data): four goals, a few bills and
/// three months of pay and spending, built by replaying those months
/// through the same state and engine as a real plan. It is never saved and
/// never touches the person's own plan.
library;

import '../data/plan_document.dart';
import '../domain/bill.dart';
import '../domain/category.dart';
import '../engine/clock.dart';
import '../engine/money.dart';
import 'app_state.dart';

class DemoNames {
  const DemoNames({
    required this.goals,
    required this.bills,
  });

  /// Four goal names, in the reader's language.
  final List<String> goals;

  /// Three bill names.
  final List<String> bills;
}

/// Replays [days] of sample history ending [now]. In euros, whatever the
/// person's own currency: it is an example, not their money.
AppState buildDemo({
  required DateTime now,
  required Duration utcOffset,
  required DemoNames names,
  int days = 92,
}) {
  Money eur(int whole) => Money(whole * 100, 'EUR');
  final start = now.subtract(Duration(days: days));
  final startDay = LocalDate.at(start, utcOffset);

  AppState at(AppState from, int d) =>
      AppState(now: start.add(Duration(days: d)), utcOffset: utcOffset)
        ..replaceWith(from.toDocument());

  var s = AppState(now: start, utcOffset: utcOffset)
    ..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur(3400)
        ..incomeAmount = eur(2600)
        ..nextIncomeDate = startDay.addDays(27)
        ..payCycleDays = 30
        ..rent = eur(900)
        ..essentials = eur(450),
    );

  final goals = [
    (names.goals[0], 1500, 420, 150, 'goal-trip'),
    (names.goals[1], 1200, 380, 330, 'goal-laptop'),
    (names.goals[2], 3000, 1900, 240, 'goal-emergency'),
    (names.goals[3], 8000, 1500, 600, 'goal-car'),
  ];
  for (final (name, target, saved, dueIn, icon) in goals) {
    s
      ..addGoal(
        name: name,
        target: eur(target),
        targetDate: startDay.addDays(dueIn),
        icon: icon,
      )
      ..contributeToGoal(s.goals.last.id, eur(saved));
  }
  s
    ..addBill(
      name: names.bills[0],
      amount: eur(35),
      every: BillEvery.month,
      nextDue: startDay.addDays(12),
    )
    ..addBill(
      name: names.bills[1],
      amount: eur(45),
      every: BillEvery.month,
      nextDue: startDay.addDays(20),
    )
    ..addBill(
      name: names.bills[2],
      amount: eur(25),
      every: BillEvery.month,
      nextDue: startDay.addDays(4),
      kind: BillKind.subscription,
    );

  const cats = [
    SpendCategory.food,
    SpendCategory.transport,
    SpendCategory.shopping,
    SpendCategory.fun,
    SpendCategory.health,
  ];
  // Every other day is enough to give the charts a shape.
  for (var d = 2; d <= days; d += 2) {
    s = at(s, d);
    s.recordExpense(eur(9 + (d * 7) % (26 + d ~/ 4)), category: cats[d % 5]);
    if (d % 30 == 4) s.recordExpense(eur(900), category: SpendCategory.bills);
    if (d % 30 == 28) s.confirmIncome(eur(2600));
    if (d % 14 == 6) {
      final g = s.goals[(d ~/ 14) % s.goals.length];
      s.contributeToGoal(g.id, eur(40 + (d % 3) * 20));
    }
    for (final b in s.bills) {
      if (b.nextDue <= s.today) s.payBill(b.id);
    }
  }
  final done = AppState(now: now, utcOffset: utcOffset)
    ..replaceWith(PlanDocument.decode(s.toDocument().encode()))
    ..clearExpenseConfirmation();
  return done;
}
