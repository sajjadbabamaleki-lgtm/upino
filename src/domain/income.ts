import type { IncomeEventId } from '../core/ids.js';
import type { Money } from '../money/money.js';
import type { LocalDate } from '../time/clock.js';

/**
 * Income lifecycle (§7). Expected salary is a forecast until confirmed, which
 * is what stops Upino telling a user they can spend money that has not
 * arrived (INV-04).
 */
export const INCOME_STATE = {
  EXPECTED: 'EXPECTED',
  CONFIRMED: 'CONFIRMED',
  LATE: 'LATE',
  MISSED: 'MISSED',
  ADJUSTED: 'ADJUSTED',
  CANCELLED: 'CANCELLED',
} as const;

export type IncomeState = (typeof INCOME_STATE)[keyof typeof INCOME_STATE];

export interface IncomeEvent {
  readonly id: IncomeEventId;
  readonly expectedAmount: Money;
  readonly expectedDate: LocalDate;
  readonly confirmedAmount?: Money;
  readonly state: IncomeState;
}

/** Only CONFIRMED income has reached the ledger; nothing else is current liquidity. */
export const isCurrentLiquidity = (i: IncomeEvent): boolean => i.state === 'CONFIRMED';

/** States that still contribute to a forward-looking projection. */
export const isProjectable = (i: IncomeEvent): boolean =>
  i.state === 'EXPECTED' || i.state === 'ADJUSTED';

/**
 * Resolve state against the clock. An expected payment whose date has passed,
 * with its grace window spent, is LATE — it is not quietly treated as received.
 */
export function resolveIncomeState(i: IncomeEvent, today: LocalDate, graceDays = 0): IncomeEvent {
  if (i.state !== 'EXPECTED') return i;
  const due = new Date(`${i.expectedDate}T00:00:00Z`).getTime() + graceDays * 86_400_000;
  const now = new Date(`${today}T00:00:00Z`).getTime();
  return now > due ? { ...i, state: INCOME_STATE.LATE } : i;
}

/** The amount a projection may use for this event. */
export function projectedAmount(i: IncomeEvent): Money | undefined {
  return isProjectable(i) ? (i.confirmedAmount ?? i.expectedAmount) : undefined;
}
