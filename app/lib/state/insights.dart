/// What is worth saying about the plan (Strategy §6.2, §12, §13, §22): the
/// one move that matters now, if any; the month ahead; and patterns in the
/// spending, only once there is enough record to support them.
///
/// Every rule here is deterministic and names its evidence. Nothing is said
/// when the evidence is thin: a suggestion the person has to discount costs
/// more than silence (§25). There is no scoring, no shaming, and no advice
/// to spend less without a measured reason.
library;

import '../domain/account.dart';
import '../domain/category.dart';
import '../domain/goal.dart';
import '../engine/clock.dart';
import '../engine/money.dart';
import 'app_state.dart';
import 'projection.dart';

/// The next thirty days in facts (§13, "what the next month needs").
class MonthAhead {
  const MonthAhead({
    required this.billCount,
    required this.billTotal,
    required this.nextPay,
    required this.tightest,
    required this.shortOn,
  });

  final int billCount;
  final Money billTotal;
  final LocalDate? nextPay;

  /// The day ahead with the least room, when it is less than today's.
  final TimelinePoint? tightest;

  /// The first day ahead something that must be paid would be short.
  final TimelinePoint? shortOn;
}

enum MoveKind { move, wait, save, spend }

/// One suggestion, with its reason (§6.2). The person decides.
class BestMove {
  const BestMove.move({
    required Money this.amount,
    required Account this.from,
    required String this.claimLabel,
    required String this.claimId,
  })  : kind = MoveKind.move,
        date = null,
        later = null,
        days = null,
        goal = null,
        waitForGap = false;

  const BestMove.waitForGap({
    required LocalDate this.date,
    required Money this.amount,
  })  : kind = MoveKind.wait,
        from = null,
        claimLabel = null,
        claimId = null,
        later = null,
        days = null,
        goal = null,
        waitForGap = true;

  const BestMove.waitForPay({
    required int this.days,
    required Money this.amount,
    required Money this.later,
  })  : kind = MoveKind.wait,
        from = null,
        claimLabel = null,
        claimId = null,
        date = null,
        goal = null,
        waitForGap = false;

  const BestMove.save({
    required Money this.amount,
    required Account this.from,
    required Goal this.goal,
    required int this.days,
  })  : kind = MoveKind.save,
        claimLabel = null,
        claimId = null,
        date = null,
        later = null,
        waitForGap = false;

  const BestMove.spend({
    required Money this.amount,
    required LocalDate this.date,
  })  : kind = MoveKind.spend,
        from = null,
        claimLabel = null,
        claimId = null,
        later = null,
        days = null,
        goal = null,
        waitForGap = false;

  final MoveKind kind;
  final Money? amount;

  /// For a move: the account the money sits in. For a save: the savings
  /// account it goes to.
  final Account? from;
  final String? claimLabel;
  final String? claimId;
  final LocalDate? date;
  final Money? later;
  final int? days;
  final Goal? goal;
  final bool waitForGap;

  /// Identifies the suggestion, so "not now" hides this one and not the
  /// next different one.
  String get key => '${kind.name}:${amount?.minor}:${date ?? days}';
}

/// A spending pattern with its consequence (§12: Behavior → Money → Time →
/// Life goal). Only a rise is reported, and only with enough record.
class Insight {
  const Insight({
    required this.category,
    required this.up,
    this.goal,
    this.goalDays,
  });

  final SpendCategory category;

  /// How much more than the thirty days before.
  final Money up;

  /// What that much, every month, would mean for a goal, if one is moving.
  final Goal? goal;
  final int? goalDays;
}

extension InsightsOf on AppState {
  MonthAhead get monthAhead {
    final t = timeline(daysBack: 0, daysAhead: 30);
    final todayFree = t.today.free;
    final tight = t.tightest;
    final upcoming = upcomingBills();
    final pay = nextIncome;
    return MonthAhead(
      billCount: upcoming.length,
      billTotal: billsDueWithin(),
      nextPay: pay != null && pay.isProjectable ? pay.expectedDate : null,
      tightest: tight != null &&
              todayFree != null &&
              tight.day != today &&
              tight.free! < todayFree
          ? tight
          : null,
      shortOn: t.firstGap,
    );
  }

