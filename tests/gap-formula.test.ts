import { describe, expect, it } from 'vitest';
import { allocate, format, supersededSubtractionGap, type AllocationInput } from '../src/index.js';
import { claim, eur, P, TODAY, TOMORROW } from './helpers.js';

/**
 * §13 defines mandatory_funding_gap as the per-claim shortfall sum across the
 * mandatory classes. Before v3.5 it was written as a single subtraction,
 *
 *   max(0, Σ(required mandatory) − liquidity)
 *
 * which agrees on most inputs but silently under-reports in the case below.
 * These tests pin why the subtraction form was replaced, so it cannot be
 * reintroduced as a "simplification".
 */
describe('§13 mandatory_funding_gap — current form vs the superseded subtraction', () => {
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
      expect(format(allocate(input).mandatoryFundingGap)).toBe(format(supersededSubtractionGap(input)));
    }
  });

  it('T36 — the subtraction form hides a hard-goal shortfall the buffer caused', () => {
    // The buffer is non-mandatory but sits above hard goals in the waterfall,
    // so it can starve a mandatory claim without the subtraction form noticing.
    const input = base(
      [claim('buffer', P.P6_BUFFER, '800.00'), claim('goal', P.P7_HARD_GOAL, '400.00')],
      '1000.00',
    );
    const result = allocate(input);

    expect(format(result.allocations.find((a) => a.claimId === 'buffer')!.allocated)).toBe('800.00 EUR');
    expect(format(result.allocations.find((a) => a.claimId === 'goal')!.allocated)).toBe('200.00 EUR');

    // The hard goal is genuinely €200 short, and §13 as written since v3.5
    // reports it.
    expect(format(result.mandatoryFundingGap)).toBe('200.00 EUR');
    expect(format(result.bufferShortfall)).toBe('0.00 EUR');

    // The superseded subtraction reported nothing, because Σ mandatory (€400)
    // is comfortably under liquidity (€1,000).
    expect(format(supersededSubtractionGap(input))).toBe('0.00 EUR');
  });
});
