/// Application state. The UI never computes money: it collects domain
/// commands, hands them to the engine and renders the snapshot (§22, §17).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/plan_document.dart';
import '../domain/bank_sms.dart';
import '../domain/category.dart';
import '../domain/goal.dart';
import '../domain/holding.dart';
import '../domain/inflation.dart';
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

  /// The upper end when income varies. The plan is built on [incomeAmount].
  Money? incomeUpperAmount;
  LocalDate? nextIncomeDate;
  Money? rent;
  Money? essentials;
  Money? cardMinimum;
  Money? goalAmount;
  int? payCycleDays;

  bool get isComplete => currentBalance != null && incomeAmount != null;
}

/// The three ways a contemplated purchase can go, each a full PlanSnapshot
/// from the same engine (Strategic Evolution §3.3).
///
/// The product shows consequences rather than a verdict: there is no field
/// here that says yes or no, because the trade-off is the user's to make.
class SpendScenarios {
  const SpendScenarios({
    required this.amount,
    required this.doNotBuy,
    required this.buyNow,
    required this.buyAfterIncome,
    required this.incomeDate,
  });

  final Money amount;
  final PlanSnapshot doNotBuy;
  final PlanSnapshot buyNow;

  /// Null when no pay is expected, so there is no later moment to compare.
  final PlanSnapshot? buyAfterIncome;
  final LocalDate? incomeDate;

  /// True when buying now leaves a commitment that must be paid unfunded.
  /// This is the one consequence worth naming before any other.
  bool get breaksNow =>
      buyNow.mandatoryFundingGap > doNotBuy.mandatoryFundingGap;

  bool get breaksAfterIncome =>
      buyAfterIncome != null &&
      buyAfterIncome!.mandatoryFundingGap.minor > 0;

  /// Commitments that lose funding by buying now, worst first. Named rather
  /// than summarised, because "something is short" is not actionable.
  List<({String claimId, String label, Money lost})> get costsNow {
    final before = {for (final a in doNotBuy.allocations) a.claimId: a.allocated};
    final out = <({String claimId, String label, Money lost})>[];
    for (final a in buyNow.allocations) {
      final was = before[a.claimId];
      if (was == null || a.allocated >= was) continue;
      out.add((claimId: a.claimId, label: a.label, lost: was - a.allocated));
    }
    out.sort((x, y) => y.lost.compareTo(x.lost));
    return out;
  }

  /// Whether waiting is materially better, which is the only comparison the
  /// engine can make without assuming anything about behaviour.
  bool get waitingHelps =>
      buyAfterIncome != null && breaksNow && !breaksAfterIncome;
}

/// A message on the phone, as the device layer hands it over.
class InboxMessage {
  const InboxMessage({
    required this.id,
    required this.body,
    required this.receivedAt,
    this.sender,
  });

  final String id;
  final String body;
  final DateTime receivedAt;
  final String? sender;
}

/// A spend a bank message describes, waiting for the person to say yes.
class BankSuggestion {
  const BankSuggestion({
    required this.messageId,
    required this.amount,
    required this.receivedAt,
    required this.body,
    this.sender,
  });

  final String messageId;
  final Money amount;
  final DateTime receivedAt;
  final String body;
  final String? sender;
}

/// Something about the plan that needs the person, for the bell at the top.
///
/// Derived from the plan every time, never stored: an alert that outlived
/// its cause would be the app saying something that is no longer true.
sealed class PlanAlert {
  const PlanAlert();
}

/// The balance has not been confirmed recently enough to trust the figure.
class BalanceStaleAlert extends PlanAlert {
  const BalanceStaleAlert({required this.days, required this.reviewRequired});

  /// Days since the last confirmation, or null if there has never been one.
  final int? days;
  final bool reviewRequired;
}

/// Pay was expected by now and has not been confirmed.
class IncomeLateAlert extends PlanAlert {
  const IncomeLateAlert(this.expectedOn);
  final LocalDate expectedOn;
}

