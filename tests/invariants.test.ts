import { describe, expect, it } from 'vitest';
import {
  allocate, computePlan, contributionSchedule, format, isNegative, newReservation,
  release, settle, type Claim,
} from '../src/index.js';
import {
  allocatedAt, BANK, claim, ev, eur, income, LOAN, NOW, opening, P, plan,
  reserved, SAVINGS, TODAY, TOMORROW, TZ, VISA, YESTERDAY,
} from './helpers.js';

/** §23 Engine Invariants. */
describe('§23 Engine Invariants', () => {
  it('INV-01 / INV-02 — a reservation and its settlement never deduct the same claim twice', () => {
    const liquidity = '3000.00';
    const withReserve = plan({
      openingBalances: opening([BANK, liquidity]),
      claims: [reserved('rent', P.P2_HARD_OBLIGATION, '1200.00')],
    });
    const paid = settle(newReservation(eur('1200.00')), eur('1200.00'));
    const afterPayment = plan({
      openingBalances: opening([BANK, liquidity]),
      events: [{ id: ev(), kind: 'expense', accountId: BANK, amount: eur('1200.00'), occurredAt: NOW }],
      claims: [{ ...claim('rent', P.P2_HARD_OBLIGATION, '1200.00'), reservation: paid }],
    });
    expect(format(afterPayment.safeToSpendNow)).toBe(format(withReserve.safeToSpendNow));
  });

  it('INV-03 — own-account transfers do not reduce spendable wealth', () => {
    const before = plan({ includedAccounts: [BANK, SAVINGS], openingBalances: opening([BANK, '1000.00'], [SAVINGS, '500.00']) });
    const after = plan({
      includedAccounts: [BANK, SAVINGS],
      openingBalances: opening([BANK, '1000.00'], [SAVINGS, '500.00']),
      events: [{ id: ev(), kind: 'transfer', fromAccountId: BANK, toAccountId: SAVINGS, amount: eur('500.00'), occurredAt: NOW }],
    });
    expect(format(after.safeToSpendNow)).toBe(format(before.safeToSpendNow));
  });

  it('INV-04 — unconfirmed income never raises safe_to_spend_now', () => {
    for (const state of ['EXPECTED', 'LATE', 'MISSED', 'CANCELLED'] as const) {
      const s = plan({ openingBalances: opening([BANK, '400.00']), incomeEvents: [income('9000.00', TOMORROW, state)] });
      expect(format(s.safeToSpendNow)).toBe('400.00 EUR');
    }
  });

  it('INV-05 — safe_to_spend_now is never negative, however deep the shortfall', () => {
    for (let i = 0; i < 200; i++) {
      const liquidity = BigInt(Math.floor(Math.random() * 500_00));
      const claims: Claim[] = [
        claim('a', P.P2_HARD_OBLIGATION, `${Math.floor(Math.random() * 4000)}.00`),
        claim('b', P.P4_ESSENTIAL_LIVING, `${Math.floor(Math.random() * 4000)}.00`),
        claim('c', P.P7_HARD_GOAL, `${Math.floor(Math.random() * 4000)}.00`),
      ];
      const s = computePlan({
        currency: 'EUR', timeZone: TZ, now: NOW, includedAccounts: [BANK],
        openingBalances: new Map([[BANK, { currency: 'EUR', minor: liquidity }]]),
        claims,
      });
      expect(isNegative(s.safeToSpendNow)).toBe(false);
      expect(isNegative(s.mandatoryFundingGap)).toBe(false);
    }
  });

  it('INV-06 — a hard obligation is never silently relaxed to make the plan fit', () => {
    const s = plan({
      openingBalances: opening([BANK, '100.00']),
      claims: [claim('rent', P.P2_HARD_OBLIGATION, '900.00')],
    });
    const rent = s.allocations.find((a) => a.claimId === 'rent')!;
    expect(format(rent.requiredNow)).toBe('900.00 EUR');
    expect(format(rent.shortfall)).toBe('800.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('800.00 EUR');
  });

  it('INV-08 — mixing currencies is refused rather than silently netted', () => {
    expect(() => computePlan({
      currency: 'EUR', timeZone: TZ, now: NOW, includedAccounts: [BANK],
      openingBalances: new Map([[BANK, { currency: 'USD', minor: 100_00n }]]),
      claims: [claim('rent', P.P2_HARD_OBLIGATION, '10.00')],
    })).toThrow(/Currency mismatch/);
  });

  it('INV-09 — a card purchase is spending once; settlement is not a second expense', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [
        { id: ev(), kind: 'card_purchase', cardId: VISA, amount: eur('100.00'), occurredAt: NOW },
        { id: ev(), kind: 'card_settlement', accountId: BANK, cardId: VISA, amount: eur('100.00'), occurredAt: NOW },
      ],
      cards: [{ id: VISA }],
    });
    expect(format(s.ledger.cumulativeSpending)).toBe('100.00 EUR');
  });

  it('INV-10 — loan principal received is not income', () => {
    const s = plan({
      openingBalances: opening([BANK, '0.00']),
      events: [{ id: ev(), kind: 'loan_drawdown', accountId: BANK, debtId: LOAN, amount: eur('2000.00'), occurredAt: NOW }],
    });
    expect(format(s.ledger.cumulativeIncome)).toBe('0.00 EUR');
  });

  it('INV-11 — every published result carries a reproducible snapshot and engine version', () => {
    const s = plan({ openingBalances: opening([BANK, '10.00']) });
    expect(s.snapshotId).toMatch(/^[0-9a-f]{32}$/);
    expect(s.engineVersion).toBeTruthy();
  });

  it('INV-13 — a balance adjustment is neither expense nor income', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [{ id: ev(), kind: 'balance_adjustment', accountId: BANK, delta: eur('-200.00'), reason: 'observed', occurredAt: NOW }],
    });
    expect(format(s.ledger.cumulativeSpending)).toBe('0.00 EUR');
    expect(format(s.ledger.cumulativeIncome)).toBe('0.00 EUR');
  });

  it('INV-14 — stale or integrity-risk evidence cannot stay TRUSTED', () => {
    const stale = plan({ openingBalances: opening([BANK, '10.00']), oldestConfirmationAt: NOW - 30 * 86_400_000 });
    expect(stale.confidenceState).toBe('REVIEW_REQUIRED');
    const risky = plan({ openingBalances: opening([BANK, '10.00']), oldestConfirmationAt: NOW, materialIntegrityIssue: true });
    expect(risky.confidenceState).toBe('REVIEW_REQUIRED');
  });

  it('INV-15 — a protection-horizon claim constrains STS even when due after payday', () => {
    const s = plan({
      openingBalances: opening([BANK, '500.00']),
      incomeEvents: [income('1000.00', TOMORROW, 'EXPECTED')],
      claims: [claim('bill', P.P2_HARD_OBLIGATION, '1200.00', { dueDate: '2026-10-03' as never })],
    });
    expect(s.protectionHorizonEnd > s.decisionHorizonEnd).toBe(true);
    expect(format(s.safeToSpendNow)).toBe('300.00 EUR');
  });

  it('INV-16 — the card reserve sits at P3 and the minimum never double-reserves', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [{ id: ev(), kind: 'card_purchase', cardId: VISA, amount: eur('300.00'), occurredAt: NOW }],
      cards: [{ id: VISA, minimumDue: eur('50.00') }],
    });
    expect(format(allocatedAt(s, P.P3_CARD_SPEND_RESERVE))).toBe('300.00 EUR');
    expect(format(s.protectedTotal)).toBe('300.00 EUR');
  });

  it('INV-17 — quantized periodic schedules sum exactly to their target', () => {
    for (const target of ['1200.00', '1000.00', '999.99', '0.07', '5555.55']) {
      for (const cycles of [1, 2, 3, 7, 11, 12, 13, 24]) {
        const schedule = contributionSchedule(eur(target), cycles);
        const total = schedule.reduce((a, m) => a + m.minor, 0n);
        expect(total).toBe(eur(target).minor);
      }
    }
  });

  it('§12 — illegal reservation transitions are refused', () => {
    expect(() => release(release(newReservation(eur('10.00'))))).toThrow(/Illegal reservation transition/);
    expect(() => settle(newReservation(eur('10.00')), eur('20.00'))).toThrow(/exceeds the reservation/);
  });
});
