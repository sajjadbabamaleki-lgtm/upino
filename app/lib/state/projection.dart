/// The financial timeline (Strategy §8): how much room there has been and
/// will be, day by day.
///
/// The past is fact: the balance as the record stood at the end of each day.
/// The future is a projection, and says so: the engine run forward on the
/// plan's own assumptions, which are printed wherever it is drawn —
///
/// * the pay arrives on its date and every pay period after, at the amount
///   the plan relies on (the lower end of a range);
/// * each bill is paid on its dates;
/// * what is set aside for living costs and undated commitments is spent
///   evenly across the pay period;
/// * goals and the buffer are kept, not spent;
/// * nothing else is spent.
///
/// Every projected figure comes out of `computePlan`, the same function
/// behind Home. Nothing here does its own money arithmetic beyond laying
/// out the assumed events.
library;

import '../domain/account.dart';
import '../domain/bill.dart';
import '../domain/goal.dart';
import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/ledger.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import 'app_state.dart';

class TimelinePoint {
  const TimelinePoint({
    required this.day,
    required this.balance,
    required this.projected,
    this.free,
    this.setAside,
    this.gap,
  });

  final LocalDate day;

  /// What the counted accounts hold, or are projected to hold.
  final Money balance;

  /// Safe-to-Spend on that day. Null in the past: what was safe to spend
  /// then depended on a plan that has since changed, so it is not shown as
  /// if it were a fact.
  final Money? free;
  final Money? setAside;

  /// What a must-pay commitment would be short, if anything.
  final Money? gap;
  final bool projected;
}

/// Something with a date on the timeline, marked under the line.
enum TimelineMarkKind { pay, bill }

class TimelineMark {
  const TimelineMark(this.day, this.kind, this.label, this.amount);
  final LocalDate day;
  final TimelineMarkKind kind;
  final String label;
  final Money amount;
}

class Timeline {
  const Timeline({
    required this.points,
    required this.todayIndex,
    required this.marks,
  });

  final List<TimelinePoint> points;
  final int todayIndex;
  final List<TimelineMark> marks;

  TimelinePoint get today => points[todayIndex];

  /// The lowest point of room ahead, which is the one worth knowing about.
  TimelinePoint? get tightest {
    TimelinePoint? low;
    for (final p in points.skip(todayIndex)) {
      final f = p.free;
      if (f == null) continue;
      if (low == null || f < low.free!) low = p;
    }
    return low;
  }

  /// The first day ahead on which something that must be paid is short.
  TimelinePoint? get firstGap {
    for (final p in points.skip(todayIndex)) {
      if ((p.gap?.minor ?? 0) > 0) return p;
    }
    return null;
  }
}

/// When a what-if purchase happens on the timeline.
enum PurchaseTiming { now, afterPay }