/// Something that must be paid is not covered by what there is.
class UnfundedAlert extends PlanAlert {
  const UnfundedAlert({
    required this.claimId,
    required this.label,
    required this.short,
  });

  final String claimId;
  final String label;
  final Money short;
}

/// A goal is not getting what it needs this period.
class GoalBehindAlert extends PlanAlert {
  const GoalBehindAlert({required this.name, required this.short});
  final String name;
  final Money short;
}

/// Bank messages are waiting to be recorded or skipped.
class BankMessagesAlert extends PlanAlert {
  const BankMessagesAlert(this.count);
  final int count;
}

/// Which theme the app follows. Stored with the plan so it survives a
/// reinstall on the same device, and defaults to whatever the phone is set
/// to rather than imposing a choice.
enum ThemeChoice { system, light, dark }

/// Which language the app is shown in. Stored with the plan for the same
/// reason as the theme: one thing to save and one thing to read back. Null
/// means follow the phone, which is the default so nothing is imposed.
typedef LanguageChoice = String?;

/// One row of the Activity screen.
/// What kind of thing a line on Activity is. The state layer has no
/// BuildContext and so no language; naming the kind here and translating it
/// at the screen keeps English out of the plan's own data.
enum ActivityKind {
  spend,
  cardPurchase,
  cardPayment,
  income,
  refund,
  transfer,
  loan,
  debtPayment,
  balanceCorrected,
}

class ActivityEntry {
  const ActivityEntry({
    required this.eventId,
    required this.kind,
    required this.amount,
    required this.increasesMoney,
    required this.removed,
  });

  final String eventId;
  final ActivityKind kind;
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
  final List<Holding> _holdings = [];
  int _holdingSeq = 0;

  String _currency = 'EUR';
  ThemeChoice _themeChoice = ThemeChoice.system;
  String? _languageCode;
  final Map<String, String> _receipts = {};
  final Map<String, SpendCategory> _categories = {};
  final Map<String, DateTime> _recordedAt = {};
  int _payCycleDays = 30;
  int? _inflationBasisPoints;
  bool _smsEnabled = false;
  DateTime? _smsSince;
  final List<String> _smsHandled = [];
  final List<BankSuggestion> _suggestions = [];
  bool _reminderEnabled = false;
  DateTime? _startedAt;
  int _goalSeq = 0;
  Money? _openingBalance;
  DateTime? _lastBalanceConfirmation;
  bool _onboarded = false;
  int _eventSeq = 0;

  /// The most recent expense, so Home can show a transient confirmation
  /// badge without the accent ever becoming a persistent state (§32.7).
  Money? lastRecordedExpense;

  /// The event behind [lastRecordedExpense], so the confirmation can offer to
  /// take that exact spend back.
  String? lastRecordedEventId;

  bool get isOnboarded => _onboarded;
  ThemeChoice get themeChoice => _themeChoice;

  void setThemeChoice(ThemeChoice choice) {
    if (choice == _themeChoice) return;
    _themeChoice = choice;
    _persist();
    notifyListeners();
  }

  /// Null follows the phone's language.
  String? get languageCode => _languageCode;

