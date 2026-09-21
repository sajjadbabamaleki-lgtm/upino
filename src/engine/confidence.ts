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