extension TimelineOf on AppState {
  /// The timeline from up to [daysBack] ago to [daysAhead] ahead. With
  /// [purchase], the projection includes that spend, [timing] saying when.
  Timeline timeline({
    int daysBack = 30,
    int daysAhead = 60,
    Money? purchase,
    PurchaseTiming timing = PurchaseTiming.now,
  }) {
    final today = this.today;
    final started = startedAt;
    var back = daysBack;
    if (started != null) {
      final inUse = today.differenceInDays(LocalDate.at(started, utcOffset));
      if (inUse < back) back = inUse < 0 ? 0 : inUse;
    } else {
      back = 0;
    }

    final points = <TimelinePoint>[];

    // The past, as the record stood at the end of each day.
    for (var i = back; i > 0; i--) {
      final day = today.addDays(-i);
      final snap = whatIf(at: _noon(day), recordedBy: _endOf(day));
      points.add(TimelinePoint(
        day: day,
        balance: snap.trustedAllocatableLiquidity,
        projected: false,
      ),);
    }

    // Today, as it is.
    final now = snapshot;
    points.add(TimelinePoint(
      day: today,
      balance: now.trustedAllocatableLiquidity,
      free: now.safeToSpendNow,
      setAside: now.protectedTotal,
      gap: now.mandatoryFundingGap,
      projected: false,
    ),);
    final todayIndex = points.length - 1;

    // The future, on the stated assumptions.
    final end = today.addDays(daysAhead);
    final pays = _paydays(daysAhead);
    final periods = _periods(pays, end);
    final living = _living(periods);
    final billPayments = _billPayments(end);
    final income = [
      for (final p in pays)
        (
          day: p.day,
          event: IncomeConfirmedEvent(
            id: 'timeline:pay:${p.day}',
            accountId: Account.mainId,
            amount: p.amount,
          ) as LedgerEvent,
        ),
    ];
    final marks = <TimelineMark>[
      for (final p in pays)
        TimelineMark(p.day, TimelineMarkKind.pay, '', p.amount),
      for (final b in billPayments)
        TimelineMark(b.due, TimelineMarkKind.bill, b.bill.name, b.bill.amount),
    ];
    final purchaseDay = purchase == null
        ? null
        : timing == PurchaseTiming.now || pays.isEmpty
            ? today
            : pays.first.day;
    ExpenseEvent purchaseEvent() => ExpenseEvent(
          id: 'timeline:purchase',
          accountId: Account.mainId,
          amount: purchase!,
        );

    for (var i = 1; i <= daysAhead; i++) {
      final day = today.addDays(i);
      final events = <LedgerEvent>[
        for (final e in income)
          if (e.day <= day) e.event,
        for (final b in billPayments)
          if (b.on <= day) b.event,
        for (final l in living.events)
          if (l.day <= day) l.event,
        if (purchaseDay != null && purchaseDay <= day) purchaseEvent(),
      ];
      final next = pays.where((p) => p.day > day).firstOrNull;
      final snap = whatIf(
        at: _noon(day),
        extraEvents: events,
        incomeEvents: [
          if (next != null)
            IncomeEvent(
              id: 'timeline:next',
              expectedAmount: next.amount,
              expectedDate: next.day,
              state: IncomeState.expected,
            ),
        ],
        // What is left of each living-cost claim for the rest of its
        // period, since the rest is assumed spent.
        ownClaims: living.claimsOn(day),
        // A bill the projection has paid is not owed again.
        bills: [
          for (final b in bills)
            () {
              var paidUpTo = b;
              for (final p in billPayments) {
                if (p.bill.id == b.id && p.on <= day) {
                  paidUpTo = paidUpTo.copyWith(nextDue: b.after(p.due));
                }
              }
              return paidUpTo;
            }(),
        ],
      );
      points.add(_point(day, snap));
    }

    // A purchase now changes today's point too.
    if (purchaseDay == today) {
      points[todayIndex] = _point(
        today,
        whatIf(extraEvents: [purchaseEvent()]),
        projected: false,
      );
    }

    marks.sort((a, b) => a.day.compareTo(b.day));
    return Timeline(points: points, todayIndex: todayIndex, marks: marks);
  }

  /// The counted balance as the record stood at the end of each day, from
  /// up to [days] ago (never before the plan began) to today, every [step]
  /// days and always ending today. The record, not a projection.
  List<({LocalDate day, Money balance})> balanceHistory({
    required int days,
    int step = 1,
  }) {
    final started = startedAt;
    var back = days;
    if (started == null) {
      back = 0;
    } else {
      final inUse = today.differenceInDays(LocalDate.at(started, utcOffset));
      if (inUse < back) back = inUse < 0 ? 0 : inUse;
    }
    final out = <({LocalDate day, Money balance})>[];
    for (var i = back; i > 0; i -= step) {
      final day = today.addDays(-i);
      out.add((
        day: day,
        balance: whatIf(at: _noon(day), recordedBy: _endOf(day))
            .trustedAllocatableLiquidity,
      ),);
    }
    out.add((day: today, balance: snapshot.trustedAllocatableLiquidity));
    return out;
  }

  TimelinePoint _point(LocalDate day, PlanSnapshot s, {bool projected = true}) =>
      TimelinePoint(
        day: day,
        balance: s.trustedAllocatableLiquidity,
        free: s.safeToSpendNow,
        setAside: s.protectedTotal,
        gap: s.mandatoryFundingGap,
        projected: projected,
      );

  /// Pay dates ahead: the expected one, then a pay period apart. A pay that
  /// is late is assumed tomorrow, never already in.
  List<({LocalDate day, Money amount})> _paydays(int daysAhead) {
    final income = nextIncome;
    if (income == null || !income.isProjectable) return const [];
    final amount = income.projectedAmount ?? income.expectedAmount;
    var day = income.expectedDate;
    if (day <= today) day = today.addDays(1);
    final end = today.addDays(daysAhead);
    return [
      for (; day <= end; day = day.addDays(payCycleDays))
        (day: day, amount: amount),
    ];
  }

