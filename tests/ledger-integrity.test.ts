import { describe, expect, it } from 'vitest';
import { BANK, ev, eur, NOW, opening, plan, type LedgerEvent } from './helpers.js';
import { claim, P } from './helpers.js';
import { format } from '../src/index.js';

/**
 * §15.3 — ledger completeness and attribution confidence, T37–T45.
 *
 * Manual entry is the only data source, so missing entries are the normal
 * case rather than an error. These pin how the engine says so, and pin that
 * saying so never moves a figure. The Dart engine runs the same table.
 */

const DAY = 86_400_000;

const spend = (amount: string): LedgerEvent =>
  ({ id: ev(), kind: 'expense', accountId: BANK, amount: eur(amount) }) as LedgerEvent;

const adjust = (delta: string): LedgerEvent =>
  ({
    id: ev(),
    kind: 'balance_adjustment',
    accountId: BANK,
    delta: eur(delta),
    reason: 'confirmation',
  }) as LedgerEvent;

const completeness = (events: readonly LedgerEvent[], confirmedDaysAgo?: number) =>
  plan({
    openingBalances: opening([BANK, '2000.00']),
    events,
    ...(confirmedDaysAgo === undefined
      ? {}
      : { oldestConfirmationAt: NOW - confirmedDaysAgo * DAY }),
  }).ledgerCompleteness;

describe('§15.3.2 ledger completeness', () => {
  it('T37 — never confirmed is UNKNOWN, not COMPLETE', () => {
    // The absence of evidence is not evidence of a complete ledger.
    expect(completeness([spend('100.00')])).toBe('UNKNOWN');
  });

  it('T38 — everything recorded, nothing reconciled, is COMPLETE', () => {
    expect(completeness([spend('100.00'), spend('50.00')], 1)).toBe('COMPLETE');
  });

  it('T39 — drift at exactly 5% is COMPLETE', () => {
    // 5 reconciled of 100 total = 50 permille, the inclusive boundary.
    expect(completeness([spend('95.00'), adjust('5.00')], 1)).toBe('COMPLETE');
  });

  it('T40 — drift at exactly 25% is PARTIAL', () => {
    expect(completeness([spend('75.00'), adjust('25.00')], 1)).toBe('PARTIAL');
  });

  it('T41 — drift above 25% is UNKNOWN', () => {
    expect(completeness([spend('70.00'), adjust('30.00')], 1)).toBe('UNKNOWN');
  });

  it('T42 — a stale confirmation makes the period since unmeasured', () => {
    // Perfect reconciliation fifteen days ago says nothing about now.
    expect(completeness([spend('100.00')], 15)).toBe('UNKNOWN');
  });

  it('T43 — nothing happened and nothing is missing is COMPLETE', () => {
    expect(completeness([], 1)).toBe('COMPLETE');
  });

  it('T44 — money moved and none of it was recorded is UNKNOWN', () => {
    // The opposite answer to T43 from the same empty transaction list, which
    // is why the two cases are separated rather than averaged.
    expect(completeness([adjust('-200.00')], 1)).toBe('UNKNOWN');
  });

  it('a negative adjustment counts the same as a positive one', () => {
    expect(completeness([spend('75.00'), adjust('-25.00')], 1)).toBe('PARTIAL');
  });
});

describe('§15.3.3 INV-18 — completeness never moves the figure', () => {
  const snapshot = (confirmedDaysAgo: number) =>
    plan({
      openingBalances: opening([BANK, '2000.00']),
      events: [spend('100.00')],
      claims: [claim('rent', P.P2_HARD_OBLIGATION, '800.00')],
      oldestConfirmationAt: NOW - confirmedDaysAgo * DAY,
    });

  it('T45 — two snapshots differing only in completeness agree on money', () => {
    const fresh = snapshot(1);
    const stale = snapshot(15);

    expect(fresh.ledgerCompleteness).toBe('COMPLETE');
    expect(stale.ledgerCompleteness).toBe('UNKNOWN');

    expect(format(stale.safeToSpendNow)).toBe(format(fresh.safeToSpendNow));
    expect(format(stale.projectedSafeToSpend)).toBe(format(fresh.projectedSafeToSpend));
    expect(format(stale.protectedTotal)).toBe(format(fresh.protectedTotal));
    expect(format(stale.mandatoryFundingGap)).toBe(format(fresh.mandatoryFundingGap));
    expect(stale.allocations.map((a) => format(a.allocated))).toEqual(
      fresh.allocations.map((a) => format(a.allocated)),
    );
  });

  it('completeness is a separate axis from liquidity confidence', () => {
    // A ledger can be complete while the balance is stale, and fresh while
    // the ledger is not. Neither implies the other.
    const completeButStale = plan({
      openingBalances: opening([BANK, '2000.00']),
      events: [spend('100.00')],
      oldestConfirmationAt: NOW - 10 * DAY,
    });
    expect(completeButStale.confidenceState).toBe('DEGRADED');
    expect(completeButStale.ledgerCompleteness).toBe('COMPLETE');

    const freshButIncomplete = plan({
      openingBalances: opening([BANK, '2000.00']),
      events: [spend('10.00'), adjust('-400.00')],
      oldestConfirmationAt: NOW - 1 * DAY,
    });
    expect(freshButIncomplete.confidenceState).toBe('TRUSTED');
    expect(freshButIncomplete.ledgerCompleteness).toBe('UNKNOWN');
  });
});

describe('§15.3.4 attribution confidence', () => {
  it('is NONE while the data model is manual-first', () => {
    // Stated, not computed. Its job is to block category-, merchant- and
    // purchase-specific claims by default until a source exists.
    const s = plan({
      openingBalances: opening([BANK, '2000.00']),
      events: [spend('100.00')],
      oldestConfirmationAt: NOW,
    });
    expect(s.attributionConfidence).toBe('NONE');
  });
});
