# Upino — Financial Engine

Deterministic implementation of the financial engine specified in
**Upino Product Foundation v3.4 (Frozen G0)**.

The engine owns every monetary calculation. It is pure: given identical inputs
and an identical engine version it returns identical allocations, Safe-to-Spend,
funding gap, confidence state and reason codes (INV-07).

## Status — gate G1

§30 defines G1 as *"T01–T12 executable and passing, including protection-horizon
and timezone boundaries; deterministic snapshots and reason codes."*

| Gate | Requirement | State |
|---|---|---|
| G0 | Domain contracts internally consistent | Closed by the v3.4 specification |
| **G1** | **T01–T12 executable and passing** | **Met — all 35 fixtures pass** |
| G2 | Vertical slice end to end | Not started (needs a client) |

```
npm install
npm test        # 52 tests: 35 acceptance fixtures, 15 invariants, 2 divergence
npm run typecheck
```

## Layout

| Path | §  | Contents |
|---|---|---|
| `src/money/` | §5, §5.1, §16 | Integer minor units, ROUND_HALF_EVEN, contribution schedules, FX |
| `src/time/` | §5 | Civil dates in the user's own timezone; overdue at local midnight |
| `src/ledger/` | §6, §15.1 | Canonical events and the fold that derives balances, card liability and spending |
| `src/domain/` | §7, §9–§12 | Income lifecycle, claims, priority waterfall, reservation state machine, reason codes |
| `src/engine/` | §11, §13, §15.2 | Allocation, confidence policy, `computePlan` → `PlanSnapshot` |
| `tests/` | §23, §24 | Acceptance fixtures, engine invariants |

## Design notes

**Money never touches floating point.** Amounts are `bigint` minor units with an
explicit currency. Mixing currencies throws rather than netting silently (§16).

**Safe-to-Spend is the P9 residual, not a parallel formula.** Allocation runs
first; `safe_to_spend_now = max(0, liquidity − Σ allocations P0…P8)` (§13).

**The protection horizon is dynamic.** A hard claim falling after the next
income event still protects the part that income cannot cover, so the engine
looks past payday (§4, INV-15, fixture T11).

**The card spend reserve is economic, not contractual.** Unsettled card
purchases reserve their full outstanding amount at P3; the contractual minimum
is tracked separately and only to the extent it exceeds the reserve, so the
overlap is never reserved twice (§9, INV-16, fixtures T34/T35).

### One deliberate divergence from the written formula

§13 states the mandatory funding gap as `max(0, Σ(required mandatory) − liquidity)`.
The engine instead sums the per-claim shortfalls of the mandatory classes.

The two agree on every fixture in §24. They are not equivalent in general: the
P6 buffer is non-mandatory but sits *above* P7 hard goals in the waterfall, so
it can absorb liquidity a hard goal then cannot reach. In that case the written
formula reports no gap while a mandatory claim is genuinely short. The
shortfall-based form is correct there and identical everywhere else.

`tests/spec-divergence.test.ts` pins both behaviours. Resolving this is a
specification decision, not an implementation one.
