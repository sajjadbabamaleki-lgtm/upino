// Design acceptance checks, §32.10 of Upino Product Foundation v3.5.
//
// These verify that presentation is a function of engine state: each check
// drives the widget from a fixed snapshot and asserts what may and may not
// appear.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/design/theme.dart';
import 'package:upino/design/tokens.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/ledger.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/engine/plan.dart';
import 'package:upino/widgets/sts_hero.dart';

const eurCode = 'EUR';
const bank = 'bank';
final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

Money eur(String v) => Money.parse(v, eurCode);

Claim claim(String id, Priority priority, String amount) => Claim(
      id: id,
      priority: priority,
      label: id,
      amount: eur(amount),
    );

PlanSnapshot snap({
  String balance = '3000.00',
  List<Claim> claims = const [],
  List<LedgerEvent> events = const [],
  DateTime? oldestConfirmationAt,
  bool materialIntegrityIssue = false,
}) =>
    computePlan(PlanInput(
      currency: eurCode,
      now: now,
      utcOffset: cest,
      includedAccounts: const [bank],
      openingBalances: {bank: eur(balance)},
      claims: claims,
      events: events,
      oldestConfirmationAt: oldestConfirmationAt,
      materialIntegrityIssue: materialIntegrityIssue,
    ),);

Future<void> pumpHero(WidgetTester tester, PlanSnapshot s) async {
  await tester.pumpWidget(MaterialApp(
    theme: buildTheme(brightness: Brightness.light),
    home: Scaffold(
      body: StsHero(snapshot: s, onConfirmBalance: () {}, onResolve: () {}),
    ),
  ),);
}

/// Every colour actually painted anywhere in the rendered tree.
Set<Color> paintedColors(WidgetTester tester) {
  final colors = <Color>{};
  for (final element in find.byType(Container).evaluate()) {
    final decoration = (element.widget as Container).decoration;
    if (decoration is BoxDecoration) {
      final color = decoration.color;
      if (color != null) colors.add(color);
      final gradient = decoration.gradient;
      if (gradient is LinearGradient) colors.addAll(gradient.colors);
    }
  }
  for (final element in find.byType(Text).evaluate()) {
    final color = (element.widget as Text).style?.color;
    if (color != null) colors.add(color);
  }
  for (final element in find.byType(Icon).evaluate()) {
    final color = (element.widget as Icon).color;
    if (color != null) colors.add(color);
  }
  return colors;
}

bool usesGradient(WidgetTester tester) => paintedColors(tester)
    .contains(UpinoTokens.gradientStart);

