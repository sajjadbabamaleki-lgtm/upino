/**
 * Currency registry. `exponent` is the number of decimal places the currency
 * defines for its minor unit, per ISO 4217. Authoritative amounts are held as
 * integer minor units (§5, §5.1) so no binary floating point is ever involved.
 */
import { CURRENCY_TABLE } from './currency-table';

export interface Currency {
  readonly code: string;
  readonly exponent: number;
  /**
   * Optional versioned rounding exception (§5.1). When absent the normative
   * mode ROUND_HALF_EVEN applies.
   */
  readonly roundingException?: { readonly mode: 'HALF_UP'; readonly version: string };
}

/**
 * Built from the generated table, which the Dart engine is built from too, so
 * the two cannot disagree about a currency's exponent.
 */
const REGISTRY = new Map<string, Currency>(
  CURRENCY_TABLE.map(([code, exponent]) => [code, { code, exponent }]),
);

export function currency(code: string): Currency {
  const c = REGISTRY.get(code);
  if (!c) throw new Error(`Unknown currency: ${code}`);
  return c;
}

export function registerCurrency(c: Currency): void {
  REGISTRY.set(c.code, c);
}
