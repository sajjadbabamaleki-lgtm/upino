/// Application state. The UI never computes money: it collects domain
/// commands, hands them to the engine and renders the snapshot (§22, §17).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/plan_document.dart';
import '../domain/account.dart';
import '../domain/bank_sms.dart';
import '../domain/bill.dart';
import '../domain/category.dart';
import '../domain/conversation.dart';
import '../domain/goal.dart';
import '../domain/holding.dart';
import '../domain/inflation.dart';
import '../domain/recovery.dart';
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
    this.goalPace = const {},
    this.payCycleDays = 30,
  });

  final Money amount;
  final PlanSnapshot doNotBuy;

  /// What each goal's claim puts away per pay period, by claim id, so a
  /// loss to a goal can be said as time rather than as money.
  final Map<String, Money> goalPace;
  final int payCycleDays;
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

  /// Goals that buying now pushes back, and by roughly how many days: what
  /// the goal loses, at the pace it is being saved for (§9). Approximate by
  /// nature, and said so wherever it is shown.
  List<({String claimId, String label, int days})> get goalDelays => [
        for (final c in costsNow)
          if (goalPace[c.claimId] case final pace? when pace.minor > 0)
            (
              claimId: c.claimId,
              label: c.label,
              days: (c.lost.minor * payCycleDays / pace.minor).ceil(),
            ),
      ];

  /// Whether waiting is materially better, which is the only comparison the
  /// engine can make without assuming anything about behaviour.
  bool get waitingHelps =>
      buyAfterIncome != null && breaksNow && !breaksAfterIncome;
}

/// A month in a few facts (§13). [previous] and the category moves are
/// null until there is a full earlier month to compare with.
class MonthReview {
  const MonthReview({
    required this.daysSeen,
    required this.spent,
    required this.previous,
    required this.goals,
    required this.goalsOnTrack,
    this.up,
    this.upBy,
    this.down,
    this.downBy,
    this.income,
    this.toGoals,
  });

  /// Pay that came in over the thirty days, and what went to goals.
  final Money? income;
  final Money? toGoals;

  /// A month is thirty days here, matching the spending window.
  static const month = 30;

  final int daysSeen;
  final Money spent;
  final Money? previous;
  final SpendCategory? up;
  final Money? upBy;
  final SpendCategory? down;
  final Money? downBy;
  final int goals;
  final int goalsOnTrack;

  bool get ready => daysSeen >= month;
  int get daysToReady => ready ? 0 : month - daysSeen;

  /// Last month against the one before, or null with nothing to compare.
  /// Within a twentieth either way it is "about the same".
  Money? get change {
    final p = previous;
    if (p == null) return null;
    return spent - p;
  }

  bool get aboutTheSame {
    final c = change, p = previous;
    if (c == null || p == null) return false;
    return c.minor.abs() * 20 <= p.minor.abs();
  }
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
  final List<Bill> _bills = [];
  int _billSeq = 0;
  final List<Account> _accounts = [];
  int _accountSeq = 0;
  final Map<String, String> _accountOf = {};
  final List<Recovery> _recoveries = [];
  final List<GoalContribution> _contributions = [];

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
  final List<Conversation> _conversations = [];
  int _conversationSeq = 0;
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
    _conversations
      ..clear()
      ..addAll(document.conversations);
    _conversationSeq = _conversations.fold(0, (seq, c) {
      final n = int.tryParse(c.id.replaceFirst('c', '')) ?? 0;
      return n > seq ? n : seq;
    });
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

    _bills
      ..clear()
      ..addAll(document.bills);
    _billSeq = _seqOf(_bills.map((b) => b.id), 'b');
    _accounts
      ..clear()
      ..addAll(document.accounts);
    _accountSeq = _seqOf(_accounts.map((a) => a.id), 'a');
    _accountOf
      ..clear()
      ..addAll(document.accountOf);
    _recoveries
      ..clear()
      ..addAll(document.recoveries);
    _contributions
      ..clear()
      ..addAll(document.contributions);

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

