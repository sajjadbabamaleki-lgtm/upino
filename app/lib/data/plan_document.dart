/// The whole durable state of a plan, as one document.
///
/// The ledger is an append-only log and the snapshot is derived, so nothing
/// computed is stored: reopening the app replays the log through the engine
/// and arrives at the same numbers (INV-07). That also means a stored
/// document can never disagree with the engine.
library;

import 'dart:convert';

import '../engine/domain.dart';
import '../engine/ledger.dart';
import '../domain/account.dart';
import '../domain/bill.dart';
import '../domain/category.dart';
import '../domain/conversation.dart';
import '../domain/goal.dart';
import '../domain/holding.dart';
import '../domain/recovery.dart';
import '../engine/money.dart';
import '../state/app_state.dart' show ThemeChoice;
import 'serialization.dart';

class PlanDocument {
  const PlanDocument({
    required this.currency,
    required this.openingBalance,
    required this.events,
    required this.claims,
    required this.incomeEvents,
    required this.onboarded,
    this.lastBalanceConfirmationAt,
    this.eventSequence = 0,
    this.themeChoice = ThemeChoice.system,
    this.languageCode,
    this.receipts = const {},
    this.categories = const {},
    this.recordedAt = const {},
    this.goals = const [],
    this.payCycleDays = 30,
    this.inflationBasisPoints,
    this.holdings = const [],
    this.smsEnabled = false,
    this.smsSince,
    this.smsHandled = const [],
    this.reminderEnabled = false,
    this.startedAt,
    this.firstRun = const {},
    this.conversations = const [],
    this.bills = const [],
    this.accounts = const [],
    this.accountOf = const {},
    this.recoveries = const [],
    this.contributions = const [],
  });

  final String currency;
  final Money openingBalance;
  final List<LedgerEvent> events;
  final List<Claim> claims;
  final List<IncomeEvent> incomeEvents;
  final bool onboarded;
  final DateTime? lastBalanceConfirmationAt;

  /// Kept so ids stay unique across restarts; regenerating from the log's
  /// length would collide after any event is ever dropped.
  final int eventSequence;

  /// A preference rather than plan data, but it lives here so there is one
  /// thing to save and one thing to read back.
  final ThemeChoice themeChoice;

  /// Null follows the phone's language.
  final String? languageCode;

  /// Event id to the receipt image stored for it, as a filename inside the
  /// app's own directory. Kept out of the ledger because the engine is pure
  /// and a photograph is evidence about a transaction, not part of the
  /// money arithmetic (§15.3, Purchase Lifecycle).
  final Map<String, String> receipts;

  /// Event id to what the spend was for. Kept beside the ledger for the same
  /// reason as a receipt: it describes a transaction without changing the
  /// arithmetic.
  final Map<String, SpendCategory> categories;

  /// Event id to when it was recorded, which is what lets spending be
  /// grouped by period. Ledger events carry no time of their own.
  final Map<String, DateTime> recordedAt;
  final List<Goal> goals;

  /// How long a pay period is, which is what a goal's contribution schedule
  /// divides by (§8).
  final int payCycleDays;

  /// The yearly inflation the person expects, in basis points. A whole
  /// number rather than a percentage so no binary fraction is involved.
  final int? inflationBasisPoints;

  /// Savings kept outside the plan's currency, shown beside it and never
  /// counted in it.
  final List<Holding> holdings;

  /// Whether bank messages are read to suggest spends, from when, and which
  /// messages have already been answered so none is offered twice.
  final bool smsEnabled;
  final DateTime? smsSince;
  final List<String> smsHandled;

  /// Whether the evening reminder is on.
  final bool reminderEnabled;

  /// When the plan was set up, so Ask can tell how well it knows the person.
  final DateTime? startedAt;

  /// First-run progress: welcome seen, sign-in, the setup draft, the primary
  /// intent and whether the first reveal is still to show. Onboarding state
  /// only; the engine never reads it.
  final Map<String, Object?> firstRun;

  /// What was asked of Ask, oldest first. Only questions are kept; answers
  /// are recomputed from the plan when a conversation is shown.
  final List<Conversation> conversations;

  /// Bills and subscriptions, each a claim on the money until it is paid.
  final List<Bill> bills;

  /// Accounts beyond the plan's own. The main account is not listed; its
  /// opening balance is [openingBalance].
  final List<Account> accounts;

  /// Event id to the account a spend was paid from, for spends not paid from
  /// the main account. Kept beside the ledger like a category.
  final Map<String, String> accountOf;

  /// Purchases that can be, or were, taken back.
  final List<Recovery> recoveries;

