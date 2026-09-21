import { describe, expect, it } from 'vitest';
import { allocate, format, specFormMandatoryGap, type AllocationInput } from '../src/index.js';
import { claim, eur, P, TODAY, TOMORROW } from './helpers.js';

/**
 * §13 states mandatory_funding_gap as
 *
 *   max(0, Σ(required mandatory allocations at P0,P1,P2,P3,P4,P5,P7) − liquidity)
 *
 * The engine instead sums the per-claim shortfalls of those classes. The two
 * agree on every fixture in §24, but they are not equivalent in general, and
 * the difference is a real reporting gap rather than a style choice.
 */
describe('§13 mandatory_funding_gap — engine form vs the literal formula', () => {
  const base = (claims: AllocationInput['claims'], liquidity: string): AllocationInput => ({
    currency: 'EUR',
    liquidity: eur(liquidity),
    claims,
    today: TODAY,
    decisionHorizonEnd: TOMORROW,
  });

  it('the two forms agree wherever no non-mandatory class outranks a mandatory one', () => {
    const cases: readonly (readonly [string, AllocationInput['claims']])[] = [
      ['2600.00', [claim('rent', P.P2_HARD_OBLIGATION, '1800.00'), claim('ess', P.P4_ESSENTIAL_LIVING, '600.00'), claim('catch', P.P5_SINKING_CATCHUP, '400.00')]],
      ['900.00', [claim('rent', P.P2_HARD_OBLIGATION, '500.00'), claim('ess', P.P4_ESSENTIAL_LIVING, '300.00'), claim('goal', P.P7_HARD_GOAL, '300.00')]],
      ['700.00', [claim('ess', P.P4_ESSENTIAL_LIVING, '500.00'), claim('buf', P.P6_BUFFER, '500.00')]],
      ['900.00', [claim('rent', P.P2_HARD_OBLIGATION, '500.00'), claim('ess', P.P4_ESSENTIAL_LIVING, '300.00'), claim('flex', P.P8_FLEXIBLE, '300.00')]],
      ['200.00', [claim('card', P.P3_CARD_SPEND_RESERVE, '350.00')]],
    ];
    for (const [liquidity, claims] of cases) {
      const input = base(claims, liquidity);
      expect(format(allocate(input).mandatoryFundingGap)).toBe(format(specFormMandatoryGap(input)));
    }
  });

  it('they diverge when the P6 buffer absorbs liquidity a P7 hard goal then cannot reach', () => {
    // The buffer is non-mandatory but sits above hard goals in the waterfall,
    // so it can starve a mandatory claim without the subtraction form noticing.
    const input = base(
      [claim('buffer', P.P6_BUFFER, '800.00'), claim('goal', P.P7_HARD_GOAL, '400.00')],
      '1000.00',
    );
    const result = allocate(input);

    expect(format(result.allocations.find((a) => a.claimId === 'buffer')!.allocated)).toBe('800.00 EUR');
    expect(format(result.allocations.find((a) => a.claimId === 'goal')!.allocated)).toBe('200.00 EUR');

    // The hard goal is genuinely €200 short and the engine reports it.
    expect(format(result.mandatoryFundingGap)).toBe('200.00 EUR');

    // The literal §13 formula reports nothing, because Σ mandatory (€400) is
    // comfortably under liquidity (€1,000).
    expect(format(specFormMandatoryGap(input))).toBe('0.00 EUR');
  });
});
