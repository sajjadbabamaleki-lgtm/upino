/// Safe-to-Spend contract, confidence policy and the immutable PlanSnapshot
/// (§13, §13.1, §15.2).
library;

import 'allocate.dart';
import 'clock.dart';
import 'domain.dart';
import 'ledger.dart';
import 'money.dart';

const engineVersion = '0.1.0';
const specVersion = 'Upino Product Foundation v3.6 (G0 + §15.3)';

/// Confidence policy (§15.2). Thresholds are versioned product defaults.
enum ConfidenceState { trusted, degraded, reviewRequired }

class FreshnessPolicy {
  const FreshnessPolicy();
  static const version = '2026-09-v1';
  static const trustedThroughDays = 7;
  static const degradedThroughDays = 21;
}

/// Integrity conditions override freshness and may force review immediately,
/// however recent the balance evidence is (§15.2).
ConfidenceState evaluateConfidence({
  required DateTime now,
  DateTime? oldestConfirmationAt,
  bool materialIntegrityIssue = false,
  int openReviewItems = 0,
}) {
  if (materialIntegrityIssue) return ConfidenceState.reviewRequired;

  if (oldestConfirmationAt != null) {
    final ageDays = now.difference(oldestConfirmationAt).inHours / 24.0;
    if (ageDays > FreshnessPolicy.degradedThroughDays) {
      return ConfidenceState.reviewRequired;
    }
    if (ageDays > FreshnessPolicy.trustedThroughDays) return ConfidenceState.degraded;
  }

  if (openReviewItems > 0) return ConfidenceState.degraded;
  return ConfidenceState.trusted;
}

/// §15.3.2 — how complete the transaction record is, which is a different
/// question from whether the balance is fresh.
///
/// Completeness cannot be observed prospectively: the engine cannot know
/// what the user did not enter, because that is what "not entered" means.
/// The only evidence is the size of the delta reconciliation reveals after
/// the fact, so the measure is retrospective by construction.
enum LedgerCompleteness { complete, partial, unknown }

/// §15.3.4 — whether a category-, merchant- or purchase-specific claim is
/// allowed. In the manual-first data model an expense carries a label the
/// user typed and nothing more, so this is [none] for every snapshot this
/// engine version produces. It is defined ahead of the data that would move
/// it because its purpose is to block such claims by default.
enum AttributionConfidence { none, partial, attributed }

class LedgerPolicy {
  const LedgerPolicy();
  static const version = '2026-09-v1';

  /// Drift is the share of money movement the engine learned about only
  /// through reconciliation rather than by being told. Compared in permille
  /// so the whole comparison stays in integers (§5).
  static const completeThroughDriftPermille = 50;
  static const partialThroughDriftPermille = 250;

  /// Past this many days, the period since the last confirmation is
  /// unmeasured, whatever the last reconciliation showed.
  static const measuredThroughDays = 14;
}

/// §15.3.2. Returns [LedgerCompleteness.unknown] rather than guessing
/// whenever the evidence does not support a stronger answer.
LedgerCompleteness evaluateLedgerCompleteness({
  required DateTime now,
  required DateTime? lastConfirmationAt,
  required int reconciledMinor,
  required int recordedMinor,
}) {
  if (lastConfirmationAt == null) return LedgerCompleteness.unknown;

  final ageDays = now.difference(lastConfirmationAt).inHours / 24.0;
  if (ageDays > LedgerPolicy.measuredThroughDays) {
    return LedgerCompleteness.unknown;
  }

  final reconciled = reconciledMinor.abs();
  final recorded = recordedMinor.abs();
  if (recorded == 0) {
    // Nothing happened and nothing is missing, or money moved and none of
    // it was recorded. Those are opposite answers, not one uncertain one.
    return reconciled == 0
        ? LedgerCompleteness.complete
        : LedgerCompleteness.unknown;
  }

  final driftPermille = divideRoundHalfEven(
    reconciled * 1000,
    reconciled + recorded,
  );
  if (driftPermille <= LedgerPolicy.completeThroughDriftPermille) {
    return LedgerCompleteness.complete;
  }
  if (driftPermille <= LedgerPolicy.partialThroughDriftPermille) {
    return LedgerCompleteness.partial;
  }
  return LedgerCompleteness.unknown;
}

