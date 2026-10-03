// Dollars, gold and coins: shown beside the plan, never counted in it.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/domain/holding.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

Money irr(String v) => Money.parse(v, 'IRR');

Future<AppState> funded(PlanStore store) async {
  final state = AppState(now: now, utcOffset: cest, store: store);
  await state.restore();
  return state
    ..completeOnboarding(
      OnboardingDraft()
        ..currency = 'IRR'
        ..currentBalance = irr('500000000')
        ..incomeAmount = irr('300000000')
        ..nextIncomeDate = LocalDate.parse('2026-10-28'),
    );
}

void main() {
  group('quantities', () {
    test('parse and print without binary fractions', () {
      expect(parseQuantity('2.5'), 2500);
      expect(parseQuantity('2,125'), 2125);
      expect(parseQuantity('10'), 10000);
      expect(parseQuantity('1.2345'), isNull);
      expect(formatQuantity(2500), '2.5');
      expect(formatQuantity(10000), '10');
      expect(formatQuantity(2125), '2.125');
    });
  });

  group('the plan', () {
    test('a holding is worth its quantity times its price', () async {
      final state = await funded(InMemoryPlanStore())
        ..addHolding(
          name: 'Gold (gram)',
          quantityMilli: 2500,
          unitPrice: irr('80000000'),
        );
      expect(state.holdings.single.value, irr('200000000'));
    });

    test('never changes what can be spent', () async {
      final state = await funded(InMemoryPlanStore());
      final before = state.snapshot.safeToSpendNow;
      state.addHolding(
        name: 'US dollar',
        quantityMilli: 500000,
        unitPrice: irr('1000000'),
      );
      expect(state.snapshot.safeToSpendNow, before);
    });

    test('adds up across holdings', () async {
      final state = await funded(InMemoryPlanStore())
        ..addHolding(
          name: 'US dollar',
          quantityMilli: 100000,
          unitPrice: irr('1000000'),
        )
        ..addHolding(
          name: 'Gold coin',
          quantityMilli: 1000,
          unitPrice: irr('900000000'),
        );
      expect(state.holdingsTotal, irr('1000000000'));
    });

    test('a new price restamps the date; a new name does not', () async {
      final state = await funded(InMemoryPlanStore())
        ..addHolding(
          name: 'US dollar',
          quantityMilli: 1000,
          unitPrice: irr('1000000'),
        );
      final id = state.holdings.single.id;
      expect(state.holdings.single.pricedOn, state.today);
      state.updateHolding(id, name: 'Dollars');
      expect(state.holdings.single.name, 'Dollars');
    });

    test('survives closing and reopening, and ids stay unique', () async {
      final store = InMemoryPlanStore();
      (await funded(store))
        ..addHolding(name: 'A', quantityMilli: 1000, unitPrice: irr('1'))
        ..addHolding(name: 'B', quantityMilli: 1000, unitPrice: irr('1'));
      final reopened = AppState(now: now, utcOffset: cest, store: store);
      await reopened.restore();
      expect(reopened.restoreFailure, isNull);
      expect(reopened.holdings.map((h) => h.name), ['A', 'B']);
      reopened.addHolding(name: 'C', quantityMilli: 1000, unitPrice: irr('1'));
      expect(reopened.holdings.map((h) => h.id).toSet().length, 3);
    });

    test('follows a change of currency', () async {
      final state = await funded(InMemoryPlanStore())
        ..addHolding(name: 'A', quantityMilli: 1000, unitPrice: irr('100'));
      state.changeCurrency('EUR');
      expect(state.holdings.single.unitPrice, Money.parse('100.00', 'EUR'));
      expect(state.holdingsTotal.currency, 'EUR');
    });
  });

  testWidgets('added from the Plan screen', (tester) async {
    final state = await funded(InMemoryPlanStore());
    tester.view
      ..physicalSize = const Size(420, 2200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(UpinoApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-1')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('plan-holding-add')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('holding-name')), 'Gold');
    await tester.enterText(find.byKey(const Key('holding-quantity')), '2.5');
    await tester.enterText(find.byKey(const Key('holding-price')), '80000000');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('holding-save')));
    await tester.pumpAndSettle();

    expect(state.holdings.single.value, irr('200000000'));
    expect(find.byKey(Key('plan-holding-${state.holdings.single.id}')),
        findsOneWidget,);
  });
}
