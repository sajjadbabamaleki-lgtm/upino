// Saving and reopening a plan.
//
// The document stores the event log and plan state, never a computed figure,
// so the real assertion is that a restored plan produces an identical
// snapshot: same Safe-to-Spend, same gap, same allocations, same reasons.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_document.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/data/serialization.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/ledger.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/state/app_state.dart';

const eurCode = 'EUR';
final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

Money eur(String v) => Money.parse(v, eurCode);

/// A plan that exercises every persisted shape at once.
AppState populated(PlanStore store) {
  final state = AppState(now: now, utcOffset: cest, store: store)
    ..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur('3000.00')
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-28')
        ..rent = eur('1200.00')
        ..essentials = eur('400.00')
        ..cardMinimum = eur('75.00')
        ..goalAmount = eur('250.00'),
    )
    ..recordExpense(eur('25.50'))
    ..recordExpense(eur('9.99'))
    ..confirmBalance(eur('2960.00'));
  return state;
}

void main() {
  group('round trip', () {
    test('a restored plan produces an identical snapshot', () async {
      final store = InMemoryPlanStore();
      final before = populated(store).snapshot;

      final restored = AppState(now: now, utcOffset: cest, store: store);
      await restored.restore();
      final after = restored.snapshot;

      expect(restored.isRestored, isTrue);
      expect(restored.restoreFailure, isNull);
      expect(restored.isOnboarded, isTrue);

      expect(after.safeToSpendNow, before.safeToSpendNow);
      expect(after.projectedSafeToSpend, before.projectedSafeToSpend);
      expect(after.mandatoryFundingGap, before.mandatoryFundingGap);
      expect(after.bufferShortfall, before.bufferShortfall);
      expect(after.protectedTotal, before.protectedTotal);
      expect(after.confidenceState, before.confidenceState);
      expect(after.reasonCodes, before.reasonCodes);
      expect(after.decisionHorizonEnd, before.decisionHorizonEnd);
      expect(after.trustedAllocatableLiquidity,
          before.trustedAllocatableLiquidity,);
      expect(
        after.allocations.map((a) => '${a.claimId}=${a.allocated}').toList(),
        before.allocations.map((a) => '${a.claimId}=${a.allocated}').toList(),
      );
      expect(after.ledger.cumulativeSpending, before.ledger.cumulativeSpending);
    });

    test('encoding twice is stable', () async {
      final store = InMemoryPlanStore();
      populated(store);
      final first = store.raw!;
      final reread = PlanDocument.decode(first).encode();
      expect(reread, first);
    });

    test('every ledger event kind survives the trip', () {
      final events = <LedgerEvent>[
        ExpenseEvent(id: 'a', accountId: 'main', amount: eur('10.00')),
        CardPurchaseEvent(id: 'b', cardId: 'visa', amount: eur('20.00')),
        CardSettlementEvent(
            id: 'c', accountId: 'main', cardId: 'visa', amount: eur('20.00'),),
        IncomeConfirmedEvent(id: 'd', accountId: 'main', amount: eur('30.00')),
        LoanDrawdownEvent(
            id: 'e', accountId: 'main', debtId: 'loan', amount: eur('40.00'),),
        DebtPaymentEvent(
            id: 'f', accountId: 'main', debtId: 'loan', amount: eur('50.00'),),
        TransferEvent(
            id: 'g',
            fromAccountId: 'main',
            toAccountId: 'save',
            amount: eur('60.00'),),
        RefundEvent(
            id: 'h',
            accountId: 'main',
            amount: eur('70.00'),
            linkedExpenseId: 'a',),
        RefundEvent(id: 'i', accountId: 'main', amount: eur('80.00')),
        BalanceAdjustmentEvent(
            id: 'j',
            accountId: 'main',
            delta: eur('-5.00'),
            reason: 'observed',
            supersededBy: 'a',),
        ExpenseEvent(
            id: 'k',
            accountId: 'main',
            amount: eur('90.00'),
            canonicalId: 'merchant-1',),
      ];

      for (final event in events) {
        final json = jsonDecode(jsonEncode(ledgerEventToJson(event)));
        final back = ledgerEventFromJson(Map<String, Object?>.from(json as Map));
        expect(
          jsonEncode(ledgerEventToJson(back)),
          jsonEncode(ledgerEventToJson(event)),
          reason: '${event.runtimeType} did not survive',
        );
      }
    });

    test('a reservation keeps its state and consumed amount', () {
      final partial = Reservation(eur('500.00')).settle(eur('300.00'));
      final claim = Claim(
        id: 'bill',
        priority: Priority.p2HardObligation,
        label: 'Bill',
        amount: eur('500.00'),
        dueDate: LocalDate.parse('2026-10-15'),
        userPriority: 3,
        reservation: partial,
      );
      final back = claimFromJson(
        Map<String, Object?>.from(jsonDecode(jsonEncode(claimToJson(claim))) as Map),
      );
      expect(back.reservation!.state, ReservationState.reserved);
      expect(back.reservation!.consumed, eur('300.00'));
      expect(back.reservation!.remaining, eur('200.00'));
      expect(back.dueDate, claim.dueDate);
      expect(back.userPriority, 3);
    });
  });

  group('durability of meaning', () {
    test('enums persist by name, not position', () {
      final json = claimToJson(Claim(
        id: 'x',
        priority: Priority.p7HardGoal,
        label: 'Goal',
        amount: eur('1.00'),
      ),);
      expect(json['priority'], 'p7HardGoal');
      expect(json['priority'], isNot(isA<int>()));
    });

    test('money persists as minor units, never a decimal string', () {
      final json = moneyToJson(eur('1234.56'));
      expect(json['minor'], 123456);
      expect(json['currency'], 'EUR');
    });

    test('an unknown enum name is refused rather than guessed', () {
      expect(
        () => claimFromJson({
          'id': 'x',
          'priority': 'p99Invented',
          'label': 'Goal',
          'amount': {'minor': 100, 'currency': 'EUR'},
        }),
        throwsA(isA<UnreadablePlanDocument>()),
      );
    });

    test('an unknown event kind is refused rather than dropped', () {
      expect(
        () => ledgerEventFromJson({'id': 'x', 'kind': 'teleport'}),
        throwsA(isA<UnreadablePlanDocument>()),
      );
    });

    test('a newer schema is refused rather than misread', () {
      expect(
        () => PlanDocument.fromJson({
          'schemaVersion': schemaVersion + 1,
          'currency': 'EUR',
          'openingBalance': {'minor': 0, 'currency': 'EUR'},
        }),
        throwsA(isA<UnreadablePlanDocument>()),
      );
    });

    test('a corrupt file leaves the plan empty and reports why', () async {
      final store = InMemoryPlanStore('{ not json at all');
      final state = AppState(now: now, utcOffset: cest, store: store);
      await state.restore();

      expect(state.isRestored, isTrue);
      expect(state.restoreFailure, isNotNull);
      expect(state.isOnboarded, isFalse,
          reason: 'a half-read document must not become a plan',);
    });

    test('a first run with no saved plan starts clean', () async {
      final state = AppState(now: now, utcOffset: cest, store: InMemoryPlanStore());
      await state.restore();
      expect(state.isRestored, isTrue);
      expect(state.restoreFailure, isNull);
      expect(state.isOnboarded, isFalse);
    });
  });

  group('file storage', () {
    late Directory dir;

    setUp(() => dir = Directory.systemTemp.createTempSync('upino-test'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('writes, reads back, and clears', () async {
      final store = FilePlanStore(File('${dir.path}/plan.json'));
      expect(await store.load(), isNull);

      final state = AppState(now: now, utcOffset: cest, store: store)
        ..completeOnboarding(
          OnboardingDraft()
            ..currentBalance = eur('500.00')
            ..incomeAmount = eur('1000.00')
            ..nextIncomeDate = LocalDate.parse('2026-10-28'),
        );
      await store.save(state.toDocument());

      final reopened = AppState(now: now, utcOffset: cest, store: store);
      await reopened.restore();
      expect(reopened.snapshot.safeToSpendNow, eur('500.00'));

      await store.clear();
      expect(await store.load(), isNull);
    });

    test('concurrent saves do not race the scratch file', () async {
      final target = File('${dir.path}/plan.json');
      final store = FilePlanStore(target);

      final state = AppState(now: now, utcOffset: cest, store: store)
        ..completeOnboarding(
          OnboardingDraft()
            ..currentBalance = eur('500.00')
            ..incomeAmount = eur('1000.00')
            ..nextIncomeDate = LocalDate.parse('2026-10-28'),
        );

      // The app persists after every mutation, so several writes can be in
      // flight at once. None of them may fail, and the newest must win.
      final writes = <Future<void>>[];
      for (var i = 1; i <= 8; i++) {
        state.recordExpense(eur('1.00'));
        writes.add(store.save(state.toDocument()));
      }
      await Future.wait(writes);

      final onDisk = PlanDocument.decode(target.readAsStringSync());
      expect(onDisk.events.length, state.toDocument().events.length);
      expect(File('${target.path}.writing').existsSync(), isFalse);
    });

    test('an interrupted write cannot leave a half-saved plan', () async {
      final target = File('${dir.path}/plan.json');
      final store = FilePlanStore(target);

      final state = AppState(now: now, utcOffset: cest, store: store)
        ..completeOnboarding(
          OnboardingDraft()
            ..currentBalance = eur('500.00')
            ..incomeAmount = eur('1000.00')
            ..nextIncomeDate = LocalDate.parse('2026-10-28'),
        );
      await store.save(state.toDocument());

      // The scratch file is renamed over the target, so the target is either
      // the old document or the new one, never a partial write.
      expect(File('${target.path}.writing').existsSync(), isFalse);
      expect(() => PlanDocument.decode(target.readAsStringSync()),
          returnsNormally,);
    });
  });
}
