import type { AccountId, CanonicalEventId, CardId, DebtId, EventId } from '../core/ids.js';
import type { Instant } from '../time/clock.js';
import type { Money } from '../money/money.js';
import type { FxRate } from '../money/fx.js';

/**
 * Canonical ledger events (§6). One real-world economic event may affect
 * spending exactly once (INV-01). Events are immutable; corrections are new
 * events, never edits.
 */
interface Base {
  readonly id: EventId;
  readonly occurredAt: Instant;
  /**
   * Identity shared by every import of the same real-world event. The first
   * event carrying a given canonical id posts; later ones are non-posting
   * duplicates linked to it (§6, T18).
   */
  readonly canonicalId?: CanonicalEventId;
  /**
   * Set when the event occurred in a currency other than the planning
   * currency. `amount` carries the converted planning value; the original
   * amount, rate, source and timestamp are preserved here (§16).
   */
  readonly fx?: { readonly original: Money; readonly rate: FxRate };
}

export type LedgerEvent =
  /** Cash or debit purchase: spending, once, at purchase. */
  | (Base & { readonly kind: 'expense'; readonly accountId: AccountId; readonly amount: Money })
  /** Credit-card purchase: spending once at purchase, plus card liability. */
  | (Base & { readonly kind: 'card_purchase'; readonly cardId: CardId; readonly amount: Money })
  /** Card settlement: debt settlement, never a second expense (§6, INV-09). */
  | (Base & { readonly kind: 'card_settlement'; readonly accountId: AccountId; readonly cardId: CardId; readonly amount: Money })
  | (Base & { readonly kind: 'income_confirmed'; readonly accountId: AccountId; readonly amount: Money })
  /** Loan principal received is not income (INV-10). */
  | (Base & { readonly kind: 'loan_drawdown'; readonly accountId: AccountId; readonly debtId: DebtId; readonly amount: Money })
  | (Base & { readonly kind: 'debt_payment'; readonly accountId: AccountId; readonly debtId: DebtId; readonly amount: Money })
  /** Movement between included accounts is neither income nor expense (INV-03). */
  | (Base & { readonly kind: 'transfer'; readonly fromAccountId: AccountId; readonly toAccountId: AccountId; readonly amount: Money })
  /** A refund with no identifiable linked expense enters REVIEW instead of posting (§6, T26). */
  | (Base & { readonly kind: 'refund'; readonly accountId: AccountId; readonly amount: Money; readonly linkedExpenseId?: EventId })
  /**
   * Correction equal to observed minus modelled balance at confirmation
   * (§15.1). Neither expense nor income (INV-13). When the missing real event
   * is later found it supersedes this adjustment, so the same money is not
   * counted twice.
   */
  | (Base & {
      readonly kind: 'balance_adjustment';
      readonly accountId: AccountId;
      readonly delta: Money;
      readonly reason: string;
      readonly supersededBy?: EventId;
    });

export type LedgerEventKind = LedgerEvent['kind'];
