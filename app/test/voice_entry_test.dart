// Saying a spend fills Quick Expense; Save is still the person's tap.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/device/voice.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/widgets/amount_sheet.dart';

class _FakeVoice implements VoiceInput {
  _FakeVoice(this.result);
  final VoiceResult result;
  String? askedFor;

  @override
  Future<VoiceResult> listen({
    required String localeId,
    ValueChanged<String>? onPartial,
  }) async {
    askedFor = localeId;
    return result;
  }

  @override
  Future<void> stop() async {}
}

final now = DateTime.utc(2026, 10, 1, 10);

AppState funded({String language = 'en'}) =>
    AppState(now: now, utcOffset: const Duration(hours: 3, minutes: 30))
      ..setLanguageCode(language)
      ..completeOnboarding(
        OnboardingDraft()
          ..currency = 'IRR'
          ..currentBalance = Money(500000000, 'IRR')
          ..incomeAmount = Money(300000000, 'IRR')
          ..nextIncomeDate = LocalDate.parse('2026-10-22'),
      );

Future<void> openSpend(WidgetTester tester, AppState state) async {
  tester.view
    ..physicalSize = const Size(420, 1600)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UpinoApp(state: state));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(FilledButton).first);
  await tester.pumpAndSettle();
}

void main() {
  tearDown(() => VoiceInput.instance = null);

  testWidgets('no microphone where the phone offers none', (tester) async {
    await openSpend(tester, funded());
    expect(find.byKey(const Key('amount-voice')), findsNothing);
  });

  testWidgets('what is heard fills the amount and the category, and nothing '
      'is recorded until Save', (tester) async {
    final voice = _FakeVoice(const VoiceResult.heard('دویست و پنجاه هزار تومن نون'));
    VoiceInput.instance = voice;
    final state = funded(language: 'fa');
    await openSpend(tester, state);

    await tester.tap(find.byKey(const Key('amount-voice')));
    await tester.pumpAndSettle();

    expect(voice.askedFor, 'fa_IR');
    expect(find.text('2500000'), findsOneWidget);
    expect(state.activity, isEmpty);

    await tester.tap(find.descendant(
      of: find.byType(AmountSheet),
      matching: find.byType(FilledButton),
    ),);
    await tester.pumpAndSettle();
    expect(state.activity.single.amount, Money(2500000, 'IRR'));
    expect(state.categoryFor(state.activity.single.eventId),
        SpendCategory.food,);
  });

  testWidgets('nothing heard says so and leaves the field alone',
      (tester) async {
    VoiceInput.instance =
        _FakeVoice(const VoiceResult.failed(VoiceFailure.nothingHeard));
    await openSpend(tester, funded());
    await tester.tap(find.byKey(const Key('amount-voice')));
    await tester.pumpAndSettle();
    expect(find.text('No amount heard. Try again, or type it.'), findsOneWidget);
  });

  testWidgets('a phone with no recogniser says so instead of going quiet',
      (tester) async {
    VoiceInput.instance =
        _FakeVoice(const VoiceResult.failed(VoiceFailure.unavailable));
    await openSpend(tester, funded());
    await tester.tap(find.byKey(const Key('amount-voice')));
    await tester.pumpAndSettle();
    expect(find.textContaining('no speech recognition'), findsOneWidget);
  });

  testWidgets('the microphone sits beside the camera, not in the amount',
      (tester) async {
    VoiceInput.instance = _FakeVoice(const VoiceResult.heard('10'));
    await openSpend(tester, funded());
    final mic = tester.getRect(find.byKey(const Key('amount-voice')));
    final camera = tester.getRect(find.byKey(const Key('receipt-camera')));
    expect(mic.center.dy, closeTo(camera.center.dy, 1));
  });
}
