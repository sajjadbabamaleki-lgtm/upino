// The page colour has to run the whole height of the display, behind the clock
// and the battery at the top and behind the gesture bar at the bottom. Drawing
// there is only half of it: nothing the user has to read or tap may end up
// underneath those system glyphs, so both halves are measured here.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/design/parts.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';

Money eur(String v) => Money.parse(v, 'EUR');

AppState onboarded() => AppState(
      now: DateTime.utc(2026, 10, 1, 10),
      utcOffset: const Duration(hours: 2),
    )..completeOnboarding(
        OnboardingDraft()
          ..currentBalance = eur('2000.00')
          ..incomeAmount = eur('2000.00')
          ..nextIncomeDate = LocalDate.parse('2026-10-31')
          ..payCycleDays = 30,
      );

/// A phone with a 44px status bar and a 28px gesture bar, which is what
/// viewPadding reports when the app draws behind both.
const insets = EdgeInsets.only(top: 44, bottom: 28);

Future<void> pumpApp(WidgetTester tester) async {
  tester.view
    ..physicalSize = const Size(400, 900)
    ..devicePixelRatio = 1.0
    ..viewPadding = const FakeViewPadding(top: 44, bottom: 28)
    ..padding = const FakeViewPadding(top: 44, bottom: 28);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UpinoApp(state: onboarded()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the system bars are transparent so the page shows through',
      (tester) async {
    await pumpApp(tester);

    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
    );
    expect(region.value.statusBarColor, Colors.transparent);
    expect(region.value.systemNavigationBarColor, Colors.transparent);
    // Android otherwise paints its own scrim over the navigation bar, which
    // reads as a band in a different shade.
    expect(region.value.systemNavigationBarContrastEnforced, isFalse);
  });

  testWidgets('the status bar glyphs are dark against the light page',
      (tester) async {
    await pumpApp(tester);
    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
    );
    expect(region.value.statusBarIconBrightness, Brightness.dark);
  });

  testWidgets('the page paints the full height of the display', (tester) async {
    await pumpApp(tester);

    final scaffold = tester.renderObject<RenderBox>(
      find.byType(Scaffold).first,
    );
    final rect = scaffold.localToGlobal(Offset.zero) & scaffold.size;
    expect(rect.top, 0, reason: 'the page must start above the status bar');
    expect(rect.bottom, 900, reason: 'and end below the gesture bar');
  });

  testWidgets('the heading still clears the status bar', (tester) async {
    await pumpApp(tester);

    final heading = tester.renderObject<RenderBox>(find.text('Your plan'));
    final top = heading.localToGlobal(Offset.zero).dy;
    expect(
      top,
      greaterThanOrEqualTo(insets.top),
      reason: 'the title slid under the clock',
    );
  });

  testWidgets('the nav bar still clears the gesture bar', (tester) async {
    await pumpApp(tester);

    final bar = tester.renderObject<RenderBox>(find.byType(UpinoNavBar));
    final bottom = bar.localToGlobal(Offset.zero).dy + bar.size.height;
    expect(
      bottom,
      lessThanOrEqualTo(900 - insets.bottom),
      reason: 'the bar slid under the gesture bar',
    );
  });
}
