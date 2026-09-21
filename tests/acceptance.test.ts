import { describe, expect, it } from 'vitest';
import {
  allocatedAt, BANK, claim, ev, eur, income, LOAN, NOW, opening, P, plan,
  reserved, SAVINGS, shortfallAt, TODAY, TOMORROW, TZ, usd, VISA, YESTERDAY, DAY_AFTER,
  type LedgerEvent,
} from './helpers.js';
import {
  computePlan, contributionSchedule, convert, format, fxRate, localDate,
  release, requiredContribution, settle, toLocalDate, newReservation, isOverdue,
} from '../src/index.js';

/**
 * Acceptance Test Vectors, §24 of Upino Product Foundation v3.4.
 * T01–T12 are the G1 golden fixtures; the remainder complete §24.
 */

describe('§24 Acceptance Test Vectors', () => {
  it('T01 — confirmed salary + rent', () => {
    const s = plan({
      openingBalances: opening([BANK, '3000.00']),
      claims: [claim('rent', P.P2_HARD_OBLIGATION, '1200.00')],
      incomeEvents: [income('3000.00', YESTERDAY, 'CONFIRMED')],
    });
    expect(format(allocatedAt(s, P.P2_HARD_OBLIGATION))).toBe('1200.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('1800.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
    expect(s.reasonCodes).toContain('INCOME_CONFIRMED');
  });

  it('T02 — expected income is excluded from the now figure', () => {
    const s = plan({
      openingBalances: opening([BANK, '400.00']),
      incomeEvents: [income('3000.00', TOMORROW, 'EXPECTED')],
    });
    expect(format(s.safeToSpendNow)).toBe('400.00 EUR');
    expect(format(s.projectedSafeToSpend)).toBe('3400.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
  });

  it('T03 — income late', () => {
    const s = plan({
      openingBalances: opening([BANK, '400.00']),
      incomeEvents: [income('3000.00', YESTERDAY, 'EXPECTED')],
    });
    expect(format(s.safeToSpendNow)).toBe('400.00 EUR');
    expect(s.reasonCodes).toContain('INCOME_LATE');
  });

  it('T04 — short salary produces a mandatory gap', () => {
    const s = plan({
      events: [{ id: ev(), kind: 'income_confirmed', accountId: BANK, amount: eur('2600.00'), occurredAt: NOW }],
      claims: [
        claim('rent', P.P2_HARD_OBLIGATION, '1800.00'),
        claim('essentials', P.P4_ESSENTIAL_LIVING, '600.00'),
        claim('catchup', P.P5_SINKING_CATCHUP, '400.00'),
      ],
    });
    expect(format(allocatedAt(s, P.P2_HARD_OBLIGATION))).toBe('1800.00 EUR');
    expect(format(allocatedAt(s, P.P4_ESSENTIAL_LIVING))).toBe('600.00 EUR');
    expect(format(allocatedAt(s, P.P5_SINKING_CATCHUP))).toBe('200.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('0.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('200.00 EUR');
    expect(s.reasonCodes).toContain('FUNDING_GAP');
  });

  it('T05 — higher salary follows the waterfall', () => {
    const s = plan({
      events: [{ id: ev(), kind: 'income_confirmed', accountId: BANK, amount: eur('3300.00'), occurredAt: NOW }],
      claims: [
        claim('rent', P.P2_HARD_OBLIGATION, '1800.00'),
        claim('essentials', P.P4_ESSENTIAL_LIVING, '600.00'),
        claim('catchup', P.P5_SINKING_CATCHUP, '200.00'),
        claim('buffer', P.P6_BUFFER, '300.00'),
        claim('goal', P.P7_HARD_GOAL, '200.00'),
      ],
    });
    expect(format(allocatedAt(s, P.P6_BUFFER))).toBe('300.00 EUR');
    expect(format(allocatedAt(s, P.P7_HARD_GOAL))).toBe('200.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('200.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
  });

  it('T06 — a reserved claim paid does not reduce Safe-to-Spend twice', () => {
    const before = plan({
      openingBalances: opening([BANK, '3000.00']),
      claims: [reserved('rent', P.P2_HARD_OBLIGATION, '1200.00')],
    });
    expect(format(before.safeToSpendNow)).toBe('1800.00 EUR');

    const paid = settle(newReservation(eur('1200.00')), eur('1200.00'));
    expect(paid.state).toBe('PAID');

    const after = plan({
      openingBalances: opening([BANK, '3000.00']),
      events: [{ id: ev(), kind: 'expense', accountId: BANK, amount: eur('1200.00'), occurredAt: NOW }],
      claims: [{ ...claim('rent', P.P2_HARD_OBLIGATION, '1200.00'), reservation: paid }],
    });
    expect(format(after.trustedAllocatableLiquidity)).toBe('1800.00 EUR');
    expect(format(after.safeToSpendNow)).toBe('1800.00 EUR');
    expect(after.reasonCodes).toContain('RESERVATION_CONSUMED');
  });

  it('T07 — partial payment consumes the reservation proportionally', () => {
    const partial = settle(newReservation(eur('500.00')), eur('300.00'));
    expect(partial.state).toBe('RESERVED');

    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [{ id: ev(), kind: 'expense', accountId: BANK, amount: eur('300.00'), occurredAt: NOW }],
      claims: [{ ...claim('bill', P.P2_HARD_OBLIGATION, '500.00'), reservation: partial }],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('700.00 EUR');
    expect(format(allocatedAt(s, P.P2_HARD_OBLIGATION))).toBe('200.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('500.00 EUR');
  });

  it('T08 — cancelling a claim releases its reserve', () => {
    const before = plan({
      openingBalances: opening([BANK, '1000.00']),
      claims: [reserved('subscription', P.P2_HARD_OBLIGATION, '200.00')],
    });
    expect(format(before.safeToSpendNow)).toBe('800.00 EUR');

    const after = plan({
      openingBalances: opening([BANK, '1000.00']),
      claims: [{ ...claim('subscription', P.P2_HARD_OBLIGATION, '200.00'), reservation: release(newReservation(eur('200.00'))) }],
    });
    expect(format(after.safeToSpendNow)).toBe('1000.00 EUR');
  });

  it('T09 — a card purchase reserves its full outstanding amount', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [{ id: ev(), kind: 'card_purchase', cardId: VISA, amount: eur('100.00'), occurredAt: NOW }],
      cards: [{ id: VISA }],
    });
    expect(format(s.ledger.cardOutstanding.get(VISA)!)).toBe('100.00 EUR');
    expect(format(s.ledger.cumulativeSpending)).toBe('100.00 EUR');
    expect(format(allocatedAt(s, P.P3_CARD_SPEND_RESERVE))).toBe('100.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('900.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
  });

  it('T10 — settlement consumes the reserve and is not a second expense', () => {
    const events: LedgerEvent[] = [
      { id: ev(), kind: 'card_purchase', cardId: VISA, amount: eur('100.00'), occurredAt: NOW },
      { id: ev(), kind: 'card_settlement', accountId: BANK, cardId: VISA, amount: eur('100.00'), occurredAt: NOW },
    ];
    const s = plan({ openingBalances: opening([BANK, '1000.00']), events, cards: [{ id: VISA }] });
    expect(format(s.ledger.balances.get(BANK)!)).toBe('900.00 EUR');
    expect(format(s.ledger.cardOutstanding.get(VISA)!)).toBe('0.00 EUR');
    expect(format(s.ledger.cumulativeSpending)).toBe('100.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('900.00 EUR');
  });

  it('T11 — protection reaches past payday for a hard claim income cannot cover', () => {
    const s = plan({
      openingBalances: opening([BANK, '500.00']),
      incomeEvents: [income('1000.00', TOMORROW, 'EXPECTED')],
      claims: [claim('bill', P.P2_HARD_OBLIGATION, '1200.00', { dueDate: DAY_AFTER })],
    });
    expect(format(allocatedAt(s, P.P2_HARD_OBLIGATION))).toBe('200.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('300.00 EUR');
    expect(s.decisionHorizonEnd).toBe(TOMORROW);
    expect(s.protectionHorizonEnd).toBe(DAY_AFTER);
    expect(s.reasonCodes).toContain('PROTECTION_HORIZON_EXTENDED');
  });

  it('T12 — a due date turns overdue at local midnight, with no UTC drift', () => {
    const dueOct1 = localDate('2026-10-01');
    const claims = [claim('bill', P.P2_HARD_OBLIGATION, '200.00', { dueDate: dueOct1 })];

    // 23:59 local on 1 October (CEST, UTC+2).
    const justBefore = Date.parse('2026-10-01T21:59:00Z');
    // 00:00 local on 2 October — still 1 October in UTC.
    const atMidnight = Date.parse('2026-10-01T22:00:00Z');

    expect(toLocalDate(justBefore, TZ)).toBe('2026-10-01');
    expect(toLocalDate(atMidnight, TZ)).toBe('2026-10-02');
    expect(new Date(atMidnight).toISOString().slice(0, 10)).toBe('2026-10-01');

    const before = computePlan({ currency: 'EUR', timeZone: TZ, now: justBefore, includedAccounts: [BANK], openingBalances: opening([BANK, '1000.00']), claims });
    expect(before.allocations[0]!.priority).toBe(P.P2_HARD_OBLIGATION);
    expect(before.reasonCodes).not.toContain('OVERDUE_HARD_CLAIM');

    const after = computePlan({ currency: 'EUR', timeZone: TZ, now: atMidnight, includedAccounts: [BANK], openingBalances: opening([BANK, '1000.00']), claims });
    expect(after.allocations[0]!.priority).toBe(P.P1_OVERDUE_HARD);
    expect(after.allocations.filter((a) => a.priority === P.P1_OVERDUE_HARD)).toHaveLength(1);
    expect(after.reasonCodes).toContain('OVERDUE_HARD_CLAIM');
    expect(isOverdue(dueOct1, localDate('2026-10-02'))).toBe(true);
  });

  it('T13 — a contractual debt minimum is a P2 hard claim', () => {
    const s = plan({
      openingBalances: opening([BANK, '500.00']),
      claims: [claim('card-minimum', P.P2_HARD_OBLIGATION, '150.00')],
    });
    expect(format(allocatedAt(s, P.P2_HARD_OBLIGATION))).toBe('150.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('350.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
  });

  it('T14 — an overdue hard claim is elevated to P1', () => {
    const s = plan({
      openingBalances: opening([BANK, '500.00']),
      claims: [claim('installment', P.P2_HARD_OBLIGATION, '150.00', { dueDate: YESTERDAY })],
    });
    expect(format(allocatedAt(s, P.P1_OVERDUE_HARD))).toBe('150.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('350.00 EUR');
    expect(s.reasonCodes).toContain('OVERDUE_HARD_CLAIM');
  });

  it('T15 — loan principal raises cash and debt but is not income', () => {
    const s = plan({
      openingBalances: opening([BANK, '500.00']),
      events: [{ id: ev(), kind: 'loan_drawdown', accountId: BANK, debtId: LOAN, amount: eur('2000.00'), occurredAt: NOW }],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('2500.00 EUR');
    expect(format(s.ledger.debtPrincipal.get(LOAN)!)).toBe('2000.00 EUR');
    expect(format(s.ledger.cumulativeIncome)).toBe('0.00 EUR');
  });

  it('T16 — an own-account transfer moves liquidity without spending it', () => {
    const s = plan({
      includedAccounts: [BANK, SAVINGS],
      openingBalances: opening([BANK, '1000.00'], [SAVINGS, '500.00']),
      events: [{ id: ev(), kind: 'transfer', fromAccountId: BANK, toAccountId: SAVINGS, amount: eur('500.00'), occurredAt: NOW }],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('1500.00 EUR');
    expect(format(s.ledger.cumulativeSpending)).toBe('0.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('1500.00 EUR');
  });

  it('T17 — a linked refund reverses the economic expense', () => {
    const purchase = ev();
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [
        { id: purchase, kind: 'expense', accountId: BANK, amount: eur('80.00'), occurredAt: NOW },
        { id: ev(), kind: 'refund', accountId: BANK, amount: eur('80.00'), occurredAt: NOW, linkedExpenseId: purchase },
      ],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('1000.00 EUR');
    expect(format(s.ledger.cumulativeSpending)).toBe('0.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('1000.00 EUR');
  });

  it('T18 — a duplicate import affects the engine once', () => {
    const canonical = 'merchant-42' as never;
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [
        { id: ev(), kind: 'expense', accountId: BANK, amount: eur('40.00'), occurredAt: NOW, canonicalId: canonical },
        { id: ev(), kind: 'expense', accountId: BANK, amount: eur('40.00'), occurredAt: NOW, canonicalId: canonical },
      ],
    });
    expect(format(s.ledger.cumulativeSpending)).toBe('40.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('960.00 EUR');
    expect(s.ledger.quarantined).toHaveLength(1);
    expect(s.reasonCodes).toContain('DUPLICATE_HOLD');
  });

  it('T19 — an annual fund requires an even contribution per cycle', () => {
    expect(format(requiredContribution(eur('1200.00'), 12))).toBe('100.00 EUR');
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      claims: [claim('insurance', P.P5_SINKING_CATCHUP, '100.00')],
    });
    expect(format(allocatedAt(s, P.P5_SINKING_CATCHUP))).toBe('100.00 EUR');
  });

  it('T20 — a missed cycle re-spreads with the residual in the final cycle', () => {
    const schedule = contributionSchedule(eur('1200.00'), 11);
    expect(schedule).toHaveLength(11);
    expect(schedule.slice(0, 10).map(format)).toEqual(Array(10).fill('109.09 EUR'));
    expect(format(schedule[10]!)).toBe('109.10 EUR');
    const total = schedule.reduce((a, m) => a + m.minor, 0n);
    expect(total).toBe(eur('1200.00').minor);
  });

  it('T21 — essentials outrank the buffer, and a buffer shortfall is not a mandatory gap', () => {
    const s = plan({
      openingBalances: opening([BANK, '700.00']),
      claims: [
        claim('essentials', P.P4_ESSENTIAL_LIVING, '500.00'),
        claim('buffer', P.P6_BUFFER, '500.00'),
      ],
    });
    expect(format(allocatedAt(s, P.P4_ESSENTIAL_LIVING))).toBe('500.00 EUR');
    expect(format(allocatedAt(s, P.P6_BUFFER))).toBe('200.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('0.00 EUR');
    expect(format(s.bufferShortfall)).toBe('300.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
  });

  it('T22 — a hard goal shortfall is mandatory and never silently moved', () => {
    const s = plan({
      openingBalances: opening([BANK, '900.00']),
      claims: [
        claim('rent', P.P2_HARD_OBLIGATION, '500.00'),
        claim('essentials', P.P4_ESSENTIAL_LIVING, '300.00'),
        claim('goal', P.P7_HARD_GOAL, '300.00'),
      ],
    });
    expect(format(allocatedAt(s, P.P7_HARD_GOAL))).toBe('100.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('0.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('200.00 EUR');
    expect(s.reasonCodes).toContain('GOAL_AT_RISK');
  });

  it('T23 — a flexible goal yields without inflating the mandatory gap', () => {
    const s = plan({
      openingBalances: opening([BANK, '900.00']),
      claims: [
        claim('rent', P.P2_HARD_OBLIGATION, '500.00'),
        claim('essentials', P.P4_ESSENTIAL_LIVING, '300.00'),
        claim('travel', P.P8_FLEXIBLE, '300.00'),
      ],
    });
    expect(format(allocatedAt(s, P.P8_FLEXIBLE))).toBe('100.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('0.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
    expect(format(s.flexibleShortfall)).toBe('200.00 EUR');
  });

  it('T24 — a disabled buffer claims nothing', () => {
    const s = plan({ openingBalances: opening([BANK, '1000.00']), claims: [] });
    expect(format(allocatedAt(s, P.P6_BUFFER))).toBe('0.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('1000.00 EUR');
  });

  it('T25 — overspending squeezes essentials and surfaces the gap', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [{ id: ev(), kind: 'expense', accountId: BANK, amount: eur('150.00'), occurredAt: NOW }],
      claims: [
        claim('rent', P.P2_HARD_OBLIGATION, '600.00'),
        claim('essentials', P.P4_ESSENTIAL_LIVING, '300.00'),
      ],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('850.00 EUR');
    expect(format(allocatedAt(s, P.P2_HARD_OBLIGATION))).toBe('600.00 EUR');
    expect(format(allocatedAt(s, P.P4_ESSENTIAL_LIVING))).toBe('250.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('0.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('50.00 EUR');
  });

  it('T26 — a foreign-currency expense keeps its original amount and a versioned rate', () => {
    const rate = fxRate('USD', 'EUR', '0.90', 'ecb', NOW);
    const original = usd('100.00');
    const converted = convert(original, rate);
    expect(format(converted)).toBe('90.00 EUR');

    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [{ id: ev(), kind: 'expense', accountId: BANK, amount: converted, occurredAt: NOW, fx: { original, rate } }],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('910.00 EUR');
    const stored = s.ledger; // original amount, rate, source and timestamp survive on the event
    expect(stored.cumulativeSpending.minor).toBe(eur('90.00').minor);
    expect(format(original)).toBe('100.00 USD');
    expect(rate.source).toBe('ecb');
    expect(rate.observedAt).toBe(NOW);
  });

  it('T27 — an unlinked refund goes to review and degrades confidence', () => {
    const s = plan({
      openingBalances: opening([BANK, '900.00']),
      events: [{ id: ev(), kind: 'refund', accountId: BANK, amount: eur('80.00'), occurredAt: NOW }],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('900.00 EUR');
    expect(s.ledger.quarantined[0]!.reason).toBe('UNLINKED_REFUND');
    expect(s.confidenceState).toBe('DEGRADED');
  });

  it('T28 — a scenario never mutates live state', () => {
    const base = {
      openingBalances: opening([BANK, '1000.00']),
      claims: [claim('rent', P.P2_HARD_OBLIGATION, '400.00')],
    };
    const live = plan(base);
    expect(format(live.safeToSpendNow)).toBe('600.00 EUR');

    const scenario = plan({
      ...base,
      events: [{ id: ev(), kind: 'expense', accountId: BANK, amount: eur('500.00'), occurredAt: NOW }],
    });
    expect(format(scenario.safeToSpendNow)).toBe('100.00 EUR');

    expect(format(plan(base).safeToSpendNow)).toBe('600.00 EUR');
    expect(plan(base).snapshotId).toBe(live.snapshotId);
  });

  it('T29 — a balance adjustment corrects liquidity without touching analytics', () => {
    const s = plan({
      openingBalances: opening([BANK, '2040.00']),
      events: [{ id: ev(), kind: 'balance_adjustment', accountId: BANK, delta: eur('-200.00'), reason: 'observed', occurredAt: NOW }],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('1840.00 EUR');
    expect(format(s.ledger.cumulativeSpending)).toBe('0.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('1840.00 EUR');
  });

  it('T30 — balance freshness degrades after the trusted window', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      oldestConfirmationAt: NOW - 8 * 86_400_000,
    });
    expect(s.confidenceState).toBe('DEGRADED');
    expect(format(s.safeToSpendNow)).toBe('1000.00 EUR');
  });

  it('T31 — stale balance evidence requires review', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      oldestConfirmationAt: NOW - 22 * 86_400_000,
    });
    expect(s.confidenceState).toBe('REVIEW_REQUIRED');
    expect(s.reasonCodes).toContain('BALANCE_STALE');
  });

  it('T32 — a discovered event supersedes its adjustment without double counting', () => {
    const realPurchase = ev();
    const s = plan({
      openingBalances: opening([BANK, '2040.00']),
      events: [
        { id: ev(), kind: 'balance_adjustment', accountId: BANK, delta: eur('-200.00'), reason: 'observed', occurredAt: NOW, supersededBy: realPurchase },
        { id: realPurchase, kind: 'expense', accountId: BANK, amount: eur('200.00'), occurredAt: NOW },
      ],
    });
    expect(format(s.trustedAllocatableLiquidity)).toBe('1840.00 EUR');
    expect(format(s.ledger.cumulativeSpending)).toBe('200.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('1840.00 EUR');
  });

  it('T33 — identical inputs and engine version produce identical output', () => {
    const build = () => plan({
      openingBalances: opening([BANK, '900.00']),
      claims: [
        claim('rent', P.P2_HARD_OBLIGATION, '500.00'),
        claim('essentials', P.P4_ESSENTIAL_LIVING, '300.00'),
        claim('goal', P.P7_HARD_GOAL, '300.00'),
      ],
      incomeEvents: [income('2000.00', TOMORROW, 'EXPECTED')],
    });
    const a = build();
    const b = build();
    expect(b.snapshotId).toBe(a.snapshotId);
    expect(b.engineVersion).toBe(a.engineVersion);
    expect(JSON.stringify(b.allocations, replacer)).toBe(JSON.stringify(a.allocations, replacer));
    expect(b.reasonCodes).toEqual(a.reasonCodes);
    expect(b.confidenceState).toBe(a.confidenceState);
    expect(format(b.safeToSpendNow)).toBe(format(a.safeToSpendNow));
    expect(format(b.mandatoryFundingGap)).toBe(format(a.mandatoryFundingGap));
  });

  it('T34 — the card minimum overlapping the reserve is not reserved twice', () => {
    const s = plan({
      openingBalances: opening([BANK, '1000.00']),
      events: [{ id: ev(), kind: 'card_purchase', cardId: VISA, amount: eur('300.00'), occurredAt: NOW }],
      cards: [{ id: VISA, minimumDue: eur('50.00'), paymentDueDate: TOMORROW }],
    });
    expect(format(allocatedAt(s, P.P3_CARD_SPEND_RESERVE))).toBe('300.00 EUR');
    expect(format(allocatedAt(s, P.P2_HARD_OBLIGATION))).toBe('0.00 EUR');
    expect(format(s.protectedTotal)).toBe('300.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('700.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('0.00 EUR');
  });

  it('T35 — a card reserve larger than liquidity produces a mandatory gap', () => {
    const s = plan({
      openingBalances: opening([BANK, '200.00']),
      events: [{ id: ev(), kind: 'card_purchase', cardId: VISA, amount: eur('350.00'), occurredAt: NOW }],
      cards: [{ id: VISA }],
    });
    expect(format(allocatedAt(s, P.P3_CARD_SPEND_RESERVE))).toBe('200.00 EUR');
    expect(format(shortfallAt(s, P.P3_CARD_SPEND_RESERVE))).toBe('150.00 EUR');
    expect(format(s.safeToSpendNow)).toBe('0.00 EUR');
    expect(format(s.mandatoryFundingGap)).toBe('150.00 EUR');
    expect(s.reasonCodes).toContain('CARD_SPEND_FUNDING_GAP');
  });
});

const replacer = (_k: string, v: unknown): unknown => (typeof v === 'bigint' ? v.toString() : v);
