import { currency } from './currency.js';
import { money, type Money } from './money.js';
import { divideRoundHalfEven } from './rounding.js';
import type { Instant } from '../time/clock.js';

/**
 * A versioned rate used by a snapshot (§16, INV-10). The rate is held as an
 * exact ratio so conversion never passes through binary floating point, and
 * the source and timestamp are stored so a later rate change cannot rewrite
 * history.
 */
export interface FxRate {
  readonly base: string;
  readonly quote: string;
  readonly numerator: bigint;
  readonly denominator: bigint;
  readonly source: string;
  readonly observedAt: Instant;
}

export function fxRate(
  base: string,
  quote: string,
  rate: string,
  source: string,
  observedAt: Instant,
): FxRate {
  const m = /^(\d+)(?:\.(\d+))?$/.exec(rate);
  if (!m) throw new Error(`Malformed FX rate: ${rate}`);
  const [, whole, frac = ''] = m;
  return {
    base,
    quote,
    numerator: BigInt(whole! + frac),
    denominator: 10n ** BigInt(frac.length),
    source,
    observedAt,
  };
}

/**
 * Convert for planning or display. The original amount and currency are always
 * preserved on the record; conversion is never destructive normalization.
 */
export function convert(original: Money, rate: FxRate): Money {
  if (original.currency !== rate.base) {
    throw new Error(`Rate ${rate.base}/${rate.quote} cannot convert ${original.currency}`);
  }
  const from = currency(rate.base);
  const to = currency(rate.quote);
  const scaleShift = 10n ** BigInt(Math.max(0, to.exponent - from.exponent));
  const unscale = 10n ** BigInt(Math.max(0, from.exponent - to.exponent));
  const numerator = original.minor * rate.numerator * scaleShift;
  const denominator = rate.denominator * unscale;
  return money(divideRoundHalfEven(numerator, denominator), rate.quote);
}