class CardTerms {
  const CardTerms({required this.id, this.minimumDue, this.paymentDueDate});
  final String id;
  final Money? minimumDue;
  final LocalDate? paymentDueDate;
}

class PlanInput {
  const PlanInput({
    required this.currency,
    required this.now,
    required this.utcOffset,
    required this.includedAccounts,
    this.openingBalances,
    this.events = const [],
    this.claims = const [],
    this.incomeEvents = const [],
    this.cards = const [],
    this.decisionHorizonEnd,
    this.incomeGraceDays = 0,
    this.oldestConfirmationAt,
    this.materialIntegrityIssue = false,
  });

  final String currency;
  final DateTime now;

  /// The user's UTC offset in effect at [now]; due dates resolve against it.
  final Duration utcOffset;
  final List<String> includedAccounts;
  final Map<String, Money>? openingBalances;
  final List<LedgerEvent> events;
  final List<Claim> claims;
  final List<IncomeEvent> incomeEvents;
  final List<CardTerms> cards;
  final LocalDate? decisionHorizonEnd;
  final int incomeGraceDays;
  final DateTime? oldestConfirmationAt;
  final bool materialIntegrityIssue;
}

/// The immutable, reproducible output of a calculation (§13.1, INV-06).
class PlanSnapshot {
  const PlanSnapshot({
    required this.engineVersion,
    required this.computedAt,
    required this.currency,
    required this.today,
    required this.safeToSpendNow,
    required this.projectedSafeToSpend,
    required this.decisionHorizonEnd,
    required this.protectionHorizonEnd,
    required this.protectedTotal,
    required this.mandatoryFundingGap,
    required this.bufferShortfall,
    required this.flexibleShortfall,
    required this.confidenceState,
    required this.reasonCodes,
    required this.allocations,
    required this.trustedAllocatableLiquidity,
    required this.ledger,
    required this.oldestConfirmationAt,
    required this.ledgerCompleteness,
    required this.attributionConfidence,
  });

  final String engineVersion;

  /// The instant this snapshot was computed for. Presentation derives ages
  /// from this, never from the wall clock, so a snapshot always renders
  /// consistently with the state it describes.
  final DateTime computedAt;
  final String currency;
  final LocalDate today;
  final Money safeToSpendNow;
  final Money projectedSafeToSpend;
  final LocalDate decisionHorizonEnd;
  final LocalDate protectionHorizonEnd;
  final Money protectedTotal;
  final Money mandatoryFundingGap;
  final Money bufferShortfall;
  final Money flexibleShortfall;
  final ConfidenceState confidenceState;
  final List<ReasonCode> reasonCodes;
  final List<Allocation> allocations;
  final Money trustedAllocatableLiquidity;
  final LedgerState ledger;
  final DateTime? oldestConfirmationAt;

  /// §15.3.2. Governs what may be said about history, never what is computed
  /// about money — INV-18 pins that separation.
  final LedgerCompleteness ledgerCompleteness;

  /// §15.3.4. Always [AttributionConfidence.none] while the data model is
  /// manual-first.
  final AttributionConfidence attributionConfidence;

  /// Whole days since the oldest required balance confirmation, floored at
  /// zero. Null when no balance has been confirmed yet.
  int? get balanceAgeInDays {
    final confirmed = oldestConfirmationAt;
    if (confirmed == null) return null;
    final days = computedAt.difference(confirmed).inDays;
    return days < 0 ? 0 : days;
  }

  bool get hasMandatoryGap => mandatoryFundingGap.minor > 0;

  /// The unfunded mandatory claim that ranks highest, used to aim the
  /// "Resolve" action on the funding-gap hero (§32.6, state S3).
  Allocation? get topUnfundedClaim {
    for (final a in allocations) {
      if (a.priority.isMandatory && a.shortfall.minor > 0) return a;
    }
    return null;
  }
}

