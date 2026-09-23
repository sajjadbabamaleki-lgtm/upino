# Upino engine — §15.3 Ledger integrity

Normative addendum to *Upino Product Foundation v3.5 (Frozen G0)*.
Engine spec version: **v3.6**. Supersedes nothing; §15.2 stands unchanged.

## Why this is engine spec and not product strategy

The Strategic Evolution document (v1.4, §9.1) establishes that Upino is
manual-first: bank connectivity is out of scope, so missing transaction
entries are a normal operating condition rather than an error. It then asks
for confidence to be split into three dimensions.

That split cannot live in a strategy document. Every other rule in this
product is enforced by a fixture in the §24 table that both engine
implementations are validated against; a rule that exists only in prose is a
rule nothing checks. §15.3 therefore states it as engine contract.

## §15.3.1 The three dimensions

§15.2 already defines **liquidity confidence** (`ConfidenceState`), derived
from the age of the oldest required balance confirmation. It answers: *may
the current Safe-to-Spend be presented as trusted?*

Two further dimensions are defined here. They answer different questions and
are computed from different evidence.

| Dimension | Question | Evidence |
|---|---|---|
| Liquidity confidence (§15.2) | May STS be presented as trusted? | Age of the oldest balance confirmation |
| Ledger completeness (§15.3.2) | Are transaction-level explanations reliable? | Share of money movement known only through reconciliation |
| Attribution confidence (§15.3.4) | May category-, merchant- or purchase-specific claims be made? | Source/category/purchase linkage |

## §15.3.2 Ledger completeness

`LedgerCompleteness ∈ { complete, partial, unknown }`.

**Completeness is not observable prospectively.** Upino cannot know what the
user did not enter — that is what "not entered" means. The only observable
evidence is the size of the unexplained delta that reconciliation reveals
*after the fact*. The metric is therefore defined retrospectively, over the
whole ledger:

```
reconciled = Σ |delta| over BalanceAdjustmentEvent
recorded   = Σ |amount| over every other value-moving event
drift      = reconciled / (reconciled + recorded)
```

`drift` is the share of money movement that Upino learned about only by
reconciliation rather than by being told. It is computed in integer minor
units and compared in permille, so no binary floating point is involved
(§5).

**Classification.** Let `d` be drift in permille and `age` the whole days
since the most recent balance confirmation.

1. No balance confirmation has ever been recorded → `unknown`.
2. `age > LedgerPolicy.measuredThroughDays` → `unknown`. Whatever the last
   reconciliation showed, the period since it is unmeasured.
3. `recorded = 0` and `reconciled = 0` → `complete`. Nothing happened, so
   nothing is missing.
4. `recorded = 0` and `reconciled > 0` → `unknown`. Money moved and none of
   it was recorded.
5. `d ≤ completeThroughDriftPermille` → `complete`.
6. `d ≤ partialThroughDriftPermille` → `partial`.
7. Otherwise → `unknown`.

**LedgerPolicy** (versioned product defaults, `2026-09-v1`):

| Constant | Value |
|---|---|
| `completeThroughDriftPermille` | 50 (5%) |
| `partialThroughDriftPermille` | 250 (25%) |
| `measuredThroughDays` | 14 |

## §15.3.3 What ledger completeness may and may not do

**INV-18 — Ledger completeness never moves the figure.**
`safeToSpendNow`, `projectedSafeToSpend`, `protectedTotal`,
`mandatoryFundingGap` and every allocation are identical for two inputs that
differ only in ledger completeness. Completeness governs what Upino may
*say about history*, never what it computes about money. A confirmed balance
is a fact about liquidity; it is not a claim that the transaction list
explaining it is complete, and conflating the two is exactly the failure
this section exists to prevent.

**INV-19 — Reconciliation is never narrated as spending.**
An unexplained delta is recorded as a `BalanceAdjustmentEvent` and presented
as a correction. No surface may render it as a transaction, infer a merchant
or category for it, or fold it into cumulative spending. §21 already forbids
silently rewriting the record; this states the manual-first case of it.

**Presentation.** Where completeness is `partial` or `unknown`, any surface
whose claim depends on a complete ledger is withheld or qualified. Where it
is `complete`, nothing changes — completeness is not a badge and never
modulates the hero (§32.6, §32.7).

## §15.3.4 Attribution confidence

`AttributionConfidence ∈ { none, partial, attributed }`.

In the manual-first data model there is no category, merchant or purchase
linkage: an expense carries a label the user typed and nothing more.
Attribution confidence is therefore **`none`** for every snapshot this
engine version produces, and it is stated rather than computed.

It is defined now, ahead of any data that would move it, because its purpose
is to block by default. Any future feature making a category-, merchant- or
purchase-specific claim must read this field and find it insufficient until
a source exists that makes it otherwise.

## §15.3.5 Fixtures

Added to the §24 table, validated by both engine implementations:

| Id | Case |
|---|---|
| T37 | Never confirmed → `unknown` |
| T38 | Everything recorded, zero drift → `complete` |
| T39 | Drift at 5% → `complete` (boundary, inclusive) |
| T40 | Drift at 25% → `partial` (boundary, inclusive) |
| T41 | Drift above 25% → `unknown` |
| T42 | Confirmed 15 days ago, zero drift → `unknown` (age gate) |
| T43 | Nothing recorded, nothing reconciled → `complete` |
| T44 | Nothing recorded, money reconciled → `unknown` |
| T45 | INV-18: completeness differs, every figure identical |
