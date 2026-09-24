// Ask Before You Spend (§3.3).
//
// The point of this feature is that it never touches the plan and never
// answers the question for the user. Both of those are properties that would
// be easy to break later without anyone noticing, so both are pinned here.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/screens/ask_chat_screen.dart';
import 'package:upino/state/ask_answers.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded({String balance = '2000.00', String rent = '0.00'}) {
  final state = AppState(
    now: DateTime.utc(2026, 10, 1, 10),
    utcOffset: const Duration(hours: 2),
  )..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur(balance)
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-31')
        ..payCycleDays = 30,
    );
  if (rent != '0.00') state.setClaimAmount('rent', eur(rent));
  return state;
}

void main() {
  group('the simulation', () {
    test('never touches the live plan', () {
      // The engine is pure, but nothing stops a caller writing to state on
      // the way past. This is the assertion that keeps it honest.
      final state = funded();
      final before = state.snapshot.safeToSpendNow;
      final events = state.snapshot.ledger.cumulativeSpending;

      state.simulatePurchase(eur('700.00'));

      expect(state.snapshot.safeToSpendNow, before);
      expect(state.snapshot.ledger.cumulativeSpending, events);
      expect(state.activity, isEmpty);
    });

    test('buying now lowers the figure by exactly the amount', () {
      final state = funded();
      final r = state.simulatePurchase(eur('700.00'));
      expect(
        r.doNotBuy.safeToSpendNow - r.buyNow.safeToSpendNow,
        eur('700.00'),
      );
    });

    test('doing nothing is the current plan, not a recomputation of it', () {
      final state = funded();
      final r = state.simulatePurchase(eur('700.00'));
      expect(r.doNotBuy.safeToSpendNow, state.snapshot.safeToSpendNow);
      expect(r.doNotBuy.mandatoryFundingGap, state.snapshot.mandatoryFundingGap);
    });

    test('names which commitments lose funding, worst first', () {
      // "Something is short" is not actionable; the row that lost the money
      // is. Rent is the only claim here, so it takes the whole shortfall.
      final state = funded(balance: '1000.00', rent: '900.00');
      final r = state.simulatePurchase(eur('500.00'));

      expect(r.breaksNow, isTrue);
      expect(r.costsNow, isNotEmpty);
      expect(r.costsNow.first.claimId, 'rent');
      expect(r.costsNow.first.lost, eur('400.00'));
    });

    test('a purchase the plan absorbs breaks nothing', () {
      final state = funded(balance: '2000.00', rent: '500.00');
      final r = state.simulatePurchase(eur('100.00'));
      expect(r.breaksNow, isFalse);
      expect(r.costsNow, isEmpty);
    });

    test('waiting for pay is offered only when it actually helps', () {
      // Breaks today, covered after income: the one comparison the engine can
      // make without assuming anything about behaviour.
      final state = funded(balance: '1000.00', rent: '900.00');
      final r = state.simulatePurchase(eur('500.00'));
      expect(r.buyAfterIncome, isNotNull);
      expect(r.breaksAfterIncome, isFalse);
      expect(r.waitingHelps, isTrue);

      // Affordable either way: waiting is not presented as an improvement.
      final easy = funded(balance: '2000.00', rent: '100.00');
      expect(easy.simulatePurchase(eur('50.00')).waitingHelps, isFalse);
    });

    test('with no expected pay there is no later scenario to compare', () {
      final state = AppState(now: DateTime.utc(2026, 10, 1, 10))
        ..completeOnboarding(
          OnboardingDraft()
            ..currentBalance = eur('2000.00')
            ..incomeAmount = eur('0.00')
            ..payCycleDays = 30,
        );
      final r = state.simulatePurchase(eur('100.00'));
      expect(r.buyAfterIncome, isNull);
      expect(r.waitingHelps, isFalse);
    });

    test('the after-pay figure comes from the engine, not from arithmetic', () {
      // A snapshot, with its own allocations — not projectedSafeToSpend minus
      // the amount, which would drift from the waterfall the moment a claim
      // changed.
      final state = funded(balance: '1000.00', rent: '900.00');
      final r = state.simulatePurchase(eur('500.00'));
      expect(r.buyAfterIncome!.allocations, isNotEmpty);
      expect(r.buyAfterIncome!.engineVersion, r.doNotBuy.engineVersion);
    });
  });

  group('the chat', () {
    Future<void> open(WidgetTester tester, AppState state) async {
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-ask')));
      await tester.pumpAndSettle();
    }

    Future<void> ask(WidgetTester tester, String text) async {
      await tester.enterText(find.byKey(const Key('chat-input')), text);
      await tester.tap(find.byKey(const Key('chat-send')));
      await tester.pumpAndSettle();
    }

    testWidgets('reached from Home, answers a price with all three scenarios',
        (tester) async {
      await open(tester, funded(balance: '1000.00', rent: '900.00'));
      expect(find.byType(ChatPage), findsOneWidget);

      await ask(tester, '500');

      expect(find.byKey(const Key('ask-do-not-buy')), findsOneWidget);
      expect(find.byKey(const Key('ask-buy-now')), findsOneWidget);
      expect(find.byKey(const Key('ask-buy-after')), findsOneWidget);
    });

    testWidgets('gives no verdict and recommends nothing', (tester) async {
      // §7 puts the decision with the user. If a "recommended" chip ever
      // appears on one of these cards, this test is what should stop it.
      await open(tester, funded(balance: '1000.00', rent: '900.00'));
      await ask(tester, 'a phone for 500');

      expect(find.text('Upino does not say yes or no. The trade-off is yours.'),
          findsOneWidget,);
      for (final word in ['Recommended', 'Best', 'You should', 'Yes', 'No']) {
        expect(find.text(word), findsNothing, reason: word);
      }
    });

    testWidgets('states the assumption on the card that depends on it',
        (tester) async {
      await open(tester, funded(balance: '1000.00', rent: '900.00'));
      await ask(tester, '500');

      expect(
        find.descendant(
          of: find.byKey(const Key('ask-buy-after')),
          matching: find.textContaining('Assumes your pay arrives'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('asking records nothing', (tester) async {
      final state = funded();
      await open(tester, state);
      await ask(tester, '700');

      expect(state.activity, isEmpty);
      expect(state.snapshot.ledger.cumulativeSpending, eur('0.00'));
    });

    testWidgets('a suggestion is answered from the plan', (tester) async {
      final state = funded();
      await open(tester, state);
      await tester.tap(find.byKey(const Key('chat-suggest-safeToSpend')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(state.snapshot.safeToSpendNow.display()),
        findsWidgets,
      );
    });

    testWidgets('a question it cannot read gets what it can answer, '
        'not a guess', (tester) async {
      await open(tester, funded());
      await ask(tester, 'tell me a joke');
      expect(find.byKey(const Key('chat-answer-help')), findsOneWidget);
    });

    testWidgets('a conversation is kept, and reopens from the Ask tab',
        (tester) async {
      final state = funded();
      await open(tester, state);
      await ask(tester, 'when is my next pay?');
      await tester.tap(find.byKey(const Key('chat-back')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('nav-4')));
      await tester.pumpAndSettle();
      final past = state.conversations.single;
      await tester.tap(find.byKey(Key('ask-past-${past.id}')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('chat-answer-pay')), findsOneWidget);
    });

    testWidgets('Persian gets Persian back, in an English app', (tester) async {
      await open(tester, funded());
      await ask(tester, 'سلام');
      expect(find.text('سلام! دربارهٔ پولت چی می‌خوای بدونی؟'), findsOneWidget);
      // The opening and the chips follow the conversation into Persian.
      expect(find.textContaining("You're new here"), findsNothing);
      expect(find.text('چقدر می‌تونم خرج کنم؟'), findsOneWidget);
    });

    testWidgets('a greeting and a question get both', (tester) async {
      await open(tester, funded());
      await ask(tester, 'سلام، چقدر می‌تونم خرج کنم؟');
      expect(find.byKey(const Key('chat-answer-smalltalk')), findsOneWidget);
      expect(find.byKey(const Key('chat-answer-safe')), findsOneWidget);
    });

    testWidgets('why explains the figure', (tester) async {
      await open(tester, funded());
      await ask(tester, 'چرا؟');
      expect(find.byKey(const Key('chat-answer-why')), findsOneWidget);
    });
  });

  group('the Ask tab', () {
    Future<void> openHub(WidgetTester tester, AppState state) async {
      tester.view
        ..physicalSize = const Size(420, 2000)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-4')));
      await tester.pumpAndSettle();
    }

    testWidgets('is a hub, not a text box', (tester) async {
      await openHub(tester, funded());
      expect(find.byKey(const Key('ask-hero')), findsOneWidget);
      expect(find.byType(ChatPage), findsNothing);
      await tester.tap(find.byKey(const Key('ask-start')));
      await tester.pumpAndSettle();
      expect(find.byType(ChatPage), findsOneWidget);
    });

    testWidgets('common questions show part of their answer already',
        (tester) async {
      final state = funded();
      await openHub(tester, state);
      expect(
        find.descendant(
          of: find.byKey(const Key('ask-common-safeToSpend')),
          matching: find.textContaining(state.snapshot.safeToSpendNow.display()),
        ),
        findsOneWidget,
      );
    });

    testWidgets('a common question opens the chat already asked',
        (tester) async {
      final state = funded();
      await openHub(tester, state);
      await tester.tap(find.byKey(const Key('ask-common-nextPay')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('chat-answer-pay')), findsOneWidget);
      expect(state.conversations, hasLength(1));
    });

    testWidgets('a past conversation can be deleted, after a yes',
        (tester) async {
      final state = funded();
      final id = state.startConversation();
      state.ask(id, 'hi');
      await openHub(tester, state);
      await tester.drag(find.byKey(Key('ask-past-$id')), const Offset(-500, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('ask-delete-yes')));
      await tester.pumpAndSettle();
      expect(state.conversations, isEmpty);
    });
  });

  group('conversations are kept', () {
    test('questions and their language survive reopening', () async {
      final store = InMemoryPlanStore();
      final state = AppState(
        now: DateTime.utc(2026, 10, 1, 10),
        store: store,
      )..completeOnboarding(
          OnboardingDraft()
            ..currentBalance = eur('2000.00')
            ..incomeAmount = eur('2000.00')
            ..nextIncomeDate = LocalDate.parse('2026-10-31'),
        );
      final id = state.startConversation();
      state
        ..ask(id, 'سلام', language: 'fa')
        ..ask(id, 'how much can I spend');
      final reopened = AppState(now: DateTime.utc(2026, 10, 2), store: store);
      await reopened.restore();
      final c = reopened.conversations.single;
      expect(c.turns.map((t) => t.question), ['سلام', 'how much can I spend']);
      expect(c.turns.first.language, 'fa');
    });

    test('opening a chat and leaving saves nothing', () {
      final state = funded()..startConversation();
      expect(state.conversations, isEmpty);
    });
  });

  group('the reply language', () {
    test('follows the question', () {
      expect(replyLanguage('سلام', 'en'), 'fa');
      expect(replyLanguage('hello', 'fa'), 'en');
      expect(replyLanguage('hello', 'en'), isNull);
      expect(replyLanguage('مرحبا', 'ar'), 'ar');
      expect(replyLanguage('1500', 'fa'), isNull);
    });
  });

  group('understanding the question', () {
    test('a price in Persian is a purchase', () {
      final a = answerQuestion('یه گوشی ۲۰ میلیونی بخرم؟', funded());
      expect(a, isA<PurchaseAnswer>());
      expect((a as PurchaseAnswer).scenarios.amount, eur('20000000.00'));
    });

    test('a number about pay is not a purchase', () {
      expect(answerQuestion('حقوقم ۲۰ میلیونه کی میاد؟', funded()),
          isA<NextPayAnswer>(),);
    });

    test('the everyday questions, in both languages', () {
      final state = funded();
      expect(answerQuestion('چقدر می‌تونم خرج کنم؟', state),
          isA<SafeToSpendAnswer>(),);
      expect(answerQuestion('How much can I spend?', state),
          isA<SafeToSpendAnswer>(),);
      expect(answerQuestion('پولم کجا رفت؟', state), isA<WhereItWentAnswer>());
      expect(answerQuestion('what is set aside for bills', state),
          isA<SetAsideAnswer>(),);
    });

    test('the safe-to-spend answer is the plan\'s own figure', () {
      final state = funded();
      final a = answerQuestion('how much can i spend', state)
          as SafeToSpendAnswer;
      expect(a.amount, state.snapshot.safeToSpendNow);
      expect(a.until, state.snapshot.decisionHorizonEnd);
    });
  });

  group('getting to know the person', () {
    AppState later(AppState from, int days) =>
        AppState(now: DateTime.utc(2026, 10, 1, 10).add(Duration(days: days)))
          ..replaceWith(from.toDocument());

    test('a new plan is a newcomer, and says so', () {
      final g = greet(funded());
      expect(g.acquaintance, Acquaintance.newcomer);
    });

    test('weeks of recorded spending make it a learner', () {
      final state = funded();
      for (var i = 0; i < 6; i++) {
        state.recordExpense(eur('10.00'));
      }
      expect(greet(later(state, 30)).acquaintance, Acquaintance.learning);
      expect(greet(later(state, 30)).daysToSeason, 60);
    });

    test('a season makes it familiar', () {
      final state = funded();
      for (var i = 0; i < 6; i++) {
        state.recordExpense(eur('10.00'));
      }
      expect(greet(later(state, 95)).acquaintance, Acquaintance.familiar);
    });

    test('the start date survives reopening', () {
      final state = funded();
      final reopened = later(state, 10);
      expect(reopened.daysInUse, 10);
    });

    test('advice waits until it would be more than a guess', () {
      final a = answerQuestion('how can I save more?', funded());
      expect(a, isA<AdviceAnswer>());
      expect((a as AdviceAnswer).biggest, isNull);
      expect(a.acquaintance, Acquaintance.newcomer);
    });

    test('with history, advice names the biggest category and a tenth of it',
        () {
      final state = AppState(now: DateTime.utc(2026, 10, 1, 10))
        ..completeOnboarding(
          OnboardingDraft()
            ..currentBalance = eur('3000.00')
            ..incomeAmount = eur('2000.00')
            ..nextIncomeDate = LocalDate.parse('2026-10-31'),
        );
      final month = later(state, 40);
      for (var i = 0; i < 6; i++) {
        month.recordExpense(eur('50.00'), category: SpendCategory.food);
      }
      month.recordExpense(eur('20.00'), category: SpendCategory.fun);
      final a = answerQuestion('پس‌انداز بیشتر', month) as AdviceAnswer;
      expect(a.acquaintance, Acquaintance.learning);
      expect(a.biggest, SpendCategory.food);
      expect(a.biggestTotal, eur('300.00'));
      expect(a.tenPercent, eur('30.00'));
    });
  });

  group('talking like a person', () {
    test('how are you, bye and ok', () {
      final state = funded();
      expect((answerQuestion('خوبی؟', state) as SmallTalkAnswer).kind,
          SmallTalk.howAreYou,);
      expect((answerQuestion('چطوری', state) as SmallTalkAnswer).kind,
          SmallTalk.howAreYou,);
      expect((answerQuestion('خداحافظ', state) as SmallTalkAnswer).kind,
          SmallTalk.bye,);
      expect((answerQuestion('باشه', state) as SmallTalkAnswer).kind,
          SmallTalk.okay,);
    });

    test('a greeting with a question is both', () {
      final r = reply('سلام خوبی؟ حقوقم کی میاد', funded());
      expect((r.first as SmallTalkAnswer).kind, SmallTalk.hiFine);
      expect(r.last, isA<NextPayAnswer>());
      expect(r, hasLength(2));

      final hello = reply('سلام خوبی', funded());
      expect((hello.single as SmallTalkAnswer).kind, SmallTalk.howAreYou);
    });

    test('why adds up to the figure', () {
      final state = funded(balance: '1000.00', rent: '400.00');
      final a = answerQuestion('why?', state) as WhyAnswer;
      expect(a.left, state.snapshot.safeToSpendNow);
    });

    test('greetings, thanks and who-are-you', () {
      final state = funded();
      expect((answerQuestion('سلام', state) as SmallTalkAnswer).kind,
          SmallTalk.hello,);
      expect((answerQuestion('merci, thanks!', state) as SmallTalkAnswer).kind,
          SmallTalk.thanks,);
      expect((answerQuestion('تو کی هستی؟', state) as SmallTalkAnswer).kind,
          SmallTalk.whoAreYou,);
    });

    test('what can be spent, spread over the days it has to last', () {
      final state = funded();
      final a = answerQuestion('how much can I spend', state)
          as SafeToSpendAnswer;
      expect(a.days, a.until.differenceInDays(state.today) + 1);
      expect(a.perDay.minor * a.days,
          closeTo(a.amount.minor, a.days.toDouble()),);
    });

    test('pay is counted down in days', () {
      final a = answerQuestion('when is my pay', funded()) as NextPayAnswer;
      expect(a.inDays, 30);
    });

    testWidgets('the chat opens with the greeting for where the person is',
        (tester) async {
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-ask')));
      await tester.pumpAndSettle();
      expect(find.textContaining("You're new here"), findsOneWidget);
    });

    testWidgets('a purchase gets a one-line summary before the cards',
        (tester) async {
      tester.view
        ..physicalSize = const Size(420, 1600)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('home-ask')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('chat-input')), '100');
      await tester.tap(find.byKey(const Key('chat-send')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('keeps everything you must pay covered'),
        findsOneWidget,
      );
    });
  });
}
