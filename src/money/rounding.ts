import { currency } from './currency.js';
import { money, type Money } from './money.js';

/**
 * Normative quantization mode (§5.1): ROUND_HALF_EVEN, unless the currency
 * carries an explicitly versioned exception.
 */
export function divideRoundHalfEven(numerator: bigint, denominator: bigint): bigint {
  if (denominator === 0n) throw new Error('Division by zero');
  const negative = numerator < 0n !== denominator < 0n;
  const n = numerator < 0n ? -numerator : numerator;
  const d = denominator < 0n ? -denominator : denominator;

  const q = n / d;
  const r = n % d;
  const twice = r * 2n;

  let result: bigint;
  if (twice > d) result = q + 1n;
  else if (twice < d) result = q;
  else result = q % 2n === 0n ? q : q + 1n; // exact half → round to even

  return negative ? -result : result;
}

function divideRoundHalfUp(numerator: bigint, denominator: bigint): bigint {
  const negative = numerator < 0n !== denominator < 0n;
  const n = numerator < 0n ? -numerator : numerator;
  const d = denominator < 0n ? -denominator : denominator;
  const result = (n * 2n + d) / (d * 2n);
  return negative ? -result : result;
}

export function quantizeDivision(total: Money, parts: bigint): Money {
  const c = currency(total.currency);
  const minor = c.roundingException?.mode === 'HALF_UP'
    ? divideRoundHalfUp(total.minor, parts)
    : divideRoundHalfEven(total.minor, parts);
  return money(minor, total.currency);
}

/**
 * Equal periodic contribution schedule (§5.1 / INV-17).
 *
 * Earlier cycles receive the quantized standard contribution; the final
 * eligible funding cycle absorbs the exact residual, so the schedule sums to
 * the target with no minor unit silently lost or created.
 *
 * €1,200 across 11 cycles → ten cycles of €109.09 and a final cycle of €109.10.
 */
export function contributionSchedule(total: Money, cycles: number): readonly Money[] {
  if (!Number.isInteger(cycles) || cycles <= 0) {
    throw new Error(`Cycle count must be a positive integer, received ${cycles}`);
  }
  const standard = quantizeDivision(total, BigInt(cycles));
  const schedule: Money[] = [];
  for (let i = 0; i < cycles - 1; i++) schedule.push(standard);
  const allocated = standard.minor * BigInt(cycles - 1);
  schedule.push(money(total.minor - allocated, total.currency));
  return schedule;
}

/** The contribution required for the next eligible cycle of a funding schedule. */
export function requiredContribution(remaining: Money, cyclesRemaining: number): Money {
  return contributionSchedule(remaining, cyclesRemaining)[0]!;
}
