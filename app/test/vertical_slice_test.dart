// The G2 vertical slice, §18: onboarding → first plan → Home → Quick Expense
// → immediate recalculation.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/engine/plan.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

void main() {
  _reopenTests();
  _setupIsObviousTests();

  late AppState state;

  setUp(() {
    state = AppState(
      now: DateTime.utc(2026, 10, 1, 10),
      utcOffset: const Duration(hours: 2),
    );
  });

  /// A tall surface so the whole form is laid out; the default 800x600 test
  /// window leaves the lower fields unbuilt inside the scroll view.
  /// [currency] is tapped when onboarding opens on the currency question, so
  /// tests about the form that follows it do not each repeat the step. Pass
  /// null to stop at the question itself.
  Future<void> boot(WidgetTester tester, {String? currency = 'EUR'}) async {
    tester.view
      ..physicalSize = const Size(420, 1800)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(UpinoApp(state: state));
    await tester.pumpAndSettle();
    if (currency != null && find.text('Which currency?').evaluate().isNotEmpty) {
      await tester.tap(find.byKey(Key('currency-$currency')));
      await tester.pumpAndSettle();
    }
  }

  /// The optional commitments are collapsed by default, so the test opens
  /// them the way a person would.
  Future<void> openCommitments(WidgetTester tester) async {
    await tester.tap(find.text('Add your commitments'));
    await tester.pumpAndSettle();
  }

  /// Fields are addressed by name, so the test says what it means and does
  /// not silently pass when the form is reordered.
  Future<void> enterAmount(WidgetTester tester, String field, String value) async {
    await tester.enterText(
      find.descendant(
        of: find.byKey(Key('field-$field')),
        matching: find.byType(TextField),
      ),
      value,
    );
    await tester.pump();
  }

  testWidgets('a new user reaches a Safe-to-Spend figure and spends against it',
      (tester) async {
    await boot(tester);

    // 1. Onboarding opens, and the action stays disabled until the two
    //    required answers are in.
    expect(find.text('Set up your plan'), findsOneWidget);
    final cta = find.widgetWithText(FilledButton, 'See what I can spend');
    expect(tester.widget<FilledButton>(cta).onPressed, isNull);

    await enterAmount(tester, 'balance', '3000.00');
    await enterAmount(tester, 'income', '2000.00');
    await openCommitments(tester);
    await enterAmount(tester, 'rent', '1200.00');
    await enterAmount(tester, 'essentials', '400.00');
    expect(tester.widget<FilledButton>(cta).onPressed, isNotNull);

    // 2. Finishing produces the first plan immediately.
    await tester.tap(cta);
    await tester.pumpAndSettle();

    expect(find.text('Your plan'), findsOneWidget);
    // 3000 − 1200 rent − 400 essentials = 1400.
    expect(find.text('€1,400.00'), findsOneWidget);
    expect(state.snapshot.safeToSpendNow.toString(), '1400.00 EUR');
    expect(state.snapshot.confidenceState, ConfidenceState.trusted);

    // 3. Quick Expense: amount, save. Nothing else on the path.
    await tester.tap(find.widgetWithText(FilledButton, 'Record a spend'));
    await tester.pumpAndSettle();
    expect(find.text('How much did you spend?'), findsOneWidget);

    final save = find.widgetWithText(FilledButton, 'Save');
    expect(tester.widget<FilledButton>(save).onPressed, isNull);

    await tester.enterText(find.byType(TextField).last, '25.00');
    await tester.pump();
    await tester.tap(save);
    await tester.pumpAndSettle();

    // 4. The figure recalculates immediately, with a transient confirmation.
    expect(find.text('€1,375.00'), findsOneWidget);
    expect(state.snapshot.safeToSpendNow.toString(), '1375.00 EUR');
    expect(find.text('€25.00 recorded'), findsOneWidget);
    expect(state.snapshot.ledger.cumulativeSpending.toString(), '25.00 EUR');
  });

  testWidgets('confirming a lower balance corrects liquidity, not spending',
      (tester) async {
    await boot(tester);
    await enterAmount(tester, 'balance', '2040.00');
    await enterAmount(tester, 'income', '2000.00');
    await tester.tap(find.widgetWithText(FilledButton, 'See what I can spend'));
    await tester.pumpAndSettle();

    expect(find.text('€2,040.00'), findsOneWidget);

    state.confirmBalance(Money.parse('1840.00', 'EUR'));
    await tester.pumpAndSettle();

    expect(find.text('€1,840.00'), findsOneWidget);
    // §15.1: an adjustment is neither expense nor income (INV-13).
    expect(state.snapshot.ledger.cumulativeSpending.toString(), '0.00 EUR');
  });

  testWidgets('committing more than you have shows the gap, not a smaller number',
      (tester) async {
    await boot(tester);
    await enterAmount(tester, 'balance', '900.00');
    await enterAmount(tester, 'income', '2000.00');
    await openCommitments(tester);
    await enterAmount(tester, 'rent', '500.00');
    await enterAmount(tester, 'essentials', '300.00');
    await enterAmount(tester, 'goal', '300.00');
    await tester.tap(find.widgetWithText(FilledButton, 'See what I can spend'));
    await tester.pumpAndSettle();

    final s = state.snapshot;
    expect(s.safeToSpendNow.toString(), '0.00 EUR');
    expect(s.mandatoryFundingGap.toString(), '200.00 EUR');

    expect(find.text('€0.00'), findsOneWidget);
    expect(find.text('€200.00 short'), findsOneWidget);
    expect(find.text('See what is short'), findsOneWidget);

    // The breakdown names the claim rather than moving it.
    await tester.tap(find.text('See what is short'));
    await tester.pumpAndSettle();
    expect(find.text('What is short'), findsOneWidget);
    expect(find.textContaining('Savings goal'), findsWidgets);
  });

  testWidgets('a simulated purchase leaves the live plan untouched', (tester) async {
    await boot(tester);
    await enterAmount(tester, 'balance', '1000.00');
    await enterAmount(tester, 'income', '2000.00');
    await openCommitments(tester);
    await enterAmount(tester, 'rent', '400.00');
    await tester.tap(find.widgetWithText(FilledButton, 'See what I can spend'));
    await tester.pumpAndSettle();

    expect(state.snapshot.safeToSpendNow.toString(), '600.00 EUR');

    final scenario = state.simulateExpense(Money.parse('500.00', 'EUR'));
    expect(scenario.safeToSpendNow.toString(), '100.00 EUR');

    // §22 RunScenario is non-mutating.
    expect(state.snapshot.safeToSpendNow.toString(), '600.00 EUR');
    await tester.pumpAndSettle();
    expect(find.text('€600.00'), findsOneWidget);
  });
}

