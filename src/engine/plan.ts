import { createHash } from 'node:crypto';
import { ENGINE_VERSION } from '../core/version.js';
import { claimId as mkClaimId, snapshotId as mkSnapshotId, type AccountId, type CardId, type SnapshotId } from '../core/ids.js';
import type { Claim } from '../domain/claim.js';
import { isProjectable, projectedAmount, resolveIncomeState, type IncomeEvent } from '../domain/income.js';
import { PRIORITY } from '../domain/priority.js';
import { REASON, type ReasonCode } from '../domain/reasonCodes.js';
import type { LedgerEvent } from '../ledger/events.js';
import { reduceLedger, totalCardOutstanding, trustedLiquidity, type LedgerState } from '../ledger/reduce.js';
import { add, clampAtZero, format, gt, isZero, sub, sum, zero, type Money } from '../money/money.js';
import { isOnOrBefore, toLocalDate, type Instant, type LocalDate } from '../time/clock.js';
import { allocate, type Allocation, type AllocationResult } from './allocate.js';
import {
  ATTRIBUTION,
  evaluateConfidence,
  evaluateLedgerCompleteness,
  type AttributionConfidence,
  type ConfidenceState,
  type LedgerCompleteness,
} from './confidence.js';

export interface CardTerms {
  readonly id: CardId;
  /** Contractual minimum due. Overlap with the spend reserve is never double-reserved (§9, INV-16). */
  readonly minimumDue?: Money;
  readonly paymentDueDate?: LocalDate;
}

export interface PlanInput {
  readonly currency: string;
  readonly timeZone: string;
  readonly now: Instant;
  readonly includedAccounts: readonly AccountId[];
  readonly openingBalances?: ReadonlyMap<AccountId, Money>;
  readonly events?: readonly LedgerEvent[];
  readonly claims?: readonly Claim[];
  readonly incomeEvents?: readonly IncomeEvent[];
  readonly cards?: readonly CardTerms[];
  /** Defaults to the next projectable income date, else today (§4). */
  readonly decisionHorizonEnd?: LocalDate;
  readonly incomeGraceDays?: number;
  readonly oldestConfirmationAt?: Instant;
  readonly materialIntegrityIssue?: boolean;
}

/** The immutable, reproducible output of a calculation (§13.1, INV-06, INV-11). */
export interface PlanSnapshot {
  readonly snapshotId: SnapshotId;
  readonly engineVersion: string;
  readonly currency: string;
  readonly safeToSpendNow: Money;
  readonly projectedSafeToSpend: Money;
  readonly decisionHorizonEnd: LocalDate;
  readonly protectionHorizonEnd: LocalDate;
  readonly protectedTotal: Money;
  readonly mandatoryFundingGap: Money;
  readonly bufferShortfall: Money;
  readonly flexibleShortfall: Money;
  readonly confidenceState: ConfidenceState;
  readonly reasonCodes: readonly ReasonCode[];
  readonly allocations: readonly Allocation[];
  readonly trustedAllocatableLiquidity: Money;
  readonly ledger: LedgerState;

  /**
   * §15.3.2. Governs what may be said about history, never what is computed
   * about money — INV-18 pins that separation.
   */
  readonly ledgerCompleteness: LedgerCompleteness;

  /** §15.3.4. Always NONE while the data model is manual-first. */
  readonly attributionConfidence: AttributionConfidence;
}

/** §15.3.2 — money the engine learned about only by reconciliation. */
function reconciledMinor(events: readonly LedgerEvent[]): bigint {
  let total = 0n;
  for (const e of events) {
    if (e.kind === 'balance_adjustment') {
      total += e.delta.minor < 0n ? -e.delta.minor : e.delta.minor;
    }
  }
  return total;
}

/**
 * §15.3.2 — money the engine was told about. A correction is not itself
 * movement; it marks another event, so it is counted neither here nor above.
 */
function recordedMinor(events: readonly LedgerEvent[]): bigint {
  const counted = new Set<string>([
    'expense',
    'card_purchase',
    'card_settlement',
    'income_confirmed',
    'loan_drawdown',
    'debt_payment',
    'transfer',
    'refund',
  ]);
  let total = 0n;
  for (const e of events) {
    if (!counted.has(e.kind)) continue;
    const m = (e as { amount: Money }).amount.minor;
    total += m < 0n ? -m : m;
  }
  return total;
}

