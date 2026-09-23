// Receipt photographs (§5, Purchase Lifecycle).
//
// The camera itself is a platform channel and cannot run here, so these cover
// what can break without a device: that a receipt is stored against the right
// event, that it survives a restart, that removing an entry does not erase
// it, and that the engine never sees it.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/data/serialization.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded({PlanStore? store}) => AppState(
      now: DateTime.utc(2026, 10, 1, 10),
      utcOffset: const Duration(hours: 2),
      store: store,
    )..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur('2000.00')
          ..incomeAmount = eur('2000.00')
          ..nextIncomeDate = LocalDate.parse('2026-10-31')
          ..payCycleDays = 30,
      );

void main() {
  group('storing a receipt', () {
    test('attaches to the event it was recorded with', () {
      final state = funded()
        ..recordExpense(eur('25.00'), receipt: 'r1.jpg')
        ..recordExpense(eur('40.00'));

      final entries = state.activity;
      expect(entries.length, 2);
      // Newest first, so the one without a photograph comes back first.
      expect(state.receiptFor(entries.first.eventId), isNull);
      expect(state.receiptFor(entries.last.eventId), 'r1.jpg');
    });

    test('a spend without one is still a complete record of the money', () {
      final state = funded()..recordExpense(eur('25.00'));
      expect(state.receiptFor(state.activity.single.eventId), isNull);
      expect(state.snapshot.ledger.cumulativeSpending, eur('25.00'));
    });

    test('the engine never sees it', () {
      // A photograph is evidence about a purchase, not part of the money
      // arithmetic. Two states differing only by a receipt must agree.
      final without = funded()..recordExpense(eur('25.00'));
      final with_ = funded()..recordExpense(eur('25.00'), receipt: 'r1.jpg');
      expect(with_.snapshot.safeToSpendNow, without.snapshot.safeToSpendNow);
      expect(
        with_.snapshot.ledger.cumulativeSpending,
        without.snapshot.ledger.cumulativeSpending,
      );
    });

    test('can be added to an entry recorded earlier', () {
      final state = funded()..recordExpense(eur('25.00'));
      final id = state.activity.single.eventId;
      state.attachReceipt(id, 'later.jpg');
      expect(state.receiptFor(id), 'later.jpg');
    });
  });

  group('keeping it', () {
    test('survives a restart', () async {
      final store = InMemoryPlanStore();
      final first = funded(store: store)
        ..recordExpense(eur('25.00'), receipt: 'r1.jpg');
      final id = first.activity.single.eventId;

      final second = AppState(
        now: DateTime.utc(2026, 10, 1, 10),
        utcOffset: const Duration(hours: 2),
        store: store,
      );
      await second.restore();
      expect(second.receiptFor(id), 'r1.jpg');
    });

    test('removing the entry does not erase the photograph', () {
      // §21: a correction adds to the record rather than deleting from it,
      // and the photograph is part of that record.
      final state = funded()..recordExpense(eur('25.00'), receipt: 'r1.jpg');
      final id = state.activity.single.eventId;
      state.removeEvent(id);

      expect(state.activity.single.removed, isTrue);
      expect(state.receiptFor(id), 'r1.jpg');
    });

    test('an older stored plan without receipts still opens', () async {
      // The field is additive, so a document written before it existed must
      // read back rather than fail.
      final store = InMemoryPlanStore(
        '{"schemaVersion":$schemaVersion,"currency":"EUR",'
        '"openingBalance":{"minor":200000,"currency":"EUR"},'
        '"onboarded":true,"eventSequence":0,"themeChoice":"system",'
        '"payCycleDays":30,"goals":[],"events":[],"claims":[],'
        '"incomeEvents":[]}',
      );
      final state = AppState(now: DateTime.utc(2026, 10, 1, 10), store: store);
      await state.restore();
      expect(state.restoreFailure, isNull);
      expect(state.receiptFor('e1'), isNull);
    });
  });

  group('the affordance', () {
    testWidgets('is offered when recording a spend', (tester) async {
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Record a spend'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('receipt-camera')), findsOneWidget);
      expect(find.byKey(const Key('receipt-gallery')), findsOneWidget);
    });

    testWidgets('is not offered when editing a plan figure', (tester) async {
      // A commitment is a number in a plan, not a purchase that happened;
      // there is nothing to photograph.
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('plan-balance')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('receipt-camera')), findsNothing);
    });
  });
}