  /// The pay periods ahead, as (start, end]: from today to the first pay,
  /// then pay to pay. With no pay expected, periods of the pay-period
  /// length stand in, so living costs are still spread out.
  List<({LocalDate start, LocalDate end})> _periods(
    List<({LocalDate day, Money amount})> pays,
    LocalDate until,
  ) {
    final out = <({LocalDate start, LocalDate end})>[];
    var s = today;
    for (final p in pays) {
      out.add((start: s, end: p.day));
      s = p.day;
    }
    while (s < until) {
      final e = s.addDays(payCycleDays);
      out.add((start: s, end: e));
      s = e;
    }
    return out;
  }

  /// Each bill payment falling due by [until], with the day it is assumed
  /// paid: on its date, or today for one already overdue.
  List<({Bill bill, LocalDate due, LocalDate on, LedgerEvent event})>
      _billPayments(LocalDate until) {
    final out =
        <({Bill bill, LocalDate due, LocalDate on, LedgerEvent event})>[];
    for (final b in bills) {
      final debt = b.debtAccountId == null ? null : account(b.debtAccountId!);
      for (final d in b.dueBetween(today, until)) {
        final id = 'timeline:bill:${b.id}:$d';
        out.add((
          bill: b,
          due: d,
          on: d < today ? today : d,
          event: switch (debt?.kind) {
            AccountKind.loan => DebtPaymentEvent(
                id: id,
                accountId: Account.mainId,
                debtId: debt!.id,
                amount: b.amount,
              ),
            AccountKind.card => CardSettlementEvent(
                id: id,
                accountId: Account.mainId,
                cardId: debt!.id,
                amount: b.amount,
              ),
            _ => ExpenseEvent(
                id: id,
                accountId: Account.mainId,
                amount: b.amount,
              ),
          },
        ),);
      }
    }
    return out;
  }

  /// Living costs and undated commitments, spent evenly over each period,
  /// and what is left of each claim on a given day. Shares are whole minor
  /// units with the rounding on a period's last day, so a period spends
  /// exactly its amount.
  _Living _living(List<({LocalDate start, LocalDate end})> periods) {
    final spentClaims = ownClaims
        .where(
          (c) =>
              c.dueDate == null &&
              (c.priority == Priority.p2HardObligation ||
                  c.priority == Priority.p4EssentialLiving),
        )
        .toList();
    final events = <({LocalDate day, LedgerEvent event})>[];
    // Claim id → day → what is still needed that day.
    final left = <String, Map<LocalDate, int>>{};
    for (final c in spentClaims) {
      final perClaim = left[c.id] = {};
      for (final p in periods) {
        final n = p.end.differenceInDays(p.start);
        if (n <= 0) continue;
        final share = c.amount.minor ~/ n;
        final rest = c.amount.minor - share * n;
        var remaining = c.amount.minor;
        perClaim[p.start] = remaining;
        for (var k = 1; k <= n; k++) {
          final day = p.start.addDays(k);
          final minor = share + (k == n ? rest : 0);
          remaining -= minor;
          if (minor > 0) {
            events.add((
              day: day,
              event: ExpenseEvent(
                id: 'timeline:living:${c.id}:$day',
                accountId: Account.mainId,
                amount: Money(minor, c.amount.currency),
              ),
            ),);
          }
          // On a pay day the next period's full amount is what is needed.
          if (k < n) perClaim[day] = remaining;
        }
      }
    }
    return _Living(events, spentClaims, left, ownClaims);
  }

  DateTime _noon(LocalDate d) =>
      DateTime.utc(d.year, d.month, d.day, 12).subtract(utcOffset);

  DateTime _endOf(LocalDate d) =>
      DateTime.utc(d.year, d.month, d.day, 23, 59, 59).subtract(utcOffset);
}

class _Living {
  const _Living(this.events, this.spent, this.left, this.all);

  final List<({LocalDate day, LedgerEvent event})> events;
  final List<Claim> spent;
  final Map<String, Map<LocalDate, int>> left;
  final List<Claim> all;

