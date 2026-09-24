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

import '../domain/account.dart';
import '../domain/bill.dart';
import '../domain/conversation.dart';
import '../domain/goal.dart';
import '../domain/holding.dart';
import '../domain/recovery.dart';
import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/ledger.dart';
import '../engine/money.dart';

/// Bumped whenever the shape below changes. A reader that meets a *newer*
/// version refuses rather than guessing; an older one still loads, with new
/// fields taking their defaults.
///
/// 2 — added the theme preference.
/// 3 — added goals and the pay-cycle length.
/// 4 — added spend categories and when each spend was recorded.
/// 5 — added the expected yearly inflation.
/// 6 — added holdings outside the plan.
/// 7 — added bank-message suggestions and the evening reminder.
/// 8 — added when the plan was started.
/// 9 — added conversations with Ask.
/// 10 — added bills, accounts, money coming back, and goal contributions.
const int schemaVersion = 10;

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
      if (i.expectedUpperAmount != null)
        'expectedUpperAmount': moneyToJson(i.expectedUpperAmount!),
    };

IncomeEvent incomeFromJson(Map<String, Object?> json) {
  final confirmed = json['confirmedAmount'];
  return IncomeEvent(
    id: json['id']! as String,
    expectedAmount: moneyFromJson(json['expectedAmount']),
    expectedDate: localDateFromJson(json['expectedDate']),
    state: enumByName(IncomeState.values, json['state'], 'income state'),
    confirmedAmount: confirmed == null ? null : moneyFromJson(confirmed),
    expectedUpperAmount: json['expectedUpperAmount'] == null
        ? null
        : moneyFromJson(json['expectedUpperAmount']),
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

// --- goals ------------------------------------------------------------------

Map<String, Object?> goalToJson(Goal g) => {
      'id': g.id,
      'name': g.name,
      'target': moneyToJson(g.target),
      'targetDate': localDateToJson(g.targetDate),
      'saved': moneyToJson(g.saved),
      'kind': g.kind.name,
    };

Goal goalFromJson(Map<String, Object?> json) => Goal(
      id: json['id']! as String,
      name: json['name']! as String,
      target: moneyFromJson(json['target']),
      targetDate: localDateFromJson(json['targetDate']),
      saved: moneyFromJson(json['saved']),
      kind: enumByName(GoalKind.values, json['kind'], 'goal kind'),
    );

// --- holdings --------------------------------------------------------------

Map<String, Object?> holdingToJson(Holding h) => {
      'id': h.id,
      'name': h.name,
      'quantityMilli': h.quantityMilli,
      'unitPrice': moneyToJson(h.unitPrice),
      'pricedOn': localDateToJson(h.pricedOn),
    };

Holding holdingFromJson(Map<String, Object?> json) {
  final quantity = json['quantityMilli'];
  if (quantity is! int) {
    throw const UnreadablePlanDocument('holding quantity is not a whole number');
  }
  return Holding(
    id: json['id']! as String,
    name: json['name']! as String,
    quantityMilli: quantity,
    unitPrice: moneyFromJson(json['unitPrice']),
    pricedOn: localDateFromJson(json['pricedOn']),
  );
}

// --- conversations ---------------------------------------------------------

Map<String, Object?> conversationToJson(Conversation c) => {
      'id': c.id,
      'startedAt': c.startedAt.toUtc().toIso8601String(),
      'turns': [
        for (final t in c.turns)
          {
            'question': t.question,
            'askedAt': t.askedAt.toUtc().toIso8601String(),
            if (t.language != null) 'language': t.language,
          },
      ],
    };

Conversation conversationFromJson(Map<String, Object?> json) => Conversation(
      id: json['id']! as String,
      startedAt: DateTime.parse(json['startedAt']! as String),
      turns: [
        for (final raw in (json['turns'] as List?) ?? const [])
          () {
            final t = Map<String, Object?>.from(raw as Map);
            return ChatTurn(
              question: t['question']! as String,
              askedAt: DateTime.parse(t['askedAt']! as String),
              language: t['language'] as String?,
            );
          }(),
      ],
    );

// --- bills -----------------------------------------------------------------

Map<String, Object?> billToJson(Bill b) => {
      'id': b.id,
      'name': b.name,
      'amount': moneyToJson(b.amount),
      'every': b.every.name,
      'nextDue': localDateToJson(b.nextDue),
      'kind': b.kind.name,
      if (b.debtAccountId != null) 'debtAccountId': b.debtAccountId,
    };

Bill billFromJson(Map<String, Object?> json) => Bill(
      id: json['id']! as String,
      name: json['name']! as String,
      amount: moneyFromJson(json['amount']),
      every: enumByName(BillEvery.values, json['every'], 'bill period'),
      nextDue: localDateFromJson(json['nextDue']),
      kind: json['kind'] == null
          ? BillKind.bill
          : enumByName(BillKind.values, json['kind'], 'bill kind'),
      debtAccountId: json['debtAccountId'] as String?,
    );

// --- accounts ----------------------------------------------------------------

Map<String, Object?> accountToJson(Account a) => {
      'id': a.id,
      'name': a.name,
      'kind': a.kind.name,
      'opening': moneyToJson(a.opening),
      if (a.countedChoice != null) 'counted': a.countedChoice,
    };

Account accountFromJson(Map<String, Object?> json) => Account(
      id: json['id']! as String,
      name: json['name']! as String,
      kind: enumByName(AccountKind.values, json['kind'], 'account kind'),
      opening: moneyFromJson(json['opening']),
      counted: json['counted'] as bool?,
    );

// --- money coming back --------------------------------------------------------

Map<String, Object?> recoveryToJson(Recovery r) => {
      'eventId': r.eventId,
      'state': r.state.name,
      'expected': moneyToJson(r.expected),
      if (r.returnBy != null) 'returnBy': localDateToJson(r.returnBy!),
    };

Recovery recoveryFromJson(Map<String, Object?> json) => Recovery(
      eventId: json['eventId']! as String,
      state: enumByName(RecoveryState.values, json['state'], 'recovery state'),
      expected: moneyFromJson(json['expected']),
      returnBy: json['returnBy'] == null
          ? null
          : localDateFromJson(json['returnBy']),
    );

// --- goal contributions -------------------------------------------------------

Map<String, Object?> contributionToJson(GoalContribution c) => {
      'goalId': c.goalId,
      'amount': moneyToJson(c.amount),
      'at': c.at.toUtc().toIso8601String(),
    };

GoalContribution contributionFromJson(Map<String, Object?> json) =>
    GoalContribution(
      goalId: json['goalId']! as String,
      amount: moneyFromJson(json['amount']),
      at: DateTime.parse(json['at']! as String),
    );
