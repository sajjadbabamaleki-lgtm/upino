/// Turning plan state into a durable document and back.
///
/// Two rules govern everything here:
///
/// * Enums persist by **name**, never by index. An index would silently change
///   meaning the moment a case is inserted into [Priority] or
///   [ReservationState], which would rewrite a saved plan's semantics without
///   anyone touching the file.
/// * Money persists as its integer minor units plus its currency, exactly as
///   §5 holds it. No decimal string, no double, nothing to re-parse wrongly.
library;

import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/ledger.dart';
import '../engine/money.dart';

/// Bumped whenever the shape below changes. A reader that meets a *newer*
/// version refuses rather than guessing; an older one still loads, with new
/// fields taking their defaults.
///
/// 2 — added the theme preference.
const int schemaVersion = 2;

class UnreadablePlanDocument implements Exception {
  const UnreadablePlanDocument(this.reason);
  final String reason;

  @override
  String toString() => 'UnreadablePlanDocument: $reason';
}

// --- primitives ------------------------------------------------------------

Map<String, Object?> moneyToJson(Money m) => {
      'minor': m.minor,
      'currency': m.currency,
    };

Money moneyFromJson(Object? raw) {
  if (raw is! Map) throw const UnreadablePlanDocument('money is not an object');
  final minor = raw['minor'];
  final currency = raw['currency'];
  if (minor is! int || currency is! String) {
    throw const UnreadablePlanDocument('money is missing minor or currency');
  }
  return Money(minor, currency);
}

String localDateToJson(LocalDate d) => d.toString();

LocalDate localDateFromJson(Object? raw) {
  if (raw is! String) throw const UnreadablePlanDocument('date is not a string');
  return LocalDate.parse(raw);
}

T enumByName<T extends Enum>(List<T> values, Object? raw, String what) {
  if (raw is! String) throw UnreadablePlanDocument('$what is not a string');
  for (final value in values) {
    if (value.name == raw) return value;
  }
  throw UnreadablePlanDocument('unknown $what "$raw"');
}

// --- reservations ----------------------------------------------------------

Map<String, Object?> reservationToJson(Reservation r) => {
      'amount': moneyToJson(r.amount),
      'consumed': moneyToJson(r.consumed),
      'state': r.state.name,
    };

Reservation reservationFromJson(Map<String, Object?> json) => Reservation(
      moneyFromJson(json['amount']),
      consumed: moneyFromJson(json['consumed']),
      state: enumByName(ReservationState.values, json['state'], 'reservation state'),
    );

// --- claims ----------------------------------------------------------------

Map<String, Object?> claimToJson(Claim c) => {
      'id': c.id,
      'priority': c.priority.name,
      'label': c.label,
      'amount': moneyToJson(c.amount),
      if (c.dueDate != null) 'dueDate': localDateToJson(c.dueDate!),
      if (c.userPriority != null) 'userPriority': c.userPriority,
      if (c.reservation != null) 'reservation': reservationToJson(c.reservation!),
    };

Claim claimFromJson(Map<String, Object?> json) {
  final reservation = json['reservation'];
  final dueDate = json['dueDate'];
  return Claim(
    id: json['id']! as String,
    priority: enumByName(Priority.values, json['priority'], 'priority'),
    label: json['label']! as String,
    amount: moneyFromJson(json['amount']),
    dueDate: dueDate == null ? null : localDateFromJson(dueDate),
    userPriority: json['userPriority'] as int?,
    reservation: reservation == null
        ? null
        : reservationFromJson(Map<String, Object?>.from(reservation as Map)),
  );
}

// --- income ----------------------------------------------------------------

Map<String, Object?> incomeToJson(IncomeEvent i) => {
      'id': i.id,
      'expectedAmount': moneyToJson(i.expectedAmount),
      'expectedDate': localDateToJson(i.expectedDate),
      'state': i.state.name,
      if (i.confirmedAmount != null)
        'confirmedAmount': moneyToJson(i.confirmedAmount!),
    };

IncomeEvent incomeFromJson(Map<String, Object?> json) {
  final confirmed = json['confirmedAmount'];
  return IncomeEvent(
    id: json['id']! as String,
    expectedAmount: moneyFromJson(json['expectedAmount']),
    expectedDate: localDateFromJson(json['expectedDate']),
    state: enumByName(IncomeState.values, json['state'], 'income state'),
    confirmedAmount: confirmed == null ? null : moneyFromJson(confirmed),
  );
}

// --- ledger events ---------------------------------------------------------

