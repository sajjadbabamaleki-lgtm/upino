# Upino — Financial Engine

Deterministic implementation of the financial engine specified in
**Upino Product Foundation v3.5 (Frozen G0)**.

The engine owns every monetary calculation. It is pure: given identical inputs
and an identical engine version it returns identical allocations, Safe-to-Spend,
funding gap, confidence state and reason codes (INV-07).

## Status — gate G1

§30 defines G1 as *"T01–T12 executable and passing, including protection-horizon
and timezone boundaries; deterministic snapshots and reason codes."*

| Gate | Requirement | State |
|---|---|---|
| G0 | Domain contracts internally consistent | Closed by the v3.4 specification |
| **G1** | **T01–T12 executable and passing** | **Met — all 36 fixtures pass** |
| G2 | Vertical slice end to end | Not started (needs a client) |

```
npm install
npm test        # 53 tests: 36 acceptance fixtures, 15 invariants, 2 formula guards
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

### The mandatory funding gap is summed per claim

§13 defines `mandatory_funding_gap` as the sum of what each mandatory claim
still needs after allocation, across P0–P5 and P7.

It is not a single subtraction of mandatory totals from liquidity. The P6
buffer is non-mandatory but sits *above* P7 hard goals in the waterfall, so a
funded buffer can absorb liquidity a hard goal then cannot reach. A
subtraction would report no gap there while a hard commitment is genuinely
underfunded. Fixture T36 covers exactly that case, and
`tests/gap-formula.test.ts` pins the superseded form so it cannot be
reintroduced as a simplification.

## Flutter client (`app/`)

The G2 vertical slice: onboarding → first plan → Home → Quick Expense →
immediate recalculation (§18).

```
cd app
flutter pub get
flutter test      # 52 tests
flutter analyze
```

### Two engines, one fixture table

`app/lib/engine/` is a Dart port of `src/`. Duplicating money logic is a
drift risk, so both implementations run the **same** §24 fixture table —
`tests/acceptance.test.ts` and `app/test/acceptance_test.dart` assert the same
36 rows with the same expected values. A divergence fails one suite
immediately.

The port exists because Quick Expense targets roughly three seconds (§18) and
the product serves cash users with intermittent connectivity, so the decision
number is computed on-device rather than behind a network call.

| Suite | Covers |
|---|---|
| `app/test/acceptance_test.dart` | §24 fixtures T01–T36 |
| `app/test/design_checks_test.dart` | §32.10 design checks D01–D12 |
| `app/test/vertical_slice_test.dart` | §18 end to end, through the real widgets |

### Timezone

The Dart core SDK ships no IANA database, so `LocalDate.at` takes the UTC
offset in effect at that instant rather than a zone name. Local-midnight
semantics are preserved (fixture T12); wiring a real zone database is a
client concern, not an engine one.
