import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/state/setup_draft.dart';

void main() {
  AppState fresh() => AppState(now: DateTime.utc(2026, 10, 1, 10));

  SetupDraft draft(AppState state) => SetupDraft(currency: 'EUR')
    ..currencyChosen = true
    ..intent = SetupIntent.payOffDebt
    ..intents = {SetupIntent.payOffDebt: const Money(450000, 'EUR')}
    ..incomes = [
      SetupIncome(
        amount: const Money(300000, 'EUR'),
        next: state.today.addDays(20),
      ),
    ]
    ..available = const Money(200000, 'EUR')
    ..obligations = [
      SetupObligation(
        kind: ObligationKind.rent,
        amount: const Money(90000, 'EUR'),
        due: state.today.addDays(5),
      ),
    ]
    ..obligationsDone = true
    ..essentials = const Money(30000, 'EUR')
    ..protectSkipped = true;

  group('the first run', () {
    testWidgets('opens on the language, then the welcome', (tester) async {
      tester.view
        ..physicalSize = const Size(420, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: fresh()));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('language-continue')), findsOneWidget);

      await tester.tap(find.byKey(const Key('language-continue')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('language-continue')), findsNothing);
    });

    test('setup turns the answers into a plan, then the reveal', () {
      final state = fresh()..completeSetup(draft(fresh()));
      expect(state.isOnboarded, isTrue);
      expect(state.revealPending, isTrue);
      expect(state.currency, 'EUR');
      // What is there, less the rent due before pay and the essentials.
      expect(state.snapshot.safeToSpendNow.toString(), '800.00 EUR');

      state.finishReveal();
      expect(state.revealPending, isFalse);
    });

    test('finishing twice never doubles a bill', () {
      final state = fresh();
      final d = draft(state);
      state
        ..completeSetup(d)
        ..completeSetup(d);
      expect(state.bills, hasLength(1));
      expect(state.snapshot.safeToSpendNow.toString(), '800.00 EUR');
    });

    test('the draft keeps every help choice and its number', () {
      final back = SetupDraft.fromJson(draft(fresh()).toJson());
      expect(back.intents, {SetupIntent.payOffDebt: const Money(450000, 'EUR')});
      expect(back.intent, SetupIntent.payOffDebt);
    });
  });
}
