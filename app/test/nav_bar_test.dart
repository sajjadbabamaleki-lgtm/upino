// The selected pill must sit the same distance from the bar's top, bottom and
// outer edge. Measured rather than eyeballed, so the geometry cannot drift.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/l10n/app_localizations.dart';
import 'package:upino/design/icon.dart';
import 'package:upino/design/parts.dart';
import 'package:upino/design/theme.dart';
import 'package:upino/design/tokens.dart';

Future<Rect> rectOf(WidgetTester tester, Finder finder) async {
  final box = tester.renderObject<RenderBox>(finder);
  final topLeft = box.localToGlobal(Offset.zero);
  return topLeft & box.size;
}

Future<void> pumpBar(
  WidgetTester tester,
  int index,
  Brightness brightness, {
  String language = 'en',
}) async {
  tester.view
    ..physicalSize = const Size(400, 900)
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildTheme(brightness: brightness),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: UpinoNavBar(index: index, onSelect: (_) {}),
          ),
        ),
      ),
    ),
  );
  // MaterialApp animates a theme change over kThemeAnimationDuration, so a
  // bare pumpWidget still reports the previous brightness.
  await tester.pump(kThemeAnimationDuration + const Duration(milliseconds: 20));
}

/// Flutter reports a layout overflow through the error reporter rather than
/// by throwing, so a row that does not fit would otherwise pass unnoticed.
bool didOverflow() {
  final error = _lastError;
  _lastError = null;
  return error != null && error.contains('overflowed');
}

String? _lastError;

