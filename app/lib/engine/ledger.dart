/// Canonical ledger events and the fold that derives modelled state (§6, §15.1).
///
/// One real-world economic event may affect spending exactly once (INV-01).
/// Events are immutable; corrections are new events, never edits.
library;

import 'money.dart';

sealed class LedgerEvent {
  const LedgerEvent({required this.id, this.canonicalId});

  final String id;

  /// Identity shared by every import of the same real-world event. The first
  /// event carrying a canonical id posts; later ones are non-posting.
  final String? canonicalId;
}

/// Cash or debit purchase: spending, once, at purchase.
class ExpenseEvent extends LedgerEvent {
  const ExpenseEvent({
    required super.id,
    required this.accountId,
    required this.amount,
    super.canonicalId,
  });
  final String accountId;
  final Money amount;
}

/// Credit-card purchase: spending once at purchase, plus card liability.
class CardPurchaseEvent extends LedgerEvent {
  const CardPurchaseEvent({
    required super.id,
    required this.cardId,
    required this.amount,
    super.canonicalId,
  });
  final String cardId;
  final Money amount;
}

/// Card settlement: debt settlement, never a second expense (INV-09).
class CardSettlementEvent extends LedgerEvent {
  const CardSettlementEvent({
    required super.id,
    required this.accountId,
    required this.cardId,
    required this.amount,
    super.canonicalId,
  });
  final String accountId;
  final String cardId;
  final Money amount;
}

class IncomeConfirmedEvent extends LedgerEvent {
  const IncomeConfirmedEvent({
    required super.id,
    required this.accountId,
    required this.amount,
    super.canonicalId,
  });
  final String accountId;
  final Money amount;
}

/// Loan principal received is not income (INV-10).
class LoanDrawdownEvent extends LedgerEvent {
  const LoanDrawdownEvent({
    required super.id,
    required this.accountId,
    required this.debtId,
    required this.amount,
    super.canonicalId,
  });
  final String accountId;
  final String debtId;
  final Money amount;
}

class DebtPaymentEvent extends LedgerEvent {
  const DebtPaymentEvent({
    required super.id,
    required this.accountId,
    required this.debtId,
    required this.amount,
    super.canonicalId,
  });
  final String accountId;
  final String debtId;
  final Money amount;
}

/// Movement between included accounts is neither income nor expense (INV-03).
class TransferEvent extends LedgerEvent {
  const TransferEvent({
    required super.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    super.canonicalId,
  });
  final String fromAccountId;
  final String toAccountId;
  final Money amount;
}

/// A refund with no identifiable linked expense enters review rather than
/// posting, so history is never silently rewritten (§6).
class RefundEvent extends LedgerEvent {
  const RefundEvent({
    required super.id,
    required this.accountId,
    required this.amount,
    this.linkedExpenseId,
    super.canonicalId,
  });
  final String accountId;
  final Money amount;
  final String? linkedExpenseId;
}

/// Observed minus modelled balance at confirmation (§15.1). Neither expense
/// nor income (INV-13). A superseded adjustment does not post; the discovered
/// real event posts in its place.
class BalanceAdjustmentEvent extends LedgerEvent {
  const BalanceAdjustmentEvent({
    required super.id,
    required this.accountId,
    required this.delta,
    required this.reason,
    this.supersededBy,
    super.canonicalId,
  });
  final String accountId;
  final Money delta;
  final String reason;
  final String? supersededBy;
}

/// A user correction (§15, §21). The voided event stays in the log: nothing
/// is erased, so the record still explains what the plan used to say.
class CorrectionEvent extends LedgerEvent {
  const CorrectionEvent({
    required super.id,
    required this.voidsEventId,
    required this.reason,
    super.canonicalId,
  });

  final String voidsEventId;
  final String reason;
}

enum QuarantineReason { duplicate, unlinkedRefund, corrected }

class QuarantinedEvent {
  const QuarantinedEvent(this.eventId, this.reason);
  final String eventId;
  final QuarantineReason reason;
}

class LedgerState {
  const LedgerState({
    required this.balances,
    required this.cardOutstanding,
    required this.debtPrincipal,
    required this.cumulativeSpending,
    required this.cumulativeIncome,
    required this.quarantined,
  });

