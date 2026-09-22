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
import '../engine/money.dart';
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

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'currency': currency,
        'openingBalance': moneyToJson(openingBalance),
        'onboarded': onboarded,
        'eventSequence': eventSequence,
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
