// The "recorded" banner: it goes by itself, and its cross takes the spend
// back only after a yes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded() => AppState(now: DateTime.utc(2026, 10, 1, 10))
  ..completeOnboarding(
    OnboardingDraft()
      ..currentBalance = eur('1000.00')
      ..incomeAmount = eur('2000.00')
      ..nextIncomeDate = LocalDate.parse('2026-10-28'),
  );

Future<AppState> recorded(WidgetTester tester) async {
  final state = funded();
  tester.view
    ..physicalSize = const Size(420, 1600)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UpinoApp(state: state));
  await tester.pumpAndSettle();
  state.recordExpense(eur('30.00'));
  await tester.pumpAndSettle();
  return state;
}

void main() {
  testWidgets('goes by itself after a few seconds', (tester) async {
    await recorded(tester);
    expect(find.text('€30 recorded'), findsOneWidget);
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    expect(find.text('€30 recorded'), findsNothing);
  });

  testWidgets('its cross asks first, and No keeps the spend', (tester) async {
    final state = await recorded(tester);
    final before = state.snapshot.safeToSpendNow;

    await tester.tap(find.byKey(const Key('banner-remove')));
    await tester.pumpAndSettle();
    expect(find.text('Remove €30?'), findsOneWidget);

    await tester.tap(find.byKey(const Key('banner-remove-no')));
    await tester.pumpAndSettle();
    expect(state.snapshot.safeToSpendNow, before);
    expect(state.activity.single.removed, isFalse);
  });

  testWidgets('Yes takes the spend back, and it stays on Activity marked',
      (tester) async {
    final state = await recorded(tester);
    final before = state.snapshot.safeToSpendNow;

    await tester.tap(find.byKey(const Key('banner-remove')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('banner-remove-yes')));
    await tester.pumpAndSettle();

    expect(state.snapshot.safeToSpendNow, before + eur('30.00'));
    expect(state.activity.single.removed, isTrue);
    expect(find.text('€30 recorded'), findsNothing);
  });

  testWidgets('the banner waits while the question is open', (tester) async {
    await recorded(tester);
    await tester.tap(find.byKey(const Key('banner-remove')));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    // Still answerable: the banner did not vanish behind the dialog.
    expect(find.byKey(const Key('banner-remove-yes')), findsOneWidget);
    expect(find.text('€30 recorded'), findsOneWidget);
  });
}
