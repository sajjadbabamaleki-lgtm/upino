// Bills, pay arriving, accounts and money coming back (Strategy §7.2, §11).
//
// Each of these is a claim on the money or a change to it, so each is pinned
// by what it does to Safe-to-Spend, not by what it shows.

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/domain/account.dart';
import 'package:upino/domain/bill.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/domain/recovery.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

final start = DateTime.utc(2026, 10, 1, 10);

/// 2000 in the bank, pay of 2000 on 31 October, nothing set aside.
AppState plan({DateTime? now}) => AppState(
      now: now ?? start,
      utcOffset: Duration.zero,
    )..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur('2000.00')
          ..incomeAmount = eur('2000.00')
          ..nextIncomeDate = LocalDate.parse('2026-10-31')
          ..payCycleDays = 30,
      );

AppState reopened(AppState from, {int days = 0}) =>
    AppState(now: start.add(Duration(days: days)), utcOffset: Duration.zero)
      ..replaceWith(PlanDocument.decode(from.toDocument().encode()));

void main() {
  group('bills', () {
    test('one due before the pay is protected in full', () {
      final state = plan()
        ..addBill(
          name: 'Phone',
          amount: eur('40.00'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-10-15'),
        );
      expect(state.snapshot.safeToSpendNow, eur('1960.00'));
    });

    test('a weekly one counts every payment before the pay', () {
      final state = plan()
        ..addBill(
          name: 'Cleaner',
          amount: eur('25.00'),
          every: BillEvery.week,
          nextDue: LocalDate.parse('2026-10-05'),
        );
      // 5, 12, 19 and 26 October: four payments before the 31st.
      expect(state.snapshot.safeToSpendNow, eur('1900.00'));
    });

    test('a monthly one due after the pay is left to the pay', () {
      final state = plan()
        ..addBill(
          name: 'Phone',
          amount: eur('40.00'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-11-10'),
        );
      expect(state.snapshot.safeToSpendNow, eur('2000.00'));
    });

    test('a yearly one is built up over its year', () {
      // Due in 395 days from the pay date's point of view is outside a year;
      // due 30 days after the horizon means 335 of 365 days have run.
      final state = plan()
        ..addBill(
          name: 'Insurance',
          amount: eur('365.00'),
          every: BillEvery.year,
          nextDue: LocalDate.parse('2026-11-30'),
        );
      expect(state.snapshot.safeToSpendNow, eur('1665.00'));
    });

    test('paying moves it on and records a bill spend', () {
      final state = plan()
        ..addBill(
          name: 'Phone',
          amount: eur('40.00'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-10-31'),
        );
      final id = state.bills.single.id;
      state.payBill(id);
      expect(state.bills.single.nextDue, LocalDate.parse('2026-11-30'));
      expect(state.spendingByCategory().single.category, SpendCategory.bills);
      // Paid, and the next one is after the pay: nothing more held back.
      expect(state.snapshot.safeToSpendNow, eur('1960.00'));
    });

    test('months keep their day, or the last one the month has', () {
      final b = Bill(
        id: 'x',
        name: 'x',
        amount: eur('1.00'),
        every: BillEvery.month,
        nextDue: LocalDate.parse('2027-01-31'),
      );
      expect(b.after(b.nextDue), LocalDate.parse('2027-02-28'));
    });

    test('the next thirty days are listed soonest first', () {
      final state = plan()
        ..addBill(
          name: 'B',
          amount: eur('10.00'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-10-20'),
        )
        ..addBill(
          name: 'A',
          amount: eur('5.00'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-10-03'),
        );
      expect(state.upcomingBills().map((u) => u.bill.name), ['A', 'B']);
      expect(state.billsDueWithin(), eur('15.00'));
    });

    test('survive reopening', () {
      final state = plan()
        ..addBill(
          name: 'Netflix',
          amount: eur('12.99'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-10-09'),
          kind: BillKind.subscription,
        );
      final again = reopened(state);
      expect(again.bills.single.name, 'Netflix');
      expect(again.bills.single.kind, BillKind.subscription);
      expect(again.snapshot.safeToSpendNow, state.snapshot.safeToSpendNow);
    });
  });

  group('pay arriving', () {
    test('becomes money, and the next one is expected a period later', () {
      final state = reopened(plan(), days: 30);
      expect(state.payDue, isTrue);
      state.confirmIncome(eur('2100.00'));
      expect(state.snapshot.trustedAllocatableLiquidity, eur('4100.00'));
      expect(state.nextIncome!.expectedDate, LocalDate.parse('2026-11-30'));
      expect(state.nextIncome!.expectedAmount, eur('2000.00'));
      expect(state.payDue, isFalse);
    });
  });

  group('accounts', () {
    test('cash counts, savings do not unless asked', () {
      final state = plan()
        ..addAccount(name: 'Wallet', kind: AccountKind.cash, opening: eur('100.00'))
        ..addAccount(
          name: 'Savings',
          kind: AccountKind.savings,
          opening: eur('5000.00'),
        );
      expect(state.snapshot.safeToSpendNow, eur('2100.00'));
      final savings = state.accounts.last.id;
      state.updateAccount(savings, counted: true);
      expect(state.snapshot.safeToSpendNow, eur('7100.00'));
    });

    test('a spend on a card is set aside until the card is paid', () {
      final state = plan()
        ..addAccount(name: 'Visa', kind: AccountKind.card, opening: eur('0.00'));
      final card = state.accounts.single.id;
      state.recordExpense(eur('300.00'), accountId: card);
      expect(state.snapshot.trustedAllocatableLiquidity, eur('2000.00'));
      expect(state.snapshot.safeToSpendNow, eur('1700.00'));
      expect(state.accountBalance(card), eur('300.00'));

      state.payCard(card, eur('300.00'));
      expect(state.snapshot.trustedAllocatableLiquidity, eur('1700.00'));
      expect(state.snapshot.safeToSpendNow, eur('1700.00'));
      expect(state.accountBalance(card), eur('0.00'));
    });

    test('what was owed on a card when added is set aside too', () {
      final state = plan()
        ..addAccount(name: 'Visa', kind: AccountKind.card, opening: eur('250.00'));
      expect(state.snapshot.safeToSpendNow, eur('1750.00'));
    });

    test('a loan goes down as its bill is paid', () {
      final state = plan()
        ..addAccount(name: 'Car', kind: AccountKind.loan, opening: eur('6000.00'));
      final loan = state.accounts.single.id;
      state.addBill(
        name: 'Car loan',
        amount: eur('250.00'),
        every: BillEvery.month,
        nextDue: LocalDate.parse('2026-10-10'),
        debtAccountId: loan,
      );
      state.payBill(state.bills.single.id);
      expect(state.accountBalance(loan), eur('5750.00'));
      expect(state.snapshot.trustedAllocatableLiquidity, eur('1750.00'));
      // A repayment is not spending.
      expect(state.spendingByCategory(), isEmpty);
    });

    test('moving money between counted accounts changes nothing', () {
      final state = plan()
        ..addAccount(name: 'Wallet', kind: AccountKind.cash, opening: eur('0.00'));
      final before = state.snapshot.safeToSpendNow;
      state.transfer(from: 'main', to: state.accounts.single.id, amount: eur('200.00'));
      expect(state.snapshot.safeToSpendNow, before);
      expect(state.accountBalance(state.accounts.single.id), eur('200.00'));
    });

    test('an account with history cannot be removed', () {
      final state = plan()
        ..addAccount(name: 'Wallet', kind: AccountKind.cash, opening: eur('50.00'));
      final wallet = state.accounts.single.id;
      state.recordExpense(eur('10.00'), accountId: wallet);
      expect(state.removeAccount(wallet), isFalse);
      expect(state.accountBalance(wallet), eur('40.00'));
    });

    test('survive reopening', () {
      final state = plan()
        ..addAccount(name: 'Visa', kind: AccountKind.card, opening: eur('80.00'));
      state.recordExpense(eur('20.00'), accountId: state.accounts.single.id);
      final again = reopened(state);
      expect(again.accounts.single.name, 'Visa');
      expect(again.accountBalance(again.accounts.single.id), eur('100.00'));
      expect(again.snapshot.safeToSpendNow, state.snapshot.safeToSpendNow);
    });
  });

  group('money coming back', () {
    test('an expected refund is shown but not spendable', () {
      final state = plan()..recordExpense(eur('120.00'));
      final spend = state.lastRecordedEventId!;
      state.expectRefund(spend);
      expect(state.moneyComingBack, eur('120.00'));
      expect(state.snapshot.safeToSpendNow, eur('1880.00'));
    });

    test('it counts once it arrives, and undoes the spend it came from', () {
      final state = plan()
        ..recordExpense(eur('120.00'), category: SpendCategory.shopping);
      final spend = state.lastRecordedEventId!;
      state
        ..expectRefund(spend)
        ..refundArrived(spend, eur('120.00'));
      expect(state.snapshot.safeToSpendNow, eur('2000.00'));
      expect(state.moneyComingBack, eur('0.00'));
      expect(state.recoveryFor(spend)!.state, RecoveryState.refunded);
      expect(state.spendingByCategory(), isEmpty);
    });

    test('what came back can go to a goal on purpose', () {
      final state = plan()
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        )
        ..recordExpense(eur('60.00'));
      final spend = state.lastRecordedEventId!;
      state
        ..refundArrived(spend, eur('60.00'))
        ..putRecoveredToward(goalId: state.goals.single.id, amount: eur('60.00'));
      expect(state.goals.single.saved, eur('60.00'));
      expect(state.contributions.single.amount, eur('60.00'));
    });
  });
}
