import type { ClaimId } from '../core/ids.js';
import type { Money } from '../money/money.js';
import type { LocalDate } from '../time/clock.js';
import type { Priority } from './priority.js';
import { remaining, type Reservation } from './reservation.js';

/**
 * A claim on liquidity. Obligations, the card spend reserve, essentials,
 * sinking-fund catch-up, the buffer and goals are all expressed as claims so
 * the waterfall has a single shape to walk.
 */
export interface Claim {
  readonly id: ClaimId;
  readonly priority: Priority;
  readonly label: string;
  /** Full amount of the claim before any reservation is consumed. */
  readonly amount: Money;
  readonly dueDate?: LocalDate;
  /** Explicit user ordering inside a priority class; lower wins. */
  readonly userPriority?: number;
  /** Attached reservation, if liquidity has already been assigned to it. */
  readonly reservation?: Reservation;
}

/**
 * What the claim still needs. A reservation already consumed by a payment
 * requires nothing further, which is what prevents the same claim reducing
 * Safe-to-Spend twice (INV-02).
 */
export function required(claim: Claim): Money {
  return claim.reservation ? remaining(claim.reservation) : claim.amount;
}

/**
 * Deterministic ordering (§11): priority class, then earliest due date, then
 * explicit user priority, then stable id purely as a tie-breaker with no
 * product meaning.
 */
export function compareClaims(a: Claim, b: Claim): number {
  if (a.priority !== b.priority) return a.priority - b.priority;

  const ad = a.dueDate;
  const bd = b.dueDate;
  if (ad !== bd) {
    if (ad === undefined) return 1;
    if (bd === undefined) return -1;
    return ad < bd ? -1 : 1;
  }

  const ap = a.userPriority ?? Number.MAX_SAFE_INTEGER;
  const bp = b.userPriority ?? Number.MAX_SAFE_INTEGER;
  if (ap !== bp) return ap - bp;

  return a.id < b.id ? -1 : a.id > b.id ? 1 : 0;
}
