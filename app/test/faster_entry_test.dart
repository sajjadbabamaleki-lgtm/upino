// Bank messages become suggestions, never entries, until the person says so;
// the evening reminder skips a day that already has a spend.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/device/device_bridge.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

final now = DateTime.utc(2026, 10, 1, 10);
const tehran = Duration(hours: 3, minutes: 30);

Money irr(int v) => Money(v, 'IRR');

Future<AppState> funded(PlanStore store) async {
  final state = AppState(now: now, utcOffset: tehran, store: store);
  await state.restore();
  if (!state.isOnboarded) {
    state.completeOnboarding(
      OnboardingDraft()
        ..currency = 'IRR'
        ..currentBalance = irr(500000000)
        ..incomeAmount = irr(300000000)
        ..nextIncomeDate = LocalDate.parse('2026-10-22'),
    );
  }
  return state;
}

InboxMessage sms(String id, String body, {Duration ago = Duration.zero}) =>
    InboxMessage(
      id: id,
      body: body,
      sender: 'Bank Mellat',
      receivedAt: now.subtract(ago),
    );

void main() {
  group('bank messages', () {
    test('are ignored while the feature is off', () async {
      final state = await funded(InMemoryPlanStore());
      state.offerBankMessages([sms('1', 'برداشت:1,500,000')]);
      expect(state.bankSuggestions, isEmpty);
    });

    test('become suggestions, and move no figure', () async {
      final state = await funded(InMemoryPlanStore())..setSmsEnabled(true);
      final before = state.snapshot.safeToSpendNow;
      state.offerBankMessages([
        sms('1', 'بانک ملت\nبرداشت:1,500,000\nمانده:9,000,000'),
        sms('2', 'واریز:2,000,000'),
        sms('3', 'رمز پویا: 123456'),
      ]);
      expect(state.bankSuggestions.single.amount, irr(1500000));
      expect(state.snapshot.safeToSpendNow, before);
    });

    test('recording one is an ordinary spend', () async {
      final state = await funded(InMemoryPlanStore())..setSmsEnabled(true);
      final before = state.snapshot.safeToSpendNow;
      state
        ..offerBankMessages([sms('1', 'برداشت:1,500,000')])
        ..acceptSuggestion('1');
      expect(state.bankSuggestions, isEmpty);
      expect(state.snapshot.safeToSpendNow, before - irr(1500000));
    });

    test('an answered message is never offered again, even after reopening',
        () async {
      final store = InMemoryPlanStore();
      final state = await funded(store)..setSmsEnabled(true);
      state
        ..offerBankMessages([sms('1', 'برداشت:1,500,000')])
        ..dismissSuggestion('1');

      final reopened = await funded(store);
      reopened.offerBankMessages([sms('1', 'برداشت:1,500,000')]);
      expect(reopened.bankSuggestions, isEmpty);
    });

    test('messages from before it was turned on are not offered', () async {
      final state = await funded(InMemoryPlanStore())..setSmsEnabled(true);
      state.offerBankMessages([
        sms('old', 'برداشت:1,500,000', ago: const Duration(days: 10)),
      ]);
      expect(state.bankSuggestions, isEmpty);
    });

    test('the same message twice is one suggestion', () async {
      final state = await funded(InMemoryPlanStore())..setSmsEnabled(true);
      state
        ..offerBankMessages([sms('1', 'برداشت:1,500,000')])
        ..offerBankMessages([sms('1', 'برداشت:1,500,000')]);
      expect(state.bankSuggestions, hasLength(1));
    });

    test('turning it off drops what was waiting', () async {
      final state = await funded(InMemoryPlanStore())..setSmsEnabled(true);
      state
        ..offerBankMessages([sms('1', 'برداشت:1,500,000')])
        ..setSmsEnabled(false);
      expect(state.bankSuggestions, isEmpty);
    });
  });

  group('the evening reminder', () {
    final today = LocalDate.parse('2026-10-01');

    test('is tonight when nothing is recorded and it is not yet 9', () {
      expect(
        DeviceBridge.nextReminderDay(
          today: today,
          localNow: DateTime(2026, 10, 1, 18),
          spentToday: false,
        ),
        today,
      );
    });

    test('moves to tomorrow once something is recorded', () {
      expect(
        DeviceBridge.nextReminderDay(
          today: today,
          localNow: DateTime(2026, 10, 1, 18),
          spentToday: true,
        ),
        today.addDays(1),
      );
    });

    test('moves to tomorrow once 9 has passed', () {
      expect(
        DeviceBridge.nextReminderDay(
          today: today,
          localNow: DateTime(2026, 10, 1, 22),
          spentToday: false,
        ),
        today.addDays(1),
      );
    });

    test('knows whether today has a spend', () async {
      final state = await funded(InMemoryPlanStore());
      expect(state.spentToday, isFalse);
      state.recordExpense(irr(10000));
      expect(state.spentToday, isTrue);
    });

    test('the setting survives reopening', () async {
      final store = InMemoryPlanStore();
      (await funded(store)).setReminderEnabled(true);
      expect((await funded(store)).reminderEnabled, isTrue);
    });
  });

  testWidgets('Home offers waiting messages and records one on a tap',
      (tester) async {
    final state = await funded(InMemoryPlanStore())
      ..setSmsEnabled(true)
      ..offerBankMessages([sms('1', 'بانک ملت\nبرداشت:1,500,000')]);
    tester.view
      ..physicalSize = const Size(420, 1600)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(UpinoApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('home-sms')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sms-record-1')));
    await tester.pumpAndSettle();

    expect(state.bankSuggestions, isEmpty);
    expect(state.activity.single.amount, irr(1500000));
    expect(find.text('All caught up.'), findsOneWidget);
  });
}
