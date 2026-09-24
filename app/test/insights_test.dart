// Best move, the month close and spending insights (Strategy §6.2, §12,
// §13). Each rule is pinned by the evidence that triggers it and by the
// evidence that keeps it quiet.

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/domain/account.dart';
import 'package:upino/domain/bill.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/state/ask_answers.dart';
import 'package:upino/state/insights.dart';

Money eur(String v) => Money.parse(v, 'EUR');
final start = DateTime.utc(2026, 10, 1, 10);

AppState plan({String balance = '1000.00', String? rent, String? pay}) =>
    AppState(now: start, utcOffset: Duration.zero)
      ..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur(balance)
          ..incomeAmount = eur('2000.00')
          ..nextIncomeDate = LocalDate.parse(pay ?? '2026-10-31')
          ..payCycleDays = 30
          ..rent = rent == null ? null : eur(rent),
      );

AppState later(AppState from, int days) =>
    AppState(now: start.add(Duration(days: days)), utcOffset: Duration.zero)
      ..replaceWith(PlanDocument.decode(from.toDocument().encode()));

void main() {
  group('best move', () {
    test('nothing to say about a new plan with nothing wrong', () {
      expect(plan().bestMove, isNull);
    });

    test('MOVE: money outside the plan covers what is short', () {
      final state = plan(balance: '300.00', rent: '500.00')
        ..addAccount(
          name: 'Savings',
          kind: AccountKind.savings,
          opening: eur('1000.00'),
        );
      final m = state.bestMove!;
      expect(m.kind, MoveKind.move);
      expect(m.amount, eur('200.00'));
      expect(m.from!.name, 'Savings');

      state.transfer(from: m.from!.id, to: 'main', amount: m.amount!);
      expect(state.snapshot.mandatoryFundingGap.isZero, isTrue);
    });

    test('WAIT: pay is days away and makes the room much bigger', () {
      final state = plan(balance: '520.00', rent: '500.00', pay: '2026-10-04');
      final m = state.bestMove!;
      expect(m.kind, MoveKind.wait);
      expect(m.waitForGap, isFalse);
      expect(m.days, 3);
      expect(m.amount, eur('20.00'));
    });

    test('short now with nothing to move it from: nothing to suggest', () {
      final state = plan(balance: '100.00', pay: '2026-12-31')
        ..addBill(
          name: 'Insurance',
          amount: eur('900.00'),
          every: BillEvery.year,
          nextDue: LocalDate.parse('2026-10-20'),
        );
      // Due before the horizon: short today, and nothing to move it from.
      expect(state.bestMove, isNull);
    });

    test('SPEND: covered, with room well beyond a month of spending', () {
      final state = plan(balance: '3000.00');
      for (var i = 0; i < 4; i++) {
        state.recordExpense(eur('50.00'), category: SpendCategory.food);
      }
      final m = later(state, 35).bestMove!;
      expect(m.kind, MoveKind.spend);
    });

    test('SAVE: spare room, a goal, and savings outside the plan', () {
      final state = plan(balance: '5000.00')
        ..addAccount(name: 'Savings', kind: AccountKind.savings, opening: eur('0.00'))
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      for (var i = 0; i < 4; i++) {
        state.recordExpense(eur('100.00'), category: SpendCategory.food);
      }
      final month = later(state, 35);
      final m = month.bestMove!;
      expect(m.kind, MoveKind.save);
      expect(m.goal!.name, 'Trip');
      expect(m.days, greaterThan(0));

      final free = month.snapshot.trustedAllocatableLiquidity;
      month.saveTowardGoal(m.goal!.id, m.amount!);
      expect(month.goals.single.saved, m.amount);
      // It left the plan: into savings, not counted twice.
      expect(month.snapshot.trustedAllocatableLiquidity, free - m.amount!);
    });

    test('not now hides that suggestion only', () {
      final state = plan(balance: '520.00', rent: '500.00', pay: '2026-10-04');
      final m = state.bestMove!;
      state.dismissMove(m.key);
      expect(state.dismissedMove, m.key);
    });
  });

  group('month close', () {
    test('counts pay that came and money put toward goals', () {
      final state = plan()
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      final month = later(state, 30)
        ..confirmIncome(eur('2000.00'))
        ..contributeToGoal(state.goals.single.id, eur('100.00'));
      final r = month.monthReview;
      expect(r.income, eur('2000.00'));
      expect(r.toGoals, eur('100.00'));
    });

    test('looks ahead: bills, the next pay, and the tightest day', () {
      final state = plan()
        ..addBill(
          name: 'Phone',
          amount: eur('40.00'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-10-10'),
        );
      final a = state.monthAhead;
      expect(a.billCount, 1);
      expect(a.billTotal, eur('40.00'));
      expect(a.nextPay, LocalDate.parse('2026-10-31'));
    });
  });

  group('insights', () {
    test('need two months of record', () {
      final state = plan();
      for (var i = 0; i < 5; i++) {
        state.recordExpense(eur('20.00'), category: SpendCategory.fun);
      }
      expect(later(state, 30).insights, isEmpty);
    });

    test('a real rise is named, with what it means for a goal', () {
      final state = plan(balance: '5000.00')
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      final first = later(state, 10);
      for (var i = 0; i < 4; i++) {
        first.recordExpense(eur('25.00'), category: SpendCategory.fun);
      }
      final second = later(first, 45);
      for (var i = 0; i < 5; i++) {
        second.recordExpense(eur('40.00'), category: SpendCategory.fun);
      }
      final insight = later(second, 65).insights.single;
      expect(insight.category, SpendCategory.fun);
      expect(insight.up, eur('100.00'));
      expect(insight.goal!.name, 'Trip');
      // By then ten periods are left for 1200, so 120 a period; 100 more
      // a month is 100/120 of a thirty-day period.
      expect(insight.goalDays, 25);
    });
  });

  group('asking', () {
    test('what to do next, and what is coming up, in both languages', () {
      final state = plan()
        ..addBill(
          name: 'Phone',
          amount: eur('40.00'),
          every: BillEvery.month,
          nextDue: LocalDate.parse('2026-10-10'),
        );
      expect(answerQuestion('what should I do next?', state),
          isA<BestMoveAnswer>(),);
      expect(answerQuestion('الان بهترین کار چیه؟', state),
          isA<BestMoveAnswer>(),);
      final coming = answerQuestion('چه قبض‌هایی در راه است؟', state);
      expect(coming, isA<ComingUpAnswer>());
      expect((coming as ComingUpAnswer).bills.single.bill.name, 'Phone');
      expect(answerQuestion('what bills are coming up', state),
          isA<ComingUpAnswer>(),);
    });
  });
}
