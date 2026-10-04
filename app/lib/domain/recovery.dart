/// Getting money back (Strategy §11.2): a purchase that can be returned, one
/// that was returned, and the refund on its way.
///
/// None of it counts as money until the refund actually arrives. An expected
/// refund is shown, never spent: it does not raise Safe-to-Spend until it is
/// confirmed (INV-04 in spirit — money that has not arrived is not money).
library;

import '../engine/clock.dart';
import '../engine/money.dart';

enum RecoveryState {
  /// Bought, and can still be taken back until [Recovery.returnBy].
  returnable,

  /// Taken back; the refund has not been asked for or has not been seen.
  returned,

  /// A refund is expected.
  refundPending,

  /// The refund arrived and is in the balance.
  refunded,

  /// Kept after all, or the refund is not coming. Nothing more to follow.
  closed,
}

class Recovery {
  const Recovery({
    required this.eventId,
    required this.state,
    required this.expected,
    this.returnBy,
  });

  /// The spend this is about.
  final String eventId;
  final RecoveryState state;

  /// What should come back. The whole spend unless the person said less.
  final Money expected;

  /// The last day it can be returned, when the person knows it. Never
  /// guessed: a shop's policy is not something to infer (§11.1).
  final LocalDate? returnBy;

  bool get open =>
      state != RecoveryState.refunded && state != RecoveryState.closed;

  /// Money that may come back, which is shown apart from the plan.
  bool get awaitingMoney =>
      state == RecoveryState.returned || state == RecoveryState.refundPending;

  Recovery to(RecoveryState next, {Money? expected}) => Recovery(
        eventId: eventId,
        state: next,
        expected: expected ?? this.expected,
        returnBy: returnBy,
      );
}
