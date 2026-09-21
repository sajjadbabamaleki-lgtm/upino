import type { ClaimId } from '../core/ids.js';
import { compareClaims, required, type Claim } from '../domain/claim.js';
import { isProjectable, projectedAmount, type IncomeEvent } from '../domain/income.js';
import { isMandatory, PRIORITY, type Priority } from '../domain/priority.js';
import { clampAtZero, isZero, min, sub, sum, zero, type Money } from '../money/money.js';
import { isAfter, isOnOrBefore, isOverdue, type LocalDate } from '../time/clock.js';

export interface Allocation {
  readonly claimId: ClaimId;
  readonly priority: Priority;
  readonly label: string;
  /** What the claim needed from current liquidity in this snapshot. */
  readonly requiredNow: Money;
  readonly allocated: Money;
  readonly shortfall: Money;
}

export interface AllocationInput {
  readonly currency: string;
  readonly liquidity: Money;
  readonly claims: readonly Claim[];
  readonly today: LocalDate;
  /** Normally the next expected income event (§4). */
  readonly decisionHorizonEnd: LocalDate;
  readonly incomeEvents?: readonly IncomeEvent[];
}

export interface AllocationResult {
  readonly allocations: readonly Allocation[];
  readonly allocatedBeforeDiscretionary: Money;
  readonly protectedTotal: Money;
  readonly mandatoryFundingGap: Money;
  readonly bufferShortfall: Money;
  readonly flexibleShortfall: Money;
  readonly protectionHorizonEnd: LocalDate;
  readonly extendedBeyondDecisionHorizon: boolean;
}

/**
 * How much of a claim current liquidity must protect right now.
 *
 * For a claim due within the decision horizon this is the whole remaining
 * amount. For one falling after it, the protection horizon stretches to cover
 * only the part expected income cannot meet (§4, INV-15, fixture T11) — the
 * engine looks past payday rather than letting the user spend money that a
 * hard claim already needs.
 */
function requiredFromCurrentLiquidity(
  claim: Claim,
  input: AllocationInput,
): { amount: Money; beyondHorizon: boolean } {
  const full = required(claim);
  const due = claim.dueDate;

  if (due === undefined || isOnOrBefore(due, input.decisionHorizonEnd)) {
    return { amount: full, beyondHorizon: false };
  }
  if (isZero(full)) return { amount: full, beyondHorizon: false };

  const incomingBeforeDue = sum(
    (input.incomeEvents ?? [])
      .filter((i) => isProjectable(i) && isAfter(i.expectedDate, input.today) && isOnOrBefore(i.expectedDate, due))
      .map((i) => projectedAmount(i) ?? zero(input.currency)),
    input.currency,
  );

  return { amount: clampAtZero(sub(full, incomingBeforeDue)), beyondHorizon: true };
}

/** Overdue hard claims are elevated out of their class into P1 (§11). */
function effectivePriority(claim: Claim, today: LocalDate): Priority {
  const hard =
    claim.priority === PRIORITY.P2_HARD_OBLIGATION ||
    claim.priority === PRIORITY.P3_CARD_SPEND_RESERVE;
  if (hard && claim.dueDate !== undefined && isOverdue(claim.dueDate, today)) {
    return PRIORITY.P1_OVERDUE_HARD;
  }
  return claim.priority;
}

/**
 * The deterministic allocation waterfall (§11). Given identical inputs and
 * engine version this returns identical allocations and ordering (INV-07).
 */
export function allocate(input: AllocationInput): AllocationResult {
  const code = input.currency;

  const prepared = input.claims
    .map((claim) => {
      const { amount, beyondHorizon } = requiredFromCurrentLiquidity(claim, input);
      const priority = effectivePriority(claim, input.today);
      return { claim: { ...claim, priority }, requiredNow: amount, beyondHorizon };
    })
    .sort((a, b) => compareClaims(a.claim, b.claim));

  let remainingLiquidity = input.liquidity;
  const allocations: Allocation[] = [];
  let protectionHorizonEnd = input.decisionHorizonEnd;
  let extended = false;

  for (const { claim, requiredNow, beyondHorizon } of prepared) {
    const allocated = min(requiredNow, clampAtZero(remainingLiquidity));
    remainingLiquidity = sub(remainingLiquidity, allocated);

    allocations.push({
      claimId: claim.id,
      priority: claim.priority,
      label: claim.label,
      requiredNow,
      allocated,
      shortfall: sub(requiredNow, allocated),
    });

    if (beyondHorizon && !isZero(requiredNow) && claim.dueDate !== undefined) {
      extended = true;
      if (isAfter(claim.dueDate, protectionHorizonEnd)) protectionHorizonEnd = claim.dueDate;
    }
  }

  const before = allocations.filter((a) => a.priority !== PRIORITY.P9_DISCRETIONARY);
  const allocatedBeforeDiscretionary = sum(before.map((a) => a.allocated), code);

  /**
   * mandatory_funding_gap (§13) is the unfunded part of the mandatory classes
   * P0–P5 and P7. P6 buffer and P8 flexible shortfalls are reported separately
   * and never inflate it.
   *
   * The specification states this as Σ(required mandatory) − liquidity. That
   * form agrees with every fixture but under-reports where a non-mandatory
   * class funded earlier in the waterfall — P6 buffer sits above P7 hard goals
   * — absorbs liquidity a mandatory claim then cannot reach. Summing the
   * per-claim shortfalls is equivalent on every fixture and correct in that
   * case too, so it is what the engine computes. See tests/spec-divergence.
   */
  const mandatoryFundingGap = sum(
    allocations.filter((a) => isMandatory(a.priority)).map((a) => a.shortfall),
    code,
  );

  const shortfallAt = (p: Priority): Money =>
    sum(allocations.filter((a) => a.priority === p).map((a) => a.shortfall), code);

  return {
    allocations,
    allocatedBeforeDiscretionary,
    protectedTotal: allocatedBeforeDiscretionary,
    mandatoryFundingGap,
    bufferShortfall: shortfallAt(PRIORITY.P6_BUFFER),
    flexibleShortfall: shortfallAt(PRIORITY.P8_FLEXIBLE),
    protectionHorizonEnd,
    extendedBeyondDecisionHorizon: extended,
  };
}

/** Literal form of the §13 formula, kept so tests can assert the two agree. */
export function specFormMandatoryGap(input: AllocationInput): Money {
  const requiredMandatory = sum(
    input.claims
      .filter((c) => isMandatory(effectivePriority(c, input.today)))
      .map((c) => requiredFromCurrentLiquidity(c, input).amount),
    input.currency,
  );
  return clampAtZero(sub(requiredMandatory, input.liquidity));
}
