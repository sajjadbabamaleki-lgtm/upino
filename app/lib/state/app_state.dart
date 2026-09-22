/// Application state. The UI never computes money: it collects domain
/// commands, hands them to the engine and renders the snapshot (§22, §17).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/plan_document.dart';
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

  bool get isComplete => currentBalance != null && incomeAmount != null;
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

  String _currency = 'EUR';
  Money? _openingBalance;
  DateTime? _lastBalanceConfirmation;
  bool _onboarded = false;
  int _eventSeq = 0;

  /// The most recent expense, so Home can show a transient confirmation
  /// badge without the accent ever becoming a persistent state (§32.7).
  Money? lastRecordedExpense;

  bool get isOnboarded => _onboarded;

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
    _events
      ..clear()
      ..addAll(document.events);
    _claims
      ..clear()
      ..addAll(document.claims);
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
        claims: _claims,
        incomeEvents: _incomeEvents,
        oldestConfirmationAt: _lastBalanceConfirmation,
      ),);

  void completeOnboarding(OnboardingDraft draft) {
    _currency = draft.currency;
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
        if (draft.goalAmount != null && draft.goalAmount!.minor > 0)
          Claim(
            id: 'goal',
            priority: Priority.p7HardGoal,
            label: 'Savings goal',
            amount: draft.goalAmount!,
          ),
      ]);

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
