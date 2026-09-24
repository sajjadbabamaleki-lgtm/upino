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

class MonthReviewAnswer extends AskAnswer {
  const MonthReviewAnswer(this.review);
  final MonthReview review;
}

class SafeToSpendAnswer extends AskAnswer {
  const SafeToSpendAnswer({
    required this.amount,
    required this.until,
    required this.days,
    required this.trusted,
  });

  final Money amount;
  final LocalDate until;

  /// Days the figure has to last, today included.
  final int days;


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

enum SmallTalk {
  hello,
  thanks,
  whoAreYou,
  howAreYou,
  bye,
  okay,

  /// A greeting that comes with a question: a short hello, then the answer.
  hi,

  /// The same, when it also asked how things are.
  hiFine,
}

class SmallTalkAnswer extends AskAnswer {
  const SmallTalkAnswer(this.kind);
  final SmallTalk kind;
}

/// "Why?" — how the figure it last gave, or the main figure, comes about:
/// what there is, what is set aside first, what is left.
class WhyAnswer extends AskAnswer {
  const WhyAnswer({
    required this.have,
    required this.setAside,
    required this.left,
  });

  final Money have;
  final Money setAside;
  final Money left;
}

/// Not understood: say what can be asked instead of guessing.
class HelpAnswer extends AskAnswer {
  const HelpAnswer();
}

/// Which language to answer in: the one the question was written in.
///
/// A person who types Persian into an app that follows an English phone
/// still expects Persian back. Arabic script is Persian unless the app is
/// in Arabic; Latin script in a Persian or Arabic app is English. Null
/// means the app's own language is the right one.
String? replyLanguage(String question, String appLanguage) {
  final arabicScript = RegExp(r'[\u0600-\u06FF]').hasMatch(question);
  final latin = RegExp(r'[A-Za-z]').hasMatch(question);
  if (arabicScript) {
    if (appLanguage == 'fa' || appLanguage == 'ar') return appLanguage;
    return 'fa';
  }
  if (latin && (appLanguage == 'fa' || appLanguage == 'ar')) return 'en';
  return null;
}

RegExp _words(String pattern) => RegExp(pattern, caseSensitive: false);

// Dart's \b only knows ASCII word characters, so Persian words are bounded
// by start, end, space or punctuation explicitly.
const _end = r'(?=$|[\s،,.!؟?])';

final _hello = _words(
  r'^\s*(سلام|درود|salam|hi|hello|hey|صبح بخیر|عصر بخیر|شب بخیر|good morning|good evening)'
  '$_end',
);
final _howAreYou = _words(
  r'خوبی|چطوری|چطورید|خوبید|حالت چطوره|حالت خوبه|how are you|how.?s it going',
);
final _bye = _words(r'خداحافظ|خدانگهدار|فعلا|بای\b|bye|goodbye|see you');
final _okay = _words(
  r'^\s*(باشه|اوکی|اوکیه|حله|خب|خوبه|عالیه|فهمیدم|ok|okay|got it|cool|great|nice)'
  '$_end',
);
final _why = _words(r'^\s*(چرا|از کجا|why|how come)' '$_end');
final _thanks = _words(r'مرسی|ممنون|سپاس|دمت گرم|thank|thanks|cheers');
final _who = _words(
  r'کی هستی|تو کی|چی هستی|اسمت چیه|چیکار (می|مي)?‌?تونی|چه کار (می|مي)?‌?توانی|'
  r'who are you|what are you|your name|what can you do',
);
final _advice = _words(
  r'پس‌?\s*انداز|صرفه\s*جویی|نصیحت|پیشنهاد|راهنمایی|مشاوره|چیکار کنم|'
  r'چه کار کنم|کمتر خرج|save more|saving|advice|tip|suggest|spend less|'
  r'cut back',
);
final _safeWords = _words(
  r'چقدر\s*(می|مي)?\s*‌?\s*(تونم|توانم)|قابل\s*خرج|می‌تونم خرج|چقدر پول دارم|'
  r'چقدر مونده|safe to spend|how much can i|can i spend|left to spend|'
  r'how much do i have',
);
final _payWords = _words(
  r'حقوق|درآمد|واریزی|پرداخت بعدی|salary|pay\b|payday|income|paid next',
);
final _whereWords = _words(
  r'کجا رفت|کجا خرج|خرج(‌| )?هام|دسته|where did|where.*go|spent on|categor',
);
final _monthWords = _words(
  r'ماهم|این ماه|ماه (گذشته|قبل|پیش)|مرور ماه|خلاصه(ٔ|ی)? ماه|ماهانه|'
  r'my month|this month|last month|month review|monthly|how did i do',
);
final _asideWords = _words(
  r'کنار|قبض|تعهد|اجاره|set aside|protected|bills|commitments|rent',
);

/// Greetings and pleasantries at the start of a message, so "hi, how much
/// can I spend?" is heard as a greeting and a question.
final _leadingPleasantry = _words(
  r'^\s*(سلام|درود|salam|hi|hello|hey|خوبی|چطوری)\s*[،,.!؟?]*\s*',
);

/// The chat's opening line, recomputed whenever the chat is shown.
GreetingAnswer greet(AppState state) => GreetingAnswer(
      acquaintance: Acquaintance.of(state),
      days: state.daysInUse,
      spends: state.spendCount,
      alerts: state.alerts.length,
    );

/// Everything said in reply to one message: usually one answer, sometimes a
/// greeting and then the answer.
List<AskAnswer> reply(String question, AppState state) {
  final text = question.trim();
  final lead = _leadingPleasantry.firstMatch(text);
  if (lead != null && lead.end < text.length) {
    // Pleasantries can come in a row: "سلام خوبی؟ ..." — strip them all.
    var rest = text.substring(lead.end).trim();
    for (var m = _leadingPleasantry.firstMatch(rest);
        m != null && m.end < rest.length;
        m = _leadingPleasantry.firstMatch(rest)) {
      rest = rest.substring(m.end).trim();
    }
    final askedHow = _howAreYou.hasMatch(text);
    final answer = answerQuestion(rest, state);
    // Nothing but pleasantries: answer them as such.
    if (answer is SmallTalkAnswer || answer is HelpAnswer) {
      return [
        SmallTalkAnswer(askedHow ? SmallTalk.howAreYou : SmallTalk.hello),
      ];
    }
    // A greeting with a question gets a short hello, not a second question
    // back before the answer.
    return [
      SmallTalkAnswer(askedHow ? SmallTalk.hiFine : SmallTalk.hi),
      answer,
    ];
  }
  return [answerQuestion(text, state)];
}

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

