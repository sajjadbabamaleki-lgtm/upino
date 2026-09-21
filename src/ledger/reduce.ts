import type { AccountId, CanonicalEventId, CardId, DebtId, EventId } from '../core/ids.js';
import { add, sum, zero, type Money } from '../money/money.js';
import type { LedgerEvent } from './events.js';

export interface LedgerState {
  /** Modelled balance per account, in the planning currency. */
  readonly balances: ReadonlyMap<AccountId, Money>;
  /** Unsettled purchase amount per card — the basis of the P3 reserve (§9). */
  readonly cardOutstanding: ReadonlyMap<CardId, Money>;
  readonly debtPrincipal: ReadonlyMap<DebtId, Money>;
  /** Cumulative economic spending, net of linked refunds. */
  readonly cumulativeSpending: Money;
  readonly cumulativeIncome: Money;
  /** Events held out of economic totals pending resolution. */
  readonly quarantined: readonly QuarantinedEvent[];
}

export interface QuarantinedEvent {
  readonly eventId: EventId;
  readonly reason: 'DUPLICATE' | 'UNLINKED_REFUND';
  readonly canonicalId?: CanonicalEventId;
}

export interface LedgerOptions {
  readonly currency: string;
  /** Accounts included in planning. Excluded accounts do not contribute liquidity. */
  readonly includedAccounts: readonly AccountId[];
  readonly openingBalances?: ReadonlyMap<AccountId, Money>;
}

function bump<K>(m: Map<K, Money>, k: K, delta: Money, code: string): void {
  m.set(k, add(m.get(k) ?? zero(code), delta));
}

/**
 * Fold ledger events into modelled state. Pure and order-dependent only through
 * duplicate resolution, which keeps the first posting of a canonical event.
 */
export function reduceLedger(events: readonly LedgerEvent[], opts: LedgerOptions): LedgerState {
  const code = opts.currency;
  const balances = new Map<AccountId, Money>();
  for (const a of opts.includedAccounts) balances.set(a, opts.openingBalances?.get(a) ?? zero(code));

  const cardOutstanding = new Map<CardId, Money>();
  const debtPrincipal = new Map<DebtId, Money>();
  const quarantined: QuarantinedEvent[] = [];
  const postedCanonical = new Set<string>();
  const spending: Money[] = [];
  const income: Money[] = [];

  for (const e of events) {
    if (e.canonicalId !== undefined) {
      if (postedCanonical.has(e.canonicalId)) {
        quarantined.push({ eventId: e.id, reason: 'DUPLICATE', canonicalId: e.canonicalId });
        continue;
      }
      postedCanonical.add(e.canonicalId);
    }

    switch (e.kind) {
      case 'expense':
        bump(balances, e.accountId, { currency: code, minor: -e.amount.minor }, code);
        spending.push(e.amount);
        break;

      case 'card_purchase':
        // Liability rises; no cash leaves yet. Spending is recorded once, here.
        bump(cardOutstanding, e.cardId, e.amount, code);
        spending.push(e.amount);
        break;

      case 'card_settlement':
        // Balance-sheet movement only — never a second expense (INV-09).
        bump(balances, e.accountId, { currency: code, minor: -e.amount.minor }, code);
        bump(cardOutstanding, e.cardId, { currency: code, minor: -e.amount.minor }, code);
        break;

      case 'income_confirmed':
        bump(balances, e.accountId, e.amount, code);
        income.push(e.amount);
        break;

      case 'loan_drawdown':
        // Cash and principal both rise; this is not income (INV-10).
        bump(balances, e.accountId, e.amount, code);
        bump(debtPrincipal, e.debtId, e.amount, code);
        break;

      case 'debt_payment':
        bump(balances, e.accountId, { currency: code, minor: -e.amount.minor }, code);
        bump(debtPrincipal, e.debtId, { currency: code, minor: -e.amount.minor }, code);
        break;

      case 'transfer':
        // Location of liquidity changes; total spendable wealth does not (INV-03).
        bump(balances, e.fromAccountId, { currency: code, minor: -e.amount.minor }, code);
        bump(balances, e.toAccountId, e.amount, code);
        break;

      case 'balance_adjustment':
        // Neither expense nor income (INV-13). A superseded adjustment does not
        // post; the discovered real event posts in its place (T32).
        if (e.supersededBy === undefined) bump(balances, e.accountId, e.delta, code);
        break;

      case 'refund':
        if (e.linkedExpenseId === undefined) {
          // No silent historical rewrite; hold it for review (§6, T26).
          quarantined.push({ eventId: e.id, reason: 'UNLINKED_REFUND' });
          break;
        }
        bump(balances, e.accountId, e.amount, code);
        spending.push({ currency: code, minor: -e.amount.minor });
        break;
    }
  }

  return {
    balances,
    cardOutstanding,
    debtPrincipal,
    cumulativeSpending: sum(spending, code),
    cumulativeIncome: sum(income, code),
    quarantined,
  };
}

/** Trusted allocatable liquidity: the included accounts' modelled balances (§13). */
export function trustedLiquidity(state: LedgerState, opts: LedgerOptions): Money {
  return sum(
    opts.includedAccounts.map((a) => state.balances.get(a) ?? zero(opts.currency)),
    opts.currency,
  );
}

/** Total unsettled card spend, the economic basis of the P3 reserve (§9, INV-16). */
export function totalCardOutstanding(state: LedgerState, code: string): Money {
  return sum([...state.cardOutstanding.values()], code);
}
