// Goals (§10) and their funding schedule (§8).
//
// A goal protects this period's contribution, not its whole target, so the
// arithmetic of that contribution is what these tests hold.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/data/serialization.dart';
import 'package:upino/design/parts.dart';
import 'package:upino/domain/goal.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);
final today = LocalDate.parse('2026-10-01');

Money eur(String v) => Money.parse(v, 'EUR');

Goal goal({
  String id = 'g1',
  String name = 'Trip',
  String target = '1200.00',
  String saved = '0.00',
  String date = '2027-10-01',
  GoalKind kind = GoalKind.hard,
}) =>
    Goal(
      id: id,
      name: name,
      target: eur(target),
      targetDate: LocalDate.parse(date),
      saved: eur(saved),
      kind: kind,
    );

AppState funded({PlanStore? store}) => AppState(
      now: now,
      utcOffset: cest,
      store: store,
    )..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur('2000.00')
          ..incomeAmount = eur('2000.00')
          ..nextIncomeDate = LocalDate.parse('2026-10-31')
          ..payCycleDays = 30,
      );

void main() {
  group('the funding schedule', () {
    test('spreads the remainder over the periods that are left', () {
      // 365 days at 30 per period is 13 periods; €1,200 over 13.
      final g = goal();
      expect(g.cyclesRemaining(today, 30), 13);
      expect(g.requiredThisCycle(today, 30), eur('92.31'));
    });

    test('money already put aside lowers what this period must hold', () {
      expect(goal().requiredThisCycle(today, 30), eur('92.31'));
      expect(goal(saved: '600.00').requiredThisCycle(today, 30), eur('46.15'));
    });

    test('a goal due today needs the whole remainder now, not a division by zero',
        () {
      final g = goal(date: '2026-10-01');
      expect(g.cyclesRemaining(today, 30), 1);
      expect(g.requiredThisCycle(today, 30), eur('1200.00'));
    });

    test('an overdue goal behaves the same rather than going negative', () {
      final g = goal(date: '2026-01-01');
      expect(g.cyclesRemaining(today, 30), 1);
      expect(g.requiredThisCycle(today, 30), eur('1200.00'));
    });

    test('a paused goal asks for nothing', () {
      expect(goal(kind: GoalKind.paused).requiredThisCycle(today, 30),
          eur('0.00'),);
    });

    test('a reached goal asks for nothing', () {
      final g = goal(saved: '1200.00');
      expect(g.isComplete, isTrue);
      expect(g.progress, 1.0);
      expect(g.requiredThisCycle(today, 30), eur('0.00'));
    });

    test('overshooting still reads as full rather than over full', () {
      expect(goal(saved: '1500.00').progress, 1.0);
      expect(goal(saved: '1500.00').remaining, eur('0.00'));
    });
  });

  group('where a goal sits in the waterfall', () {
    test('a committed goal is a hard claim', () {
      expect(goal().priority, Priority.p7HardGoal);
      expect(goal().toClaim(today, 30)!.priority, Priority.p7HardGoal);
    });

    test('a flexible goal yields first', () {
      expect(goal(kind: GoalKind.flexible).priority, Priority.p8Flexible);
    });

    test('a paused goal contributes no claim at all', () {
      expect(goal(kind: GoalKind.paused).priority, isNull);
      expect(goal(kind: GoalKind.paused).toClaim(today, 30), isNull);
    });
  });

  group('goals in the plan', () {
    test('a committed goal reduces what is safe to spend', () {
      final state = funded();
      expect(state.snapshot.safeToSpendNow, eur('2000.00'));

      state.addGoal(
        name: 'Trip',
        target: eur('1200.00'),
        targetDate: LocalDate.parse('2027-10-01'),
      );
      expect(state.snapshot.safeToSpendNow, eur('1907.69'));
    });

    test('a flexible goal yields before a hard obligation does', () {
      final state = funded()
        ..setClaimAmount('rent', eur('1950.00'))
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
          kind: GoalKind.flexible,
        );
      final s = state.snapshot;
      expect(s.safeToSpendNow, eur('0.00'));
      // Rent is fully funded; the flexible goal takes what is left.
      expect(s.mandatoryFundingGap, eur('0.00'));
      expect(s.flexibleShortfall.minor, greaterThan(0));
    });

    test('pausing a goal frees the money immediately', () {
      final state = funded()
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      final id = state.goals.single.id;
      expect(state.snapshot.safeToSpendNow, eur('1907.69'));

      state.updateGoal(id, kind: GoalKind.paused);
      expect(state.snapshot.safeToSpendNow, eur('2000.00'));
    });

    test('adding money lowers the contribution without spending anything', () {
      final state = funded()
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      final id = state.goals.single.id;
      final before = state.snapshot.safeToSpendNow;

      state.contributeToGoal(id, eur('600.00'));

      expect(state.goals.single.saved, eur('600.00'));
      expect(state.snapshot.ledger.cumulativeSpending, eur('0.00'),
          reason: 'putting money aside is not spending it',);
      expect(state.snapshot.safeToSpendNow.minor, greaterThan(before.minor));
    });

    test('removing a goal frees its contribution', () {
      final state = funded()
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      state.removeGoal(state.goals.single.id);
      expect(state.goals, isEmpty);
      expect(state.snapshot.safeToSpendNow, eur('2000.00'));
    });
  });

  group('storage', () {
    test('goals survive closing and reopening', () async {
      final store = InMemoryPlanStore();
      final state = funded(store: store)
        ..addGoal(
          name: 'Deposit',
          target: eur('5000.00'),
          targetDate: LocalDate.parse('2028-01-01'),
          kind: GoalKind.flexible,
        );
      state.contributeToGoal(state.goals.single.id, eur('250.00'));
      final before = state.snapshot.safeToSpendNow;

      final reopened = AppState(now: now, utcOffset: cest, store: store);
      await reopened.restore();

      expect(reopened.goals.single.name, 'Deposit');
      expect(reopened.goals.single.saved, eur('250.00'));
      expect(reopened.goals.single.kind, GoalKind.flexible);
      expect(reopened.snapshot.safeToSpendNow, before);
    });

    test('the kind persists by name, not position', () {
      final json = goalToJson(goal(kind: GoalKind.flexible));
      expect(json['kind'], 'flexible');
    });

    test('a plan saved before goals existed becomes a real goal', () async {
      // Version 2 documents carried a flat "goal" claim with no date.
      final store = InMemoryPlanStore(PlanDocument(
        currency: 'EUR',
        openingBalance: eur('1000.00'),
        events: const [],
        claims: [
          Claim(
            id: 'goal',
            priority: Priority.p7HardGoal,
            label: 'Savings goal',
            amount: eur('200.00'),
          ),
        ],
        incomeEvents: const [],
        onboarded: true,
      ).encode(),);

      final state = AppState(now: now, utcOffset: cest, store: store);
      await state.restore();

      expect(state.goals, hasLength(1));
      expect(state.goals.single.name, 'Savings goal');
      expect(state.goals.single.target, eur('200.00'));
      expect(state.editableClaims.where((c) => c.id == 'goal'), isEmpty);
    });

    test('the schema version moved with the shape', () {
      expect(schemaVersion, 6);
    });
  });

  group('the goals destination', () {
    testWidgets('the bar carries Goals and it opens the screen', (tester) async {
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav-2')));
      await tester.pumpAndSettle();
      expect(find.text('Goals'), findsWidgets);
      expect(find.byKey(const Key('goals-new')), findsOneWidget);
    });

    testWidgets('the Plan row switches to that same tab', (tester) async {
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('plan-goals')));
      await tester.pumpAndSettle();

      // The tab, not a pushed copy: the bar is still there and Goals is lit.
      expect(find.byType(UpinoNavBar), findsOneWidget);
      expect(find.byKey(const Key('goals-new')), findsOneWidget);
    });
  });

  group('the goals screen', () {
    Future<AppState> openGoals(WidgetTester tester, AppState state) async {
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-2')));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('an empty state explains what goals are for', (tester) async {
      await openGoals(tester, funded());
      expect(find.text('Nothing saved toward yet.'), findsOneWidget);
      expect(find.text('New goal'), findsOneWidget);
    });

    testWidgets('a goal can be created end to end', (tester) async {
      final state = await openGoals(tester, funded());

      await tester.tap(find.text('New goal'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('goal-name')), 'Laptop');
      await tester.enterText(find.byKey(const Key('goal-target')), '1200.00');
      await tester.pump();
      await tester.tap(find.byKey(const Key('goal-horizon-12')));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Add this goal'));
      await tester.pumpAndSettle();

      expect(state.goals.single.name, 'Laptop');
      expect(state.goals.single.target, eur('1200.00'));
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('of €1,200.00'), findsOneWidget);
    });

    testWidgets('money can be added to a goal from its card', (tester) async {
      final state = funded()
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      await openGoals(tester, state);

      final id = state.goals.single.id;
      await tester.tap(find.byKey(Key('goal-add-$id')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, '300.00');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(state.goals.single.saved, eur('300.00'));
      expect(find.text('€300.00'), findsOneWidget);
    });

    testWidgets('a goal can be deleted from its editor', (tester) async {
      final state = funded()
        ..addGoal(
          name: 'Trip',
          target: eur('1200.00'),
          targetDate: LocalDate.parse('2027-10-01'),
        );
      await openGoals(tester, state);

      await tester.tap(find.byType(RowAffordance).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('goal-delete')));
      await tester.pumpAndSettle();

      expect(state.goals, isEmpty);
    });
  });
}
