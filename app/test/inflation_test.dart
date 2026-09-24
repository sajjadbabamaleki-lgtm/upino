// What a goal will really cost on its date.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/domain/goal.dart';
import 'package:upino/domain/inflation.dart';
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
    )
    ..addGoal(
      name: 'Laptop',
      target: eur('1000.00'),
      targetDate: LocalDate.parse('2027-10-01'),
    );
}

void main() {
  group('the arithmetic', () {
    test('a year at 35% adds 35%', () {
      expect(inflated(eur('1000.00'), 3500, 365), eur('1350.00'));
    });

    test('whole years compound', () {
      expect(inflated(eur('1000.00'), 1000, 730), eur('1210.00'));
    });

    test('the rest of a year grows in proportion', () {
      expect(inflated(eur('1000.00'), 3650, 73), eur('1073.00'));
    });

    test('no rate or no time changes nothing', () {
      expect(inflated(eur('1000.00'), 0, 365), eur('1000.00'));
      expect(inflated(eur('1000.00'), 3500, 0), eur('1000.00'));
    });

    test('a rial amount does not overflow', () {
      final big = Money.parse('50000000000', 'IRR');
      expect(inflated(big, 5000, 3650).minor, greaterThan(big.minor * 50));
    });
  });

  group('rates as people write them', () {
    test('parsed', () {
      expect(parseRate('35'), 3500);
      expect(parseRate('35.5'), 3550);
      expect(parseRate('35,25 %'), 3525);
      expect(parseRate('abc'), isNull);
    });

    test('written', () {
      expect(formatRate(3500), '35');
      expect(formatRate(3550), '35.5');
      expect(formatRate(3525), '35.25');
    });
  });

  group('the plan', () {
    test('says nothing until a rate is set', () async {
      final state = await funded(InMemoryPlanStore());
      expect(state.inflatedTarget(state.goals.single), isNull);
    });

    test('grows a goal to its date', () async {
      final state = await funded(InMemoryPlanStore())..setInflation(3500);
      expect(state.inflatedTarget(state.goals.single), eur('1350.00'));
    });

    test('changes no figure, because the estimate is advice, not a claim',
        () async {
      final state = await funded(InMemoryPlanStore());
      final before = state.snapshot.safeToSpendNow;
      state.setInflation(3500);
      expect(state.snapshot.safeToSpendNow, before);
    });

    test('says nothing for a paused goal', () async {
      final state = await funded(InMemoryPlanStore())..setInflation(3500);
      state.updateGoal(state.goals.single.id, kind: GoalKind.paused);
      expect(state.inflatedTarget(state.goals.single), isNull);
    });

    test('is kept across reopening', () async {
      final store = InMemoryPlanStore();
      (await funded(store)).setInflation(3500);
      final reopened = AppState(now: now, utcOffset: cest, store: store);
      await reopened.restore();
      expect(reopened.inflationBasisPoints, 3500);
    });
  });

  testWidgets('the Goals screen shows the grown cost once a rate is set',
      (tester) async {
    final state = await funded(InMemoryPlanStore());
    tester.view
      ..physicalSize = const Size(420, 1600)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(UpinoApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('goals-show-mine')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('goals-inflation')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('inflation-field')), '35');
    await tester.tap(find.byKey(const Key('inflation-save')));
    await tester.pumpAndSettle();

    expect(state.inflationBasisPoints, 3500);
    // Said on the goal itself, which opens from its tile.
    await tester.tap(find.byKey(Key('goal-tile-${state.goals.single.id}')));
    await tester.pumpAndSettle();
    expect(
      find.text('At 35% a year, this will cost about €1,350.00 by then.'),
      findsOneWidget,
    );
  });
}
