/// Priority waterfall, claims, reservations, income lifecycle and reason
/// codes (§7, §9–§12, §14).
library;

import 'clock.dart';
import 'money.dart';

/// The deterministic allocation waterfall (§11). Lower ordinal is funded
/// first; P9 is the discretionary residual that becomes Safe-to-Spend.
enum Priority {
  p0IntegrityHold('P0 Integrity hold'),
  p1OverdueHard('P1 Overdue hard obligation'),
  p2HardObligation('P2 Hard obligation before horizon'),
  p3CardSpendReserve('P3 Credit Card Spend Reserve'),
  p4EssentialLiving('P4 Essential variable living'),
  p5SinkingCatchup('P5 Required sinking-fund catch-up'),
  p6Buffer('P6 Protected minimum buffer'),
  p7HardGoal('P7 Hard goal'),
  p8Flexible('P8 Flexible goal / optional debt acceleration'),
  p9Discretionary('P9 Discretionary');

  const Priority(this.label);
  final String label;

  /// Classes whose shortfall counts toward mandatory_funding_gap (§13).
  /// P6 buffer and P8 flexible are user policy, not commitments.
  bool get isMandatory => switch (this) {
        p0IntegrityHold ||
        p1OverdueHard ||
        p2HardObligation ||
        p3CardSpendReserve ||
        p4EssentialLiving ||
        p5SinkingCatchup ||
        p7HardGoal =>
          true,
        p6Buffer || p8Flexible || p9Discretionary => false,
      };
}

/// Machine-readable explanations attached to engine output (§14).
enum ReasonCode {
  incomeConfirmed('INCOME_CONFIRMED'),
  incomeLate('INCOME_LATE'),
  reservationConsumed('RESERVATION_CONSUMED'),
  goalAtRisk('GOAL_AT_RISK'),
  fundingGap('FUNDING_GAP'),
  duplicateHold('DUPLICATE_HOLD'),
  balanceStale('BALANCE_STALE'),
  overdueHardClaim('OVERDUE_HARD_CLAIM'),
  cardSpendFundingGap('CARD_SPEND_FUNDING_GAP'),
  protectionHorizonExtended('PROTECTION_HORIZON_EXTENDED'),
  bufferShortfall('BUFFER_SHORTFALL'),
  flexibleShortfall('FLEXIBLE_SHORTFALL');

  const ReasonCode(this.code);
  final String code;
}

/// Reservation lifecycle (§12).
enum ReservationState {
  planned,
  reserved,
  committed,
  paid,
  released,
  overdue,
  review,
  cancelled;

  static const _allowed = <ReservationState, List<ReservationState>>{
    ReservationState.planned: [ReservationState.reserved, ReservationState.cancelled],
    ReservationState.reserved: [
      ReservationState.committed,
      ReservationState.released,
      ReservationState.overdue,
    ],
    ReservationState.committed: [
      ReservationState.paid,
      ReservationState.reserved,
      ReservationState.review,
    ],
    ReservationState.paid: [],
    ReservationState.released: [],
    ReservationState.overdue: [
      ReservationState.reserved,
      ReservationState.committed,
      ReservationState.paid,
      ReservationState.cancelled,
    ],
    ReservationState.review: ReservationState.values,
    ReservationState.cancelled: [],
  };

  bool canTransitionTo(ReservationState next) => _allowed[this]!.contains(next);
}

/// Purpose assigned to money — never a second copy of it (§12, INV-01).
class Reservation {
  Reservation(this.amount, {Money? consumed, this.state = ReservationState.reserved})
      : consumed = consumed ?? Money.zero(amount.currency);

  final Money amount;
  final Money consumed;
  final ReservationState state;

  /// Amount still protected. A consumed reservation protects nothing further.
  Money get remaining => switch (state) {
        ReservationState.released ||
        ReservationState.cancelled ||
        ReservationState.paid =>
          Money.zero(amount.currency),
        _ => amount - consumed,
      };

  /// Partial payments consume proportionally; the remainder stays reserved.
  Reservation settle(Money payment) {
    final left = amount - consumed;
    if (payment > left) {
      throw StateError(
        'Payment exceeds the reservation; overpayment is allocated by event '
        'type, never silently attached to another claim (§12)',
      );
    }
    final nowConsumed = consumed + payment;
    final fullySettled = nowConsumed.minor == amount.minor;
    return Reservation(
      amount,
      consumed: nowConsumed,
      state: fullySettled ? ReservationState.paid : state,
    );
  }

