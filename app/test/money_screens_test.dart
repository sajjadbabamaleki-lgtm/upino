// The screens for bills, pay arriving, accounts, getting money back and the
// charts. Each drives the real app and checks what the plan did, not only
// what was drawn.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/screens/goals_screen.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/domain/account.dart';
import 'package:upino/domain/bill.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/domain/recovery.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/state/demo.dart';

final now = DateTime.utc(2026, 10, 1, 10);
Money eur(String v) => Money.parse(v, 'EUR');

AppState funded({DateTime? at}) => AppState(now: at ?? now, utcOffset: Duration.zero)
  ..completeOnboarding(
    OnboardingDraft()
      ..currentBalance = eur('1000.00')
      ..incomeAmount = eur('2000.00')
      ..nextIncomeDate = LocalDate.parse('2026-10-28')
      ..rent = eur('400.00'),
  );

Future<void> open(WidgetTester tester, AppState state, {int tab = 0}) async {
  tester.view
    ..physicalSize = const Size(420, 1600)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UpinoApp(state: state));
  await tester.pumpAndSettle();
  if (tab != 0) {
    await tester.tap(find.byKey(Key('nav-$tab')));
    await tester.pumpAndSettle();
  }
}

Future<void> tapKey(WidgetTester tester, String key) async {
  final f = find.byKey(Key(key));
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

void main() {
  // These look at the person's own goals, not the samples.
  setUp(() => GoalsScreen.samplesWhenFew = false);
  testWidgets('a bill added on Plan is set aside and listed on Home',
      (tester) async {
    final state = funded();
    await open(tester, state, tab: 1);
    await tapKey(tester, 'plan-bill-add');
    await tester.enterText(find.byKey(const Key('bill-name')), 'Internet');
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('bill-amount')),
        matching: find.byType(TextField),
      ),
      '30.00',
    );
    await tester.pump();
    await tapKey(tester, 'bill-save');

    expect(state.bills.single.name, 'Internet');
    expect(state.bills.single.nextDue, LocalDate.parse('2026-10-08'));
    expect(state.snapshot.safeToSpendNow, eur('570.00'));

    await tester.tap(find.byKey(const Key('nav-0')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('home-coming-up')));
    expect(
      find.descendant(
        of: find.byKey(const Key('home-coming-up')),
        matching: find.text('Internet'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a bill is paid from its row', (tester) async {
    final state = funded()
      ..addBill(
        name: 'Phone',
        amount: eur('20.00'),
        every: BillEvery.month,
        nextDue: LocalDate.parse('2026-10-05'),
      );
    await open(tester, state, tab: 1);
    await tapKey(tester, 'plan-bill-${state.bills.single.id}');
    await tester.tap(find.byKey(const Key('choice-pay')));
    await tester.pumpAndSettle();
    expect(state.bills.single.nextDue, LocalDate.parse('2026-11-05'));
    expect(state.snapshot.trustedAllocatableLiquidity, eur('980.00'));
  });

  testWidgets('pay that is due is asked about on Home, and counts once it came',
      (tester) async {
    final state = AppState(
      now: now.add(const Duration(days: 28)),
      utcOffset: Duration.zero,
    )..replaceWith(PlanDocument.decode(funded().toDocument().encode()));
    await open(tester, state);
    // The tile carries a dot while the pay is due.
    expect(find.byKey(const Key('home-pay-arrived-flag')), findsOneWidget);
    await tapKey(tester, 'home-pay-arrived');
    expect(find.text('How much arrived?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(state.snapshot.trustedAllocatableLiquidity, eur('3000.00'));
    expect(state.payDue, isFalse);
    expect(find.byKey(const Key('home-pay-arrived-flag')), findsNothing);
  });

  testWidgets('an account is added on Plan and offered when spending',
      (tester) async {
    final state = funded();
    await open(tester, state, tab: 1);
    await tapKey(tester, 'plan-account-add');
    await tester.tap(find.byKey(const Key('account-kind-card')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('account-name')), 'Visa');
    await tester.enterText(
      find.descendant(
        of: find.byKey(const Key('account-opening')),
        matching: find.byType(TextField),
      ),
      '0',
    );
    await tester.pump();
    await tapKey(tester, 'account-save');
    expect(state.accounts.single.kind, AccountKind.card);

    await tester.tap(find.byKey(const Key('nav-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Record a spend'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '50');
    await tester.pump();
    await tester.tap(find.byKey(Key('pay-from-${state.accounts.single.id}')));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    // Spent on the card: the bank is untouched, the card owes it, and it
    // is set aside until paid.
    expect(state.snapshot.trustedAllocatableLiquidity, eur('1000.00'));
    expect(state.accountBalance(state.accounts.single.id), eur('50.00'));
    expect(state.snapshot.safeToSpendNow, eur('550.00'));
  });

  testWidgets('a category is suggested from the record, and one tap changes it',
      (tester) async {
    final state = funded();
    for (var i = 0; i < 3; i++) {
      state.recordExpense(eur('12.00'), category: SpendCategory.food);
    }
    await open(tester, state);
    await tester.tap(find.text('Record a spend'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '11');
    await tester.pump();
    expect(find.byKey(const Key('amount-category-suggested')), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect(state.categoryFor(state.lastRecordedEventId!), SpendCategory.food);
  });

  testWidgets('a returned purchase is followed to its refund', (tester) async {
    final state = funded()..recordExpense(eur('80.00'));
    final spend = state.lastRecordedEventId!;
    state.clearExpenseConfirmation();
    await open(tester, state, tab: 3);

    await tester.tap(find.text('−€80'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('recover-expect')));
    await tester.pumpAndSettle();
    expect(state.recoveryFor(spend)!.state, RecoveryState.refundPending);
    expect(find.byKey(const Key('money-coming-back')), findsOneWidget);

    await tester.tap(find.text('−€80'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('recover-arrived')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('choice-leave')));
    await tester.pumpAndSettle();
    expect(state.recoveryFor(spend)!.state, RecoveryState.refunded);
    expect(state.snapshot.trustedAllocatableLiquidity, eur('1000.00'));
  });

  testWidgets('the gauge counts the days to pay and says what the pay brings',
      (tester) async {
    final state = funded();
    await open(tester, state);
    final gauge = find.byKey(const Key('pay-gauge'));
    await tester.ensureVisible(gauge);
    await tester.pumpAndSettle();
    // 1 October to 28 October.
    expect(
      tester.widget<Text>(find.byKey(const Key('pay-gauge-days'))).data,
      '27',
    );
    // What is free once the pay lands, beside what has to last until then.
    expect(find.text('NEXT PAY'), findsOneWidget);
    expect(find.text('TO LAST'), findsOneWidget);
  });

  testWidgets('a goal path opens, and a new pace moves its date only when chosen',
      (tester) async {
    final state = funded()
      ..addGoal(
        name: 'Bike',
        target: eur('600.00'),
        targetDate: LocalDate.parse('2027-10-01'),
      );
    final goal = state.goals.single;
    final before = goal.targetDate;
    await open(tester, state, tab: 2);
    await tapKey(tester, 'goal-tile-${goal.id}');
    await tapKey(tester, 'goal-path-${goal.id}');
    expect(find.byKey(Key('goal-chart-${goal.id}')), findsOneWidget);

    // All the way right: the most per period, the soonest date.
    final slider = find.byKey(Key('goal-pace-${goal.id}'));
    await tester.ensureVisible(slider);
    await tester.pumpAndSettle();
    await tester.drag(slider, const Offset(400, 0));
    await tester.pumpAndSettle();
    expect(state.goals.single.targetDate, before);

    await tapKey(tester, 'goal-pace-apply-${goal.id}');
    expect(state.goals.single.targetDate < before, isTrue);
  });

  testWidgets('the quick menu reaches the bills and the month from Home',
      (tester) async {
    final state = funded()
      ..addBill(
        name: 'Phone',
        amount: eur('20.00'),
        every: BillEvery.month,
        nextDue: LocalDate.parse('2026-10-05'),
      );
    await open(tester, state);
    expect(find.byKey(const Key('quick-actions')), findsOneWidget);

    await tapKey(tester, 'home-bills');
    await tester.tap(find.byKey(Key('bills-sheet-${state.bills.single.id}')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('choice-pay')));
    await tester.pumpAndSettle();
    expect(state.bills.single.nextDue, LocalDate.parse('2026-11-05'));
    // The sheet follows the plan while it is open.
    expect(find.text('Nov 5'), findsNothing);
    expect(find.textContaining('November 5'), findsWidgets);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tapKey(tester, 'home-month');
    expect(find.byKey(const Key('month-review')), findsOneWidget);
    // Before the first month it still says when the look back is ready.
    expect(find.textContaining('30 days'), findsWidgets);
  });

  testWidgets('the goal rings arrive: the centre counts up to the whole',
      (tester) async {
    final state = funded()
      ..addGoal(
        name: 'Bike',
        target: eur('600.00'),
        targetDate: LocalDate.parse('2027-10-01'),
      );
    state.contributeToGoal(state.goals.single.id, eur('300.00'));
    await open(tester, state);
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Early in the welcome the count has not reached the whole.
    expect(
      tester.widget<Text>(find.byKey(const Key('goals-overall'))).data,
      isNot('50%'),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.byKey(const Key('goals-overall'))).data,
      '50%',
    );
  });

  testWidgets('goals open on four samples until there are four of your own, '
      'and the samples leave the plan alone', (tester) async {
    GoalsScreen.samplesWhenFew = true;
    addTearDown(() => GoalsScreen.samplesWhenFew = false);
    final state = funded();
    final before = state.toDocument().encode();
    await open(tester, state, tab: 2);
    expect(find.byKey(const Key('goals-orbit')), findsOneWidget);
    expect(find.text('TRIP'), findsNothing); // Latin names curve, painted
    expect(find.text('Each goal'), findsOneWidget);
    expect(state.toDocument().encode(), before);
    expect(state.goals, isEmpty);
  });

  test('the sample plan has four goals, bills and months of history', () {
    final demo = buildDemo(
      now: now,
      utcOffset: Duration.zero,
      names: const DemoNames(
        goals: ['A', 'B', 'C', 'D'],
        bills: ['x', 'y', 'z'],
      ),
    );
    expect(demo.goals, hasLength(4));
    expect(demo.bills, hasLength(3));
    expect(demo.daysInUse, 92);
    expect(demo.monthlySpending().length, greaterThan(1));
    expect(demo.snapshot.mandatoryFundingGap.isZero, isTrue);
  });

  testWidgets('an answer comes after a moment of dots', (tester) async {
    final state = funded();
    await open(tester, state);
    await tester.tap(find.byKey(const Key('home-ask')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('chat-input')), 'how much can I spend');
    await tester.tap(find.byKey(const Key('chat-send')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('chat-typing')), findsOneWidget);
    expect(find.byKey(const Key('chat-answer-safe')), findsNothing);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('chat-typing')), findsNothing);
    expect(find.byKey(const Key('chat-answer-safe')), findsOneWidget);
  });
}