/// Credit Card Spend Reserve (§9, INV-16). Unsettled purchases reserve their
/// full outstanding amount because the purchase already economically
/// occurred. The contractual minimum is tracked separately, and only to the
/// extent it exceeds the reserve, so the overlap is never reserved twice.
List<Claim> _cardClaims(LedgerState ledger, List<CardTerms> cards, String currency) {
  final out = <Claim>[];
  for (final card in cards) {
    final outstanding = ledger.cardOutstanding[card.id] ?? Money.zero(currency);
    if (outstanding.minor > 0) {
      out.add(Claim(
        id: 'card-reserve:${card.id}',
        priority: Priority.p3CardSpendReserve,
        label: 'Card balance already spent',
        amount: outstanding,
        dueDate: card.paymentDueDate,
      ),);
    }
    final minimum = card.minimumDue;
    if (minimum != null) {
      final extra = (minimum - outstanding).clampedAtZero;
      if (!extra.isZero) {
        out.add(Claim(
          id: 'card-minimum:${card.id}',
          priority: Priority.p2HardObligation,
          label: 'Card minimum due',
          amount: extra,
          dueDate: card.paymentDueDate,
        ),);
      }
    }
  }
  return out;
}

List<ReasonCode> _reasonCodes({
  required AllocationResult result,
  required List<IncomeEvent> income,
  required LedgerState ledger,
  required List<Claim> claims,
  required ConfidenceState confidence,
}) {
  final codes = <ReasonCode>{};

  if (income.any((i) => i.state == IncomeState.confirmed)) {
    codes.add(ReasonCode.incomeConfirmed);
  }
  if (income.any((i) => i.state == IncomeState.late)) codes.add(ReasonCode.incomeLate);

  if (result.mandatoryFundingGap.minor > 0) codes.add(ReasonCode.fundingGap);
  if (result.bufferShortfall.minor > 0) codes.add(ReasonCode.bufferShortfall);
  if (result.flexibleShortfall.minor > 0) codes.add(ReasonCode.flexibleShortfall);

  for (final a in result.allocations) {
    if (a.priority == Priority.p1OverdueHard) codes.add(ReasonCode.overdueHardClaim);
    if (a.shortfall.minor > 0) {
      if (a.priority == Priority.p7HardGoal) codes.add(ReasonCode.goalAtRisk);
      if (a.priority == Priority.p3CardSpendReserve) {
        codes.add(ReasonCode.cardSpendFundingGap);
      }
    }
  }

  if (claims.any((c) => c.reservation?.state == ReservationState.paid)) {
    codes.add(ReasonCode.reservationConsumed);
  }
  if (ledger.quarantined.any((q) => q.reason == QuarantineReason.duplicate)) {
    codes.add(ReasonCode.duplicateHold);
  }
  if (result.extendedBeyondDecisionHorizon) {
    codes.add(ReasonCode.protectionHorizonExtended);
  }
  if (confidence != ConfidenceState.trusted) codes.add(ReasonCode.balanceStale);

  return codes.toList()..sort((a, b) => a.code.compareTo(b.code));
}

/// Allocation runs first; Safe-to-Spend is exactly the P9 residual (§13).
/// §15.3.2 — money the engine learned about only by reconciliation.
int _reconciledMinor(List<LedgerEvent> events) {
  var total = 0;
  for (final e in events) {
    if (e is BalanceAdjustmentEvent) total += e.delta.minor.abs();
  }
  return total;
}

/// §15.3.2 — money the engine was told about. A correction is not itself
/// movement; it marks another event, so it is not counted here or above.
int _recordedMinor(List<LedgerEvent> events) {
  var total = 0;
  for (final e in events) {
    total += switch (e) {
      ExpenseEvent(:final amount) => amount.minor.abs(),
      CardPurchaseEvent(:final amount) => amount.minor.abs(),
      CardSettlementEvent(:final amount) => amount.minor.abs(),
      IncomeConfirmedEvent(:final amount) => amount.minor.abs(),
      LoanDrawdownEvent(:final amount) => amount.minor.abs(),
      DebtPaymentEvent(:final amount) => amount.minor.abs(),
      TransferEvent(:final amount) => amount.minor.abs(),
      RefundEvent(:final amount) => amount.minor.abs(),
      _ => 0,
    };
  }
  return total;
}