  final Map<String, Money> balances;
  final Map<String, Money> cardOutstanding;
  final Map<String, Money> debtPrincipal;
  final Money cumulativeSpending;
  final Money cumulativeIncome;
  final List<QuarantinedEvent> quarantined;

  /// Trusted allocatable liquidity: the included accounts' balances (§13).
  Money trustedLiquidity(List<String> includedAccounts, String currency) =>
      Money.sum(
        includedAccounts.map((a) => balances[a] ?? Money.zero(currency)),
        currency,
      );

  Money totalCardOutstanding(String currency) =>
      Money.sum(cardOutstanding.values, currency);
}

/// Fold events into modelled state. Pure, and order-dependent only through
/// duplicate resolution, which keeps the first posting of a canonical event.
LedgerState reduceLedger(
  List<LedgerEvent> events, {
  required String currency,
  required List<String> includedAccounts,
  Map<String, Money>? openingBalances,
}) {
  final balances = <String, Money>{
    for (final a in includedAccounts) a: openingBalances?[a] ?? Money.zero(currency),
  };
  final cardOutstanding = <String, Money>{};
  final debtPrincipal = <String, Money>{};
  final quarantined = <QuarantinedEvent>[];
  final postedCanonical = <String>{};

  // Gathered first, because a correction is appended after the event it
  // voids and must still stop it from posting.
  final voided = <String>{
    for (final e in events)
      if (e is CorrectionEvent) e.voidsEventId,
  };
  final spending = <Money>[];
  final income = <Money>[];

  void bump(Map<String, Money> m, String k, Money delta) {
    m[k] = (m[k] ?? Money.zero(currency)) + delta;
  }

  for (final e in events) {
    if (voided.contains(e.id)) {
      quarantined.add(QuarantinedEvent(e.id, QuarantineReason.corrected));
      continue;
    }

    final canonical = e.canonicalId;
    if (canonical != null) {
      if (postedCanonical.contains(canonical)) {
        quarantined.add(QuarantinedEvent(e.id, QuarantineReason.duplicate));
        continue;
      }
      postedCanonical.add(canonical);
    }

    switch (e) {
      case ExpenseEvent(:final accountId, :final amount):
        bump(balances, accountId, -amount);
        spending.add(amount);

      case CardPurchaseEvent(:final cardId, :final amount):
        // Liability rises; no cash leaves yet. Spending is recorded once, here.
        bump(cardOutstanding, cardId, amount);
        spending.add(amount);

      case CardSettlementEvent(:final accountId, :final cardId, :final amount):
        bump(balances, accountId, -amount);
        bump(cardOutstanding, cardId, -amount);

      case IncomeConfirmedEvent(:final accountId, :final amount):
        bump(balances, accountId, amount);
        income.add(amount);

      case LoanDrawdownEvent(:final accountId, :final debtId, :final amount):
        bump(balances, accountId, amount);
        bump(debtPrincipal, debtId, amount);

      case DebtPaymentEvent(:final accountId, :final debtId, :final amount):
        bump(balances, accountId, -amount);
        bump(debtPrincipal, debtId, -amount);

      case TransferEvent(:final fromAccountId, :final toAccountId, :final amount):
        bump(balances, fromAccountId, -amount);
        bump(balances, toAccountId, amount);

      case RefundEvent(:final accountId, :final amount, :final linkedExpenseId):
        if (linkedExpenseId == null) {
          quarantined.add(QuarantinedEvent(e.id, QuarantineReason.unlinkedRefund));
        } else {
          bump(balances, accountId, amount);
          spending.add(-amount);
        }

      case BalanceAdjustmentEvent(:final accountId, :final delta, :final supersededBy):
        if (supersededBy == null) bump(balances, accountId, delta);

      case CorrectionEvent():
        // Carries no economic value of its own; its effect is the event it
        // voids, which was skipped above.
        break;
    }
  }

  return LedgerState(
    balances: balances,
    cardOutstanding: cardOutstanding,
    debtPrincipal: debtPrincipal,
    cumulativeSpending: Money.sum(spending, currency),
    cumulativeIncome: Money.sum(income, currency),
    quarantined: quarantined,
  );
}