  void setLanguageCode(String? code) {
    if (code == _languageCode) return;
    _languageCode = code;
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
    _languageCode = document.languageCode;
    _receipts
      ..clear()
      ..addAll(document.receipts);
    _categories
      ..clear()
      ..addAll(document.categories);
    _recordedAt
      ..clear()
      ..addAll(document.recordedAt);
    _payCycleDays = document.payCycleDays;
    _inflationBasisPoints = document.inflationBasisPoints;
    _smsEnabled = document.smsEnabled;
    _smsSince = document.smsSince;
    _smsHandled
      ..clear()
      ..addAll(document.smsHandled);
    _reminderEnabled = document.reminderEnabled;
    _startedAt = document.startedAt;
    _goals
      ..clear()
      ..addAll(document.goals);
    _goalSeq = _goals.length;
    _holdings
      ..clear()
      ..addAll(document.holdings);
    _holdingSeq = _holdings.fold(0, (seq, h) {
      final n = int.tryParse(h.id.replaceFirst('h', '')) ?? 0;
      return n > seq ? n : seq;
    });

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

  /// Replace the whole plan with one from a backup. Nothing of the current
  /// plan is merged in: two logs cannot be interleaved without inventing an
  /// order for them, so the backup is taken as it stands.
  void replaceWith(PlanDocument document) {
    _apply(document);
    _restoreFailure = null;
    lastRecordedExpense = null;
    _persist();
    notifyListeners();
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
        languageCode: _languageCode,
        receipts: Map.of(_receipts),
        categories: Map.of(_categories),
        recordedAt: Map.of(_recordedAt),
        goals: List.unmodifiable(_goals),
        payCycleDays: _payCycleDays,
        inflationBasisPoints: _inflationBasisPoints,
        holdings: List.unmodifiable(_holdings),
        smsEnabled: _smsEnabled,
        smsSince: _smsSince,
        smsHandled: List.unmodifiable(_smsHandled),
        reminderEnabled: _reminderEnabled,
        startedAt: _startedAt,
      );

  /// Every mutation persists. Saving is fire-and-forget so recording a spend
  /// stays within the §18 three-second target; the in-memory state is already
  /// correct when the UI rebuilds.
  void _persist() {
    _cachedSnapshot = null;
    unawaited(_store?.save(toDocument()));
  }
  String get currency => _currency;

  /// Keep the plan in [code] instead. Every amount keeps its number and takes
  /// the new currency; nothing is converted at an exchange rate, because the
  /// app has no rates and a guessed one would put a made-up figure on Home.
  /// This is for a plan set up in the wrong currency, which onboarding
  /// otherwise leaves no way out of short of deleting everything.
  ///
  /// The log is rewritten in place rather than corrected by a new event: the
  /// engine forbids mixing currencies (§16), and what changes is the unit the
  /// amounts are written in, not what happened.
  void changeCurrency(String code) {
    if (code == _currency || !Currency.isKnown(code)) return;
    Money r(Money m) => m.relabelled(code);
    Money? rn(Money? m) => m?.relabelled(code);

    _currency = code;
    _openingBalance = rn(_openingBalance);
    lastRecordedExpense = null;

    for (var i = 0; i < _events.length; i++) {
      _events[i] = _relabelEvent(_events[i], code);
    }
    for (var i = 0; i < _claims.length; i++) {
      final c = _claims[i];
      final reservation = c.reservation;
      _claims[i] = Claim(
        id: c.id,
        priority: c.priority,
        label: c.label,
        amount: r(c.amount),
        dueDate: c.dueDate,
        userPriority: c.userPriority,
        reservation: reservation == null
            ? null
            : Reservation(
                r(reservation.amount),
                consumed: r(reservation.consumed),
                state: reservation.state,
              ),
      );
    }
    for (var i = 0; i < _incomeEvents.length; i++) {
      final income = _incomeEvents[i];
      final amount = r(income.expectedAmount);
      final upper = rn(income.expectedUpperAmount);
      _incomeEvents[i] = IncomeEvent(
        id: income.id,
        expectedAmount: amount,
        expectedDate: income.expectedDate,
        state: income.state,
        confirmedAmount: rn(income.confirmedAmount),
        // Rounding into a currency with fewer decimals can close a narrow
        // range, and a range must not run backwards.
        expectedUpperAmount:
            upper != null && upper.minor > amount.minor ? upper : null,
      );
    }
    for (var i = 0; i < _goals.length; i++) {
      final g = _goals[i];
      _goals[i] = g.copyWith(target: r(g.target), saved: r(g.saved));
    }
    for (var i = 0; i < _holdings.length; i++) {
      final h = _holdings[i];
      _holdings[i] = h.copyWith(unitPrice: r(h.unitPrice));
    }

    _persist();
    notifyListeners();
  }

  static LedgerEvent _relabelEvent(LedgerEvent e, String code) {
    Money r(Money m) => m.relabelled(code);
    return switch (e) {
      ExpenseEvent() => ExpenseEvent(
          id: e.id,
          accountId: e.accountId,
          amount: r(e.amount),
          canonicalId: e.canonicalId,
        ),
      CardPurchaseEvent() => CardPurchaseEvent(
          id: e.id,
          cardId: e.cardId,
          amount: r(e.amount),
          canonicalId: e.canonicalId,
        ),
      CardSettlementEvent() => CardSettlementEvent(
          id: e.id,
          accountId: e.accountId,
          cardId: e.cardId,
          amount: r(e.amount),
          canonicalId: e.canonicalId,
        ),
      IncomeConfirmedEvent() => IncomeConfirmedEvent(
          id: e.id,
          accountId: e.accountId,
          amount: r(e.amount),
          canonicalId: e.canonicalId,
        ),
      LoanDrawdownEvent() => LoanDrawdownEvent(
          id: e.id,
          accountId: e.accountId,
          debtId: e.debtId,
          amount: r(e.amount),
          canonicalId: e.canonicalId,
        ),
      DebtPaymentEvent() => DebtPaymentEvent(
          id: e.id,
          accountId: e.accountId,
          debtId: e.debtId,
          amount: r(e.amount),
          canonicalId: e.canonicalId,
        ),
      TransferEvent() => TransferEvent(
          id: e.id,
          fromAccountId: e.fromAccountId,
          toAccountId: e.toAccountId,
          amount: r(e.amount),
          canonicalId: e.canonicalId,
        ),
      RefundEvent() => RefundEvent(
          id: e.id,
          accountId: e.accountId,
          amount: r(e.amount),
          linkedExpenseId: e.linkedExpenseId,
          canonicalId: e.canonicalId,
        ),
      BalanceAdjustmentEvent() => BalanceAdjustmentEvent(
          id: e.id,
          accountId: e.accountId,
          delta: r(e.delta),
          reason: e.reason,
          supersededBy: e.supersededBy,
          canonicalId: e.canonicalId,
        ),
      CorrectionEvent() => e,
    };
  }

  LocalDate get today => LocalDate.at(_now, _utcOffset);
  List<Claim> get claims => List.unmodifiable(_claims);

  /// Recomputed from scratch on every read; the engine is pure, so there is
  /// no derived state to keep in sync (§13, INV-07).
  /// The engine is pure and the clock is captured once at construction, so
  /// the same inputs give the same snapshot until something mutates. Reading
  /// it was recomputing the whole waterfall every time, and one screen build
  /// reads it several times: measured at 0.25ms with 40 events and 0.58ms
  /// with 600, which is most of a frame on a phone and grows with use.
  PlanSnapshot? _cachedSnapshot;

  PlanSnapshot get snapshot => _cachedSnapshot ??= _computeSnapshot();

  /// Every mutator ends in one of these two, so the cache cannot outlive the
  /// state it describes.
  @override
  void notifyListeners() {
    _cachedSnapshot = null;
    super.notifyListeners();
  }

  PlanSnapshot _computeSnapshot() => computePlan(PlanInput(
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

  // --- faster entry ---------------------------------------------------------

  bool get smsEnabled => _smsEnabled;

  /// Turning it on looks back three days, not through years of messages:
  /// old spends are long since in the balance, and offering them now would
  /// count them twice.
  void setSmsEnabled(bool enabled) {
    if (enabled == _smsEnabled) return;
    _smsEnabled = enabled;
    if (enabled) {
      _smsSince ??= _now.subtract(const Duration(days: 3));
    } else {
      _suggestions.clear();
    }
    _persist();
    notifyListeners();
  }

  /// Where the device layer should start reading from.
  DateTime? get smsSince => _smsEnabled ? _smsSince : null;

  List<BankSuggestion> get bankSuggestions => List.unmodifiable(_suggestions);

  /// Messages read from the phone. Only those that describe a spend this plan
  /// can record, that arrived after the feature was turned on, and that the
  /// person has not already answered become suggestions.
  void offerBankMessages(Iterable<InboxMessage> messages) {
    if (!_smsEnabled) return;
    final since = _smsSince;
    final known = {for (final s in _suggestions) s.messageId, ..._smsHandled};
    var added = false;
    for (final m in messages) {
      if (known.contains(m.id)) continue;
      if (since != null && !m.receivedAt.isAfter(since)) continue;
      final spend = parseBankSms(m.body, planCurrency: _currency);
      if (spend == null) continue;
      _suggestions.add(BankSuggestion(
        messageId: m.id,
        amount: spend.amount,
        receivedAt: m.receivedAt,
        body: m.body,
        sender: m.sender,
      ),);
      known.add(m.id);
      added = true;
    }
    if (!added) return;
    _suggestions.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    notifyListeners();
  }

  /// Record what the bank said was spent. The one path from a message to
  /// the ledger, and it goes through the person.
  void acceptSuggestion(String messageId, {SpendCategory? category}) {
    final index = _suggestions.indexWhere((s) => s.messageId == messageId);
    if (index < 0) return;
    final s = _suggestions.removeAt(index);
    _markHandled(messageId);
    recordExpense(s.amount, category: category);
  }

  void dismissSuggestion(String messageId) {
    final index = _suggestions.indexWhere((s) => s.messageId == messageId);
    if (index < 0) return;
    _suggestions.removeAt(index);
    _markHandled(messageId);
    _persist();
    notifyListeners();
  }

  /// Answered messages are remembered by id so they are never offered
  /// twice. Only the recent ones are kept: anything older has fallen behind
  /// the reading window anyway.
  void _markHandled(String id) {
    _smsHandled.add(id);
    if (_smsHandled.length > 300) {
      _smsHandled.removeRange(0, _smsHandled.length - 300);
    }
  }

  bool get reminderEnabled => _reminderEnabled;

  void setReminderEnabled(bool enabled) {
    if (enabled == _reminderEnabled) return;
    _reminderEnabled = enabled;
    _persist();
    notifyListeners();
  }

  /// Whether a spend was recorded today, local time. The evening reminder
  /// skips a day that already has one.
  bool get spentToday {
    for (final e in _events) {
      if (e is! ExpenseEvent) continue;
      final at = _recordedAt[e.id];
      if (at != null && LocalDate.at(at, _utcOffset) == today) return true;
    }
    return false;
  }

  Duration get utcOffset => _utcOffset;
  DateTime get now => _now;

  /// When this plan began. Saved from schema 8; for a plan older than that,
  /// the earliest thing it knows the time of stands in.
  DateTime? get startedAt {
    if (_startedAt != null) return _startedAt;
    DateTime? earliest = _lastBalanceConfirmation;
    for (final at in _recordedAt.values) {
      if (earliest == null || at.isBefore(earliest)) earliest = at;
    }
    return earliest;
  }

  /// Whole days the plan has been in use.
  int get daysInUse {
    final start = startedAt;
    if (start == null) return 0;
    return _now.difference(start).inDays;
  }

  /// Spends recorded that still count.
  int get spendCount {
    final voided = {
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    return _events
        .where((e) => e is ExpenseEvent && !voided.contains(e.id))
        .length;
  }

  /// What the bell shows, most urgent first: a commitment that cannot be
  /// paid, then a figure that cannot be trusted, then pay that has not come,
  /// then goals falling behind, then messages to review.
  List<PlanAlert> get alerts {
    if (!_onboarded) return const [];
    final snap = snapshot;
    final out = <PlanAlert>[];
    for (final a in snap.allocations) {
      if (a.shortfall.minor <= 0) continue;
      if (a.claimId.startsWith('goal:')) continue;
      if (!a.priority.isMandatory) continue;
      out.add(UnfundedAlert(
        claimId: a.claimId,
        label: a.label,
        short: a.shortfall,
      ),);
    }
    if (snap.confidenceState != ConfidenceState.trusted) {
      out.add(BalanceStaleAlert(
        days: snap.balanceAgeInDays,
        reviewRequired: snap.confidenceState == ConfidenceState.reviewRequired,
      ),);
    }
    for (final i in _incomeEvents) {
      if (i.state == IncomeState.expected && i.expectedDate < today) {
        out.add(IncomeLateAlert(i.expectedDate));
      }
    }
    for (final a in snap.allocations) {
      if (a.shortfall.minor <= 0 || !a.claimId.startsWith('goal:')) continue;
      out.add(GoalBehindAlert(name: a.label, short: a.shortfall));
    }
    if (_suggestions.isNotEmpty) {
      out.add(BankMessagesAlert(_suggestions.length));
    }
    return out;
  }

  List<Holding> get holdings => List.unmodifiable(_holdings);

  /// What the holdings are worth together, at the prices last given.
  Money get holdingsTotal =>
      Money.sum(_holdings.map((h) => h.value), _currency);

  void addHolding({
    required String name,
    required int quantityMilli,
    required Money unitPrice,
  }) {
    _holdings.add(Holding(
      id: 'h${++_holdingSeq}',
      name: name,
      quantityMilli: quantityMilli,
      unitPrice: unitPrice,
      pricedOn: today,
    ),);
    _persist();
    notifyListeners();
  }

  /// A new price restamps the date, because the date is what says how far
  /// to trust the figure.
  void updateHolding(
    String id, {
    String? name,
    int? quantityMilli,
    Money? unitPrice,
  }) {
    final index = _holdings.indexWhere((h) => h.id == id);
    if (index < 0) return;
    final h = _holdings[index];
    _holdings[index] = h.copyWith(
      name: name,
      quantityMilli: quantityMilli,
      unitPrice: unitPrice,
      pricedOn: unitPrice != null && unitPrice != h.unitPrice ? today : null,
    );
    _persist();
    notifyListeners();
  }

  void removeHolding(String id) {
    _holdings.removeWhere((h) => h.id == id);
    _persist();
    notifyListeners();
  }

  /// The yearly inflation the person expects, in basis points, or null when
  /// they have not said. A preference like the theme, so starting over
  /// keeps it.
  int? get inflationBasisPoints => _inflationBasisPoints;

  void setInflation(int? basisPoints) {
    final next = basisPoints == null || basisPoints <= 0 ? null : basisPoints;
    if (next == _inflationBasisPoints) return;
    _inflationBasisPoints = next;
    _persist();
    notifyListeners();
  }

  /// What [goal]'s target will cost on its date at the expected rate, or
  /// null when there is nothing to say: no rate, a goal already reached or
  /// paused, or a date that has come.
  Money? inflatedTarget(Goal goal) {
    final rate = _inflationBasisPoints;
    if (rate == null || goal.isComplete || goal.kind == GoalKind.paused) {
      return null;
    }
    final days = goal.targetDate.differenceInDays(today);
    if (days <= 0) return null;
    final grown = inflated(goal.target, rate, days);
    return grown > goal.target ? grown : null;
  }
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
    _startedAt = _now;

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
        expectedUpperAmount:
            (draft.incomeUpperAmount?.minor ?? 0) > incomeAmount.minor
                ? draft.incomeUpperAmount
                : null,
      ),);
    }

    _onboarded = true;
    _persist();
    notifyListeners();
  }

