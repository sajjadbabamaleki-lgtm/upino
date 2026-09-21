/**
 * The deterministic allocation waterfall (§11). Ordering is normative:
 * lower ordinal is funded first, and P9 is the discretionary residual that
 * becomes Safe-to-Spend.
 */
export const PRIORITY = {
  P0_INTEGRITY_HOLD: 0,
  P1_OVERDUE_HARD: 1,
  P2_HARD_OBLIGATION: 2,
  P3_CARD_SPEND_RESERVE: 3,
  P4_ESSENTIAL_LIVING: 4,
  P5_SINKING_CATCHUP: 5,
  P6_BUFFER: 6,
  P7_HARD_GOAL: 7,
  P8_FLEXIBLE: 8,
  P9_DISCRETIONARY: 9,
} as const;

export type Priority = (typeof PRIORITY)[keyof typeof PRIORITY];

export const PRIORITY_LABEL: Readonly<Record<Priority, string>> = {
  0: 'P0 Integrity hold',
  1: 'P1 Overdue hard obligation',
  2: 'P2 Hard obligation before horizon',
  3: 'P3 Credit Card Spend Reserve',
  4: 'P4 Essential variable living',
  5: 'P5 Required sinking-fund catch-up',
  6: 'P6 Protected minimum buffer',
  7: 'P7 Hard goal',
  8: 'P8 Flexible goal / optional debt acceleration',
  9: 'P9 Discretionary',
};

/**
 * Classes whose shortfall counts toward mandatory_funding_gap (§13).
 * P6 (buffer) is a user protection policy and P8 (flexible) is optional;
 * their shortfalls are reported separately and never inflate the gap.
 */
export const MANDATORY_PRIORITIES: ReadonlySet<Priority> = new Set([
  PRIORITY.P0_INTEGRITY_HOLD,
  PRIORITY.P1_OVERDUE_HARD,
  PRIORITY.P2_HARD_OBLIGATION,
  PRIORITY.P3_CARD_SPEND_RESERVE,
  PRIORITY.P4_ESSENTIAL_LIVING,
  PRIORITY.P5_SINKING_CATCHUP,
  PRIORITY.P7_HARD_GOAL,
]);

export const isMandatory = (p: Priority): boolean => MANDATORY_PRIORITIES.has(p);
