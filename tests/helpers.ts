import {
  accountId, cardId, claimId, debtId, eventId, incomeEventId,
  parseMoney, computePlan, newReservation,
  PRIORITY, type Claim, type IncomeEvent, type LedgerEvent, type Money,
  type PlanInput, type PlanSnapshot, type Priority, localDate,
} from '../src/index.js';

export const EUR = 'EUR';
export const TZ = 'Europe/Amsterdam';

/** 2026-10-01 12:00 local (CEST, UTC+2). */
export const NOW = Date.parse('2026-10-01T10:00:00Z');
export const TODAY = localDate('2026-10-01');
export const TOMORROW = localDate('2026-10-02');
export const DAY_AFTER = localDate('2026-10-03');
export const YESTERDAY = localDate('2026-09-30');

export const eur = (major: string): Money => parseMoney(major, EUR);
export const usd = (major: string): Money => parseMoney(major, 'USD');

export const BANK = accountId('bank');
export const SAVINGS = accountId('savings');
export const VISA = cardId('visa');
export const LOAN = debtId('loan');

let seq = 0;
export const ev = (): ReturnType<typeof eventId> => eventId(`e${++seq}`);

export function claim(
  id: string,
  priority: Priority,
  amount: string,
  extra: Partial<Omit<Claim, 'id' | 'priority' | 'amount'>> = {},
): Claim {
  return { id: claimId(id), priority, label: id, amount: eur(amount), ...extra };
}

export function reserved(id: string, priority: Priority, amount: string): Claim {
  return { ...claim(id, priority, amount), reservation: newReservation(eur(amount)) };
}

export function income(
  amount: string,
  date: ReturnType<typeof localDate>,
  state: IncomeEvent['state'],
): IncomeEvent {
  return { id: incomeEventId(`inc-${date}-${state}`), expectedAmount: eur(amount), expectedDate: date, state };
}

export function plan(overrides: Partial<PlanInput> = {}): PlanSnapshot {
  return computePlan({
    currency: EUR,
    timeZone: TZ,
    now: NOW,
    includedAccounts: [BANK],
    ...overrides,
  });
}

export function opening(...pairs: readonly (readonly [ReturnType<typeof accountId>, string])[]) {
  return new Map(pairs.map(([a, m]) => [a, eur(m)]));
}

/** Allocation for a given priority class, summed. */
export function allocatedAt(snap: PlanSnapshot, p: Priority): Money {
  return snap.allocations
    .filter((a) => a.priority === p)
    .reduce((acc, a) => ({ currency: EUR, minor: acc.minor + a.allocated.minor }), eur('0'));
}

export function shortfallAt(snap: PlanSnapshot, p: Priority): Money {
  return snap.allocations
    .filter((a) => a.priority === p)
    .reduce((acc, a) => ({ currency: EUR, minor: acc.minor + a.shortfall.minor }), eur('0'));
}

export const P = PRIORITY;
export type { LedgerEvent };
