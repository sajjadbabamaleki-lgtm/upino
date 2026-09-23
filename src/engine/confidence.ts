import { divideRoundHalfEven } from '../money/rounding.js';
import type { Instant } from '../time/clock.js';

/** Confidence policy (§15.2). Freshness thresholds are versioned defaults. */
export const CONFIDENCE = {
  TRUSTED: 'TRUSTED',
  DEGRADED: 'DEGRADED',
  REVIEW_REQUIRED: 'REVIEW_REQUIRED',
} as const;

export type ConfidenceState = (typeof CONFIDENCE)[keyof typeof CONFIDENCE];

export const FRESHNESS_POLICY = {
  version: '2026-09-v1',
  trustedThroughDays: 7,
  degradedThroughDays: 21,
} as const;

const DAY_MS = 86_400_000;

export interface ConfidenceInput {
  readonly now: Instant;
  /** Oldest required balance confirmation across included accounts. */
  readonly oldestConfirmationAt?: Instant;
  /** A material unresolved duplicate, reversal or ledger-integrity condition. */
  readonly materialIntegrityIssue?: boolean;
  /** Non-material unresolved review items, e.g. an unlinked refund. */
  readonly openReviewItems?: number;
}

/**
 * Integrity conditions override freshness and may force REVIEW_REQUIRED
 * immediately, regardless of how recent the balance evidence is (§15.2).
 */
export function evaluateConfidence(input: ConfidenceInput): ConfidenceState {
  if (input.materialIntegrityIssue === true) return CONFIDENCE.REVIEW_REQUIRED;

  if (input.oldestConfirmationAt !== undefined) {
    const ageDays = (input.now - input.oldestConfirmationAt) / DAY_MS;
    if (ageDays > FRESHNESS_POLICY.degradedThroughDays) return CONFIDENCE.REVIEW_REQUIRED;
    if (ageDays > FRESHNESS_POLICY.trustedThroughDays) return CONFIDENCE.DEGRADED;
  }

  if ((input.openReviewItems ?? 0) > 0) return CONFIDENCE.DEGRADED;

  return CONFIDENCE.TRUSTED;
}

const RANK: Readonly<Record<ConfidenceState, number>> = {
  TRUSTED: 0,
  DEGRADED: 1,
  REVIEW_REQUIRED: 2,
};

export const atLeast = (actual: ConfidenceState, floor: ConfidenceState): boolean =>
  RANK[actual] >= RANK[floor];

/**
 * §15.3.2 — how complete the transaction record is, which is a different
 * question from whether the balance is fresh.
 *
 * Completeness cannot be observed prospectively: the engine cannot know what
 * the user did not enter, because that is what "not entered" means. The only
 * evidence is the size of the delta reconciliation reveals after the fact, so
 * the measure is retrospective by construction.
 */
export const LEDGER_COMPLETENESS = {
  COMPLETE: 'COMPLETE',
  PARTIAL: 'PARTIAL',
  UNKNOWN: 'UNKNOWN',
} as const;

export type LedgerCompleteness =
  (typeof LEDGER_COMPLETENESS)[keyof typeof LEDGER_COMPLETENESS];

/**
 * §15.3.4 — whether a category-, merchant- or purchase-specific claim is
 * allowed. In the manual-first data model an expense carries a label the user
 * typed and nothing more, so this is NONE for every snapshot this engine
 * version produces. It is defined ahead of the data that would move it
 * because its purpose is to block such claims by default.
 */
export const ATTRIBUTION = {
  NONE: 'NONE',
  PARTIAL: 'PARTIAL',
  ATTRIBUTED: 'ATTRIBUTED',
} as const;

export type AttributionConfidence = (typeof ATTRIBUTION)[keyof typeof ATTRIBUTION];

export const LEDGER_POLICY = {
  version: '2026-09-v1',
  /**
   * Drift is the share of money movement the engine learned about only
   * through reconciliation rather than by being told. Compared in permille so
   * the whole comparison stays in integers (§5).
   */
  completeThroughDriftPermille: 50,
  partialThroughDriftPermille: 250,
  /**
   * Past this many days, the period since the last confirmation is
   * unmeasured, whatever the last reconciliation showed.
   */
  measuredThroughDays: 14,
} as const;

export interface LedgerCompletenessInput {
  readonly now: Instant;
  readonly lastConfirmationAt?: Instant;
  /** Sum of |delta| over BalanceAdjustment events, in minor units. */
  readonly reconciledMinor: bigint;
  /** Sum of |amount| over every other value-moving event, in minor units. */
  readonly recordedMinor: bigint;
}

const abs = (v: bigint): bigint => (v < 0n ? -v : v);

/** §15.3.2. Returns UNKNOWN rather than guessing whenever the evidence does
 * not support a stronger answer. */
export function evaluateLedgerCompleteness(
  input: LedgerCompletenessInput,
): LedgerCompleteness {
  if (input.lastConfirmationAt === undefined) return LEDGER_COMPLETENESS.UNKNOWN;

  const ageDays = (input.now - input.lastConfirmationAt) / DAY_MS;
  if (ageDays > LEDGER_POLICY.measuredThroughDays) return LEDGER_COMPLETENESS.UNKNOWN;

  const reconciled = abs(input.reconciledMinor);
  const recorded = abs(input.recordedMinor);
  if (recorded === 0n) {
    // Nothing happened and nothing is missing, or money moved and none of it
    // was recorded. Those are opposite answers, not one uncertain one.
    return reconciled === 0n
      ? LEDGER_COMPLETENESS.COMPLETE
      : LEDGER_COMPLETENESS.UNKNOWN;
  }

  const driftPermille = divideRoundHalfEven(reconciled * 1000n, reconciled + recorded);
  if (driftPermille <= BigInt(LEDGER_POLICY.completeThroughDriftPermille)) {
    return LEDGER_COMPLETENESS.COMPLETE;
  }
  if (driftPermille <= BigInt(LEDGER_POLICY.partialThroughDriftPermille)) {
    return LEDGER_COMPLETENESS.PARTIAL;
  }
  return LEDGER_COMPLETENESS.UNKNOWN;
}