function nextIncomeDate(income: readonly IncomeEvent[], today: LocalDate): LocalDate | undefined {
  return income
    .filter((i) => isProjectable(i))
    .map((i) => i.expectedDate)
    .filter((d) => !isOnOrBefore(d, today))
    .sort()[0];
}

/**
 * Credit Card Spend Reserve (§9, INV-16). Every unsettled card purchase is
 * reserved at its full outstanding amount because the purchase has already
 * economically occurred. The contractual minimum is tracked separately for
 * due-date compliance but only to the extent it exceeds the reserve, so the
 * overlapping part is never reserved twice.
 */
function cardClaims(ledger: LedgerState, cards: readonly CardTerms[], code: string): Claim[] {
  const out: Claim[] = [];
  for (const card of cards) {
    const outstanding = ledger.cardOutstanding.get(card.id) ?? zero(code);
    if (gt(outstanding, zero(code))) {
      out.push({
        id: mkClaimId(`card-reserve:${card.id}`),
        priority: PRIORITY.P3_CARD_SPEND_RESERVE,
        label: `Credit Card Spend Reserve (${card.id})`,
        amount: outstanding,
        ...(card.paymentDueDate !== undefined ? { dueDate: card.paymentDueDate } : {}),
      });
    }
    if (card.minimumDue !== undefined) {
      const extra = clampAtZero(sub(card.minimumDue, outstanding));
      if (!isZero(extra)) {
        out.push({
          id: mkClaimId(`card-minimum:${card.id}`),
          priority: PRIORITY.P2_HARD_OBLIGATION,
          label: `Card minimum due (${card.id})`,
          amount: extra,
          ...(card.paymentDueDate !== undefined ? { dueDate: card.paymentDueDate } : {}),
        });
      }
    }
  }
  return out;
}

function deriveReasonCodes(
  result: AllocationResult,
  income: readonly IncomeEvent[],
  ledger: LedgerState,
  claims: readonly Claim[],
  confidence: ConfidenceState,
  code: string,
): ReasonCode[] {
  const codes = new Set<ReasonCode>();

  if (income.some((i) => i.state === 'CONFIRMED')) codes.add(REASON.INCOME_CONFIRMED);
  if (income.some((i) => i.state === 'LATE')) codes.add(REASON.INCOME_LATE);

  if (gt(result.mandatoryFundingGap, zero(code))) codes.add(REASON.FUNDING_GAP);
  if (gt(result.bufferShortfall, zero(code))) codes.add(REASON.BUFFER_SHORTFALL);
  if (gt(result.flexibleShortfall, zero(code))) codes.add(REASON.FLEXIBLE_SHORTFALL);

  for (const a of result.allocations) {
    if (a.priority === PRIORITY.P1_OVERDUE_HARD) codes.add(REASON.OVERDUE_HARD_CLAIM);
    if (gt(a.shortfall, zero(code))) {
      if (a.priority === PRIORITY.P7_HARD_GOAL) codes.add(REASON.GOAL_AT_RISK);
      if (a.priority === PRIORITY.P3_CARD_SPEND_RESERVE) codes.add(REASON.CARD_SPEND_FUNDING_GAP);
    }
  }

  if (claims.some((c) => c.reservation?.state === 'PAID')) codes.add(REASON.RESERVATION_CONSUMED);
  if (ledger.quarantined.some((q) => q.reason === 'DUPLICATE')) codes.add(REASON.DUPLICATE_HOLD);
  if (result.extendedBeyondDecisionHorizon) codes.add(REASON.PROTECTION_HORIZON_EXTENDED);
  if (confidence !== 'TRUSTED') codes.add(REASON.BALANCE_STALE);

  return [...codes].sort();
}

