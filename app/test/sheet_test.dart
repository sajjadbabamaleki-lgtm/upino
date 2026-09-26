/// The pickers open from the bottom edge.
///
/// Asked for after using the app on a phone: a question that replaced the
/// whole screen read as being sent somewhere, and coming back needed a
/// button. A sheet keeps the screen it belongs to visible behind it, and
/// leaves by swipe or by tapping outside.
///
/// The motion is checked rather than described. Flutter's default modal
/// bottom sheet takes 250ms on one curve, which at phone size reads as a
/// snap; these tests hold the app to the longer Material 3 pair.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/main.dart';
import 'package:upino/screens/currency_screen.dart';
import 'package:upino/screens/language_screen.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/widgets/upino_sheet.dart';

Future<void> pumpSetup(WidgetTester tester) async {
  tester.view
    ..physicalSize = const Size(400, 1200)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    UpinoApp(state: AppState(now: DateTime.utc(2026, 10, 1, 10)), singleFormSetup: true),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('a picker sheet', () {
    testWidgets('climbs from the bottom rather than appearing in place',
        (tester) async {
      await pumpSetup(tester);
      await tester.tap(find.byKey(const Key('change-language')));
      await tester.pump(); // the route is pushed on this frame

      await tester.pump(const Duration(milliseconds: 80));
      final early = tester.getTopLeft(find.byType(LanguagePicker)).dy;
      await tester.pump(const Duration(milliseconds: 120));
      final later = tester.getTopLeft(find.byType(LanguagePicker)).dy;
      await tester.pumpAndSettle();
      final settled = tester.getTopLeft(find.byType(LanguagePicker)).dy;

      expect(later, lessThan(early), reason: 'it should still be climbing');
      expect(settled, lessThan(later));
    });

    testWidgets('takes long enough to be read as motion', (tester) async {
      await pumpSetup(tester);
      await tester.tap(find.byKey(const Key('change-currency')));
      await tester.pump();

      // Flutter's own default would have finished by here.
      await tester.pump(const Duration(milliseconds: 260));
      final atDefault = tester.getTopLeft(find.byType(CurrencyPicker)).dy;
      await tester.pumpAndSettle();
      final settled = tester.getTopLeft(find.byType(CurrencyPicker)).dy;

      expect(
        atDefault,
        greaterThan(settled),
        reason: 'still arriving at 260ms, which 250ms defaults would not be',
      );
      expect(UpinoSheet.enterDuration.inMilliseconds, 400);
    });

    testWidgets('leaves the screen it belongs to visible behind it',
        (tester) async {
      await pumpSetup(tester);
      await tester.tap(find.byKey(const Key('change-language')));
      await tester.pumpAndSettle();

      // The setup screen is still mounted and readable under the scrim.
      expect(find.text('Set up your plan'), findsOneWidget);
      final dimmed = tester
          .widgetList<ModalBarrier>(find.byType(ModalBarrier))
          .any((b) => b.color != null && b.color!.a > 0);
      expect(dimmed, isTrue, reason: 'the page behind has to read as inactive');
    });

    testWidgets('closes on the button, on a tap outside, and on a swipe down',
        (tester) async {
      await pumpSetup(tester);

      Future<void> open() async {
        await tester.tap(find.byKey(const Key('change-language')));
        await tester.pumpAndSettle();
        expect(find.byType(LanguagePicker), findsOneWidget);
      }

      await open();
      await tester.tap(find.byKey(const Key('sheet-close')));
      await tester.pumpAndSettle();
      expect(find.byType(LanguagePicker), findsNothing);

      await open();
      await tester.tapAt(const Offset(200, 20));
      await tester.pumpAndSettle();
      expect(find.byType(LanguagePicker), findsNothing);

      await open();
      // Dragged from the sheet's own body, which is what a thumb lands on.
      expect(find.byKey(const Key('sheet-handle')), findsOneWidget);
      await tester.fling(
        find.text('Which language?'),
        const Offset(0, 600),
        1200,
      );
      await tester.pumpAndSettle();
      expect(find.byType(LanguagePicker), findsNothing);
    });

    testWidgets('opens tall enough to show every language at once',
        (tester) async {
      // The height the sheet is set to is this list: eleven rows, and a
      // language you have to scroll to find is a language someone who cannot
      // read the current one may never find.
      await pumpSetup(tester);
      final screen =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      await tester.tap(find.byKey(const Key('change-language')));
      await tester.pumpAndSettle();

      for (final code in ['system', ...languageNames.keys]) {
        final row = find.byKey(Key('language-$code'));
        expect(row, findsOneWidget, reason: code);
        expect(
          tester.getRect(row).bottom,
          lessThanOrEqualTo(screen),
          reason: '$code is below the bottom of the screen',
        );
      }
    });

    testWidgets(
        'both pickers open to the same edge, below the top of the '
        'screen', (tester) async {
      // Two pickers opening to two heights read as two components. And a
      // sheet that reaches the status bar is a screen, not a sheet.
      await pumpSetup(tester);
      final screen =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final tops = <String, double>{};

      for (final row in ['change-language', 'change-currency']) {
        await tester.tap(find.byKey(Key(row)));
        await tester.pumpAndSettle();
        tops[row] = tester.getTopLeft(find.byKey(const Key('sheet-handle'))).dy;
        expect(find.text('Set up your plan'), findsOneWidget);
        await tester.tap(find.byKey(const Key('sheet-close')));
        await tester.pumpAndSettle();
      }

      expect(tops['change-language'], tops['change-currency']);
      expect(
        tops['change-language'],
        greaterThan(screen * (1 - UpinoSheet.maxShare) - 1),
        reason: 'the page behind has to keep a strip of the screen',
      );
    });

    testWidgets('keeps its height when the keyboard comes up', (tester) async {
      // The currency sheet carries a search field. Measured against the room
      // left over rather than the screen, the keyboard would shrink the list
      // to a few rows at the moment it is being searched.
      await pumpSetup(tester);
      await tester.tap(find.byKey(const Key('change-currency')));
      await tester.pumpAndSettle();
      final before = tester.getSize(find.byType(CurrencyPicker)).height;

      tester.view.viewInsets = FakeViewPadding(
        bottom: 300 * tester.view.devicePixelRatio,
      );
      await tester.pumpAndSettle();
      final after = tester.getSize(find.byType(CurrencyPicker)).height;

      expect(
        after,
        before,
        reason: 'the sheet had room and did not need to give any of it back',
      );
    });

    testWidgets('is never taller than the screen it sits on', (tester) async {
      // The currency list is 149 rows long. Sized to its content it would
      // cover the whole screen and stop being a sheet.
      await pumpSetup(tester);
      await tester.tap(find.byKey(const Key('change-currency')));
      await tester.pumpAndSettle();

      final top = tester.getTopLeft(find.byType(CurrencyPicker)).dy;
      expect(top, greaterThan(0), reason: 'the screen behind must still show');
      expect(find.text('Set up your plan'), findsOneWidget);
    });
  });
}