  if (_why.hasMatch(text)) return _explain(state);
  if (_advice.hasMatch(text)) return _advise(state);
  if (_safeWords.hasMatch(text)) return _safeToSpend(state);
  if (aboutPay) return _nextPay(state);
  if (_whereWords.hasMatch(text)) return _whereItWent(state);
  if (_monthWords.hasMatch(text)) return MonthReviewAnswer(state.monthReview);
  if (_asideWords.hasMatch(text)) return _setAside(state);
  if (_who.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.whoAreYou);
  if (_howAreYou.hasMatch(text)) {
    return const SmallTalkAnswer(SmallTalk.howAreYou);
  }
  if (_thanks.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.thanks);
  if (_bye.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.bye);
  if (_hello.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.hello);
  if (_okay.hasMatch(text)) return const SmallTalkAnswer(SmallTalk.okay);
  return const HelpAnswer();
}

WhyAnswer _explain(AppState state) {
  final s = state.snapshot;
  return WhyAnswer(
    have: s.trustedAllocatableLiquidity,
    setAside: s.protectedTotal,
    left: s.safeToSpendNow,
  );
}

/// The questions offered as one-tap chips, so the first message never has
/// to be typed.
enum SuggestedQuestion {
  safeToSpend,
  nextPay,
  whereItWent,
  setAside,
  monthReview,
  advice,
}

AskAnswer answerSuggested(SuggestedQuestion q, AppState state) => switch (q) {
      SuggestedQuestion.safeToSpend => _safeToSpend(state),
      SuggestedQuestion.nextPay => _nextPay(state),
      SuggestedQuestion.whereItWent => _whereItWent(state),
      SuggestedQuestion.setAside => _setAside(state),
      SuggestedQuestion.monthReview => MonthReviewAnswer(state.monthReview),
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
