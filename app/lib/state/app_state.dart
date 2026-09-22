/// Application state. The UI never computes money: it collects domain
/// commands, hands them to the engine and renders the snapshot (§22, §17).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/plan_document.dart';
import '../domain/goal.dart';
import '../data/plan_store.dart';
import '../engine/allocate.dart';
import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/ledger.dart';
import '../engine/money.dart';
import '../engine/plan.dart';

/// What onboarding collects, in the order §18 defines.
class OnboardingDraft {
  OnboardingDraft();

  String currency = 'EUR';
  Money? currentBalance;
  Money? incomeAmount;
  LocalDate? nextIncomeDate;
  Money? rent;
  Money? essentials;
  Money? cardMinimum;
  Money? goalAmount;
  int? payCycleDays;

  bool get isComplete => currentBalance != null && incomeAmount != null;
}

/// Which theme the app follows. Stored with the plan so it survives a
/// reinstall on the same device, and defaults to whatever the phone is set
/// to rather than imposing a choice.
enum ThemeChoice { system, light, dark }

/// One row of the Activity screen.
class ActivityEntry {
  const ActivityEntry({
    required this.eventId,
    required this.label,
    required this.amount,
    required this.increasesMoney,
    required this.removed,
  });

  final String eventId;
  final String label;
  final Money amount;
  final bool increasesMoney;

  /// Still listed, but no longer counted. Removed entries stay visible
  /// because this product does not erase what it once told you.
  final bool removed;
}

class AppState extends ChangeNotifier {
  AppState({DateTime? now, Duration? utcOffset, PlanStore? store})
      : _now = now ?? DateTime.now().toUtc(),
        _utcOffset = utcOffset ?? DateTime.now().timeZoneOffset,
        _store = store,
        // With no storage there is nothing to wait for, so the UI should not
        // sit on the restoring screen.
        _restored = store == null;

  static const _accountId = 'main';

  final DateTime _now;
  final Duration _utcOffset;
  final PlanStore? _store;

  final List<LedgerEvent> _events = [];
  final List<Claim> _claims = [];
  final List<IncomeEvent> _incomeEvents = [];
  final List<Goal> _goals = [];

  String _currency = 'EUR';
  ThemeChoice _themeChoice = ThemeChoice.system;
  int _payCycleDays = 30;
  int _goalSeq = 0;
  Money? _openingBalance;
  DateTime? _lastBalanceConfirmation;
  bool _onboarded = false;
  int _eventSeq = 0;

  /// The most recent expense, so Home can show a transient confirmation
  /// badge without the accent ever becoming a persistent state (§32.7).
  Money? lastRecordedExpense;

  bool get isOnboarded => _onboarded;
  ThemeChoice get themeChoice => _themeChoice;

  void setThemeChoice(ThemeChoice choice) {
    if (choice == _themeChoice) return;
    _themeChoice = choice;
    _persist();
    notifyListeners();
  }

  /// True once [restore] has run. The UI waits for it rather than showing an
  /// empty plan for a frame and then replacing it.
  bool get isRestored => _restored;
  bool _restored;

  /// Set when a stored document could not be read. The plan is left empty
  /// rather than partially applied, and the file is kept for inspection.
  String? get restoreFailure => _restoreFailure;
  String? _restoreFailure;

  /// Replay a stored plan. The engine recomputes everything from the log, so
  /// nothing derived is trusted from disk (INV-07).
  Future<void> restore() async {
    final store = _store;
    if (store == null) {
      _restored = true;
      notifyListeners();
      return;
    }
    try {
      final document = await store.load();
      if (document != null) _apply(document);
    } on Object catch (error) {
      _restoreFailure = error.toString();
    }
    _restored = true;
    notifyListeners();
  }

  void _apply(PlanDocument document) {
    _currency = document.currency;
    _openingBalance = document.openingBalance;
    _lastBalanceConfirmation = document.lastBalanceConfirmationAt;
    _onboarded = document.onboarded;
    _eventSeq = document.eventSequence;
    _themeChoice = document.themeChoice;
    _payCycleDays = document.payCycleDays;
    _goals
      ..clear()
      ..addAll(document.goals);
    _goalSeq = _goals.length;

    _events
      ..clear()
      ..addAll(document.events);
    _claims
      ..clear()
      ..addAll(document.claims);

    // A plan saved before goals existed carried one flat "goal" claim with no
    // target or date. Turn it into a real goal rather than leaving it behind.
    // This has to run after the claims are loaded, not before them.
    final legacy = _claims.indexWhere((c) => c.id == 'goal');
    if (legacy >= 0) {
      final claim = _claims.removeAt(legacy);
      _goals.add(Goal(
        id: 'g${++_goalSeq}',
        name: claim.label,
        target: claim.amount,
        targetDate: today.addDays(_payCycleDays),
        saved: Money.zero(_currency),
        kind: GoalKind.hard,
      ),);
    }
    _incomeEvents
      ..clear()
      ..addAll(document.incomeEvents);
  }