  /// Money put toward goals, and when.
  final List<GoalContribution> contributions;

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'currency': currency,
        'openingBalance': moneyToJson(openingBalance),
        'onboarded': onboarded,
        'eventSequence': eventSequence,
        'themeChoice': themeChoice.name,
        if (languageCode != null) 'languageCode': languageCode,
        'payCycleDays': payCycleDays,
        if (inflationBasisPoints != null)
          'inflationBasisPoints': inflationBasisPoints,
        'goals': goals.map(goalToJson).toList(),
        if (holdings.isNotEmpty)
          'holdings': holdings.map(holdingToJson).toList(),
        if (smsEnabled) 'smsEnabled': true,
        if (smsSince != null) 'smsSince': smsSince!.toUtc().toIso8601String(),
        if (smsHandled.isNotEmpty) 'smsHandled': smsHandled,
        if (reminderEnabled) 'reminderEnabled': true,
        if (firstRun.isNotEmpty) 'firstRun': firstRun,
        if (startedAt != null)
          'startedAt': startedAt!.toUtc().toIso8601String(),
        if (conversations.isNotEmpty)
          'conversations': conversations.map(conversationToJson).toList(),
        if (bills.isNotEmpty) 'bills': bills.map(billToJson).toList(),
        if (accounts.isNotEmpty)
          'accounts': accounts.map(accountToJson).toList(),
        if (accountOf.isNotEmpty) 'accountOf': accountOf,
        if (recoveries.isNotEmpty)
          'recoveries': recoveries.map(recoveryToJson).toList(),
        if (contributions.isNotEmpty)
          'contributions': contributions.map(contributionToJson).toList(),
        if (receipts.isNotEmpty) 'receipts': receipts,
        if (categories.isNotEmpty)
          'categories': {
            for (final e in categories.entries) e.key: e.value.name,
          },
        if (recordedAt.isNotEmpty)
          'recordedAt': {
            for (final e in recordedAt.entries)
              e.key: e.value.toUtc().toIso8601String(),
          },
        if (lastBalanceConfirmationAt != null)
          'lastBalanceConfirmationAt':
              lastBalanceConfirmationAt!.toUtc().toIso8601String(),
        'events': events.map(ledgerEventToJson).toList(),
        'claims': claims.map(claimToJson).toList(),
        'incomeEvents': incomeEvents.map(incomeToJson).toList(),
      };

  static PlanDocument fromJson(Map<String, Object?> json) {
    final version = json['schemaVersion'];
    if (version is! int) {
      throw const UnreadablePlanDocument('missing schemaVersion');
    }
    if (version > schemaVersion) {
      throw UnreadablePlanDocument(
        'document is version $version; this build reads up to $schemaVersion',
      );
    }

    List<T> listOf<T>(Object? raw, T Function(Map<String, Object?>) read) {
      if (raw == null) return <T>[];
      if (raw is! List) throw const UnreadablePlanDocument('expected a list');
      return raw
          .map((e) => read(Map<String, Object?>.from(e as Map)))
          .toList();
    }

    final confirmedAt = json['lastBalanceConfirmationAt'];

    return PlanDocument(
      currency: json['currency']! as String,
      openingBalance: moneyFromJson(json['openingBalance']),
      events: listOf(json['events'], ledgerEventFromJson),
      claims: listOf(json['claims'], claimFromJson),
      incomeEvents: listOf(json['incomeEvents'], incomeFromJson),
      onboarded: json['onboarded'] as bool? ?? false,
      eventSequence: json['eventSequence'] as int? ?? 0,
      // Absent in a version 1 document, which simply means "follow the phone".
      goals: listOf(json['goals'], goalFromJson),
      holdings: listOf(json['holdings'], holdingFromJson),
      smsEnabled: json['smsEnabled'] as bool? ?? false,
      smsSince: json['smsSince'] == null
          ? null
          : DateTime.parse(json['smsSince']! as String),
      smsHandled: [
        for (final id in (json['smsHandled'] as List?) ?? const []) id as String,
      ],
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      firstRun: json['firstRun'] == null
          ? const {}
          : (json['firstRun']! as Map).cast<String, Object?>(),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt']! as String),
      conversations: listOf(json['conversations'], conversationFromJson),
      bills: listOf(json['bills'], billFromJson),
      accounts: listOf(json['accounts'], accountFromJson),
      accountOf: json['accountOf'] == null
          ? const {}
          : Map<String, String>.from(json['accountOf'] as Map),
      recoveries: listOf(json['recoveries'], recoveryFromJson),
      contributions: listOf(json['contributions'], contributionFromJson),
      payCycleDays: json['payCycleDays'] as int? ?? 30,
      inflationBasisPoints: json['inflationBasisPoints'] as int?,
      themeChoice: json['themeChoice'] == null
          ? ThemeChoice.system
          : enumByName(ThemeChoice.values, json['themeChoice'], 'theme choice'),
      languageCode: json['languageCode'] as String?,
      receipts: json['receipts'] == null
          ? const {}
          : Map<String, String>.from(json['receipts'] as Map),
      categories: {
        for (final e in ((json['categories'] as Map?) ?? const {}).entries)
          e.key as String:
              enumByName(SpendCategory.values, e.value, 'spend category'),
      },
      recordedAt: {
        for (final e in ((json['recordedAt'] as Map?) ?? const {}).entries)
          e.key as String: DateTime.parse(e.value as String),
      },
      lastBalanceConfirmationAt:
          confirmedAt == null ? null : DateTime.parse(confirmedAt as String),
    );
  }

  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());

  static PlanDocument decode(String source) {
    final Object? parsed;
    try {
      parsed = jsonDecode(source);
    } on FormatException catch (e) {
      throw UnreadablePlanDocument('not valid JSON: ${e.message}');
    }
    if (parsed is! Map) {
      throw const UnreadablePlanDocument('document root is not an object');
    }
    return fromJson(Map<String, Object?>.from(parsed));
  }
}
