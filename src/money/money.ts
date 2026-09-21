import { currency, type Currency } from './currency.js';

/**
 * An authoritative monetary amount, held as integer minor units (§5).
 * Binary floating point is never used for a value of this type.
 */
export interface Money {
  readonly currency: string;
  readonly minor: bigint;
}

export function money(minor: bigint | number, code: string): Money {
  if (typeof minor === 'number' && !Number.isInteger(minor)) {
    throw new Error(`Money must be whole minor units, received ${minor}`);
  }
  return { currency: code, minor: BigInt(minor) };
}

/** Build from a major-unit decimal string, e.g. "1200.00" or "109.09". */
export function parseMoney(major: string, code: string): Money {
  const c = currency(code);
  const m = /^(-?)(\d+)(?:\.(\d+))?$/.exec(major.trim());
  if (!m) throw new Error(`Malformed amount: ${major}`);
  const [, sign, whole, frac = ''] = m;
  if (frac.length > c.exponent) {
    throw new Error(`${major} has more precision than ${code} defines (${c.exponent})`);
  }
  const padded = frac.padEnd(c.exponent, '0');
  const minor = BigInt(whole!) * 10n ** BigInt(c.exponent) + BigInt(padded || '0');
  return { currency: code, minor: sign === '-' ? -minor : minor };
}

export const zero = (code: string): Money => ({ currency: code, minor: 0n });

function same(a: Money, b: Money): void {
  if (a.currency !== b.currency) {
    throw new Error(`Currency mismatch: ${a.currency} vs ${b.currency}. §16 forbids implicit netting across currencies.`);
  }
}

export function add(a: Money, b: Money): Money {
  same(a, b);
  return { currency: a.currency, minor: a.minor + b.minor };
}

export function sub(a: Money, b: Money): Money {
  same(a, b);
  return { currency: a.currency, minor: a.minor - b.minor };
}

export const neg = (a: Money): Money => ({ currency: a.currency, minor: -a.minor });

export function sum(items: readonly Money[], code: string): Money {
  return items.reduce((acc, m) => add(acc, m), zero(code));
}

export function cmp(a: Money, b: Money): -1 | 0 | 1 {
  same(a, b);
  return a.minor < b.minor ? -1 : a.minor > b.minor ? 1 : 0;
}

export const eq = (a: Money, b: Money): boolean => cmp(a, b) === 0;
export const lt = (a: Money, b: Money): boolean => cmp(a, b) < 0;
export const gt = (a: Money, b: Money): boolean => cmp(a, b) > 0;
export const gte = (a: Money, b: Money): boolean => cmp(a, b) >= 0;
export const isZero = (a: Money): boolean => a.minor === 0n;
export const isNegative = (a: Money): boolean => a.minor < 0n;
export const min = (a: Money, b: Money): Money => (lt(a, b) ? a : b);
export const max = (a: Money, b: Money): Money => (gt(a, b) ? a : b);

/** Floors at zero. Used for the published Safe-to-Spend, per INV-05. */
export const clampAtZero = (a: Money): Money => (isNegative(a) ? zero(a.currency) : a);

export function format(a: Money): string {
  const c: Currency = currency(a.currency);
  const negative = a.minor < 0n;
  const abs = negative ? -a.minor : a.minor;
  const scale = 10n ** BigInt(c.exponent);
  const whole = abs / scale;
  const frac = abs % scale;
  const fracStr = c.exponent === 0 ? '' : `.${frac.toString().padStart(c.exponent, '0')}`;
  return `${negative ? '-' : ''}${whole}${fracStr} ${a.currency}`;
}
