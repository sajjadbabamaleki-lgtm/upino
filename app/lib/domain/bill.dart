/// Bills and subscriptions (Strategy §11.1): something that costs the same
/// amount again and again, on a date that can be named.
///
/// A bill is not a reminder. It becomes a claim on the money, so it changes
/// what is safe to spend before it is paid, not after.
library;

import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/money.dart';

enum BillEvery { week, month, quarter, year }

/// A subscription is a bill that can be cancelled. The difference is only
/// what it is called and what can be done about it; the money is the same.
enum BillKind { bill, subscription }

class Bill {
  const Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.every,
    required this.nextDue,
    this.kind = BillKind.bill,
    this.debtAccountId,
  });

  final String id;
  final String name;
  final Money amount;
  final BillEvery every;
  final LocalDate nextDue;
  final BillKind kind;

  /// The loan or card this payment goes to, when it is a repayment rather
  /// than a cost. Paying it then lowers what is owed instead of being
  /// recorded as spending.
  final String? debtAccountId;

  String get claimId => 'bill:$id';

  /// The date after [date], one period on. Months keep their day where the
  /// month has it and take the last day where it does not (31 Jan → 28 Feb).
  LocalDate after(LocalDate date) => switch (every) {
        BillEvery.week => date.addDays(7),
        BillEvery.month => _addMonths(date, 1),
        BillEvery.quarter => _addMonths(date, 3),
        BillEvery.year => _addMonths(date, 12),
      };

  /// Roughly how many days one period is, for spreading a long one out.
  int get periodDays => switch (every) {
        BillEvery.week => 7,
        BillEvery.month => 30,
        BillEvery.quarter => 91,
        BillEvery.year => 365,
      };

  /// Every date this bill falls due on from [from] through [until].
  Iterable<LocalDate> dueBetween(LocalDate from, LocalDate until) sync* {
    var d = nextDue;
    // A bill already overdue is still owed; it is not skipped.
    while (d <= until) {
      if (d >= from || d == nextDue) yield d;
      d = after(d);
    }
  }

  /// What this bill asks of the money now, as the waterfall's claim.
  ///
  /// Due by [horizon] (usually the next pay): every payment falling due by
  /// then is protected in full, as a hard obligation.
  ///
  /// A bill that comes round less often than the pay (quarterly, yearly) is
  /// built up over its period instead: by the horizon, the share of the
  /// amount its elapsed period has run through, as a sinking fund (§11 P5).
  /// Nothing is stored for this; the share follows from the dates, so paying
  /// the bill and moving its date resets it.
  ///
  /// A bill due after the horizon that comes round as often as the pay is
  /// left to the engine, which protects only what the income arriving before
  /// it cannot meet.
  Claim toClaim(LocalDate today, LocalDate horizon, int payCycleDays) {
    final due = dueBetween(today, horizon).toList();
    if (due.isNotEmpty) {
      return Claim(
        id: claimId,
        priority: Priority.p2HardObligation,
        label: name,
        amount: Money(amount.minor * due.length, amount.currency),
        dueDate: due.first,
      );
    }
    if (periodDays > payCycleDays) {
      final daysLeft = nextDue.differenceInDays(horizon);
      final elapsed = (periodDays - daysLeft).clamp(0, periodDays);
      return Claim(
        id: claimId,
        priority: Priority.p5SinkingCatchup,
        label: name,
        amount: Money(
          divideRoundHalfEven(amount.minor * elapsed, periodDays),
          amount.currency,
        ),
      );
    }
    return Claim(
      id: claimId,
      priority: Priority.p2HardObligation,
      label: name,
      amount: amount,
      dueDate: nextDue,
    );
  }

  Bill copyWith({
    String? name,
    Money? amount,
    BillEvery? every,
    LocalDate? nextDue,
    BillKind? kind,
  }) =>
      Bill(
        id: id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        every: every ?? this.every,
        nextDue: nextDue ?? this.nextDue,
        kind: kind ?? this.kind,
        debtAccountId: debtAccountId,
      );
}

LocalDate _addMonths(LocalDate date, int months) {
  final total = date.month - 1 + months;
  final year = date.year + total ~/ 12;
  final month = total % 12 + 1;
  final last = DateTime.utc(year, month + 1, 0).day;
  return LocalDate(year, month, date.day > last ? last : date.day);
}
