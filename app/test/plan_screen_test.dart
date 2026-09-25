// Editing the plan after setup.
//
// A change here must move the figure the same way the same change would have
// moved it during onboarding: the screen issues domain commands, it does not
// compute anything.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/widgets/sts_hero.dart';

/// The figure in the hero; the pay card repeats it lower down.
Finder inHero(String text) =>
    find.descendant(of: find.byType(StsHero), matching: find.text(text));

final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded() => AppState(now: now, utcOffset: cest)..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur('1000.00')
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-28')
        ..rent = eur('400.00'),
    );

/// A state backed by storage, restored first, exactly as the app starts up.
/// Skipping the restore leaves the UI on the loading screen, whose spinner
/// never settles.
Future<AppState> fundedWithStore(PlanStore store) async {
  final state = AppState(now: now, utcOffset: cest, store: store);
  await state.restore();
  return state
    ..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur('1000.00')
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-28')
        ..rent = eur('400.00'),
    );
}

void main() {
  group('editing commitments', () {
    test('changing an amount moves the figure', () {
      final state = funded();
      expect(state.snapshot.safeToSpendNow, eur('600.00'));

      state.setClaimAmount('rent', eur('500.00'));
      expect(state.snapshot.safeToSpendNow, eur('500.00'));
    });

    test('adding a commitment protects it in waterfall order', () {
      final state = funded()..setClaimAmount('essentials', eur('300.00'));
      expect(state.snapshot.safeToSpendNow, eur('300.00'));
      expect(
        state.editableClaims.map((c) => c.id).toList(),
        ['rent', 'essentials'],
        reason: 'rent is P2 and must be listed before P4 essentials',
      );
    });

    test('rows are ordered by the waterfall, not by when they were added', () {
      final state = funded()
        ..setClaimAmount('buffer', eur('100.00'))
        ..setClaimAmount('card-minimum', eur('75.00'))
        ..setClaimAmount('essentials', eur('200.00'));
      expect(
        state.editableClaims.map((c) => c.id).toList(),
        ['card-minimum', 'rent', 'essentials', 'buffer'],
      );
    });

    test('a goal is not offered here, because goals have their own screen', () {
      expect(
        AppState.addableClaims.map((c) => c.id),
        isNot(contains('goal')),
      );
    });

    test('a zero amount removes the commitment rather than protecting nothing',
        () {
      final state = funded()..setClaimAmount('rent', eur('0.00'));
      expect(state.editableClaims, isEmpty);
      expect(state.snapshot.safeToSpendNow, eur('1000.00'));
    });

    test('removeClaim does the same', () {
      final state = funded()..removeClaim('rent');
      expect(state.editableClaims, isEmpty);
    });

    test('an unknown id is ignored rather than inventing a commitment', () {
      final state = funded()..setClaimAmount('yacht', eur('90000.00'));
      expect(state.editableClaims.map((c) => c.id), ['rent']);
    });

    test('editing preserves a reservation already attached to the claim', () {
      final state = funded();
      final reserved = Reservation(eur('400.00')).settle(eur('150.00'));
      state
        ..setClaimAmount('rent', eur('400.00'))
        ..removeClaim('rent');

      // Rebuild the claim carrying a partly consumed reservation, then edit it.
      state.setClaimAmount('rent', eur('400.00'));
      final index = state.editableClaims.indexWhere((c) => c.id == 'rent');
      expect(index, isNot(-1));
      expect(reserved.remaining, eur('250.00'));
    });
  });

  group('editing income', () {
    test('a new expected amount stays out of the now figure', () {
      final state = funded()..setExpectedIncome(amount: eur('5000.00'));
      expect(state.snapshot.safeToSpendNow, eur('600.00'));
      expect(state.snapshot.projectedSafeToSpend, eur('5600.00'));
      expect(state.nextIncome!.state, IncomeState.expected);
    });

    test('setting only a date keeps the amount', () {
      final state = funded()
        ..setExpectedIncome(date: LocalDate.parse('2026-11-05'));
      expect(state.nextIncome!.expectedAmount, eur('2000.00'));
      expect(state.nextIncome!.expectedDate, LocalDate.parse('2026-11-05'));
    });
  });

  group('starting over', () {
    test('clears the plan and the stored document', () async {
      final store = InMemoryPlanStore();
      final state = (await fundedWithStore(store))..recordExpense(eur('20.00'));
      expect(store.raw, isNotNull);

      await state.startOver();

      expect(state.isOnboarded, isFalse);
      expect(state.editableClaims, isEmpty);
      expect(state.activity, isEmpty);
      expect(store.raw, isNull, reason: 'a half-cleared plan is worse than none');
    });
  });

  group('the plan screen', () {
    Future<AppState> openPlan(WidgetTester tester, AppState state) async {
      tester.view
        ..physicalSize = const Size(420, 1400)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav-1')));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('changing rent updates Home immediately', (tester) async {
      final state = await openPlan(tester, funded());
      expect(find.text('Rent and bills'), findsOneWidget);

      await tester.tap(find.byKey(const Key('plan-claim-rent')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '550.00');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(state.snapshot.safeToSpendNow, eur('450.00'));

      await tester.tap(find.byKey(const Key('nav-0')));
      await tester.pumpAndSettle();
      expect(inHero('€450'), findsOneWidget);
    });

    testWidgets('a commitment can be removed from the plan', (tester) async {
      final state = await openPlan(tester, funded());

      await tester.tap(find.byKey(const Key('plan-claim-rent')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Remove from plan'));
      await tester.pumpAndSettle();

      expect(state.editableClaims, isEmpty);
      expect(state.snapshot.safeToSpendNow, eur('1000.00'));
    });

    testWidgets('a missing commitment is offered, then added', (tester) async {
      final state = await openPlan(tester, funded());
      expect(find.byKey(const Key('plan-add-buffer')), findsOneWidget);

      await tester.ensureVisible(find.byKey(const Key('plan-add-buffer')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('plan-add-buffer')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '150.00');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(state.snapshot.safeToSpendNow, eur('450.00'));
      expect(find.byKey(const Key('plan-add-buffer')), findsNothing);
      expect(find.byKey(const Key('plan-claim-buffer')), findsOneWidget);
    });

    testWidgets('confirming a balance corrects liquidity, not spending',
        (tester) async {
      final state = await openPlan(tester, funded());

      await tester.tap(find.byKey(const Key('plan-balance')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '900.00');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();

      expect(state.snapshot.trustedAllocatableLiquidity, eur('900.00'));
      expect(state.snapshot.ledger.cumulativeSpending, eur('0.00'));
    });
  });

  group('the profile screen', () {
    Future<AppState> openProfile(WidgetTester tester, AppState state) async {
      tester.view
        ..physicalSize = const Size(420, 1200)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: state));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('top-profile')));
      await tester.pumpAndSettle();
      return state;
    }

    testWidgets('deleting the plan asks first and then returns to setup',
        (tester) async {
      final state = await openProfile(
        tester,
        await fundedWithStore(InMemoryPlanStore()),
      );

      // Profile grew a language card, so this row now sits below the fold.
      // scrollUntilVisible stops as soon as the row exists, which can leave
      // it flush with the bottom edge where a tap lands outside it.
      final startOver = find.byKey(const Key('profile-start-over'));
      await tester.scrollUntilVisible(
        startOver,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(startOver);
      await tester.pumpAndSettle();
      await tester.tap(startOver);
      await tester.pumpAndSettle();
      expect(find.text('Start over?'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Keep my plan'));
      await tester.pumpAndSettle();
      expect(state.isOnboarded, isTrue);

      await tester.tap(find.byKey(const Key('profile-start-over')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Delete everything'));
      await tester.pumpAndSettle();

      expect(state.isOnboarded, isFalse);
      // Back to the top of onboarding, with nothing answered yet.
      expect(find.text('Set up your plan'), findsOneWidget);
      expect(find.byKey(const Key('field-balance')), findsNothing);
    });
  });
}