  Reservation release() {
    if (!state.canTransitionTo(ReservationState.released)) {
      throw StateError('Illegal reservation transition $state → released (§12)');
    }
    return Reservation(amount, consumed: consumed, state: ReservationState.released);
  }
}

/// A claim on liquidity. Obligations, the card reserve, essentials, catch-up,
/// the buffer and goals all take this shape so the waterfall walks one type.
class Claim {
  const Claim({
    required this.id,
    required this.priority,
    required this.label,
    required this.amount,
    this.dueDate,
    this.userPriority,
    this.reservation,
  });

  final String id;
  final Priority priority;
  final String label;
  final Money amount;
  final LocalDate? dueDate;
  final int? userPriority;
  final Reservation? reservation;

  /// What the claim still needs; a settled reservation needs nothing (INV-02).
  Money get required => reservation?.remaining ?? amount;

  Claim copyWith({Priority? priority, Reservation? reservation}) => Claim(
        id: id,
        priority: priority ?? this.priority,
        label: label,
        amount: amount,
        dueDate: dueDate,
        userPriority: userPriority,
        reservation: reservation ?? this.reservation,
      );

  /// Priority class, then earliest due date, then explicit user priority,
  /// then stable id purely as a tie-breaker with no product meaning (§11).
  static int compare(Claim a, Claim b) {
    if (a.priority != b.priority) return a.priority.index - b.priority.index;
    final ad = a.dueDate;
    final bd = b.dueDate;
    if (ad != bd) {
      if (ad == null) return 1;
      if (bd == null) return -1;
      final byDate = ad.compareTo(bd);
      if (byDate != 0) return byDate;
    }
    final ap = a.userPriority ?? 1 << 30;
    final bp = b.userPriority ?? 1 << 30;
    if (ap != bp) return ap - bp;
    return a.id.compareTo(b.id);
  }
}

/// Income lifecycle (§7). Expected salary is a forecast until confirmed,
/// which is what stops Upino showing money that has not arrived (INV-04).
enum IncomeState { expected, confirmed, late, missed, adjusted, cancelled }

class IncomeEvent {
  IncomeEvent({
    required this.id,
    required this.expectedAmount,
    required this.expectedDate,
    required this.state,
    this.confirmedAmount,
    this.expectedUpperAmount,
  }) : assert(
          expectedUpperAmount == null ||
              expectedUpperAmount.minor >= expectedAmount.minor,
          'the upper end of an income range cannot be below the lower end',
        );

  final String id;

  /// The amount the plan relies on. For an income given as a range this is
  /// its lower end, never its midpoint: a plan built on an average breaks in
  /// every month that comes in below average, and not breaking is the whole
  /// claim this product makes.
  final Money expectedAmount;
  final LocalDate expectedDate;
  final IncomeState state;
  final Money? confirmedAmount;

  /// The upper end of a range, or null for a fixed income. It is shown so the
  /// user can see the spread they entered, and it enters no calculation —
  /// INV-20 pins that.
  final Money? expectedUpperAmount;

  bool get isRange =>
      expectedUpperAmount != null &&
      expectedUpperAmount!.minor > expectedAmount.minor;

  bool get isProjectable =>
      state == IncomeState.expected || state == IncomeState.adjusted;

  Money? get projectedAmount => isProjectable ? (confirmedAmount ?? expectedAmount) : null;

  /// An expected payment whose date has passed, grace spent, is LATE — it is
  /// never quietly treated as received.
  IncomeEvent resolvedAt(LocalDate today, {int graceDays = 0}) {
    if (state != IncomeState.expected) return this;
    final due = expectedDate.addDays(graceDays);
    if (today > due) {
      return IncomeEvent(
        id: id,
        expectedAmount: expectedAmount,
        expectedDate: expectedDate,
        state: IncomeState.late,
        confirmedAmount: confirmedAmount,
        expectedUpperAmount: expectedUpperAmount,
      );
    }
    return this;
  }
}
