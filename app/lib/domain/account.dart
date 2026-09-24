/// Manual accounts (Strategy §7.2): where money is kept, without connecting
/// a bank.
///
/// The engine already keeps a balance per account and counts only the
/// included ones as money the plan can use. This is the person's side of
/// that: a name, a kind, and whether it counts.
library;

import '../engine/money.dart';

enum AccountKind {
  /// A current account. The plan's own account is one of these.
  bank,
  cash,

  /// Savings are kept out of the plan unless the person says otherwise:
  /// money put away is usually not money meant for this month.
  savings,

  /// A credit card: spending on it is spending now, and what is owed on it
  /// is set aside until it is paid (§9, INV-16).
  card,

  /// A loan: what is owed, going down as it is paid.
  loan,
}

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.kind,
    required this.opening,
    bool? counted,
  }) : _counted = counted;

  /// The plan's first account, which every spend went to before there were
  /// others. Its opening balance is the plan's opening balance.
  static const mainId = 'main';

  final String id;
  final String name;
  final AccountKind kind;

  /// The balance when it was added; for a card or loan, what was owed then.
  final Money opening;
  final bool? _counted;

  /// Whether the balance is money the plan can use. Only money-holding
  /// accounts can count; what is owed is handled as a claim, not a balance.
  bool get counted => switch (kind) {
        AccountKind.card || AccountKind.loan => false,
        AccountKind.savings => _counted ?? false,
        AccountKind.bank || AccountKind.cash => _counted ?? true,
      };

  bool get holdsMoney =>
      kind == AccountKind.bank ||
      kind == AccountKind.cash ||
      kind == AccountKind.savings;

  /// Whether a spend can be paid from it.
  bool get canPay =>
      kind == AccountKind.bank ||
      kind == AccountKind.cash ||
      kind == AccountKind.card;

  bool get isDebt => kind == AccountKind.card || kind == AccountKind.loan;

  Account copyWith({String? name, bool? counted}) => Account(
        id: id,
        name: name ?? this.name,
        kind: kind,
        opening: opening,
        counted: counted ?? _counted,
      );

  /// Stored only when the person chose it, so a default can still change.
  bool? get countedChoice => _counted;
}
