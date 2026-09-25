/// Goals (§10) and their funding schedule (§8).
///
/// A goal is not a single protected amount. It is a target, a date and what
/// has been put aside so far; what the engine protects each period is the
/// contribution needed to still reach the target on time.
library;

import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/money.dart';

/// §10. Hard targets are never moved for the user; flexible ones yield before
/// a hard commitment; paused ones stay visible and claim nothing.
enum GoalKind { hard, flexible, paused }

class Goal {
  const Goal({
    required this.id,
    required this.name,
    required this.target,
    required this.targetDate,
    required this.saved,
    required this.kind,
    this.icon,
  });

  final String id;
  final String name;
  final Money target;
  final LocalDate targetDate;
  final Money saved;
  final GoalKind kind;

  /// The icon the person chose for it, a key into the icon set.
  final String? icon;

  Money get remaining => (target - saved).clampedAtZero;
  bool get isComplete => remaining.isZero;

  /// Fraction funded, clamped so a goal that overshot still reads as full.
  double get progress {
    if (target.minor <= 0) return 1;
    return (saved.minor / target.minor).clamp(0.0, 1.0);
  }

  Goal copyWith({
    String? name,
    Money? target,
    LocalDate? targetDate,
    Money? saved,
    GoalKind? kind,
    String? icon,
  }) =>
      Goal(
        id: id,
        name: name ?? this.name,
        target: target ?? this.target,
        targetDate: targetDate ?? this.targetDate,
        saved: saved ?? this.saved,
        kind: kind ?? this.kind,
        icon: icon ?? this.icon,
      );

  /// Pay periods left before the target date, never fewer than one: a goal
  /// due today still needs its whole remainder now rather than dividing by
  /// zero or quietly slipping.
  int cyclesRemaining(LocalDate today, int payCycleDays) {
    final days = targetDate.differenceInDays(today);
    if (days <= 0) return 1;
    final cycles = (days / payCycleDays).ceil();
    return cycles < 1 ? 1 : cycles;
  }

  /// What this period must hold back to keep the target reachable (§8).
  /// A paused or completed goal asks for nothing.
  Money requiredThisCycle(LocalDate today, int payCycleDays) {
    if (kind == GoalKind.paused || isComplete) {
      return Money.zero(target.currency);
    }
    return requiredContribution(remaining, cyclesRemaining(today, payCycleDays));
  }

  /// Hard goals sit at P7 and count toward the mandatory gap; flexible ones
  /// sit at P8 and yield first (§11, §13).
  Priority? get priority => switch (kind) {
        GoalKind.hard => Priority.p7HardGoal,
        GoalKind.flexible => Priority.p8Flexible,
        GoalKind.paused => null,
      };

  /// The claim this goal contributes to the waterfall, if any.
  ///
  /// The claim carries no due date. What it holds back is *this period's*
  /// instalment, which is due now; the target date is the deadline for the
  /// whole goal. Dating the claim at the target instead made the engine
  /// correctly conclude that income arriving before then would cover it, so
  /// it protected nothing and the goal silently never funded.
  ///
  /// Goals with a nearer target fund first within their class, expressed as
  /// an explicit user priority rather than by borrowing the due date.
  Claim? toClaim(LocalDate today, int payCycleDays) {
    final p = priority;
    if (p == null) return null;
    final amount = requiredThisCycle(today, payCycleDays);
    if (amount.isZero) return null;
    return Claim(
      id: 'goal:$id',
      priority: p,
      label: name,
      amount: amount,
      userPriority: targetDate.differenceInDays(today),
    );
  }
}

/// Money put toward a goal, and when. Kept so a month can say how much went
/// to goals, which the goal's running total alone cannot.
class GoalContribution {
  const GoalContribution({
    required this.goalId,
    required this.amount,
    required this.at,
  });

  final String goalId;
  final Money amount;
  final DateTime at;
}