  /// The one move worth making now, or null when none is (§6.2). In order:
  /// cover a shortfall with money that is sitting outside the plan; hold
  /// back when something ahead would come up short, or when pay is close;
  /// put spare room toward a goal; or say plainly that there is room.
  BestMove? get bestMove {
    if (!isOnboarded) return null;
    final s = snapshot;

    // MOVE: something that must be paid is short now, and money that could
    // cover it is in an account the plan does not count.
    if (s.mandatoryFundingGap.minor > 0) {
      final claim = s.topUnfundedClaim;
      final sources = accounts
          .where((a) => a.holdsMoney && !a.counted)
          .map((a) => (a, accountBalance(a.id)))
          .where((p) => p.$2.minor > 0)
          .toList()
        ..sort((a, b) => b.$2.compareTo(a.$2));
      if (claim != null && sources.isNotEmpty) {
        final (from, has) = sources.first;
        return BestMove.move(
          amount: Money.min(s.mandatoryFundingGap, has),
          from: from,
          claimLabel: claim.label,
          claimId: claim.claimId,
        );
      }
      // Short with nothing to move: Home's attention list says so already.
      return null;
    }

    final t = timeline(daysBack: 0, daysAhead: 45);

    // WAIT: something that must be paid would be short later on.
    final gap = t.firstGap;
    if (gap != null && gap.day != today) {
      return BestMove.waitForGap(date: gap.day, amount: gap.gap!);
    }

    // WAIT: pay is days away and makes a real difference to the room.
    final pay = nextIncome;
    final free = s.safeToSpendNow;
    if (pay != null && pay.isProjectable) {
      final days = pay.expectedDate.differenceInDays(today);
      final at = t.points
          .where((p) => p.day == pay.expectedDate)
          .firstOrNull
          ?.free;
      if (days > 0 &&
          days <= 7 &&
          at != null &&
          free.minor * 5 < at.minor) {
        return BestMove.waitForPay(days: days, amount: free, later: at);
      }
    }

    // The rest rests on knowing how this person spends: a month at least.
    if (daysInUse < 30) return null;
    final spent = Money.sum(
      spendingByCategory().map((r) => r.total),
      currency,
    );

    // SAVE: more room than a whole month of spending, a goal to put it
    // toward, and somewhere outside the plan to put it.
    final savings = savingsOutsidePlan;
    final open = goals
        .where((g) => g.kind != GoalKind.paused && !g.isComplete)
        .toList();
    if (savings != null && open.isNotEmpty && free > spent + spent) {
      // The goal furthest behind, or the nearest one.
      open.sort((a, b) {
        final pa = goalProjection(a).daysLate ?? 1 << 20;
        final pb = goalProjection(b).daysLate ?? 1 << 20;
        return pb.compareTo(pa);
      });
      final goal = open.first;
      final spare = free - spent - spent;
      var amount = Money(_round(spare.minor ~/ 2), currency);
      if (amount > goal.remaining) amount = goal.remaining;
      if (amount.minor > 0) {
        final pace = goalPace(goal);
        final days = pace.minor > 0
            ? (amount.minor * payCycleDays / pace.minor).round()
            : 0;
        return BestMove.save(
          amount: amount,
          from: savings,
          goal: goal,
          days: days,
        );
      }
    }

    // SPEND: covered, with room well beyond usual spending until pay, and
    // nothing ahead coming up short. Said, because it is true and useful.
    final until = s.decisionHorizonEnd;
    final toPay = until.differenceInDays(today).clamp(1, 60);
    final usual = spent.minor * toPay ~/ 30;
    final goalsOk = open.every((g) => goalProjection(g).onTrack);
    if (free.minor > 0 && goalsOk && free.minor >= usual * 3 ~/ 2) {
      return BestMove.spend(amount: free, date: until);
    }
    return null;
  }

  /// Categories rising on the month before, with what the rise would mean
  /// for a goal kept up for a month (§12). Needs two months of record, a
  /// real rise (a quarter or more) and several spends behind it.
  List<Insight> get insights {
    if (daysInUse < 60) return const [];
    final last = {
      for (final r in spendingByCategory())
        if (r.category != null) r.category!: r.total,
    };
    final before = {
      for (final r in spendingByCategory(before: 30))
        if (r.category != null) r.category!: r.total,
    };
    final counts = spendCountsByCategory();
    final goal = goals
        .where((g) => g.kind != GoalKind.paused && !g.isComplete)
        .where((g) => goalPace(g).minor > 0)
        .firstOrNull;
    final out = <Insight>[];
    for (final e in last.entries) {
      final was = before[e.key];
      if (was == null || was.minor <= 0) continue;
      final up = e.value - was;
      if (up.minor * 4 < was.minor) continue;
      if ((counts[e.key] ?? 0) < 4) continue;
      final pace = goal == null ? null : goalPace(goal);
      out.add(Insight(
        category: e.key,
        up: up,
        goal: goal,
        goalDays: pace == null
            ? null
            : (up.minor * payCycleDays / pace.minor).round(),
      ),);
    }
    out.sort((a, b) => b.up.compareTo(a.up));
    return out.take(2).toList();
  }
}

/// A suggested amount a person would say: two significant figures.
int _round(int minor) {
  if (minor < 100) return minor;
  var unit = 1;
  while (minor ~/ unit >= 100) {
    unit *= 10;
  }
  return minor ~/ unit * unit;
}