void main() {
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    _lastError = details.exceptionAsString();
    previousOnError?.call(details);
  };

  testWidgets('the selected pill is inset equally on three sides', (t) async {
    // The last destination, so its outer edge is the bar's right edge.
    await pumpBar(t, UpinoNavBar.destinationCount - 1, Brightness.light);

    final bar = await rectOf(t, find.byType(UpinoNavBar));
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));

    final top = pill.top - bar.top;
    final bottom = bar.bottom - pill.bottom;
    final right = bar.right - pill.right;

    expect(top, closeTo(UpinoNavBar.inset, 0.01));
    expect(bottom, closeTo(UpinoNavBar.inset, 0.01), reason: 'top $top');
    expect(right, closeTo(UpinoNavBar.inset, 0.01), reason: 'top $top');
  });

  testWidgets('a pill on the left is inset equally on its three sides',
      (t) async {
    await pumpBar(t, 0, Brightness.light);

    final bar = await rectOf(t, find.byType(UpinoNavBar));
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));

    expect(pill.top - bar.top, closeTo(UpinoNavBar.inset, 0.01));
    expect(bar.bottom - pill.bottom, closeTo(UpinoNavBar.inset, 0.01));
    expect(pill.left - bar.left, closeTo(UpinoNavBar.inset, 0.01));
  });

  testWidgets('a middle destination keeps the same vertical insets', (t) async {
    await pumpBar(t, 1, Brightness.light);
    final bar = await rectOf(t, find.byType(UpinoNavBar));
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));
    expect(pill.top - bar.top, closeTo(UpinoNavBar.inset, 0.01));
    expect(bar.bottom - pill.bottom, closeTo(UpinoNavBar.inset, 0.01));
  });

  testWidgets('every destination fits on one row at phone width', (t) async {
    // In every language. The selected pill is the only one that carries a
    // label, and how wide that label is depends on the language: this caught
    // the bar overflowing in eight of the ten, English among them.
    for (final language in [
      'ar',
      'en',
      'es',
      'fa',
      'fr',
      'hi',
      'pt',
      'ru',
      'tr',
      'zh',
    ]) {
      for (var i = 0; i < UpinoNavBar.destinationCount; i++) {
        await pumpBar(t, i, Brightness.light, language: language);
        expect(
          didOverflow(),
          isFalse,
          reason: '$language destination $i overflowed',
        );
      }
    }
  });

  testWidgets('the pill hugs its label rather than the space offered',
      (t) async {
    // A Container given an alignment expands to its whole constraint, and
    // the selected item is Flexible, so the pill was taking the row's spare
    // width and centring inside it — wide empty margins either side of the
    // icon and label.
    await pumpBar(t, 0, Brightness.light);
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));
    final icon = await rectOf(
      t,
      find.descendant(
        of: find.byKey(const Key('nav-selected-pill')),
        matching: find.byType(UpinoIcon),
      ),
    );
    final label = await rectOf(t, find.text('Home'));

    const padding = 12.0;
    expect(
      icon.left - pill.left,
      closeTo(padding, 0.5),
      reason: 'gap before the icon',
    );
    expect(
      pill.right - label.right,
      closeTo(padding, 0.5),
      reason: 'gap after the label',
    );
  });

  testWidgets('the pill fills the row height', (t) async {
    await pumpBar(t, 3, Brightness.light);
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));
    expect(pill.height, closeTo(UpinoNavBar.itemHeight, 0.01));
  });

  testWidgets('only the selected destination shows a label', (t) async {
    await pumpBar(t, 4, Brightness.light);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    expect(find.text('Plan'), findsNothing);
    expect(find.text('Goals'), findsNothing);
    expect(find.text('Activity'), findsNothing);
  });

  BoxDecoration barDecoration(WidgetTester tester) => tester
      .widget<Container>(find.byKey(const Key('nav-bar-surface')))
      .decoration! as BoxDecoration;

  testWidgets('the bar casts no shadow in either mode', (t) async {
    await pumpBar(t, 3, Brightness.light);
    expect(barDecoration(t).boxShadow, isNull);

    await pumpBar(t, 3, Brightness.dark);
    expect(barDecoration(t).boxShadow, isNull);
  });

  testWidgets('the scrim fades from nothing into the page colour', (t) async {
    const scrim = NavScrim(navHeight: 64, bottomGap: 22);
    await t.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildTheme(brightness: Brightness.light),
        home: const Scaffold(
          body: Align(alignment: Alignment.bottomCenter, child: scrim),
        ),
      ),
    );

    final decorated = t.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(NavScrim),
        matching: find.byType(DecoratedBox),
      ),
    );
    final gradient =
        (decorated.decoration as BoxDecoration).gradient! as LinearGradient;

    expect(gradient.begin, Alignment.topCenter);
    expect(gradient.end, Alignment.bottomCenter);
    expect(
      gradient.colors.first.a,
      0,
      reason: 'the top edge must be invisible',
    );
    expect(gradient.colors.last, UpinoTokens.surfacePage);

    // Solid page colour from the bar's top edge down, transparent 15 above it.
    expect(scrim.height, 15 + 64 + 22);
    expect(gradient.stops![1], closeTo(15 / scrim.height, 0.0001));
  });

  testWidgets('the scrim reaches exactly 15 above the bar on Home', (t) async {
    final scrim = const NavScrim(navHeight: 64, bottomGap: 22);
    expect(scrim.height - scrim.navHeight - scrim.bottomGap, 15);
  });

  test('the idle glyph clears the 3:1 minimum for a UI component', () {
    double channel(int v) {
      final c = v / 255.0;
      return c <= 0.03928
          ? c / 12.92
          : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
    }

    double luminance(Color c) =>
        0.2126 * channel((c.r * 255).round()) +
        0.7152 * channel((c.g * 255).round()) +
        0.0722 * channel((c.b * 255).round());

    double ratio(Color a, Color b) {
      final la = luminance(a);
      final lb = luminance(b);
      final hi = la > lb ? la : lb;
      final lo = la > lb ? lb : la;
      return (hi + 0.05) / (lo + 0.05);
    }

    expect(
      ratio(UpinoTokens.navIdle, UpinoTokens.surfaceRaised),
      greaterThanOrEqualTo(3.0),
    );
    expect(
      ratio(UpinoTokens.actionOnTint, UpinoTokens.actionTint),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets('the label sits close to the glyph it belongs to',
      (tester) async {
    // The icon and the word are one label, not two things side by side, so
    // the space between them is smaller than the space around the pair.
    await pumpBar(tester, 0, Brightness.light);

    final glyph = await rectOf(tester, find.byType(UpinoIcon).first);
    final word = await rectOf(tester, find.text('Home'));
    final gap = word.left - glyph.right;

    expect(gap, lessThanOrEqualTo(5));
    expect(gap, greaterThan(0), reason: 'they must not touch');

    // And still further from the pill's own edge than from each other, or
    // the pair stops reading as one thing.
    final pill =
        await rectOf(tester, find.byKey(const Key('nav-selected-pill')));
    expect(glyph.left - pill.left, greaterThan(gap));
  });
}