void main() {
  _ageRegression();

  group('§32.10 Design acceptance checks', () {
    testWidgets('D01 — trusted, STS positive: gradient hero, no accent', (t) async {
      final s = snap(claims: [claim('rent', Priority.p2HardObligation, '1200.00')]);
      expect(s.confidenceState, ConfidenceState.trusted);
      expect(heroStateFor(s), HeroState.trusted);

      await pumpHero(t, s);
      expect(find.text('€1,800.00'), findsOneWidget);
      expect(usesGradient(t), isTrue);
      expect(paintedColors(t), isNot(contains(UpinoTokens.accentConfirm)));
      expect(paintedColors(t), isNot(contains(UpinoTokens.critical)));
    });

    testWidgets('D02 — degraded: identical fill, no warning styling at all', (t) async {
      final trusted = snap();
      final degraded = snap(
        oldestConfirmationAt: now.subtract(const Duration(days: 8)),
      );
      expect(degraded.confidenceState, ConfidenceState.degraded);
      expect(heroStateFor(degraded), HeroState.degraded);

      await pumpHero(t, trusted);
      final trustedColors = paintedColors(t);

      await pumpHero(t, degraded);
      final degradedColors = paintedColors(t);

      // Same figure, same gradient, and not one critical token on screen.
      expect(find.text('€3,000.00'), findsOneWidget);
      expect(usesGradient(t), isTrue);
      expect(degradedColors, isNot(contains(UpinoTokens.critical)));
      expect(degradedColors, isNot(contains(UpinoTokens.criticalOnInverse)));
      expect(degradedColors, isNot(contains(UpinoTokens.criticalSurface)));
      // Degraded may add de-emphasis, never emphasis: anything new must be a
      // lower-opacity variant of the on-inverse text, not a new hue.
      final introduced = degradedColors.difference(trustedColors);
      for (final color in introduced) {
        expect(
          color.r == color.g && color.g == color.b,
          isTrue,
          reason: 'age introduced a hue ($color); §15.2 allows de-emphasis only',
        );
        expect(
          color.a < 1.0,
          isTrue,
          reason: 'age introduced a fully opaque colour ($color)',
        );
      }
      expect(find.textContaining('Confirm'), findsOneWidget);
    });

    testWidgets('D03 — stale beyond review window: figure de-emphasised', (t) async {
      final s = snap(oldestConfirmationAt: now.subtract(const Duration(days: 22)));
      expect(s.confidenceState, ConfidenceState.reviewRequired);
      expect(heroStateFor(s), HeroState.reviewRequired);

      await pumpHero(t, s);
      expect(usesGradient(t), isFalse);
      expect(find.text('Not up to date'), findsOneWidget);
      expect(find.text('Confirm balance'), findsOneWidget);
    });

    testWidgets('D04 — material integrity risk overrides fresh evidence', (t) async {
      final s = snap(oldestConfirmationAt: now, materialIntegrityIssue: true);
      expect(heroStateFor(s), HeroState.reviewRequired);

      await pumpHero(t, s);
      expect(usesGradient(t), isFalse);
      expect(paintedColors(t), contains(UpinoTokens.criticalSurface));
    });

    testWidgets('D05 — mandatory gap: zero figure, gap named in critical', (t) async {
      final s = snap(
        balance: '900.00',
        claims: [
          claim('rent', Priority.p2HardObligation, '500.00'),
          claim('essentials', Priority.p4EssentialLiving, '300.00'),
          claim('goal', Priority.p7HardGoal, '300.00'),
        ],
      );
      expect(s.mandatoryFundingGap.toString(), '200.00 EUR');
      expect(heroStateFor(s), HeroState.fundingGap);

      await pumpHero(t, s);
      expect(find.text('€0.00'), findsOneWidget);
      expect(usesGradient(t), isFalse);
      expect(paintedColors(t), contains(UpinoTokens.surfaceInverse));
      expect(paintedColors(t), contains(UpinoTokens.criticalOnInverse));
      // The gap is stated once on the hero and again beside the claim that
      // caused it; both are the same authoritative figure.
      expect(find.textContaining('€200.00'), findsNWidgets(2));
      expect(
        find.text('€200.00 short of what you have committed'),
        findsOneWidget,
      );
    });

    testWidgets('D06 — review takes precedence over a funding gap', (t) async {
      final s = snap(
        balance: '900.00',
        claims: [claim('goal', Priority.p7HardGoal, '1500.00')],
        oldestConfirmationAt: now.subtract(const Duration(days: 22)),
      );
      expect(s.hasMandatoryGap, isTrue);
      expect(s.confidenceState, ConfidenceState.reviewRequired);
      expect(heroStateFor(s), HeroState.reviewRequired);

      await pumpHero(t, s);
      expect(find.text('Not up to date'), findsOneWidget);
    });

    testWidgets('D07 — a buffer shortfall never borrows the critical token', (t) async {
      final s = snap(
        balance: '700.00',
        claims: [
          claim('essentials', Priority.p4EssentialLiving, '500.00'),
          claim('buffer', Priority.p6Buffer, '500.00'),
        ],
      );
      expect(s.bufferShortfall.toString(), '300.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');
      expect(heroStateFor(s), HeroState.trusted);

      await pumpHero(t, s);
      expect(usesGradient(t), isTrue);
      expect(paintedColors(t), isNot(contains(UpinoTokens.critical)));
      expect(paintedColors(t), isNot(contains(UpinoTokens.criticalOnInverse)));
    });

    testWidgets('D08 — a flexible shortfall is equally not a failure', (t) async {
      final s = snap(
        balance: '900.00',
        claims: [
          claim('rent', Priority.p2HardObligation, '500.00'),
          claim('travel', Priority.p8Flexible, '600.00'),
        ],
      );
      expect(s.flexibleShortfall.toString(), '200.00 EUR');
      expect(s.mandatoryFundingGap.toString(), '0.00 EUR');

      await pumpHero(t, s);
      expect(usesGradient(t), isTrue);
      expect(paintedColors(t), isNot(contains(UpinoTokens.criticalOnInverse)));
    });

    testWidgets('D09 — a card shortfall names its own cause', (t) async {
      final s = computePlan(PlanInput(
        currency: eurCode,
        now: now,
        utcOffset: cest,
        includedAccounts: const [bank],
        openingBalances: {bank: eur('200.00')},
        events: [
          CardPurchaseEvent(id: 'e1', cardId: 'visa', amount: eur('350.00')),
        ],
        cards: const [CardTerms(id: 'visa')],
      ),);
      expect(s.reasonCodes, contains(ReasonCode.cardSpendFundingGap));
      expect(heroStateFor(s), HeroState.fundingGap);

      await pumpHero(t, s);
      expect(find.textContaining('Card balance already spent'), findsOneWidget);
      expect(find.textContaining('€150.00'), findsWidgets);
    });

    testWidgets('D10 — the figure never abbreviates a large amount', (t) async {
      await pumpHero(t, snap(balance: '12345.67'));
      expect(find.text('€12,345.67'), findsOneWidget);
      expect(find.textContaining('k'), findsNothing);
    });

    testWidgets('D11 — every state is distinguishable from text alone', (t) async {
      final states = <HeroState, PlanSnapshot>{
        HeroState.trusted: snap(),
        HeroState.degraded:
            snap(oldestConfirmationAt: now.subtract(const Duration(days: 8))),
        HeroState.fundingGap: snap(
          balance: '100.00',
          claims: [claim('rent', Priority.p2HardObligation, '500.00')],
        ),
        HeroState.reviewRequired:
            snap(oldestConfirmationAt: now.subtract(const Duration(days: 30))),
      };
      final phrases = <String>{};
      for (final entry in states.entries) {
        expect(heroStateFor(entry.value), entry.key);
        await pumpHero(t, entry.value);
        final texts = find
            .byType(Text)
            .evaluate()
            .map((e) => (e.widget as Text).data ?? '')
            .where((s) => s.isNotEmpty)
            .join(' | ');
        phrases.add(texts);
      }
      expect(phrases.length, 4,
          reason: 'each state must read differently without relying on colour',);
    });

    testWidgets('D12 — dark mode keeps the gradient exclusive to S1 and S2', (t) async {
      final gap = snap(
        balance: '100.00',
        claims: [claim('rent', Priority.p2HardObligation, '500.00')],
      );
      await t.pumpWidget(MaterialApp(
        theme: buildTheme(brightness: Brightness.dark),
        home: Scaffold(
          body: StsHero(snapshot: gap, onConfirmBalance: () {}, onResolve: () {}),
        ),
      ),);
      expect(paintedColors(t), isNot(contains(UpinoTokens.darkGradientStart)));

      await t.pumpWidget(MaterialApp(
        theme: buildTheme(brightness: Brightness.dark),
        home: Scaffold(
          body: StsHero(
            snapshot: snap(),
            onConfirmBalance: () {},
            onResolve: () {},
          ),
        ),
      ),);
      expect(paintedColors(t), contains(UpinoTokens.darkGradientStart));
    });
  });
}

// Regression: the freshness line once derived its age from the wall clock
// rather than the snapshot, so a snapshot computed for a fixed instant
// rendered "-1 days ago".
void _ageRegression() {
  group('§32.6 freshness line reads the snapshot clock', () {
    test('age comes from the snapshot, not the wall clock', () {
      final s = snap(oldestConfirmationAt: now.subtract(const Duration(days: 8)));
      expect(s.computedAt, now);
      expect(s.balanceAgeInDays, 8);
    });

    test('a confirmation newer than the snapshot never reads negative', () {
      final s = snap(oldestConfirmationAt: now.add(const Duration(days: 3)));
      expect(s.balanceAgeInDays, 0);
    });

    test('no confirmation yet reads as unknown, not zero', () {
      expect(snap().balanceAgeInDays, isNull);
    });
  });
}
