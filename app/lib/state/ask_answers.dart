/// What the Ask chat answers, and how it knows what was asked.
///
/// The chat is a way of asking, not a second source of figures: every number
/// in an answer is read from the same engine snapshot the rest of the app
/// shows, and a purchase is answered with the same three full plans the Ask
/// screen shows. Nothing here does arithmetic of its own, so the chat cannot
/// say a number the plan does not.
///
/// Understanding is keyword matching over Persian and English, plus the
/// spoken-amount reader for "can I buy a phone for twenty million". It is
/// deliberately narrow: a question it does not recognise gets the list of
/// what it can answer, never a guess.
library;

import '../domain/category.dart';
import '../domain/spoken_spend.dart';
import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import 'app_state.dart';

sealed class AskAnswer {
  const AskAnswer();
}

/// "What if I bought it?" — the three plans, and no verdict.
class PurchaseAnswer extends AskAnswer {
  const PurchaseAnswer(this.scenarios);
  final SpendScenarios scenarios;
}

class SafeToSpendAnswer extends AskAnswer {
  const SafeToSpendAnswer({
    required this.amount,
    required this.until,
    required this.trusted,
  });

  final Money amount;
  final LocalDate until;

  /// False when the balance needs confirming, which the answer says rather
  /// than presenting a stale figure as current.
  final bool trusted;
}

class NextPayAnswer extends AskAnswer {
  const NextPayAnswer(this.income);

  /// Null when no pay is expected.
  final IncomeEvent? income;
}

class WhereItWentAnswer extends AskAnswer {
  const WhereItWentAnswer(this.rows);
  final List<({SpendCategory? category, Money total})> rows;
}

class SetAsideAnswer extends AskAnswer {
  const SetAsideAnswer({required this.total, required this.claims});
  final Money total;
  final List<({String claimId, String label, Money amount})> claims;
}

/// Not understood: say what can be asked instead of guessing.
class HelpAnswer extends AskAnswer {
  const HelpAnswer();
}

final _safeWords = RegExp(
  r'چقدر\s*(می|مي)?\s*[‌]?\s*(تونم|توانم)|قابل\s*خرج|می‌تونم خرج|'
  r'safe to spend|how much can i|can i spend|left to spend|how much do i have',
  caseSensitive: false,
);
final _payWords = RegExp(
  r'حقوق|درآمد|واریزی|پرداخت بعدی|salary|pay\b|payday|income|paid next',
  caseSensitive: false,
);
final _whereWords = RegExp(
  r'کجا رفت|کجا خرج|خرج(‌| )?هام|دسته|where did|where.*go|spent on|categor',
  caseSensitive: false,
);
final _asideWords = RegExp(
  r'کنار|قبض|تعهد|اجاره|set aside|protected|bills|commitments|rent',
  caseSensitive: false,
);

AskAnswer answerQuestion(String question, AppState state) {
  final text = question.trim();

  // A number in the question makes it a purchase, unless the words say it
  // is about something else ("my pay is 20 million" is not a purchase).
  final spoken = parseSpokenSpend(text, planCurrency: state.currency);
  final amount = spoken.amount;
  final aboutPay = _payWords.hasMatch(text);
  if (amount != null && !aboutPay) {
    return PurchaseAnswer(state.simulatePurchase(amount));
  }

  if (_safeWords.hasMatch(text)) return _safeToSpend(state);
  if (aboutPay) return NextPayAnswer(state.nextIncome);
  if (_whereWords.hasMatch(text)) {
    return WhereItWentAnswer(state.spendingByCategory());
  }
  if (_asideWords.hasMatch(text)) return _setAside(state);
  return const HelpAnswer();
}

/// The questions offered as one-tap chips, so the first message never has
/// to be typed.
enum SuggestedQuestion { safeToSpend, nextPay, whereItWent, setAside }

AskAnswer answerSuggested(SuggestedQuestion q, AppState state) => switch (q) {
      SuggestedQuestion.safeToSpend => _safeToSpend(state),
      SuggestedQuestion.nextPay => NextPayAnswer(state.nextIncome),
      SuggestedQuestion.whereItWent =>
        WhereItWentAnswer(state.spendingByCategory()),
      SuggestedQuestion.setAside => _setAside(state),
    };

SafeToSpendAnswer _safeToSpend(AppState state) {
  final s = state.snapshot;
  return SafeToSpendAnswer(
    amount: s.safeToSpendNow,
    until: s.decisionHorizonEnd,
    trusted: s.confidenceState == ConfidenceState.trusted,
  );
}

SetAsideAnswer _setAside(AppState state) {
  final s = state.snapshot;
  return SetAsideAnswer(
    total: s.protectedTotal,
    claims: [
      for (final a in s.allocations)
        if (a.allocated.minor > 0)
          (claimId: a.claimId, label: a.label, amount: a.allocated),
    ],
  );
}
