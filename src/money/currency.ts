/**
 * Currency registry. `exponent` is the number of decimal places the currency
 * defines for its minor unit, per ISO 4217. Authoritative amounts are held as
 * integer minor units (§5, §5.1) so no binary floating point is ever involved.
 */
export interface Currency {
  readonly code: string;
  readonly exponent: number;
  /**
   * Optional versioned rounding exception (§5.1). When absent the normative
   * mode ROUND_HALF_EVEN applies.
   */
  readonly roundingException?: { readonly mode: 'HALF_UP'; readonly version: string };
}

const REGISTRY = new Map<string, Currency>([
  ['EUR', { code: 'EUR', exponent: 2 }],
  ['USD', { code: 'USD', exponent: 2 }],
  ['GBP', { code: 'GBP', exponent: 2 }],
  ['JPY', { code: 'JPY', exponent: 0 }],
  ['IRR', { code: 'IRR', exponent: 0 }],
  ['KWD', { code: 'KWD', exponent: 3 }],
]);

export function currency(code: string): Currency {
  const c = REGISTRY.get(code);
  if (!c) throw new Error(`Unknown currency: ${code}`);
  return c;
}

export function registerCurrency(c: Currency): void {
  REGISTRY.set(c.code, c);
}
