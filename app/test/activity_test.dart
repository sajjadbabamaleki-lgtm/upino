// Recording, listing and correcting.
//
// A correction must do two things that pull against each other: stop the
// entry counting immediately, and leave the record intact. These tests hold
// both.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/ledger.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded({PlanStore? store}) => AppState(
      now: now,
      utcOffset: cest,
      store: store,
    )..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur('1000.00')
          ..incomeAmount = eur('2000.00')
          ..nextIncomeDate = LocalDate.parse('2026-10-28')
          ..rent = eur('400.00'),
      );

void main() {
  group('correcting an entry', () {
    test('removal restores the figure but keeps the record', () {
      final state = funded();
      expect(state.snapshot.safeToSpendNow, eur('600.00'));

      state.recordExpense(eur('25.00'));
      expect(state.snapshot.safeToSpendNow, eur('575.00'));
      expect(state.activity.single.removed, isFalse);

      final entryId = state.activity.single.eventId;
      state.removeEvent(entryId);

      // Stops counting immediately.
      expect(state.snapshot.safeToSpendNow, eur('600.00'));
      expect(state.snapshot.ledger.cumulativeSpending, eur('0.00'));

      // And is still on the record, marked.
      expect(state.activity.single.removed, isTrue);
      expect(state.activity.single.amount, eur('25.00'));
    });

    test('the voided event is never dropped from the log', () {
      final state = funded()..recordExpense(eur('25.00'));
      final entryId = state.activity.single.eventId;
      state.removeEvent(entryId);

      final events = state.toDocument().events;
      expect(events.whereType<ExpenseEvent>().length, 1,
          reason: 'the original expense must remain',);
      expect(events.whereType<CorrectionEvent>().length, 1);
      expect(events.whereType<CorrectionEvent>().single.voidsEventId, entryId);
    });

    test('a correction carries the reason it was made', () {
      final state = funded()..recordExpense(eur('10.00'));
      state.removeEvent(state.activity.single.eventId, reason: 'Typed twice');
      expect(
        state.toDocument().events.whereType<CorrectionEvent>().single.reason,
        'Typed twice',
      );
    });

    test('removing twice is a no-op, not a second correction', () {
      final state = funded()..recordExpense(eur('25.00'));
      final entryId = state.activity.single.eventId;
      state
        ..removeEvent(entryId)
        ..removeEvent(entryId);
      expect(
        state.toDocument().events.whereType<CorrectionEvent>().length,
        1,
      );
      expect(state.snapshot.safeToSpendNow, eur('600.00'));
    });

    test('removing an unknown id changes nothing', () {
      final state = funded()..recordExpense(eur('25.00'));
      final before = state.toDocument().events.length;
      state.removeEvent('no-such-event');
      expect(state.toDocument().events.length, before);
      expect(state.snapshot.safeToSpendNow, eur('575.00'));
    });

    test('only the corrected entry stops counting', () {
      final state = funded()
        ..recordExpense(eur('10.00'))
        ..recordExpense(eur('20.00'))
        ..recordExpense(eur('30.00'));
      expect(state.snapshot.safeToSpendNow, eur('540.00'));

      // activity is newest first, so this is the €20 entry.
      state.removeEvent(state.activity[1].eventId);

      expect(state.snapshot.safeToSpendNow, eur('560.00'));
      expect(state.activity.map((e) => e.removed).toList(),
          [false, true, false],);
    });

    test('a correction survives saving and reopening', () async {
      final store = InMemoryPlanStore();
      final state = funded(store: store)..recordExpense(eur('25.00'));
      state.removeEvent(state.activity.single.eventId);

      final reopened = AppState(now: now, utcOffset: cest, store: store);
      await reopened.restore();

      expect(reopened.snapshot.safeToSpendNow, eur('600.00'));
      expect(reopened.activity.single.removed, isTrue);
      expect(
        reopened.toDocument().events.whereType<CorrectionEvent>().length,
        1,
      );
    });
  });

  group('the activity list', () {
    test('shows newest first and signs each amount', () {
      final state = funded()
        ..recordExpense(eur('10.00'))
        ..recordExpense(eur('20.00'));
      final entries = state.activity;
      expect(entries.map((e) => e.amount).toList(), [eur('20.00'), eur('10.00')]);
      expect(entries.every((e) => e.increasesMoney == false), isTrue);
    });

    test('a balance confirmation appears as a correction, not as spending', () {
      final state = funded()..confirmBalance(eur('950.00'));
      final entry = state.activity.single;
      expect(entry.kind, ActivityKind.balanceCorrected);
      expect(entry.amount, eur('50.00'));
      expect(entry.increasesMoney, isFalse);
      expect(state.snapshot.ledger.cumulativeSpending, eur('0.00'));
    });

    test('corrections are not themselves rows', () {
      final state = funded()..recordExpense(eur('25.00'));
      state.removeEvent(state.activity.single.eventId);
      expect(state.activity.length, 1);
    });
  });

  group('the activity screen', () {
    Future<AppState> boot(WidgetTester tester, AppState state) async {
      tester.view
        ..physicalSize = const Size(420, 1200)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-3')));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('lists what was recorded and removes it on confirmation',
        (tester) async {
      final state = funded()..recordExpense(eur('25.00'));
      await boot(tester, state);

      expect(find.text('Activity'), findsWidgets);
      expect(find.text('Spent'), findsOneWidget);
      expect(find.text('−€25'), findsOneWidget);

      await tester.tap(find.text('Spent'));
      await tester.pumpAndSettle();
      expect(find.text('Remove €25?'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Remove it'));
      await tester.pumpAndSettle();

      expect(find.text('REMOVED'), findsOneWidget);
      expect(state.snapshot.safeToSpendNow, eur('600.00'));
    });

    testWidgets('keeping it changes nothing', (tester) async {
      final state = funded()..recordExpense(eur('25.00'));
      await boot(tester, state);

      await tester.tap(find.text('Spent'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Keep it'));
      await tester.pumpAndSettle();

      expect(find.text('REMOVED'), findsNothing);
      expect(state.snapshot.safeToSpendNow, eur('575.00'));
    });

    testWidgets('an empty list explains itself', (tester) async {
      await boot(tester, funded());
      expect(find.text('Nothing recorded yet.'), findsOneWidget);
    });
  });
}