// Closing and reopening the app. This is what persistence is for: the plan a
// person built is still there, and the figure they trusted is unchanged.
void _reopenTests() {
  group('reopening the app', () {
    late InMemoryPlanStore store;

    setUp(() => store = InMemoryPlanStore());

    /// [currency] is tapped when onboarding opens on the currency question.
    /// Left null so each test says for itself whether it gets that far.
    Future<AppState> boot(WidgetTester tester, {String? currency}) async {
      final state = AppState(
        now: DateTime.utc(2026, 10, 1, 10),
        utcOffset: const Duration(hours: 2),
        store: store,
      );
      await state.restore();
      tester.view
        ..physicalSize = const Size(420, 1800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      if (currency != null) {
        await tester.tap(find.byKey(Key('currency-$currency')));
        await tester.pumpAndSettle();
      }
      return state;
    }

    testWidgets('a finished plan comes back instead of the setup form',
        (tester) async {
      final first = await boot(tester, currency: 'EUR');
      expect(find.text('Set up your plan'), findsOneWidget);

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('field-balance')),
          matching: find.byType(TextField),
        ),
        '3000.00',
      );
      await tester.pump();
      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('field-income')),
          matching: find.byType(TextField),
        ),
        '2000.00',
      );
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'See what I can spend'));
      await tester.pumpAndSettle();

      expect(find.text('€3,000.00'), findsOneWidget);
      first.recordExpense(Money.parse('25.00', 'EUR'));
      await tester.pumpAndSettle();
      expect(find.text('€2,975.00'), findsOneWidget);

      // Close and reopen against the same storage.
      final second = await boot(tester);
      expect(second.isOnboarded, isTrue);
      expect(find.text('Which currency?'), findsNothing);
      expect(find.text('Set up your plan'), findsNothing);
      expect(find.text('Your plan'), findsOneWidget);
      expect(find.text('€2,975.00'), findsOneWidget);
      expect(second.snapshot.ledger.cumulativeSpending,
          Money.parse('25.00', 'EUR'),);
    });

    testWidgets('a corrupt file sends the user to setup, not to a wrong figure',
        (tester) async {
      store = InMemoryPlanStore('{{{ truncated');
      final state = await boot(tester, currency: null);
      expect(state.restoreFailure, isNotNull);
      // Onboarding from the top, which starts at the currency question.
      expect(find.text('Which currency?'), findsOneWidget);
    });
  });
}

// Found by installing the app on a real phone: the setup screen looked like a
// dead end. The amount fields showed "0.00", which reads as a filled value
// rather than an empty one, and the disabled button gave no reason.
void _setupIsObviousTests() {
  group('the setup screen says what to do', () {
    Future<void> boot(WidgetTester tester) async {
      tester.view
        ..physicalSize = const Size(420, 1800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(
        state: AppState(
          now: DateTime.utc(2026, 10, 1, 10),
          utcOffset: const Duration(hours: 2),
        ),
      ),);
      await tester.pumpAndSettle();
      // Past the currency question; these tests are about the form after it.
      await tester.tap(find.byKey(const Key('currency-EUR')));
      await tester.pumpAndSettle();
    }

    testWidgets('empty fields invite typing rather than showing a value',
        (tester) async {
      await boot(tester);
      expect(find.text('Tap to type'), findsWidgets);
      expect(find.text('0.00'), findsNothing,
          reason: 'a zero placeholder reads as an amount already entered',);
    });

    testWidgets('a disabled button explains what is missing', (tester) async {
      await boot(tester);
      final cta = find.widgetWithText(FilledButton, 'See what I can spend');
      expect(tester.widget<FilledButton>(cta).onPressed, isNull);
      expect(
        find.text('Fill in the first two answers to continue'),
        findsOneWidget,
      );
    });

    testWidgets('the explanation disappears once the button works',
        (tester) async {
      await boot(tester);
      for (final field in ['balance', 'income']) {
        await tester.enterText(
          find.descendant(
            of: find.byKey(Key('field-$field')),
            matching: find.byType(TextField),
          ),
          '100.00',
        );
        await tester.pump();
      }
      final cta = find.widgetWithText(FilledButton, 'See what I can spend');
      expect(tester.widget<FilledButton>(cta).onPressed, isNotNull);
      expect(
        find.text('Fill in the first two answers to continue'),
        findsNothing,
      );
    });
  });
}
