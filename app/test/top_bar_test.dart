// The capsule at the top and what its bell counts.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded({
  String balance = '2000.00',
  String rent = '0.00',
  DateTime? now,
  String nextPay = '2026-10-28',
}) {
  final state = AppState(now: now ?? DateTime.utc(2026, 10, 1, 10))
    ..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur(balance)
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse(nextPay),
    );
  if (rent != '0.00') state.setClaimAmount('rent', eur(rent));
  return state;
}

Future<void> pump(WidgetTester tester, AppState state) async {
  tester.view
    ..physicalSize = const Size(420, 1600)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UpinoApp(state: state));
  await tester.pumpAndSettle();
}

void main() {
  group('alerts', () {
    test('a plan in order has none', () {
      expect(funded().alerts, isEmpty);
    });

    test('an unfunded commitment comes first', () {
      final alerts = funded(balance: '500.00', rent: '900.00').alerts;
      expect(alerts.first, isA<UnfundedAlert>());
      expect((alerts.first as UnfundedAlert).short, eur('400.00'));
    });

    test('pay that has not come by its date', () {
      final alerts = funded(nextPay: '2026-09-28').alerts;
      expect(alerts.whereType<IncomeLateAlert>(), hasLength(1));
    });

    test('a balance that needs confirming', () {
      final state = funded();
      final later = AppState(now: DateTime.utc(2026, 11, 15, 10))
        ..replaceWith(state.toDocument());
      expect(later.alerts.whereType<BalanceStaleAlert>(), hasLength(1));
    });
  });

  group('the capsule', () {
    testWidgets('names the page, and follows the tabs', (tester) async {
      await pump(tester, funded());
      expect(find.byKey(const Key('upino-mark')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('top-title'))).data,
        'Home',
      );
      await tester.tap(find.byKey(const Key('nav-1')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('top-title'))).data,
        'Plan',
      );
    });

    testWidgets('opens Profile, which is no longer a tab', (tester) async {
      await pump(tester, funded());
      await tester.tap(find.byKey(const Key('top-profile')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile-confirm-balance')), findsOneWidget);
      expect(find.byKey(const Key('nav-selected-pill')), findsNothing);
    });

    testWidgets('the bell shows no count when nothing needs the person',
        (tester) async {
      await pump(tester, funded());
      expect(find.byKey(const Key('top-alerts-count')), findsNothing);
      await tester.tap(find.byKey(const Key('top-alerts')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('alerts-empty')), findsOneWidget);
    });

    testWidgets('the bell counts, lists, and a tap goes to the fix',
        (tester) async {
      await pump(tester, funded(nextPay: '2026-09-28'));
      expect(find.byKey(const Key('top-alerts-count')), findsOneWidget);

      await tester.tap(find.byKey(const Key('top-alerts')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('alert-0')));
      await tester.pumpAndSettle();

      // Late pay is dealt with by saying whether it came.
      expect(find.text('How much arrived?'), findsOneWidget);
    });
  });
}