  static int _seqOf(Iterable<String> ids, String prefix) => ids.fold(0, (seq, id) {
        final n = int.tryParse(id.replaceFirst(prefix, '')) ?? 0;
        return n > seq ? n : seq;
      });

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
        conversations: List.unmodifiable(_conversations),
        bills: List.unmodifiable(_bills),
        accounts: List.unmodifiable(_accounts),
        accountOf: Map.of(_accountOf),
        recoveries: List.unmodifiable(_recoveries),
        contributions: List.unmodifiable(_contributions),
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
    for (var i = 0; i < _bills.length; i++) {
      _bills[i] = _bills[i].copyWith(amount: r(_bills[i].amount));
    }
    for (var i = 0; i < _accounts.length; i++) {
      final a = _accounts[i];
      _accounts[i] = Account(
        id: a.id,
        name: a.name,
        kind: a.kind,
        opening: r(a.opening),
        counted: a.countedChoice,
      );
    }
    for (var i = 0; i < _recoveries.length; i++) {
      final c = _recoveries[i];
      _recoveries[i] = c.to(c.state, expected: r(c.expected));
    }
    for (var i = 0; i < _contributions.length; i++) {
      final c = _contributions[i];
      _contributions[i] = GoalContribution(
        goalId: c.goalId,
        amount: r(c.amount),
        at: c.at,
      );
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

  PlanSnapshot _computeSnapshot() => computePlan(_input());

  /// What the engine is given, for the live plan or for a what-if. A what-if
  /// differs only in what it passes here; the claims, accounts and rules are
  /// always the live plan's.
  PlanInput _input({
    DateTime? at,
    List<LedgerEvent> extraEvents = const [],
    List<IncomeEvent>? incomeEvents,
    DateTime? recordedBy,
    List<Claim>? ownClaims,
    List<Bill>? bills,
  }) {
    final now = at ?? _now;
    final day = LocalDate.at(now, _utcOffset);
    final income = incomeEvents ?? _incomeEvents;
    final horizon = income
            .where((i) => i.isProjectable && i.expectedDate > day)
            .map((i) => i.expectedDate)
            .fold<LocalDate?>(null, (a, b) => a == null || b < a ? b : a) ??
        day;
    return PlanInput(
      currency: _currency,
      now: now,
      utcOffset: _utcOffset,
      includedAccounts: _includedAccounts,
      openingBalances: {
        _accountId: _openingBalance ?? Money.zero(_currency),
        for (final a in _accounts)
          if (a.holdsMoney) a.id: a.opening,
      },
      events: [
        // What was owed on a card when it was added is owed now, and is set
        // aside like any other card spending until it is paid.
        for (final a in _accounts)
          if (a.kind == AccountKind.card && a.opening.minor > 0)
            CardPurchaseEvent(
              id: 'opening:${a.id}',
              cardId: a.id,
              amount: a.opening,
            ),
        for (final e in _events)
          if (recordedBy == null ||
              !(_recordedAt[e.id]?.isAfter(recordedBy) ?? false))
            e,
        ...extraEvents,
      ],
      // Goals included: leaving them out of a what-if made a purchase look
      // free when it came out of a goal.
      claims: [
        ...ownClaims ?? _claims,
        ..._goalClaimsAt(day),
        for (final b in bills ?? _bills) b.toClaim(day, horizon, _payCycleDays),
      ],
      incomeEvents: income,
      cards: [
        for (final a in _accounts)
          if (a.kind == AccountKind.card) CardTerms(id: a.id),
      ],
      oldestConfirmationAt: _lastBalanceConfirmation,
    );
  }

  List<String> get _includedAccounts => [
        _accountId,
        for (final a in _accounts)
          if (a.counted) a.id,
      ];

  /// Each goal contributes this period's required contribution, so the
  /// waterfall protects the schedule rather than the whole target (§8).
  List<Claim> get _goalClaims => _goalClaimsAt(today);

  List<Claim> _goalClaimsAt(LocalDate day) => [
        for (final goal in _goals)
          if (goal.toClaim(day, _payCycleDays) case final claim?) claim,
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
      if (_spent(e) == null) continue;
      final at = _recordedAt[e.id];
      if (at != null && LocalDate.at(at, _utcOffset) == today) return true;
    }
    return false;
  }

  Duration get utcOffset => _utcOffset;
  DateTime get now => _now;

  // --- conversations with Ask ----------------------------------------------

  /// Kept to the most recent, so the saved plan does not grow without end.
  static const maxConversations = 30;
  static const maxTurns = 60;

  /// Newest first.
  List<Conversation> get conversations =>
      List.unmodifiable(_conversations.reversed);

  Conversation? conversation(String id) =>
      _conversations.where((c) => c.id == id).firstOrNull;

