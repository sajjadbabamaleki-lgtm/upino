/// The deterministic allocation waterfall (§11) and Safe-to-Spend (§13).
library;

import 'clock.dart';
import 'domain.dart';
import 'money.dart';

class Allocation {
  const Allocation({
    required this.claimId,
    required this.priority,
    required this.label,
    required this.requiredNow,
    required this.allocated,
  });

  final String claimId;
  final Priority priority;
  final String label;

  /// What the claim needed from current liquidity in this snapshot.
  final Money requiredNow;
  final Money allocated;

  Money get shortfall => requiredNow - allocated;
}

class AllocationInput {
  const AllocationInput({
    required this.currency,
    required this.liquidity,
    required this.claims,
    required this.today,
    required this.decisionHorizonEnd,
    this.incomeEvents = const [],
  });

  final String currency;
  final Money liquidity;
  final List<Claim> claims;
  final LocalDate today;
  final LocalDate decisionHorizonEnd;
  final List<IncomeEvent> incomeEvents;

  AllocationInput withLiquidity(Money value) => AllocationInput(
        currency: currency,
        liquidity: value,
        claims: claims,
        today: today,
        decisionHorizonEnd: decisionHorizonEnd,
        incomeEvents: incomeEvents,
      );
}

class AllocationResult {
  const AllocationResult({
    required this.allocations,
    required this.allocatedBeforeDiscretionary,
    required this.mandatoryFundingGap,
    required this.bufferShortfall,
    required this.flexibleShortfall,
    required this.protectionHorizonEnd,
    required this.extendedBeyondDecisionHorizon,
  });

  final List<Allocation> allocations;
  final Money allocatedBeforeDiscretionary;
  final Money mandatoryFundingGap;
  final Money bufferShortfall;
  final Money flexibleShortfall;
  final LocalDate protectionHorizonEnd;
  final bool extendedBeyondDecisionHorizon;

  Money get protectedTotal => allocatedBeforeDiscretionary;
}

class _Prepared {
  const _Prepared(this.claim, this.requiredNow, this.beyondHorizon);
  final Claim claim;
  final Money requiredNow;
  final bool beyondHorizon;
}

/// How much of a claim current liquidity must protect right now.
///
/// A claim due inside the decision horizon needs its whole remaining amount.
/// One falling after it stretches the protection horizon to cover only the
/// part expected income cannot meet (§4, INV-15, fixture T11) — the engine
/// looks past payday rather than letting money a hard claim already needs be
/// spent today.
_Prepared _prepare(Claim claim, AllocationInput input) {
  final full = claim.required;
  final due = claim.dueDate;

  if (due == null || due <= input.decisionHorizonEnd || full.isZero) {
    return _Prepared(claim, full, false);
  }

  final incomingBeforeDue = Money.sum(
    input.incomeEvents
        .where((i) =>
            i.isProjectable && i.expectedDate > input.today && i.expectedDate <= due,)
        .map((i) => i.projectedAmount ?? Money.zero(input.currency)),
    input.currency,
  );

  return _Prepared(claim, (full - incomingBeforeDue).clampedAtZero, true);
}

/// Overdue hard claims are elevated out of their class into P1 (§11).
Priority _effectivePriority(Claim claim, LocalDate today) {
  final due = claim.dueDate;
  final isHard = claim.priority == Priority.p2HardObligation ||
      claim.priority == Priority.p3CardSpendReserve;
  if (isHard && due != null && isOverdue(due, today)) return Priority.p1OverdueHard;
  return claim.priority;
}

/// Given identical inputs and engine version this returns identical
/// allocations and ordering (INV-07).
AllocationResult allocate(AllocationInput input) {
  final currency = input.currency;

  final prepared = input.claims.map((c) {
    final p = _prepare(c, input);
    return _Prepared(
      c.copyWith(priority: _effectivePriority(c, input.today)),
      p.requiredNow,
      p.beyondHorizon,
    );
  }).toList()
    ..sort((a, b) => Claim.compare(a.claim, b.claim));

  var remaining = input.liquidity;
  final allocations = <Allocation>[];
  var protectionHorizonEnd = input.decisionHorizonEnd;
  var extended = false;

  for (final p in prepared) {
    final allocated = Money.min(p.requiredNow, remaining.clampedAtZero);
    remaining = remaining - allocated;

    allocations.add(Allocation(
      claimId: p.claim.id,
      priority: p.claim.priority,
      label: p.claim.label,
      requiredNow: p.requiredNow,
      allocated: allocated,
    ),);

    final due = p.claim.dueDate;
    if (p.beyondHorizon && !p.requiredNow.isZero && due != null) {
      extended = true;
      if (due > protectionHorizonEnd) protectionHorizonEnd = due;
    }
  }

  Money shortfallWhere(bool Function(Allocation) test) => Money.sum(
        allocations.where(test).map((a) => a.shortfall),
        currency,
      );

  return AllocationResult(
    allocations: allocations,
    allocatedBeforeDiscretionary: Money.sum(
      allocations
          .where((a) => a.priority != Priority.p9Discretionary)
          .map((a) => a.allocated),
      currency,
    ),
    // Summed per claim rather than by subtracting one mandatory total from
    // total liquidity, because P6 sits above P7: a funded buffer can absorb
    // liquidity a hard goal then cannot reach, and a single subtraction would
    // report no gap while a hard commitment is underfunded (§13, T36).
    mandatoryFundingGap: shortfallWhere((a) => a.priority.isMandatory),
    bufferShortfall: shortfallWhere((a) => a.priority == Priority.p6Buffer),
    flexibleShortfall: shortfallWhere((a) => a.priority == Priority.p8Flexible),
    protectionHorizonEnd: protectionHorizonEnd,
    extendedBeyondDecisionHorizon: extended,
  );
}