  PlanDocument toDocument() => PlanDocument(
        currency: _currency,
        openingBalance: _openingBalance ?? Money.zero(_currency),
        events: List.unmodifiable(_events),
        claims: List.unmodifiable(_claims),
        incomeEvents: List.unmodifiable(_incomeEvents),
        onboarded: _onboarded,
        lastBalanceConfirmationAt: _lastBalanceConfirmation,
        eventSequence: _eventSeq,
        themeChoice: _themeChoice,
        goals: List.unmodifiable(_goals),
        payCycleDays: _payCycleDays,
      );

  /// Every mutation persists. Saving is fire-and-forget so recording a spend
  /// stays within the §18 three-second target; the in-memory state is already
  /// correct when the UI rebuilds.
  void _persist() {
    unawaited(_store?.save(toDocument()));
  }
  String get currency => _currency;
  LocalDate get today => LocalDate.at(_now, _utcOffset);
  List<Claim> get claims => List.unmodifiable(_claims);

  /// Recomputed from scratch on every read; the engine is pure, so there is
  /// no derived state to keep in sync (§13, INV-07).
  PlanSnapshot get snapshot => computePlan(PlanInput(
        currency: _currency,
        now: _now,
        utcOffset: _utcOffset,
        includedAccounts: const [_accountId],
        openingBalances: {
          _accountId: _openingBalance ?? Money.zero(_currency),
        },
        events: _events,
        claims: [..._claims, ..._goalClaims],
        incomeEvents: _incomeEvents,
        oldestConfirmationAt: _lastBalanceConfirmation,
      ),);

  /// Each goal contributes this period's required contribution, so the
  /// waterfall protects the schedule rather than the whole target (§8).
  List<Claim> get _goalClaims => [
        for (final goal in _goals)
          if (goal.toClaim(today, _payCycleDays) case final claim?) claim,
      ];

  List<Goal> get goals => List.unmodifiable(_goals);
  int get payCycleDays => _payCycleDays;

  void addGoal({
    required String name,
    required Money target,
    required LocalDate targetDate,
    GoalKind kind = GoalKind.hard,
    Money? saved,
  }) {
    _goals.add(Goal(
      id: 'g${++_goalSeq}',
      name: name,
      target: target,
      targetDate: targetDate,
      saved: saved ?? Money.zero(_currency),
      kind: kind,
    ),);
    _persist();
    notifyListeners();
  }

