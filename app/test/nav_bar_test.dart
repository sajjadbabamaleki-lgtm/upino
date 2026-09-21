// The selected pill must sit the same distance from the bar's top, bottom and
// outer edge. Measured rather than eyeballed, so the geometry cannot drift.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  Brightness brightness,
) async {
  await tester.pumpWidget(
    MaterialApp(
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

void main() {
  testWidgets('the selected pill is inset equally on three sides', (t) async {
    await pumpBar(t, 2, Brightness.light);

    final bar = await rectOf(t, find.byType(UpinoNavBar));
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));

    final top = pill.top - bar.top;
    final bottom = bar.bottom - pill.bottom;
    final right = bar.right - pill.right;

    expect(top, closeTo(UpinoNavBar.inset, 0.01));
    expect(bottom, closeTo(UpinoNavBar.inset, 0.01), reason: 'top $top');
    expect(right, closeTo(UpinoNavBar.inset, 0.01), reason: 'top $top');
  });

  testWidgets('a pill on the left is inset equally on its three sides', (t) async {
    await pumpBar(t, 0, Brightness.light);

    final bar = await rectOf(t, find.byType(UpinoNavBar));
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));

    expect(pill.top - bar.top, closeTo(UpinoNavBar.inset, 0.01));
    expect(bar.bottom - pill.bottom, closeTo(UpinoNavBar.inset, 0.01));
    expect(pill.left - bar.left, closeTo(UpinoNavBar.inset, 0.01));
  });

  testWidgets('the pill fills the row height', (t) async {
    await pumpBar(t, 2, Brightness.light);
    final pill = await rectOf(t, find.byKey(const Key('nav-selected-pill')));
    expect(pill.height, closeTo(UpinoNavBar.itemHeight, 0.01));
  });

  testWidgets('only the selected destination shows a label', (t) async {
    await pumpBar(t, 2, Brightness.light);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    expect(find.text('Plan'), findsNothing);
  });

  BoxDecoration barDecoration(WidgetTester tester) =>
      tester
          .widget<Container>(find.byKey(const Key('nav-bar-surface')))
          .decoration! as BoxDecoration;

  testWidgets('the bar carries a soft shadow in light mode only', (t) async {
    await pumpBar(t, 2, Brightness.light);
    final light = barDecoration(t);
    expect(light.boxShadow, isNotNull);
    expect(light.boxShadow!.first.blurRadius, greaterThanOrEqualTo(24));

    await pumpBar(t, 2, Brightness.dark);
    expect(barDecoration(t).boxShadow, isNull);
  });

  test('the idle glyph clears the 3:1 minimum for a UI component', () {
    double channel(int v) {
      final c = v / 255.0;
      return c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
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
}
