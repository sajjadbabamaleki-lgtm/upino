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
| `app/test/persistence_test.dart` | Saving, reopening and refusing bad documents |
| `app/test/nav_bar_test.dart` | Navigation geometry, measured rather than eyeballed |
| `app/test/activity_test.dart` | Listing recorded events and correcting them |
| `app/test/plan_screen_test.dart` | Editing commitments, income and starting over |
| `app/test/theme_choice_test.dart` | The theme preference and its persistence |

### Timezone

The Dart core SDK ships no IANA database, so `LocalDate.at` takes the UTC
offset in effect at that instant rather than a zone name. Local-midnight
semantics are preserved (fixture T12); wiring a real zone database is a
client concern, not an engine one.

### Persistence

A plan is stored as one JSON document: the event log, the plan state and the
opening balance. Nothing computed is stored, so reopening replays the log
through the engine and lands on the same numbers (INV-07) — a saved file can
never disagree with the engine.

Two rules keep a stored plan meaning what it meant:

- **Enums persist by name.** An index would silently change meaning the moment
  a case is inserted into `Priority` or `ReservationState`.
- **Money persists as integer minor units plus its currency**, exactly as §5
  holds it — no decimal string to re-parse, no double.

The theme preference lives in the same document. It is a preference rather
than plan data, so deleting the plan keeps it, and a version 1 document
without the field simply loads as "follow the phone".

A document carries `schemaVersion`. A reader that meets a newer version, an
unknown enum name or an unknown event kind refuses the whole document rather
than applying part of it; the app then starts clean and reports why, instead
of showing a figure built from half a plan.

`FilePlanStore` writes to a scratch file and renames it over the target, so an
interrupted write cannot leave a half-saved plan. Writes are serialized and
coalesced because the app persists after every mutation: two rapid edits
would otherwise race the same scratch path, and an older state must never land
on disk after a newer one.

### Corrections

Removing a recorded entry appends a `CorrectionEvent` beside it rather than
deleting it. The voided event stays in the log, so the record still explains
what the plan used to say (§15, §21), while the figure recovers immediately
because the reducer collects voided ids in a first pass and skips those events
when folding.

The entry also stays on the Activity list, dimmed and marked. Silently erasing
a line the user once saw would contradict the one rule this product is built
on, in the smallest and most damaging way available.

### Screens

Four destinations, as §32.9 specifies.

| Screen | Holds |
|---|---|
| Home | The decision: Safe-to-Spend, what is short, why the figure moved |
| Plan | Commitments, income and balance — listed in waterfall order |
| Activity | What was recorded, and how to correct it |
| Profile | Balance confirmation, confidence, theme, starting over |

Every amount in the app is entered through one `AmountSheet`, so the keypad
path is identical whether it is a spend, a balance confirmation or an edit.

The Plan screen lists commitments in waterfall order rather than in the order
they were typed, and each row says in plain language where it sits — "Must be
paid — comes first", "Kept back for emergencies". The order on screen is the
order the money is actually assigned, so it is explained rather than asserted.

### Running it on a phone

Every push builds an installable APK and publishes it to the **latest-android**
release, so the download link never changes:

**https://github.com/sajjadbabamaleki-lgtm/upino/releases/tag/latest-android**

Open that on the phone, download `upino.apk` and tap it. Android asks once to
allow installing from this source.

The release exists because a workflow artifact is only reachable from the
desktop web UI and arrives wrapped in a zip — useless on the device the app is
meant to run on. The artifact is still uploaded for CI debugging.

The APK is debug-signed, which is what makes it installable without a release
key. A store build needs its own signing config.

The app declares no permissions and talks to no network: the plan lives in a
file in the app's own storage.

Building locally instead, which needs no CI at all:

```
cd app
flutter pub get
flutter run                  # on a connected device or emulator
flutter build apk --debug    # build/app/outputs/flutter-apk/app-debug.apk
```