  /// RecordExpense (§22). The UI issues the command; the engine decides what
  /// it means for Safe-to-Spend.
  /// [receipt] is a filename inside the app's own directory, already copied
  /// there by the caller. Null when no photograph was taken.
  void recordExpense(
    Money amount, {
    String? receipt,
    SpendCategory? category,
  }) {
    final id = 'e${++_eventSeq}';
    _events.add(ExpenseEvent(
      id: id,
      accountId: _accountId,
      amount: amount,
    ),);
    if (receipt != null) _receipts[id] = receipt;
    if (category != null) _categories[id] = category;
    _recordedAt[id] = _now;
    lastRecordedExpense = amount;
    lastRecordedEventId = id;
    _persist();
    notifyListeners();
  }

  /// The receipt stored for an event, or null. Removing an entry leaves the
  /// receipt in place: §21 says a correction adds to the record rather than
  /// erasing it, and the photograph is part of that record.
  String? receiptFor(String eventId) => _receipts[eventId];

  SpendCategory? categoryFor(String eventId) => _categories[eventId];

  /// Sorting a spend afterwards, or changing its sort. Not a correction: the
  /// amount and the plan are untouched, only the label on the entry changes.
  void setCategory(String eventId, SpendCategory? category) {
    if (_events.every((e) => e.id != eventId)) return;
    if (category == null) {
      _categories.remove(eventId);
    } else {
      _categories[eventId] = category;
    }
    _persist();
    notifyListeners();
  }