  void updateGoal(
    String id, {
    String? name,
    Money? target,
    LocalDate? targetDate,
    GoalKind? kind,
  }) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index < 0) return;
    _goals[index] = _goals[index].copyWith(
      name: name,
      target: target,
      targetDate: targetDate,
      kind: kind,
    );
    _persist();
    notifyListeners();
  }

  /// Record progress toward a goal. The money is already counted in
  /// liquidity; what changes is how much still has to be held back each
  /// period, so a contribution lowers future claims rather than spending
  /// anything now.
  void contributeToGoal(String id, Money amount) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index < 0 || amount.minor <= 0) return;
    final goal = _goals[index];
    _goals[index] = goal.copyWith(saved: goal.saved + amount);
    _persist();
    notifyListeners();
  }

  void removeGoal(String id) {
    _goals.removeWhere((g) => g.id == id);
    _persist();
    notifyListeners();
  }

  void completeOnboarding(OnboardingDraft draft) {
    _currency = draft.currency;
    _payCycleDays = draft.payCycleDays ?? 30;
    _openingBalance = draft.currentBalance ?? Money.zero(_currency);
    _lastBalanceConfirmation = _now;

    _claims
      ..clear()
      ..addAll([
        if (draft.rent != null && draft.rent!.minor > 0)
          Claim(
            id: 'rent',
            priority: Priority.p2HardObligation,
            label: 'Rent and bills',
            amount: draft.rent!,
          ),
        if (draft.cardMinimum != null && draft.cardMinimum!.minor > 0)
          Claim(
            id: 'card-minimum',
            priority: Priority.p2HardObligation,
            label: 'Card minimum due',
            amount: draft.cardMinimum!,
          ),
        if (draft.essentials != null && draft.essentials!.minor > 0)
          Claim(
            id: 'essentials',
            priority: Priority.p4EssentialLiving,
            label: 'Food and transport',
            amount: draft.essentials!,
          ),
      ]);

    _goals.clear();
    _goalSeq = 0;
    final goalAmount = draft.goalAmount;
    if (goalAmount != null && goalAmount.minor > 0) {
      // Onboarding asks what to put aside this period, not a target, so the
      // first goal is that amount over the coming year — a starting point the
      // Goals screen can correct.
      addGoal(
        name: 'Savings goal',
        target: Money(goalAmount.minor * 12, _currency),
        targetDate: today.addDays(_payCycleDays * 12),
      );
    }

    _incomeEvents.clear();
    final incomeAmount = draft.incomeAmount;
    final incomeDate = draft.nextIncomeDate;
    if (incomeAmount != null && incomeDate != null) {
      _incomeEvents.add(IncomeEvent(
        id: 'income-next',
        expectedAmount: incomeAmount,
        expectedDate: incomeDate,
        state: IncomeState.expected,
      ),);
    }

    _onboarded = true;
    _persist();
    notifyListeners();
  }

  /// RecordExpense (§22). The UI issues the command; the engine decides what
  /// it means for Safe-to-Spend.
  void recordExpense(Money amount) {
    _events.add(ExpenseEvent(
      id: 'e${++_eventSeq}',
      accountId: _accountId,
      amount: amount,
    ),);
    lastRecordedExpense = amount;
    _persist();
    notifyListeners();
  }

  /// ConfirmBalance (§22, §15.1). A difference from the modelled balance is
  /// recorded as an auditable adjustment, never as spending.
  void confirmBalance(Money observed) {
    final modelled = snapshot.trustedAllocatableLiquidity;
    final delta = observed - modelled;
    if (!delta.isZero) {
      _events.add(BalanceAdjustmentEvent(
        id: 'e${++_eventSeq}',
        accountId: _accountId,
        delta: delta,
        reason: 'User confirmed observed balance',
      ),);
    }
    _lastBalanceConfirmation = _now;
    _persist();
    notifyListeners();
  }

  void clearExpenseConfirmation() {
    lastRecordedExpense = null;
    notifyListeners();
  }

  /// The commitments a person can edit, in the order the waterfall funds
  /// them, so the list reads the way the money is actually assigned (§11).
  List<Claim> get editableClaims {
    final sorted = [..._claims]..sort(Claim.compare);
    return List.unmodifiable(sorted);
  }

  IncomeEvent? get nextIncome =>
      _incomeEvents.isEmpty ? null : _incomeEvents.first;

  Money get openingBalance => _openingBalance ?? Money.zero(_currency);

  /// Amounts a person can add. Debt and sinking funds are modelled but have
  /// no editor yet, so they are not offered.
  static const addableClaims = <({String id, Priority priority, String label})>[
    (id: 'rent', priority: Priority.p2HardObligation, label: 'Rent and bills'),
    (
      id: 'card-minimum',
      priority: Priority.p2HardObligation,
      label: 'Card minimum due'
    ),
    (
      id: 'essentials',
      priority: Priority.p4EssentialLiving,
      label: 'Food and transport'
    ),
    (id: 'buffer', priority: Priority.p6Buffer, label: 'Emergency buffer'),
  ];

  /// Create or change a commitment. A zero amount removes it rather than
  /// leaving a claim that protects nothing.
  void setClaimAmount(String id, Money amount) {
    final template = addableClaims.where((c) => c.id == id).firstOrNull;
    final index = _claims.indexWhere((c) => c.id == id);

    if (amount.minor <= 0) {
      if (index >= 0) _claims.removeAt(index);
    } else if (index >= 0) {
      final existing = _claims[index];
      _claims[index] = Claim(
        id: existing.id,
        priority: existing.priority,
        label: existing.label,
        amount: amount,
        dueDate: existing.dueDate,
        userPriority: existing.userPriority,
        reservation: existing.reservation,
      );
    } else if (template != null) {
      _claims.add(Claim(
        id: template.id,
        priority: template.priority,
        label: template.label,
        amount: amount,
      ),);
    } else {
      return;
    }

    _persist();
    notifyListeners();
  }

  void removeClaim(String id) => setClaimAmount(id, Money.zero(_currency));

  /// Change what the next pay is expected to be. Still an expectation, so it
  /// stays out of safe_to_spend_now (INV-04).
  void setExpectedIncome({Money? amount, LocalDate? date}) {
    final current = _incomeEvents.isEmpty ? null : _incomeEvents.first;
    final nextAmount = amount ?? current?.expectedAmount;
    final nextDate = date ?? current?.expectedDate;
    if (nextAmount == null || nextDate == null) return;

    _incomeEvents
      ..clear()
      ..add(IncomeEvent(
        id: 'income-next',
        expectedAmount: nextAmount,
        expectedDate: nextDate,
        state: IncomeState.expected,
      ),);
    _persist();
    notifyListeners();
  }

  /// Wipe the plan and start again. The stored document goes too, because a
  /// half-cleared plan would be worse than none.
  Future<void> startOver() async {
    _events.clear();
    _claims.clear();
    _incomeEvents.clear();
    _goals.clear();
    _goalSeq = 0;
    _openingBalance = null;
    _lastBalanceConfirmation = null;
    _onboarded = false;
    _eventSeq = 0;
    lastRecordedExpense = null;
    // The theme is a preference, not plan data, so wiping the plan keeps it.
    await _store?.clear();
    notifyListeners();
  }

  /// What the Activity screen shows: the events a person recorded, newest
  /// first, each marked with whether it still counts.
  List<ActivityEntry> get activity {
    final corrected = <String>{
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    final entries = <ActivityEntry>[];
    for (final e in _events) {
      final described = _describe(e);
      if (described == null) continue;
      entries.add(ActivityEntry(
        eventId: e.id,
        label: described.label,
        amount: described.amount,
        increasesMoney: described.increasesMoney,
        removed: corrected.contains(e.id),
      ),);
    }
    return entries.reversed.toList();
  }

  ({String label, Money amount, bool increasesMoney})? _describe(LedgerEvent e) =>
      switch (e) {
        ExpenseEvent(:final amount) =>
          (label: 'Spent', amount: amount, increasesMoney: false),
        CardPurchaseEvent(:final amount) =>
          (label: 'Card purchase', amount: amount, increasesMoney: false),
        CardSettlementEvent(:final amount) =>
          (label: 'Card payment', amount: amount, increasesMoney: false),
        IncomeConfirmedEvent(:final amount) =>
          (label: 'Income received', amount: amount, increasesMoney: true),
        RefundEvent(:final amount) =>
          (label: 'Refund', amount: amount, increasesMoney: true),
        TransferEvent(:final amount) =>
          (label: 'Moved between accounts', amount: amount, increasesMoney: true),
        LoanDrawdownEvent(:final amount) =>
          (label: 'Loan received', amount: amount, increasesMoney: true),
        DebtPaymentEvent(:final amount) =>
          (label: 'Debt payment', amount: amount, increasesMoney: false),
        BalanceAdjustmentEvent(:final delta) => (
            label: 'Balance corrected',
            amount: delta.isNegative ? -delta : delta,
            increasesMoney: !delta.isNegative,
          ),
        // A correction is not itself an entry; it marks the one it voids.
        CorrectionEvent() => null,
      };

  /// Remove a recorded event. The event stays in the log and a correction is
  /// appended beside it, so the record still explains what the plan used to
  /// say (§15, §21). Nothing is erased.
  void removeEvent(String eventId, {String reason = 'Removed by user'}) {
    if (_events.every((e) => e.id != eventId)) return;
    if (_events.any((e) => e is CorrectionEvent && e.voidsEventId == eventId)) {
      return;
    }
    _events.add(CorrectionEvent(
      id: 'e${++_eventSeq}',
      voidsEventId: eventId,
      reason: reason,
    ),);
    _persist();
    notifyListeners();
  }

  /// RunScenario (§22) — non-mutating, because the engine is pure.
  PlanSnapshot simulateExpense(Money amount) => computePlan(PlanInput(
        currency: _currency,
        now: _now,
        utcOffset: _utcOffset,
        includedAccounts: const [_accountId],
        openingBalances: {_accountId: _openingBalance ?? Money.zero(_currency)},
        events: [
          ..._events,
          ExpenseEvent(id: 'scenario', accountId: _accountId, amount: amount),
        ],
        claims: _claims,
        incomeEvents: _incomeEvents,
        oldestConfirmationAt: _lastBalanceConfirmation,
      ),);

  Allocation? allocationFor(String claimId) {
    for (final a in snapshot.allocations) {
      if (a.claimId == claimId) return a;
    }
    return null;
  }
}
