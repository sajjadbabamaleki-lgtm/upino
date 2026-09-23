// §15.3 — ledger completeness and attribution confidence.
//
// Manual entry is the only data source, so missing entries are the normal
// case. These fixtures (T37–T45) pin how the engine says so, and pin that
// saying so never moves a figure.

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/ledger.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/engine/plan.dart';

final now = DateTime.utc(2026, 10, 1, 10);
Money eur(String v) => Money.parse(v, 'EUR');

LedgerCompleteness completeness({
  DateTime? confirmedAt,
  List<LedgerEvent> events = const [],
  DateTime? at,
}) =>
    computePlan(
      PlanInput(
        currency: 'EUR',
        now: at ?? now,
        utcOffset: Duration.zero,
        includedAccounts: const ['a'],
        openingBalances: {'a': eur('2000.00')},
        events: events,
        oldestConfirmationAt: confirmedAt,
      ),
    ).ledgerCompleteness;

LedgerEvent spend(String id, String amount) =>
    ExpenseEvent(id: id, accountId: 'a', amount: eur(amount));

LedgerEvent adjust(String id, String delta) => BalanceAdjustmentEvent(
      id: id,
      accountId: 'a',
      delta: eur(delta),
      reason: 'confirmation',
    );

void main() {
  group('§15.3.2 ledger completeness', () {
    test('T37 never confirmed is unknown, not complete', () {
      // The absence of evidence is not evidence of a complete ledger.
      expect(completeness(events: [spend('e1', '100.00')]),
          LedgerCompleteness.unknown,);
    });

    test('T38 everything recorded, nothing reconciled, is complete', () {
      expect(
        completeness(
          confirmedAt: now.subtract(const Duration(days: 1)),
          events: [spend('e1', '100.00'), spend('e2', '50.00')],
        ),
        LedgerCompleteness.complete,
      );
    });

    test('T39 drift at exactly 5% is complete', () {
      // 5 reconciled of 100 total = 50 permille, the inclusive boundary.
      expect(
        completeness(
          confirmedAt: now.subtract(const Duration(days: 1)),
          events: [spend('e1', '95.00'), adjust('b1', '5.00')],
        ),
        LedgerCompleteness.complete,
      );
    });

    test('T40 drift at exactly 25% is partial', () {
      expect(
        completeness(
          confirmedAt: now.subtract(const Duration(days: 1)),
          events: [spend('e1', '75.00'), adjust('b1', '25.00')],
        ),
        LedgerCompleteness.partial,
      );
    });

    test('T41 drift above 25% is unknown', () {
      expect(
        completeness(
          confirmedAt: now.subtract(const Duration(days: 1)),
          events: [spend('e1', '70.00'), adjust('b1', '30.00')],
        ),
        LedgerCompleteness.unknown,
      );
    });

    test('T42 a stale confirmation makes the period since unmeasured', () {
      // Perfect reconciliation fifteen days ago says nothing about now.
      expect(
        completeness(
          confirmedAt: now.subtract(const Duration(days: 15)),
          events: [spend('e1', '100.00')],
        ),
        LedgerCompleteness.unknown,
      );
    });

    test('T43 nothing happened and nothing is missing is complete', () {
      expect(
        completeness(confirmedAt: now.subtract(const Duration(days: 1))),
        LedgerCompleteness.complete,
      );
    });

    test('T44 money moved and none of it was recorded is unknown', () {
      // The opposite answer to T43 from the same empty transaction list,
      // which is why the two cases are separated rather than averaged.
      expect(
        completeness(
          confirmedAt: now.subtract(const Duration(days: 1)),
          events: [adjust('b1', '-200.00')],
        ),
        LedgerCompleteness.unknown,
      );
    });

    test('a negative adjustment counts the same as a positive one', () {
      final under = completeness(
        confirmedAt: now.subtract(const Duration(days: 1)),
        events: [spend('e1', '75.00'), adjust('b1', '-25.00')],
      );
      expect(under, LedgerCompleteness.partial);
    });
  });

  group('§15.3.3 INV-18 completeness never moves the figure', () {
    PlanSnapshot snapshotWith(List<LedgerEvent> events, DateTime? confirmed) =>
        computePlan(
          PlanInput(
            currency: 'EUR',
            now: now,
            utcOffset: Duration.zero,
            includedAccounts: const ['a'],
            openingBalances: {'a': eur('2000.00')},
            events: events,
            oldestConfirmationAt: confirmed,
            claims: [
              Claim(
                id: 'rent',
                priority: Priority.p2HardObligation,
                label: 'Rent',
                amount: eur('800.00'),
              ),
            ],
          ),
        );

    test('T45 two snapshots differing only in completeness agree on money', () {
      // Same events, same money; only the confirmation age differs, which is
      // what moves completeness. Every figure must be identical.
      final fresh = snapshotWith(
        [spend('e1', '100.00')],
        now.subtract(const Duration(days: 1)),
      );
      final stale = snapshotWith(
        [spend('e1', '100.00')],
        now.subtract(const Duration(days: 15)),
      );

      expect(fresh.ledgerCompleteness, LedgerCompleteness.complete);
      expect(stale.ledgerCompleteness, LedgerCompleteness.unknown);

      expect(stale.safeToSpendNow, fresh.safeToSpendNow);
      expect(stale.projectedSafeToSpend, fresh.projectedSafeToSpend);
      expect(stale.protectedTotal, fresh.protectedTotal);
      expect(stale.mandatoryFundingGap, fresh.mandatoryFundingGap);
      expect(stale.trustedAllocatableLiquidity, fresh.trustedAllocatableLiquidity);
      expect(
        stale.allocations.map((a) => a.allocated),
        fresh.allocations.map((a) => a.allocated),
      );
    });

    test('completeness is a separate axis from liquidity confidence', () {
      // A ledger can be complete while the balance is stale, and fresh while
      // the ledger is not. Neither implies the other.
      final completeButStale = computePlan(
        PlanInput(
          currency: 'EUR',
          now: now,
          utcOffset: Duration.zero,
          includedAccounts: const ['a'],
          openingBalances: {'a': eur('2000.00')},
          events: [spend('e1', '100.00')],
          oldestConfirmationAt: now.subtract(const Duration(days: 10)),
        ),
      );
      expect(completeButStale.confidenceState, ConfidenceState.degraded);
      expect(completeButStale.ledgerCompleteness, LedgerCompleteness.complete);

      final freshButIncomplete = computePlan(
        PlanInput(
          currency: 'EUR',
          now: now,
          utcOffset: Duration.zero,
          includedAccounts: const ['a'],
          openingBalances: {'a': eur('2000.00')},
          events: [spend('e1', '10.00'), adjust('b1', '-400.00')],
          oldestConfirmationAt: now.subtract(const Duration(days: 1)),
        ),
      );
      expect(freshButIncomplete.confidenceState, ConfidenceState.trusted);
      expect(freshButIncomplete.ledgerCompleteness, LedgerCompleteness.unknown);
    });
  });

  group('§15.3.4 attribution confidence', () {
    test('is none while the data model is manual-first', () {
      // Stated, not computed. Its job is to block category-, merchant- and
      // purchase-specific claims by default until a source exists.
      final s = computePlan(
        PlanInput(
          currency: 'EUR',
          now: now,
          utcOffset: Duration.zero,
          includedAccounts: const ['a'],
          openingBalances: {'a': eur('2000.00')},
          events: [spend('e1', '100.00')],
          oldestConfirmationAt: now,
        ),
      );
      expect(s.attributionConfidence, AttributionConfidence.none);
    });
  });
}
