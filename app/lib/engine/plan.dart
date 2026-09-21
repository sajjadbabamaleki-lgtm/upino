/// Safe-to-Spend contract, confidence policy and the immutable PlanSnapshot
/// (§13, §13.1, §15.2).
library;

import 'allocate.dart';
import 'clock.dart';
import 'domain.dart';
import 'ledger.dart';
import 'money.dart';

const engineVersion = '0.1.0';
const specVersion = 'Upino Product Foundation v3.5 (Frozen G0)';

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
  });

  final String engineVersion;
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
  );
}
