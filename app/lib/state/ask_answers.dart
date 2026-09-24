/// What the Ask chat answers, and how it knows what was asked.
///
/// The chat is a way of asking, not a second source of figures: every number
/// in an answer is read from the same engine snapshot the rest of the app
/// shows, and a purchase is answered with the same three full plans the
/// scenario cards show. The only arithmetic here is presentation — a figure
/// spread over the days it has to last, a share of a total — and it says so.
///
/// It is also honest about how well it knows the person. A plan a week old
/// has a balance and a payday and not much else; answers that lean on
/// spending history say how much history there is, and advice waits until
/// there is enough to be advice rather than a guess dressed up as one.
///
/// Understanding is keyword matching over Persian and English plus the
/// spoken-amount reader for "can I buy a phone for twenty million". A
/// question it does not recognise gets what it can answer, never a guess.
library;

import '../domain/category.dart';
import '../domain/spoken_spend.dart';
import '../engine/clock.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import 'app_state.dart';

/// How well the chat knows the person, from how long the plan has run and
/// how much of it has been recorded.
enum Acquaintance {
  /// The first couple of weeks, or hardly anything recorded.
  newcomer,

  /// Some history, less than a season of it.
  learning,

  /// A season or more: enough to talk about habits.
  familiar;

  /// A season, roughly: long enough to see a few pay cycles and the bills
  /// that only come round now and then.
  static const seasonDays = 90;

  static Acquaintance of(AppState state) {
    final days = state.daysInUse;
    if (days < 14 || state.spendCount < 5) return Acquaintance.newcomer;
    if (days < seasonDays) return Acquaintance.learning;
    return Acquaintance.familiar;
  }
}

sealed class AskAnswer {
  const AskAnswer();
}

/// The chat's opening, which changes as it gets to know the person.
class GreetingAnswer extends AskAnswer {
  const GreetingAnswer({
    required this.acquaintance,
    required this.days,
    required this.spends,
    required this.alerts,
  });

  final Acquaintance acquaintance;
  final int days;
  final int spends;

  /// Things on the bell, mentioned so the opening is useful straight away.
  final int alerts;

  int get daysToSeason =>
      (Acquaintance.seasonDays - days).clamp(0, Acquaintance.seasonDays);
}

/// "What if I bought it?" — the three plans, a sentence that sums them up,
/// and no verdict.
class PurchaseAnswer extends AskAnswer {
  const PurchaseAnswer(this.scenarios);
  final SpendScenarios scenarios;
}

class SafeToSpendAnswer extends AskAnswer {
  const SafeToSpendAnswer({
    required this.amount,
    required this.until,
    required this.days,
    required this.perDay,
    required this.trusted,
  });

  final Money amount;
  final LocalDate until;

  /// Days the figure has to last, today included.
  final int days;

  /// [amount] spread evenly over [days], rounded half-even. A way of seeing
  /// the figure, not a budget the plan enforces.
  final Money perDay;

  /// False when the balance needs confirming, which the answer says rather
  /// than presenting a stale figure as current.
  final bool trusted;
}

class NextPayAnswer extends AskAnswer {
  const NextPayAnswer({this.income, this.inDays});

  /// Null when no pay is expected.
  final IncomeEvent? income;

  /// Days from today; negative when it is late.
  final int? inDays;
}

class WhereItWentAnswer extends AskAnswer {
  const WhereItWentAnswer({required this.rows, required this.daysSeen});
  final List<({SpendCategory? category, Money total})> rows;

  /// How many of the thirty days the plan has actually been running.
  final int daysSeen;

  Money? get total => rows.isEmpty
      ? null
      : Money.sum(rows.map((r) => r.total), rows.first.total.currency);

  /// The largest sorted category's share of everything, in whole percent.
  int? get topShare {
    final t = total;
    final top = rows.where((r) => r.category != null).firstOrNull;
    if (t == null || top == null || t.minor <= 0) return null;
    return divideRoundHalfEven(top.total.minor * 100, t.minor);
  }
}

class SetAsideAnswer extends AskAnswer {
  const SetAsideAnswer({required this.total, required this.claims});
  final Money total;
  final List<({String claimId, String label, Money amount})> claims;
}

/// "How can I save more?" Only answered with specifics once there is a
/// history to be specific about.
class AdviceAnswer extends AskAnswer {
  const AdviceAnswer({
    required this.acquaintance,
    required this.days,
    this.biggest,
    this.biggestTotal,
    this.tenPercent,
    this.previousTotal,
    this.lastTotal,
  });

  final Acquaintance acquaintance;
  final int days;
  final SpendCategory? biggest;
  final Money? biggestTotal;

  /// A tenth of [biggestTotal]: what a small cut there would free up.
  final Money? tenPercent;

  /// All spending in the thirty days before the last thirty, and in the
  /// last thirty, for a month-on-month comparison.
  final Money? previousTotal;
  final Money? lastTotal;
}

enum SmallTalk { hello, thanks, whoAreYou }

class SmallTalkAnswer extends AskAnswer {
  const SmallTalkAnswer(this.kind);
  final SmallTalk kind;
}