/// Discriminator strings are fixed forever. Renaming one orphans every saved
/// event of that kind, so a new kind gets a new string rather than a reused
/// one.
Map<String, Object?> ledgerEventToJson(LedgerEvent e) {
  final base = <String, Object?>{
    'id': e.id,
    if (e.canonicalId != null) 'canonicalId': e.canonicalId,
  };
  return switch (e) {
    ExpenseEvent(:final accountId, :final amount) => {
        ...base,
        'kind': 'expense',
        'accountId': accountId,
        'amount': moneyToJson(amount),
      },
    CardPurchaseEvent(:final cardId, :final amount) => {
        ...base,
        'kind': 'cardPurchase',
        'cardId': cardId,
        'amount': moneyToJson(amount),
      },
    CardSettlementEvent(:final accountId, :final cardId, :final amount) => {
        ...base,
        'kind': 'cardSettlement',
        'accountId': accountId,
        'cardId': cardId,
        'amount': moneyToJson(amount),
      },
    IncomeConfirmedEvent(:final accountId, :final amount) => {
        ...base,
        'kind': 'incomeConfirmed',
        'accountId': accountId,
        'amount': moneyToJson(amount),
      },
    LoanDrawdownEvent(:final accountId, :final debtId, :final amount) => {
        ...base,
        'kind': 'loanDrawdown',
        'accountId': accountId,
        'debtId': debtId,
        'amount': moneyToJson(amount),
      },
    DebtPaymentEvent(:final accountId, :final debtId, :final amount) => {
        ...base,
        'kind': 'debtPayment',
        'accountId': accountId,
        'debtId': debtId,
        'amount': moneyToJson(amount),
      },
    TransferEvent(:final fromAccountId, :final toAccountId, :final amount) => {
        ...base,
        'kind': 'transfer',
        'fromAccountId': fromAccountId,
        'toAccountId': toAccountId,
        'amount': moneyToJson(amount),
      },
    RefundEvent(:final accountId, :final amount, :final linkedExpenseId) => {
        ...base,
        'kind': 'refund',
        'accountId': accountId,
        'amount': moneyToJson(amount),
        if (linkedExpenseId != null) 'linkedExpenseId': linkedExpenseId,
      },
    CorrectionEvent(:final voidsEventId, :final reason) => {
        ...base,
        'kind': 'correction',
        'voidsEventId': voidsEventId,
        'reason': reason,
      },
    BalanceAdjustmentEvent(
      :final accountId,
      :final delta,
      :final reason,
      :final supersededBy,
    ) =>
      {
        ...base,
        'kind': 'balanceAdjustment',
        'accountId': accountId,
        'delta': moneyToJson(delta),
        'reason': reason,
        if (supersededBy != null) 'supersededBy': supersededBy,
      },
  };
}

LedgerEvent ledgerEventFromJson(Map<String, Object?> json) {
  final id = json['id']! as String;
  final canonicalId = json['canonicalId'] as String?;
  Money amount() => moneyFromJson(json['amount']);

  return switch (json['kind']) {
    'expense' => ExpenseEvent(
        id: id,
        accountId: json['accountId']! as String,
        amount: amount(),
        canonicalId: canonicalId,
      ),
    'cardPurchase' => CardPurchaseEvent(
        id: id,
        cardId: json['cardId']! as String,
        amount: amount(),
        canonicalId: canonicalId,
      ),
    'cardSettlement' => CardSettlementEvent(
        id: id,
        accountId: json['accountId']! as String,
        cardId: json['cardId']! as String,
        amount: amount(),
        canonicalId: canonicalId,
      ),
    'incomeConfirmed' => IncomeConfirmedEvent(
        id: id,
        accountId: json['accountId']! as String,
        amount: amount(),
        canonicalId: canonicalId,
      ),
    'loanDrawdown' => LoanDrawdownEvent(
        id: id,
        accountId: json['accountId']! as String,
        debtId: json['debtId']! as String,
        amount: amount(),
        canonicalId: canonicalId,
      ),
    'debtPayment' => DebtPaymentEvent(
        id: id,
        accountId: json['accountId']! as String,
        debtId: json['debtId']! as String,
        amount: amount(),
        canonicalId: canonicalId,
      ),
    'transfer' => TransferEvent(
        id: id,
        fromAccountId: json['fromAccountId']! as String,
        toAccountId: json['toAccountId']! as String,
        amount: amount(),
        canonicalId: canonicalId,
      ),
    'refund' => RefundEvent(
        id: id,
        accountId: json['accountId']! as String,
        amount: amount(),
        linkedExpenseId: json['linkedExpenseId'] as String?,
        canonicalId: canonicalId,
      ),
    'correction' => CorrectionEvent(
        id: id,
        voidsEventId: json['voidsEventId']! as String,
        reason: json['reason']! as String,
        canonicalId: canonicalId,
      ),
    'balanceAdjustment' => BalanceAdjustmentEvent(
        id: id,
        accountId: json['accountId']! as String,
        delta: moneyFromJson(json['delta']),
        reason: json['reason']! as String,
        supersededBy: json['supersededBy'] as String?,
        canonicalId: canonicalId,
      ),
    final unknown => throw UnreadablePlanDocument('unknown event kind "$unknown"'),
  };
}