  /// Begins a conversation and returns its id. Nothing is saved until the
  /// first question, so opening the chat and leaving leaves no empty entry.
  String startConversation() => 'c${++_conversationSeq}';

  void ask(String conversationId, String question, {String? language}) {
    final turn = ChatTurn(
      question: question,
      askedAt: _now,
      language: language,
    );
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index < 0) {
      _conversations.add(
        Conversation(id: conversationId, startedAt: _now, turns: [turn]),
      );
      if (_conversations.length > maxConversations) {
        _conversations.removeAt(0);
      }
    } else {
      final c = _conversations[index];
      if (c.turns.length >= maxTurns) return;
      _conversations[index] = c.withTurn(turn);
    }
    _persist();
    notifyListeners();
  }

  void deleteConversation(String id) {
    _conversations.removeWhere((c) => c.id == id);
    _persist();
    notifyListeners();
  }

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
        .where((e) => _spent(e) != null && !voided.contains(e.id))
        .length;
  }

  /// What an event spent, whether from an account or on a card; null for
  /// anything that is not a spend.
  static Money? _spent(LedgerEvent e) => switch (e) {
        ExpenseEvent(:final amount) => amount,
        CardPurchaseEvent(:final amount) => amount,
        _ => null,
      };

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
    String? icon,
  }) {
    _goals.add(Goal(
      id: 'g${++_goalSeq}',
      name: name,
      target: target,
      targetDate: targetDate,
      saved: saved ?? Money.zero(_currency),
      kind: kind,
      icon: icon,
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
    String? icon,
  }) {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index < 0) return;
    _goals[index] = _goals[index].copyWith(
      name: name,
      target: target,
      targetDate: targetDate,
      kind: kind,
      icon: icon,
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
    _contributions.add(GoalContribution(goalId: id, amount: amount, at: _now));
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
    String? accountId,
  }) {
    final id = 'e${++_eventSeq}';
    final from = accountId == null ? null : account(accountId);
    _events.add(from?.kind == AccountKind.card
        ? CardPurchaseEvent(id: id, cardId: from!.id, amount: amount)
        : ExpenseEvent(
            id: id,
            accountId: from != null && from.canPay ? from.id : _accountId,
            amount: amount,
          ),);
    if (from != null && from.canPay) _accountOf[id] = from.id;
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
      if (voided.contains(e.id)) continue;
      final at = _recordedAt[e.id];
      if (at == null || at.isBefore(since) || at.isAfter(until)) continue;
      // Money that came back takes its spend's sort, so a returned purchase
      // does not stay counted as spending.
      final (key, amount) = switch (e) {
        RefundEvent(:final linkedExpenseId?, :final amount) =>
          (_categories[linkedExpenseId], -amount),
        _ => (_categories[e.id], _spent(e)),
      };
      if (amount == null) continue;
      totals[key] = (totals[key] ?? Money.zero(_currency)) + amount;
    }
    totals.removeWhere((_, v) => v.minor <= 0);
    final out = [
      for (final entry in totals.entries)
        (category: entry.key, total: entry.value),
    ]..sort((a, b) => b.total.compareTo(a.total));
    return out;
  }

  /// Spending, net of refunds, per local day for the last [days] days,
  /// oldest first; today is last.
  List<Money> spendingByDay({int days = 7}) {
    final voided = {
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    final out = List<int>.filled(days, 0);
    for (final e in _events) {
      if (voided.contains(e.id)) continue;
      final at = _recordedAt[e.id];
      if (at == null) continue;
      final ago = today.differenceInDays(LocalDate.at(at, _utcOffset));
      if (ago < 0 || ago >= days) continue;
      final minor = switch (e) {
        RefundEvent(:final amount, linkedExpenseId: _?) => -amount.minor,
        _ => _spent(e)?.minor ?? 0,
      };
      out[days - 1 - ago] += minor;
    }
    return [for (final m in out) Money(m < 0 ? 0 : m, _currency)];
  }

  /// Money in and out per week for the last [weeks] weeks, oldest first:
  /// pay and refunds in, spending and repayments out. Moving money between
  /// the person's own accounts is neither.
  List<({Money moneyIn, Money moneyOut})> flowsByWeek({int weeks = 8}) {
    final voided = {
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    final ins = List<int>.filled(weeks, 0);
    final outs = List<int>.filled(weeks, 0);
    for (final e in _events) {
      if (voided.contains(e.id)) continue;
      final at = _recordedAt[e.id];
      if (at == null) continue;
      final ago = today.differenceInDays(LocalDate.at(at, _utcOffset)) ~/ 7;
      if (ago < 0 || ago >= weeks) continue;
      final i = weeks - 1 - ago;
      switch (e) {
        case IncomeConfirmedEvent(:final amount):
          ins[i] += amount.minor;
        case RefundEvent(:final amount):
          ins[i] += amount.minor;
        case ExpenseEvent(:final amount):
          outs[i] += amount.minor;
        case CardPurchaseEvent(:final amount):
          outs[i] += amount.minor;
        case DebtPaymentEvent(:final amount):
          outs[i] += amount.minor;
        default:
          break;
      }
    }
    return [
      for (var i = 0; i < weeks; i++)
        (moneyIn: Money(ins[i], _currency), moneyOut: Money(outs[i], _currency)),
    ];
  }

  /// What went out in each thirty-day stretch, oldest first, the current
  /// one last; only stretches the plan was in use for most of, up to
  /// [months]. A stretch mostly from before the plan began would read as a
  /// month of saving and pull the average down.
  List<Money> monthlySpending({int months = 6}) {
    final used = ((daysInUse + 15) ~/ 30).clamp(1, 1 << 20);
    final n = used < months ? used : months;
    return [
      for (var k = n - 1; k >= 0; k--)
        Money.sum(
          spendingByCategory(before: k * 30).map((r) => r.total),
          _currency,
        ),
    ];
  }

  /// How many spends each category had over the last [days].
  Map<SpendCategory, int> spendCountsByCategory({int days = 30}) {
    final since = _now.subtract(Duration(days: days));
    final voided = {
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    final out = <SpendCategory, int>{};
    for (final e in _events) {
      final category = _categories[e.id];
      final at = _recordedAt[e.id];
      if (_spent(e) == null || category == null || at == null) continue;
      if (voided.contains(e.id) || at.isBefore(since)) continue;
      out[category] = (out[category] ?? 0) + 1;
    }
    return out;
  }

  /// A category for a spend of [amount], when the record makes one clear
  /// (Strategy §7.1): at least three sorted spends of a similar size in the
  /// last ninety days, most of them in one category. Otherwise nothing: a
  /// guess the person has to undo costs more than no guess.
  SpendCategory? suggestCategory(Money amount) {
    if (amount.minor <= 0) return null;
    final since = _now.subtract(const Duration(days: 90));
    final voided = {
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    final counts = <SpendCategory, int>{};
    var similar = 0;
    for (final e in _events) {
      final spent = _spent(e);
      final category = _categories[e.id];
      final at = _recordedAt[e.id];
      if (spent == null || category == null || at == null) continue;
      if (voided.contains(e.id) || at.isBefore(since)) continue;
      // Similar: within a third either way.
      final lo = amount.minor * 2 ~/ 3;
      final hi = amount.minor * 3 ~/ 2;
      if (spent.minor < lo || spent.minor > hi) continue;
      similar++;
      counts[category] = (counts[category] ?? 0) + 1;
    }
    if (similar < 3) return null;
    final top = counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return top.value * 10 >= similar * 6 ? top.key : null;
  }

  /// Where a spend can be paid from: the main account first, then any
  /// cash, bank or card account.
  List<({String id, String name, AccountKind kind})> get payableAccounts => [
        for (final a in _accounts)
          if (a.canPay) (id: a.id, name: a.name, kind: a.kind),
      ];

  void attachReceipt(String eventId, String filename) {
    _receipts[eventId] = filename;
    _persist();
    notifyListeners();
  }

  /// ConfirmBalance (§22, §15.1). A difference from the modelled balance is
  /// recorded as an auditable adjustment, never as spending.
  void confirmBalance(Money observed) {
    // The main account's own balance: with other accounts counted, the
    // plan's total is not what this one account holds.
    final modelled =
        snapshot.ledger.balances[_accountId] ?? Money.zero(_currency);
    final delta = observed - modelled;
    if (!delta.isZero) {
      final id = 'e${++_eventSeq}';
      _events.add(BalanceAdjustmentEvent(
        id: id,
        accountId: _accountId,
        delta: delta,
        reason: 'User confirmed observed balance',
      ),);
      _recordedAt[id] = _now;
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
    _bills.clear();
    _billSeq = 0;
    _accounts.clear();
    _accountSeq = 0;
    _accountOf.clear();
    _recoveries.clear();
    _contributions.clear();
    _suggestions.clear();
    _startedAt = null;
    _conversations.clear();
    _conversationSeq = 0;
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
        goalPace: {
          for (final c in _goalClaims) c.id: c.amount,
        },
        payCycleDays: _payCycleDays,
      );

  /// The last thirty days against the thirty before (§13): what went out,
  /// what moved most, and how the goals stand. Only facts already recorded;
  /// no score and no judgement.
  MonthReview get monthReview {
    final days = daysInUse;
    final last = spendingByCategory();
    final previous = days >= 60 ? spendingByCategory(before: 30) : null;
    Money sum(List<({SpendCategory? category, Money total})> rows) =>
        Money.sum(rows.map((r) => r.total), _currency);

    SpendCategory? up, down;
    Money? upBy, downBy;
    if (previous != null) {
      final before = {for (final r in previous) r.category: r.total};
      final now = {for (final r in last) r.category: r.total};
      for (final c in {...before.keys, ...now.keys}) {
        if (c == null) continue;
        final d = (now[c] ?? Money.zero(_currency)) -
            (before[c] ?? Money.zero(_currency));
        if (d.minor > 0 && (upBy == null || d > upBy)) {
          up = c;
          upBy = d;
        } else if (d.minor < 0 && (downBy == null || -d.minor > downBy.minor)) {
          down = c;
          downBy = Money(-d.minor, _currency);
        }
      }
    }

    final goals = snapshot.allocations
        .where((a) => a.claimId.startsWith('goal:'))
        .toList();
    return MonthReview(
      daysSeen: days,
      spent: sum(last),
      previous: previous == null ? null : sum(previous),
      up: up,
      upBy: upBy,
      down: down,
      downBy: downBy,
      goals: goals.length,
      goalsOnTrack: goals.where((a) => a.shortfall.minor <= 0).length,
      income: incomeWithin(),
      toGoals: toGoalsWithin(),
    );
  }

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
      computePlan(_input(
        at: at,
        incomeEvents: incomeEvents,
        extraEvents: [
          ...extraEvents,
          if (extraExpense != null)
            ExpenseEvent(
              id: 'scenario',
              accountId: _accountId,
              amount: extraExpense,
            ),
        ],
      ),);


  // --- bills and subscriptions (Strategy §11.1) ------------------------------

  List<Bill> get bills {
    final sorted = [..._bills]
      ..sort((Bill a, Bill b) => a.nextDue.compareTo(b.nextDue));
    return List.unmodifiable(sorted);
  }

  void addBill({
    required String name,
    required Money amount,
    required BillEvery every,
    required LocalDate nextDue,
    BillKind kind = BillKind.bill,
    String? debtAccountId,
  }) {
    _bills.add(Bill(
      id: 'b${++_billSeq}',
      name: name,
      amount: amount,
      every: every,
      nextDue: nextDue,
      kind: kind,
      debtAccountId: debtAccountId,
    ),);
    _persist();
    notifyListeners();
  }

  void updateBill(
    String id, {
    String? name,
    Money? amount,
    BillEvery? every,
    LocalDate? nextDue,
    BillKind? kind,
  }) {
    final index = _bills.indexWhere((b) => b.id == id);
    if (index < 0) return;
    _bills[index] = _bills[index].copyWith(
      name: name,
      amount: amount,
      every: every,
      nextDue: nextDue,
      kind: kind,
    );
    _persist();
    notifyListeners();
  }

  void removeBill(String id) {
    _bills.removeWhere((b) => b.id == id);
    _persist();
    notifyListeners();
  }

  /// Pay a bill: the money goes out, and the bill moves to its next date.
  /// A repayment lowers what is owed on its loan or card instead of being
  /// counted as spending.
  void payBill(String id, {Money? amount}) {
    final index = _bills.indexWhere((b) => b.id == id);
    if (index < 0) return;
    final bill = _bills[index];
    final paid = amount ?? bill.amount;
    final eventId = 'e${++_eventSeq}';
    final debt = bill.debtAccountId == null
        ? null
        : _accounts.where((a) => a.id == bill.debtAccountId).firstOrNull;
    _events.add(switch (debt?.kind) {
      AccountKind.loan => DebtPaymentEvent(
          id: eventId,
          accountId: _accountId,
          debtId: debt!.id,
          amount: paid,
        ),
      AccountKind.card => CardSettlementEvent(
          id: eventId,
          accountId: _accountId,
          cardId: debt!.id,
          amount: paid,
        ),
      _ => ExpenseEvent(id: eventId, accountId: _accountId, amount: paid),
    },);
    if (debt == null) _categories[eventId] = SpendCategory.bills;
    _recordedAt[eventId] = _now;
    _bills[index] = bill.copyWith(nextDue: bill.after(bill.nextDue));
    _persist();
    notifyListeners();
  }

  /// Payments falling due from today through [days] ahead, soonest first.
  /// One already overdue is included: it is still owed.
  List<({Bill bill, LocalDate due})> upcomingBills({int days = 30}) {
    final until = today.addDays(days);
    final out = <({Bill bill, LocalDate due})>[
      for (final b in _bills)
        for (final d in b.dueBetween(today, until)) (bill: b, due: d),
    ]..sort((a, b) => a.due.compareTo(b.due));
    return out;
  }

  /// What the bills due in the next [days] add up to (§6.3).
  Money billsDueWithin({int days = 30}) => Money.sum(
        upcomingBills(days: days).map((u) => u.bill.amount),
        _currency,
      );

  // --- pay arriving ----------------------------------------------------------

  /// The pay came. It becomes money in the balance, and the next one is
  /// expected a pay period after the one that came, at the same amount.
  void confirmIncome(Money amount) {
    final current = nextIncome;
    final id = 'e${++_eventSeq}';
    _events.add(IncomeConfirmedEvent(
      id: id,
      accountId: _accountId,
      amount: amount,
    ),);
    _recordedAt[id] = _now;
    if (current != null) {
      var next = current.expectedDate.addDays(_payCycleDays);
      if (next <= today) next = today.addDays(_payCycleDays);
      _incomeEvents
        ..clear()
        ..add(IncomeEvent(
          id: 'income-next',
          expectedAmount: current.expectedAmount,
          expectedDate: next,
          state: IncomeState.expected,
          expectedUpperAmount: current.expectedUpperAmount,
        ),);
    }
    _persist();
    notifyListeners();
  }

  /// Whether the next pay is due, so Home can ask whether it came.
  bool get payDue {
    final i = nextIncome;
    return i != null && i.isProjectable && i.expectedDate <= today;
  }

  // --- accounts (Strategy §7.2) ----------------------------------------------

  /// Accounts beyond the plan's own, in the order they were added.
  List<Account> get accounts => List.unmodifiable(_accounts);

  Account? account(String id) =>
      _accounts.where((a) => a.id == id).firstOrNull;

  void addAccount({
    required String name,
    required AccountKind kind,
    required Money opening,
    bool? counted,
  }) {
    _accounts.add(Account(
      id: 'a${++_accountSeq}',
      name: name,
      kind: kind,
      opening: opening,
      counted: counted,
    ),);
    _persist();
    notifyListeners();
  }

  void updateAccount(String id, {String? name, bool? counted}) {
    final index = _accounts.indexWhere((a) => a.id == id);
    if (index < 0) return;
    _accounts[index] = _accounts[index].copyWith(name: name, counted: counted);
    _persist();
    notifyListeners();
  }

  /// Whether anything was recorded against [id]. An account with history
  /// cannot be removed: the record would stop adding up.
  bool accountInUse(String id) =>
      _accountOf.values.contains(id) ||
      _bills.any((b) => b.debtAccountId == id) ||
      _events.any((e) => switch (e) {
            TransferEvent(:final fromAccountId, :final toAccountId) =>
              fromAccountId == id || toAccountId == id,
            CardSettlementEvent(:final cardId) => cardId == id,
            DebtPaymentEvent(:final debtId) => debtId == id,
            BalanceAdjustmentEvent(:final accountId) => accountId == id,
            _ => false,
          },);

  bool removeAccount(String id) {
    if (accountInUse(id)) return false;
    _accounts.removeWhere((a) => a.id == id);
    _persist();
    notifyListeners();
    return true;
  }

  /// What is in a money account, or what is owed on a card or loan.
  Money accountBalance(String id) {
    final ledger = snapshot.ledger;
    if (id == _accountId) {
      return ledger.balances[_accountId] ?? Money.zero(_currency);
    }
    final a = account(id);
    if (a == null) return Money.zero(_currency);
    return switch (a.kind) {
      AccountKind.card =>
        ledger.cardOutstanding[id] ?? Money.zero(_currency),
      AccountKind.loan =>
        a.opening + (ledger.debtPrincipal[id] ?? Money.zero(_currency)),
      // An included account's balance starts from its opening balance in
      // the engine; one left out starts from zero there, so it is added.
      _ => a.counted
          ? ledger.balances[id] ?? a.opening
          : a.opening + (ledger.balances[id] ?? Money.zero(_currency)),
    };
  }

  /// Money moved between two of the person's accounts: neither spent nor
  /// earned (INV-03).
  void transfer({
    required String from,
    required String to,
    required Money amount,
  }) {
    if (from == to || amount.minor <= 0) return;
    final id = 'e${++_eventSeq}';
    _events.add(TransferEvent(
      id: id,
      fromAccountId: from,
      toAccountId: to,
      amount: amount,
    ),);
    _recordedAt[id] = _now;
    _persist();
    notifyListeners();
  }

  /// Pay off some of a card from the main account: settling a debt, never a
  /// second expense (INV-09).
  void payCard(String cardId, Money amount) {
    if (amount.minor <= 0) return;
    final id = 'e${++_eventSeq}';
    _events.add(CardSettlementEvent(
      id: id,
      accountId: _accountId,
      cardId: cardId,
      amount: amount,
    ),);
    _recordedAt[id] = _now;
    _persist();
    notifyListeners();
  }

  /// Say what one account really holds. The difference is an adjustment,
  /// never spending, as for the main account.
  void confirmAccountBalance(String id, Money observed) {
    if (id == _accountId) {
      confirmBalance(observed);
      return;
    }
    final a = account(id);
    if (a == null || !a.holdsMoney) return;
    final delta = observed - accountBalance(id);
    if (delta.isZero) return;
    final eventId = 'e${++_eventSeq}';
    _events.add(BalanceAdjustmentEvent(
      id: eventId,
      accountId: id,
      delta: delta,
      reason: 'User confirmed observed balance',
    ),);
    _recordedAt[eventId] = _now;
    _persist();
    notifyListeners();
  }

  /// The account a spend was paid from; the main one unless it was another.
  String accountOf(String eventId) => _accountOf[eventId] ?? _accountId;

  // --- money coming back (Strategy §11.2) --------------------------------------

  List<Recovery> get recoveries => List.unmodifiable(_recoveries);

  Recovery? recoveryFor(String eventId) =>
      _recoveries.where((r) => r.eventId == eventId).lastOrNull;

  /// What may come back, shown apart: none of it is money yet.
  Money get moneyComingBack => Money.sum(
        _recoveries.where((r) => r.awaitingMoney).map((r) => r.expected),
        _currency,
      );

  void _setRecovery(Recovery r) {
    _recoveries
      ..removeWhere((x) => x.eventId == r.eventId)
      ..add(r);
    _persist();
    notifyListeners();
  }

  Money? _spendAmount(String eventId) {
    for (final e in _events) {
      if (e.id != eventId) continue;
      return switch (e) {
        ExpenseEvent(:final amount) => amount,
        CardPurchaseEvent(:final amount) => amount,
        _ => null,
      };
    }
    return null;
  }

  /// A purchase that can still be taken back, until [returnBy] if known.
  void markReturnable(String eventId, {LocalDate? returnBy}) {
    final amount = _spendAmount(eventId);
    if (amount == null) return;
    _setRecovery(Recovery(
      eventId: eventId,
      state: RecoveryState.returnable,
      expected: amount,
      returnBy: returnBy,
    ),);
  }

  /// Taken back, or a refund asked for: money expected, not yet money.
  void expectRefund(String eventId, {Money? amount}) {
    final spent = _spendAmount(eventId);
    if (spent == null) return;
    final current = recoveryFor(eventId);
    _setRecovery(Recovery(
      eventId: eventId,
      state: RecoveryState.refundPending,
      expected: amount ?? current?.expected ?? spent,
      returnBy: current?.returnBy,
    ),);
  }

  /// The refund arrived. Only now does it count, and it goes back to where
  /// the spend came from.
  void refundArrived(String eventId, Money amount) {
    final spent = _spendAmount(eventId);
    if (spent == null || amount.minor <= 0) return;
    final id = 'e${++_eventSeq}';
    _events.add(RefundEvent(
      id: id,
      accountId: accountOf(eventId) == _accountId ||
              account(accountOf(eventId))?.holdsMoney != true
          ? _accountId
          : accountOf(eventId),
      amount: amount,
      linkedExpenseId: eventId,
    ),);
    _recordedAt[id] = _now;
    final current = recoveryFor(eventId);
    _recoveries
      ..removeWhere((x) => x.eventId == eventId)
      ..add(Recovery(
        eventId: eventId,
        state: RecoveryState.refunded,
        expected: amount,
        returnBy: current?.returnBy,
      ),);
    _persist();
    notifyListeners();
  }

  /// Kept after all, or the refund is not coming.
  void closeRecovery(String eventId) {
    final current = recoveryFor(eventId);
    if (current == null) return;
    _setRecovery(current.to(RecoveryState.closed));
  }

  /// Money that came back put somewhere on purpose (§11.2): toward a goal,
  /// or into the emergency buffer. Leaving it is the third choice and needs
  /// no call.
  void putRecoveredToward({String? goalId, bool buffer = false, required Money amount}) {
    if (goalId != null) {
      // Toward a goal means out of reach: into savings kept outside the
      // plan, when there is such an account, so it is not counted twice.
      final savings = savingsOutsidePlan;
      if (savings != null) {
        transfer(from: _accountId, to: savings.id, amount: amount);
      }
      contributeToGoal(goalId, amount);
    } else if (buffer) {
      final current =
          _claims.where((c) => c.id == 'buffer').firstOrNull?.amount;
      setClaimAmount('buffer', (current ?? Money.zero(_currency)) + amount);
    }
  }

  List<GoalContribution> get contributions => List.unmodifiable(_contributions);

  /// The suggestion the person set aside with "not now", for this session.
  /// Not saved: a new day may deserve a fresh look.
  String? get dismissedMove => _dismissedMove;
  String? _dismissedMove;

  void dismissMove(String key) {
    _dismissedMove = key;
    notifyListeners();
  }

  /// A savings account kept out of the plan, where goal money can go.
  Account? get savingsOutsidePlan => _accounts
      .where((a) => a.kind == AccountKind.savings && !a.counted)
      .firstOrNull;

  /// Pay that came in over the last [days], as recorded.
  Money incomeWithin({int days = 30}) {
    final since = _now.subtract(Duration(days: days));
    final voided = {
      for (final e in _events)
        if (e is CorrectionEvent) e.voidsEventId,
    };
    return Money.sum(
      [
        for (final e in _events)
          if (e is IncomeConfirmedEvent &&
              !voided.contains(e.id) &&
              !(_recordedAt[e.id]?.isBefore(since) ?? true))
            e.amount,
      ],
      _currency,
    );
  }

  /// What was put toward goals over the last [days]; toward one goal
  /// when [goalId] is given.
  Money toGoalsWithin({int days = 30, String? goalId}) {
    final since = _now.subtract(Duration(days: days));
    return Money.sum(
      [
        for (final c in _contributions)
          if (!c.at.isBefore(since) && (goalId == null || c.goalId == goalId))
            c.amount,
      ],
      _currency,
    );
  }

  /// Move money toward a goal on purpose: out of the plan into savings,
  /// and recorded against the goal.
  void saveTowardGoal(String goalId, Money amount) {
    final savings = savingsOutsidePlan;
    if (savings == null || amount.minor <= 0) return;
    transfer(from: _accountId, to: savings.id, amount: amount);
    contributeToGoal(goalId, amount);
  }

  /// A what-if on the live plan: the same claims, accounts and rules, with
  /// only the moment, some extra events or the expected income changed.
  /// [recordedBy] leaves out what was recorded after that instant, which is
  /// how the plan looked then. Never changes anything.
  PlanSnapshot whatIf({
    DateTime? at,
    List<LedgerEvent> extraEvents = const [],
    List<IncomeEvent>? incomeEvents,
    DateTime? recordedBy,
    List<Claim>? ownClaims,
    List<Bill>? bills,
  }) =>
      computePlan(_input(
        at: at,
        extraEvents: extraEvents,
        incomeEvents: incomeEvents,
        recordedBy: recordedBy,
        ownClaims: ownClaims,
        bills: bills,
      ),);

  /// The claims the person set, without goals or bills.
  List<Claim> get ownClaims => List.unmodifiable(_claims);

  Allocation? allocationFor(String claimId) {
    for (final a in snapshot.allocations) {
      if (a.claimId == claimId) return a;
    }
    return null;
  }
}