/// Not understood: say what can be asked instead of guessing.
class HelpAnswer extends AskAnswer {
  const HelpAnswer();
}

RegExp _words(String pattern) => RegExp(pattern, caseSensitive: false);

final _hello = _words(r'^\s*(سلام|درود|salam|hi|hello|hey)\b|^\s*(سلام|درود)');
final _thanks = _words(r'مرسی|ممنون|سپاس|دمت گرم|thank|thanks|cheers');
final _who = _words(
  r'کی هستی|تو کی|چی هستی|چیکار (می|مي)?‌?تونی|چه کار (می|مي)?‌?توانی|'
  r'who are you|what are you|what can you do',
);
final _advice = _words(
  r'پس‌?\s*انداز|صرفه\s*جویی|نصیحت|پیشنهاد|راهنمایی|مشاوره|چیکار کنم|'
  r'چه کار کنم|کمتر خرج|save more|saving|advice|tip|suggest|spend less|'
  r'cut back',
);
final _safeWords = _words(
  r'چقدر\s*(می|مي)?\s*‌?\s*(تونم|توانم)|قابل\s*خرج|می‌تونم خرج|'
  r'safe to spend|how much can i|can i spend|left to spend|how much do i have',
);
final _payWords = _words(
  r'حقوق|درآمد|واریزی|پرداخت بعدی|salary|pay\b|payday|income|paid next',
);
final _whereWords = _words(
  r'کجا رفت|کجا خرج|خرج(‌| )?هام|دسته|where did|where.*go|spent on|categor',
);
final _asideWords = _words(
  r'کنار|قبض|تعهد|اجاره|set aside|protected|bills|commitments|rent',
);

/// The chat's opening line, recomputed whenever the chat is shown.
GreetingAnswer greet(AppState state) => GreetingAnswer(
      acquaintance: Acquaintance.of(state),
      days: state.daysInUse,
      spends: state.spendCount,
      alerts: state.alerts.length,
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

  if (_advice.hasMatch(text)) return _advise(state);
  if (_safeWords.hasMatch(text)) return _safeToSpend(state);
  if (aboutPay) return _nextPay(state);
  if (_whereWords.hasMatch(text)) return _whereItWent(state);
  if (_asideWords.hasMatch(text)) return _setAside(state);
  if (_who.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.whoAreYou);
  if (_thanks.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.thanks);
  if (_hello.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.hello);
  return const HelpAnswer();
}

/// The questions offered as one-tap chips, so the first message never has
/// to be typed.
enum SuggestedQuestion { safeToSpend, nextPay, whereItWent, setAside, advice }

AskAnswer answerSuggested(SuggestedQuestion q, AppState state) => switch (q) {
      SuggestedQuestion.safeToSpend => _safeToSpend(state),
      SuggestedQuestion.nextPay => _nextPay(state),
      SuggestedQuestion.whereItWent => _whereItWent(state),
      SuggestedQuestion.setAside => _setAside(state),
      SuggestedQuestion.advice => _advise(state),
    };

SafeToSpendAnswer _safeToSpend(AppState state) {
  final s = state.snapshot;
  final days = s.decisionHorizonEnd.differenceInDays(state.today) + 1;
  final spread = days < 1 ? 1 : days;
  return SafeToSpendAnswer(
    amount: s.safeToSpendNow,
    until: s.decisionHorizonEnd,
    days: spread,
    perDay: Money(
      divideRoundHalfEven(s.safeToSpendNow.minor, spread),
      s.safeToSpendNow.currency,
    ),
    trusted: s.confidenceState == ConfidenceState.trusted,
  );
}

NextPayAnswer _nextPay(AppState state) {
  final income = state.nextIncome;
  return NextPayAnswer(
    income: income,
    inDays: income?.expectedDate.differenceInDays(state.today),
  );
}

WhereItWentAnswer _whereItWent(AppState state) => WhereItWentAnswer(
      rows: state.spendingByCategory(),
      daysSeen: state.daysInUse.clamp(0, 30),
    );

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

AdviceAnswer _advise(AppState state) {
  final who = Acquaintance.of(state);
  final days = state.daysInUse;
  if (who == Acquaintance.newcomer) {
    return AdviceAnswer(acquaintance: who, days: days);
  }
  final last = state.spendingByCategory();
  final previous = state.spendingByCategory(before: 30);
  final sorted = last.where((r) => r.category != null).toList();
  final top = sorted.firstOrNull;
  Money? sum(List<({SpendCategory? category, Money total})> rows) =>
      rows.isEmpty
          ? null
          : Money.sum(rows.map((r) => r.total), rows.first.total.currency);
  return AdviceAnswer(
    acquaintance: who,
    days: days,
    biggest: top?.category,
    biggestTotal: top?.total,
    tenPercent: top == null
        ? null
        : Money(divideRoundHalfEven(top.total.minor, 10), top.total.currency),
    lastTotal: sum(last),
    // Only a full earlier month is worth comparing against.
    previousTotal: days >= 60 ? sum(previous) : null,
  );
}