PlanSnapshot computePlan(PlanInput input) {
  final currency = input.currency;
  final today = LocalDate.at(input.now, input.utcOffset);

  final ledger = reduceLedger(
    input.events,
    currency: currency,
    includedAccounts: input.includedAccounts,
    openingBalances: input.openingBalances,
  );
  final liquidity = ledger.trustedLiquidity(input.includedAccounts, currency);

  final income = input.incomeEvents
      .map((i) => i.resolvedAt(today, graceDays: input.incomeGraceDays))
      .toList();

  final claims = <Claim>[
    ...input.claims,
    ..._cardClaims(ledger, input.cards, currency),
  ];

  final nextIncome = income
      .where((i) => i.isProjectable && i.expectedDate > today)
      .map((i) => i.expectedDate)
      .fold<LocalDate?>(null, (a, b) => a == null || b < a ? b : a);

  final horizon = input.decisionHorizonEnd ?? nextIncome ?? today;

  final allocationInput = AllocationInput(
    currency: currency,
    liquidity: liquidity,
    claims: claims,
    today: today,
    decisionHorizonEnd: horizon,
    incomeEvents: income,
  );
  final result = allocate(allocationInput);

  final safeToSpendNow =
      (liquidity - result.allocatedBeforeDiscretionary).clampedAtZero;

  // The projected value re-runs the same waterfall over liquidity plus the
  // income explicitly identified for the horizon. It is never presented as
  // cash already available (§13, INV-04).
  final incomingThroughHorizon = Money.sum(
    income
        .where((i) => i.isProjectable && i.expectedDate <= horizon)
        .map((i) => i.projectedAmount ?? Money.zero(currency)),
    currency,
  );
  final projectedLiquidity = liquidity + incomingThroughHorizon;
  final projectedResult = allocate(allocationInput.withLiquidity(projectedLiquidity));
  final projectedSafeToSpend =
      (projectedLiquidity - projectedResult.allocatedBeforeDiscretionary).clampedAtZero;

  final confidence = evaluateConfidence(
    now: input.now,
    oldestConfirmationAt: input.oldestConfirmationAt,
    materialIntegrityIssue: input.materialIntegrityIssue,
    openReviewItems: ledger.quarantined
        .where((q) => q.reason == QuarantineReason.unlinkedRefund)
        .length,
  );

  return PlanSnapshot(
    engineVersion: engineVersion,
    computedAt: input.now,
    currency: currency,
    today: today,
    safeToSpendNow: safeToSpendNow,
    projectedSafeToSpend: projectedSafeToSpend,
    decisionHorizonEnd: horizon,
    protectionHorizonEnd: result.protectionHorizonEnd,
    protectedTotal: result.protectedTotal,
    mandatoryFundingGap: result.mandatoryFundingGap,
    bufferShortfall: result.bufferShortfall,
    flexibleShortfall: result.flexibleShortfall,
    confidenceState: confidence,
    reasonCodes: _reasonCodes(
      result: result,
      income: income,
      ledger: ledger,
      claims: claims,
      confidence: confidence,
    ),
    allocations: result.allocations,
    trustedAllocatableLiquidity: liquidity,
    ledger: ledger,
    oldestConfirmationAt: input.oldestConfirmationAt,
    ledgerCompleteness: evaluateLedgerCompleteness(
      now: input.now,
      lastConfirmationAt: input.oldestConfirmationAt,
      reconciledMinor: _reconciledMinor(input.events),
      recordedMinor: _recordedMinor(input.events),
    ),
    attributionConfidence: AttributionConfidence.none,
  );
}
