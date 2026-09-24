/// Movement, checked the way everything else here is: by measuring it.
///
/// Asked for after the build on a phone — "the items have no welcome
/// animation anywhere", "the pickers open dead", "the scroll gives no good
/// feeling". Each of those is one thing that can be measured, so each has a
/// test rather than a screenshot and a hope.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/design/motion.dart';
import 'package:upino/design/parts.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/widgets/sts_hero.dart';
import 'package:upino/screens/language_screen.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/widgets/upino_sheet.dart';

AppState funded() {
  final state = AppState(
    now: DateTime.utc(2026, 10, 1, 10),
    utcOffset: const Duration(hours: 2),
  );
  state.completeOnboarding(
    OnboardingDraft()
      ..currency = 'EUR'
      ..currentBalance = Money.parse('3000.00', 'EUR')
      ..incomeAmount = Money.parse('2000.00', 'EUR')
      ..rent = Money.parse('1200.00', 'EUR'),
  );
  return state;
}

Future<void> pumpApp(WidgetTester tester, AppState state) async {
  tester.view
    ..physicalSize = const Size(400, 900)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(UpinoApp(state: state));
  await tester.pumpAndSettle();
}

void main() {
  group('cards arrive rather than appear', () {
    testWidgets('the hero starts low and see-through, and ends in place',
        (tester) async {
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));

      // One frame in: the animation has started and nothing has arrived.
      await tester.pump();
      // The first card on Home, now that the page's name is in the capsule.
      final title = find.byType(StsHero);
      final early = tester.getTopLeft(title).dy;
      expect(
        tester.widget<Opacity>(
          find.ancestor(of: title, matching: find.byType(Opacity)).first,
        ).opacity,
        lessThan(1),
      );

      await tester.pumpAndSettle();
      final settled = tester.getTopLeft(title).dy;
      expect(settled, lessThan(early), reason: 'it should have lifted');
      expect(early - settled, closeTo(UpinoMotion.rise, 0.5));
      expect(
        tester.widget<Opacity>(
          find.ancestor(of: title, matching: find.byType(Opacity)).first,
        ).opacity,
        1,
      );
    });

    testWidgets('one card follows the next rather than all at once',
        (tester) async {
      // The whole point of the stagger: at the moment the first card has
      // arrived, a later one is still on its way.
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pump();
      await tester.pump(UpinoMotion.enter);

      double opacityAbove(Finder target) => tester
          .widget<Opacity>(
            find.ancestor(of: target, matching: find.byType(Opacity)).first,
          )
          .opacity;

      expect(opacityAbove(find.byType(StsHero)), 1);
      expect(opacityAbove(find.text('Set aside first')), lessThan(1));

      await tester.pumpAndSettle();
      expect(opacityAbove(find.text('Set aside first')), 1);
    });

    testWidgets('a phone asked to stop animating gets none of it',
        (tester) async {
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: UpinoApp(state: funded()),
        ),
      );
      await tester.pump();
      expect(find.byType(Opacity), findsNothing);
      expect(find.byType(StsHero), findsOneWidget);
    });
  });

  group('the picker sheets', () {
    testWidgets('bring their rows in one after another', (tester) async {
      await pumpApp(tester, funded());
      await tester.tap(find.byKey(const Key('top-profile')));
      await tester.pumpAndSettle();
      final row = find.byKey(const Key('profile-language'));
      await tester.scrollUntilVisible(row, 200);
      await tester.ensureVisible(row);
      await tester.pumpAndSettle();
      await tester.tap(row);

      // Part-way through the sheet's own entrance the rows are still coming.
      await tester.pump();
      await tester.pump(UpinoSheet.enterDuration);
      final phone = find.byKey(const Key('language-system'));
      final turkish = find.byKey(const Key('language-tr'));
      double opacityAbove(Finder t) => tester
          .widget<Opacity>(
            find.ancestor(of: t, matching: find.byType(Opacity)).first,
          )
          .opacity;
      expect(opacityAbove(phone), greaterThan(opacityAbove(turkish)));

      await tester.pumpAndSettle();
      expect(opacityAbove(turkish), 1);
      expect(find.byType(LanguagePicker), findsOneWidget);
    });

    testWidgets('give the close button a finger-sized target away from the '
        'corner', (tester) async {
      // Both complaints at once: too small to hit, and close enough to the
      // edge to be caught while scrolling the list.
      await pumpApp(tester, AppState(now: DateTime.utc(2026, 10, 1, 10)));
      await tester.tap(find.byKey(const Key('change-language')));
      await tester.pumpAndSettle();

      final button = tester.getRect(find.byKey(const Key('sheet-close')));
      expect(button.width, greaterThanOrEqualTo(36));
      expect(button.height, greaterThanOrEqualTo(36));

      final screen = tester.view.physicalSize.width / tester.view.devicePixelRatio;
      expect(
        screen - button.right,
        greaterThanOrEqualTo(22),
        reason: 'it sat on the edge of the sheet',
      );
    });
  });

  group('scrolling', () {
    testWidgets('carries its momentum instead of stopping dead',
        (tester) async {
      await pumpApp(tester, funded());
      // The position's physics, not the widget's: a ListView with no
      // controller declares AlwaysScrollableScrollPhysics and the behaviour's
      // physics is applied underneath it, so the chain is what to read.
      final position = tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position;

      var physics = position.physics;
      var bouncing = false;
      while (true) {
        if (physics is BouncingScrollPhysics) bouncing = true;
        final parent = physics.parent;
        if (parent == null) break;
        physics = parent;
      }

      expect(
        bouncing,
        isTrue,
        reason: 'the clamping default is what reads as stiff: '
            '${position.physics}',
      );
    });

    testWidgets('answers an overscroll by moving, not by glowing',
        (tester) async {
      await pumpApp(tester, funded());
      expect(find.byType(GlowingOverscrollIndicator), findsNothing);
      expect(find.byType(UpinoNavBar), findsOneWidget);
    });
  });

  testWidgets('the bar floats clear of the bottom of the screen',
      (tester) async {
    // It was 7px up, which put the pill's shadow on the edge of the display
    // and, on a phone with a gesture bar, right against it.
    await pumpApp(tester, funded());
    final screen =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final bar = tester.getRect(find.byType(UpinoNavBar));
    expect(screen - bar.bottom, greaterThanOrEqualTo(15));
  });
}
