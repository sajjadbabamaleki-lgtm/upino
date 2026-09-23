// Ask Before You Spend (§3.3).
//
// The point of this feature is that it never touches the plan and never
// answers the question for the user. Both of those are properties that would
// be easy to break later without anyone noticing, so both are pinned here.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/screens/ask_screen.dart';
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

  group('the screen', () {
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

    testWidgets('reached from Home and shows all three scenarios',
        (tester) async {
      await open(tester, funded(balance: '1000.00', rent: '900.00'));
      expect(find.byType(AskScreen), findsOneWidget);

      await tester.enterText(find.byKey(const Key('ask-amount')), '500');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('ask-run')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('ask-do-not-buy')), findsOneWidget);
      expect(find.byKey(const Key('ask-buy-now')), findsOneWidget);
      expect(find.byKey(const Key('ask-buy-after')), findsOneWidget);
    });

    testWidgets('gives no verdict and recommends nothing', (tester) async {
      // §7 puts the decision with the user. If a "recommended" chip ever
      // appears on one of these cards, this test is what should stop it.
      await open(tester, funded(balance: '1000.00', rent: '900.00'));
      await tester.enterText(find.byKey(const Key('ask-amount')), '500');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('ask-run')));
      await tester.pumpAndSettle();

      expect(find.text('Upino does not say yes or no. The trade-off is yours.'),
          findsOneWidget,);
      for (final word in ['Recommended', 'Best', 'You should', 'Yes', 'No']) {
        expect(find.text(word), findsNothing, reason: word);
      }
    });

    testWidgets('states the assumption on the card that depends on it',
        (tester) async {
      await open(tester, funded(balance: '1000.00', rent: '900.00'));
      await tester.enterText(find.byKey(const Key('ask-amount')), '500');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('ask-run')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('ask-buy-after')),
          matching: find.textContaining('Assumes your pay arrives'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('running it records nothing', (tester) async {
      final state = funded();
      await open(tester, state);
      await tester.enterText(find.byKey(const Key('ask-amount')), '700');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('ask-run')));
      await tester.pumpAndSettle();

      expect(state.activity, isEmpty);
      expect(state.snapshot.ledger.cumulativeSpending, eur('0.00'));
    });

    testWidgets('the action stays disabled until an amount is entered',
        (tester) async {
      await open(tester, funded());
      final run = find.byKey(const Key('ask-run'));
      expect(tester.widget<FilledButton>(run).onPressed, isNull);

      await tester.enterText(find.byKey(const Key('ask-amount')), '0');
      await tester.pumpAndSettle();
      // Zero is not a purchase, so it is not a question either.
      expect(tester.widget<FilledButton>(run).onPressed, isNull);

      await tester.enterText(find.byKey(const Key('ask-amount')), '25');
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(run).onPressed, isNotNull);
    });

    testWidgets('changing the amount clears the previous answer',
        (tester) async {
      await open(tester, funded());
      await tester.enterText(find.byKey(const Key('ask-amount')), '700');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('ask-run')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('ask-buy-now')), findsOneWidget);

      await tester.enterText(find.byKey(const Key('ask-amount')), '900');
      await tester.pumpAndSettle();
      // A stale answer beside a new number is worse than no answer.
      expect(find.byKey(const Key('ask-buy-now')), findsNothing);
    });
  });
}
