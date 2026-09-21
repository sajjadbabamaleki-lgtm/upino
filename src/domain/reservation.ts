import { type Money, add, gt, sub, zero } from '../money/money.js';

/**
 * Reservation lifecycle (§12). A reservation assigns purpose to money; it is
 * never a second copy of it. The machine exists so that the same claim cannot
 * be deducted once when reserved and again when paid (INV-01, INV-02).
 */
export const RESERVATION_STATE = {
  PLANNED: 'PLANNED',
  RESERVED: 'RESERVED',
  COMMITTED: 'COMMITTED',
  PAID: 'PAID',
  RELEASED: 'RELEASED',
  OVERDUE: 'OVERDUE',
  REVIEW: 'REVIEW',
  CANCELLED: 'CANCELLED',
} as const;

export type ReservationState = (typeof RESERVATION_STATE)[keyof typeof RESERVATION_STATE];

const ALLOWED: Readonly<Record<ReservationState, readonly ReservationState[]>> = {
  PLANNED: ['RESERVED', 'CANCELLED'],
  RESERVED: ['COMMITTED', 'RELEASED', 'OVERDUE'],
  COMMITTED: ['PAID', 'RESERVED', 'REVIEW'],
  PAID: [],
  RELEASED: [],
  OVERDUE: ['RESERVED', 'COMMITTED', 'PAID', 'CANCELLED'],
  REVIEW: ['PLANNED', 'RESERVED', 'COMMITTED', 'PAID', 'RELEASED', 'OVERDUE', 'CANCELLED'],
  CANCELLED: [],
};

export function canTransition(from: ReservationState, to: ReservationState): boolean {
  return ALLOWED[from].includes(to);
}

export function assertTransition(from: ReservationState, to: ReservationState): void {
  if (!canTransition(from, to)) {
    throw new Error(`Illegal reservation transition ${from} → ${to} (§12)`);
  }
}

export interface Reservation {
  readonly amount: Money;
  readonly consumed: Money;
  readonly state: ReservationState;
}

export function newReservation(amount: Money, state: ReservationState = 'RESERVED'): Reservation {
  return { amount, consumed: zero(amount.currency), state };
}

/** Amount still protected. A consumed reservation protects nothing further. */
export function remaining(r: Reservation): Money {
  if (r.state === 'RELEASED' || r.state === 'CANCELLED' || r.state === 'PAID') {
    return zero(r.amount.currency);
  }
  return sub(r.amount, r.consumed);
}

/**
 * Settle a payment against a reservation. Partial payments consume the
 * reservation proportionally; the remainder stays reserved (§12, T07).
 */
export function settle(r: Reservation, payment: Money): Reservation {
  const left = sub(r.amount, r.consumed);
  if (gt(payment, left)) {
    throw new Error('Payment exceeds the reservation; overpayment is allocated by event type, never silently attached to another claim (§12)');
  }
  const consumed = add(r.consumed, payment);
  const fullySettled = consumed.minor === r.amount.minor;
  const next: ReservationState = fullySettled ? 'PAID' : r.state;
  if (fullySettled) assertTransition(r.state === 'RESERVED' ? 'COMMITTED' : r.state, 'PAID');
  return { amount: r.amount, consumed, state: next };
}

export function release(r: Reservation): Reservation {
  assertTransition(r.state, 'RELEASED');
  return { ...r, state: 'RELEASED' };
}