/** Deterministic snapshot identity: same inputs and engine version, same id (INV-07). */
function computeSnapshotId(input: PlanInput, liquidity: Money, claims: readonly Claim[]): SnapshotId {
  const canonical = JSON.stringify({
    engine: ENGINE_VERSION,
    currency: input.currency,
    timeZone: input.timeZone,
    now: input.now,
    liquidity: format(liquidity),
    claims: [...claims]
      .map((c) => ({
        id: c.id,
        p: c.priority,
        amount: format(c.amount),
        due: c.dueDate ?? null,
        up: c.userPriority ?? null,
        res: c.reservation ? { a: format(c.reservation.amount), c: format(c.reservation.consumed), s: c.reservation.state } : null,
      }))
      .sort((a, b) => (a.id < b.id ? -1 : a.id > b.id ? 1 : 0)),
    income: [...(input.incomeEvents ?? [])]
      .map((i) => ({ id: i.id, a: format(i.expectedAmount), d: i.expectedDate, s: i.state }))
      .sort((a, b) => (a.id < b.id ? -1 : a.id > b.id ? 1 : 0)),
  });
  return mkSnapshotId(createHash('sha256').update(canonical).digest('hex').slice(0, 32));
}

/**
 * Produce a PlanSnapshot. Allocation runs first; Safe-to-Spend is exactly the
 * P9 residual (§13).
 */
export function computePlan(input: PlanInput): PlanSnapshot {
  const code = input.currency;
  const today = toLocalDate(input.now, input.timeZone);

  const ledgerOpts = {
    currency: code,
    includedAccounts: input.includedAccounts,
    ...(input.openingBalances !== undefined ? { openingBalances: input.openingBalances } : {}),
  };
  const ledger = reduceLedger(input.events ?? [], ledgerOpts);
  const liquidity = trustedLiquidity(ledger, ledgerOpts);

  const income = (input.incomeEvents ?? []).map((i) =>
    resolveIncomeState(i, today, input.incomeGraceDays ?? 0),
  );

  const claims: Claim[] = [
    ...(input.claims ?? []),
    ...cardClaims(ledger, input.cards ?? [], code),
  ];

  const decisionHorizonEnd = input.decisionHorizonEnd ?? nextIncomeDate(income, today) ?? today;

  const allocationInput = {
    currency: code,
    liquidity,
    claims,
    today,
    decisionHorizonEnd,
    incomeEvents: income,
  };
  const result = allocate(allocationInput);

  const safeToSpendNow = clampAtZero(sub(liquidity, result.allocatedBeforeDiscretionary));

  // Projected value re-runs the same waterfall over liquidity plus the future
  // income explicitly identified for the horizon. It is never presented as
  // cash already available (§13, INV-04).
  const incomingThroughHorizon = sum(
    income
      .filter((i) => isProjectable(i) && isOnOrBefore(i.expectedDate, decisionHorizonEnd))
      .map((i) => projectedAmount(i) ?? zero(code)),
    code,
  );
  const projectedResult = allocate({ ...allocationInput, liquidity: add(liquidity, incomingThroughHorizon) });
  const projectedSafeToSpend = clampAtZero(
    sub(add(liquidity, incomingThroughHorizon), projectedResult.allocatedBeforeDiscretionary),
  );

  const confidenceState = evaluateConfidence({
    now: input.now,
    ...(input.oldestConfirmationAt !== undefined ? { oldestConfirmationAt: input.oldestConfirmationAt } : {}),
    ...(input.materialIntegrityIssue !== undefined ? { materialIntegrityIssue: input.materialIntegrityIssue } : {}),
    openReviewItems: ledger.quarantined.filter((q) => q.reason === 'UNLINKED_REFUND').length,
  });

  return {
    snapshotId: computeSnapshotId(input, liquidity, claims),
    engineVersion: ENGINE_VERSION,
    currency: code,
    safeToSpendNow,
    projectedSafeToSpend,
    decisionHorizonEnd,
    protectionHorizonEnd: result.protectionHorizonEnd,
    protectedTotal: result.protectedTotal,
    mandatoryFundingGap: result.mandatoryFundingGap,
    bufferShortfall: result.bufferShortfall,
    flexibleShortfall: result.flexibleShortfall,
    confidenceState,
    reasonCodes: deriveReasonCodes(result, income, ledger, claims, confidenceState, code),
    allocations: result.allocations,
    trustedAllocatableLiquidity: liquidity,
    ledger,
    ledgerCompleteness: evaluateLedgerCompleteness({
      now: input.now,
      ...(input.oldestConfirmationAt !== undefined
        ? { lastConfirmationAt: input.oldestConfirmationAt }
        : {}),
      reconciledMinor: reconciledMinor(input.events ?? []),
      recordedMinor: recordedMinor(input.events ?? []),
    }),
    attributionConfidence: ATTRIBUTION.NONE,
  };
}