  /// Where the money went over the last [days], largest first. Only spends
  /// that still count are included, and only those recorded with a time —
  /// entries from before times were kept cannot be placed in a window.
  /// A null category is spending nobody sorted, shown as such rather than
  /// quietly folded into "other".
  /// [before] moves the window back: `days: 30, before: 30` is the thirty
  /// days before the last thirty, which is what a comparison needs.
  List<({SpendCategory? category, Money total})> spendingByCategory({
    int days = 30,
    int before = 0,
  }) {
    final voided = <String>{
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    final until = _now.subtract(Duration(days: before));
    final since = until.subtract(Duration(days: days));
    final totals = <SpendCategory?, Money>{};
    for (final e in _events) {
      if (e is! ExpenseEvent || voided.contains(e.id)) continue;
      final at = _recordedAt[e.id];
      if (at == null || at.isBefore(since) || at.isAfter(until)) continue;
      final key = _categories[e.id];
      totals[key] = (totals[key] ?? Money.zero(_currency)) + e.amount;
    }
    final out = [
      for (final entry in totals.entries)
        (category: entry.key, total: entry.value),
    ]..sort((a, b) => b.total.compareTo(a.total));
    return out;
  }

  void attachReceipt(String eventId, String filename) {
    _receipts[eventId] = filename;
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
    lastRecordedEventId = null;
    notifyListeners();
  }

  /// Take back the spend just recorded, from its confirmation. The same
  /// correction Activity makes: the entry stays on the record, marked
  /// removed, and stops counting (§15, §21).
  void undoLastExpense() {
    final id = lastRecordedEventId;
    lastRecordedExpense = null;
    lastRecordedEventId = null;
    if (id == null) {
      notifyListeners();
      return;
    }
    removeEvent(id);
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
  /// [upper] gives an income that varies. The plan is built on [amount], the
  /// lower end, and the upper end is carried only so the user can see the
  /// spread they entered. Pass [clearUpper] to go back to a fixed income.
  void setExpectedIncome({
    Money? amount,
    LocalDate? date,
    Money? upper,
    bool clearUpper = false,
  }) {
    final current = _incomeEvents.isEmpty ? null : _incomeEvents.first;
    final nextAmount = amount ?? current?.expectedAmount;
    final nextDate = date ?? current?.expectedDate;
    if (nextAmount == null || nextDate == null) return;

    final nextUpper =
        clearUpper ? null : (upper ?? current?.expectedUpperAmount);

    _incomeEvents
      ..clear()
      ..add(IncomeEvent(
        id: 'income-next',
        expectedAmount: nextAmount,
        expectedDate: nextDate,
        state: IncomeState.expected,
        // A stored upper end below a newly lowered amount would be a range
        // running backwards, so it is dropped rather than kept.
        expectedUpperAmount: nextUpper != null && nextUpper > nextAmount
            ? nextUpper
            : null,
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
    // Event ids restart from e1, so anything keyed by id has to go with the
    // log or it would attach itself to the next plan's first entries.
    _receipts.clear();
    _categories.clear();
    _recordedAt.clear();
    _holdings.clear();
    _holdingSeq = 0;
    _suggestions.clear();
    _startedAt = null;
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
        kind: described.kind,
        amount: described.amount,
        increasesMoney: described.increasesMoney,
        removed: corrected.contains(e.id),
      ),);
    }
    return entries.reversed.toList();
  }

  ({ActivityKind kind, Money amount, bool increasesMoney})? _describe(
    LedgerEvent e,
  ) =>
      switch (e) {
        ExpenseEvent(:final amount) =>
          (kind: ActivityKind.spend, amount: amount, increasesMoney: false),
        CardPurchaseEvent(:final amount) => (
            kind: ActivityKind.cardPurchase,
            amount: amount,
            increasesMoney: false,
          ),
        CardSettlementEvent(:final amount) => (
            kind: ActivityKind.cardPayment,
            amount: amount,
            increasesMoney: false,
          ),
        IncomeConfirmedEvent(:final amount) =>
          (kind: ActivityKind.income, amount: amount, increasesMoney: true),
        RefundEvent(:final amount) =>
          (kind: ActivityKind.refund, amount: amount, increasesMoney: true),
        TransferEvent(:final amount) =>
          (kind: ActivityKind.transfer, amount: amount, increasesMoney: true),
        LoanDrawdownEvent(:final amount) =>
          (kind: ActivityKind.loan, amount: amount, increasesMoney: true),
        DebtPaymentEvent(:final amount) => (
            kind: ActivityKind.debtPayment,
            amount: amount,
            increasesMoney: false,
          ),
        BalanceAdjustmentEvent(:final delta) => (
            kind: ActivityKind.balanceCorrected,
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
  PlanSnapshot simulateExpense(Money amount) => _simulate(extraExpense: amount);

  /// The three answers to "should I buy this?" (Strategic Evolution §3.3).
  ///
  /// Every figure comes from the same engine that produces the live plan, run
  /// on inputs that differ only by the contemplated purchase. Nothing here is
  /// arithmetic done on top of a snapshot, and nothing mutates the plan.
  SpendScenarios simulatePurchase(Money amount) => SpendScenarios(
        amount: amount,
        doNotBuy: snapshot,
        buyNow: _simulate(extraExpense: amount),
        buyAfterIncome: _afterIncome(amount),
        incomeDate: _projectableIncome?.expectedDate,
      );

  IncomeEvent? get _projectableIncome {
    for (final i in _incomeEvents) {
      if (i.isProjectable) return i;
    }
    return null;
  }

  /// "If your pay arrives as expected and you buy it then." The income is
  /// treated as received and the clock moved past it — a stated assumption,
  /// not a claim that the money has arrived. Null when no pay is expected,
  /// because there is then no later moment to compare against.
  PlanSnapshot? _afterIncome(Money amount) {
    final income = _projectableIncome;
    if (income == null) return null;

    final arrival = income.expectedDate;
    final then = DateTime.utc(arrival.year, arrival.month, arrival.day, 12)
        .subtract(_utcOffset);
    if (!then.isAfter(_now)) return null;

    return _simulate(
      extraExpense: amount,
      at: then,
      extraEvents: [
        IncomeConfirmedEvent(
          id: 'scenario-income',
          accountId: _accountId,
          amount: income.projectedAmount ?? income.expectedAmount,
        ),
      ],
      incomeEvents: _incomeEvents.where((i) => i.id != income.id).toList(),
    );
  }

  PlanSnapshot _simulate({
    Money? extraExpense,
    DateTime? at,
    List<LedgerEvent> extraEvents = const [],
    List<IncomeEvent>? incomeEvents,
  }) =>
      computePlan(PlanInput(
        currency: _currency,
        now: at ?? _now,
        utcOffset: _utcOffset,
        includedAccounts: const [_accountId],
        openingBalances: {_accountId: _openingBalance ?? Money.zero(_currency)},
        events: [
          ..._events,
          ...extraEvents,
          if (extraExpense != null)
            ExpenseEvent(
              id: 'scenario',
              accountId: _accountId,
              amount: extraExpense,
            ),
        ],
        claims: _claims,
        incomeEvents: incomeEvents ?? _incomeEvents,
        oldestConfirmationAt: _lastBalanceConfirmation,
      ),);

  Allocation? allocationFor(String claimId) {
    for (final a in snapshot.allocations) {
      if (a.claimId == claimId) return a;
    }
    return null;
  }
}