  /// The person's claims as they stand on [day]: living costs reduced to
  /// what the rest of their period still needs, everything else unchanged.
  List<Claim> claimsOn(LocalDate day) => [
        for (final c in all)
          if (left[c.id]?[day] case final minor?)
            Claim(
              id: c.id,
              priority: c.priority,
              label: c.label,
              amount: Money(minor, c.amount.currency),
              userPriority: c.userPriority,
            )
          else
            c,
      ];
}

/// Where a goal is heading (Strategy §10): at the pace the plan can
/// actually hold for it, when it is reached, against when it was meant to
/// be. A projection like the timeline, on one assumption only: that pace,
/// put aside once each pay period.
class GoalProjection {
  const GoalProjection({
    required this.goal,
    required this.pace,
    required this.days,
    required this.saved,
    required this.todayIndex,
    required this.finishes,
  });

  final Goal goal;

  /// What goes to it each pay period.
  final Money pace;

  /// Sample days, a week apart, and what is saved on each.
  final List<LocalDate> days;
  final List<Money> saved;
  final int todayIndex;

  /// The pay day it is reached on, or null if nothing is going to it.
  final LocalDate? finishes;

  /// Days after the target date it is reached; negative is early.
  int? get daysLate => finishes?.differenceInDays(goal.targetDate);

  bool get onTrack => finishes != null && daysLate! <= 0;
}

extension GoalProjectionOf on AppState {
  /// What the plan holds for [goal] this period: its allocation, which is
  /// less than it asks for when the money is short.
  Money goalPace(Goal goal) {
    final a = allocationFor('goal:${goal.id}');
    return a?.allocated ?? Money.zero(currency);
  }

  /// [pace] overrides what goes to it each period, for "what if I put
  /// aside this much instead?".
  GoalProjection goalProjection(Goal goal, {Money? pace}) {
    final per = pace ?? goalPace(goal);
    final cycle = payCycleDays;
    final income = nextIncome;
    var firstPay = income != null && income.isProjectable
        ? income.expectedDate
        : today.addDays(cycle);
    if (firstPay <= today) firstPay = today.addDays(1);

    // The pay day it is reached on: the first by which enough periods have
    // gone to it. What is protected this period counts at the first pay.
    LocalDate? finishes;
    final remaining = goal.remaining.minor;
    if (remaining <= 0) {
      finishes = today;
    } else if (per.minor > 0) {
      var periods = (remaining / per.minor).ceil();
      // A per-period amount rounded to the cent can leave a cent or two
      // over; that is not a whole period more.
      if (periods > 1 && remaining - (periods - 1) * per.minor <= periods) {
        periods--;
      }
      // This period's share is set aside now; the rest come with each pay.
      finishes =
          periods == 1 ? today : firstPay.addDays((periods - 2) * cycle);
    }

    // History: what was saved as of each week, from the contributions log.
    final log = contributions.where((c) => c.goalId == goal.id).toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    var from = today;
    if (log.isNotEmpty) {
      final first = LocalDate.at(log.first.at, utcOffset);
      if (first < from) from = first;
    }
    final weeksBack = (today.differenceInDays(from) / 7).ceil().clamp(0, 52);

    Money savedOn(LocalDate day) {
      if (day <= today) {
        var s = goal.saved.minor;
        for (final c in log) {
          if (LocalDate.at(c.at, utcOffset) > day) s -= c.amount.minor;
        }
        return Money(s < 0 ? 0 : s, currency);
      }
      if (per.minor <= 0) return goal.saved;
      // This period's share, set aside now, then one with each pay.
      var paid = 1;
      for (var p = firstPay; p <= day; p = p.addDays(cycle)) {
        paid++;
      }
      final s = goal.saved.minor + paid * per.minor;
      return Money(s > goal.target.minor ? goal.target.minor : s, currency);
    }

    // Far enough ahead to show both the target date and the finish, capped
    // so a goal that will take decades does not flatten the chart.
    var end = goal.targetDate;
    if (finishes != null && finishes > end) end = finishes;
    if (end < today.addDays(28)) end = today.addDays(28);
    final weeksAhead =
        ((end.differenceInDays(today) / 7).ceil() + 2).clamp(4, 156);

    final days = [
      for (var w = -weeksBack; w <= weeksAhead; w++) today.addDays(w * 7),
    ];
    return GoalProjection(
      goal: goal,
      pace: per,
      days: days,
      saved: [for (final d in days) savedOn(d)],
      todayIndex: weeksBack,
      finishes: finishes,
    );
  }
}
