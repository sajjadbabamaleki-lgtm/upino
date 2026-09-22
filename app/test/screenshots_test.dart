// Renders each screen and hero state to a PNG so the design can be reviewed
// without a device.
//
//   flutter test test/screenshots_test.dart --update-goldens
//
// Images land in test/screenshots/. These are review artefacts, not assertions
// about pixels: regenerate them whenever the design changes.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/design/theme.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/domain.dart';
import 'package:upino/engine/ledger.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/engine/plan.dart';
import 'package:upino/main.dart';
import 'package:upino/state/app_state.dart';
import 'package:upino/widgets/sts_hero.dart';

const eurCode = 'EUR';
const bank = 'bank';
final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);
const boundary = Key('shot');

Money eur(String v) => Money.parse(v, eurCode);

Claim claim(String id, Priority p, String amount, String label) =>
    Claim(id: id, priority: p, label: label, amount: eur(amount));

PlanSnapshot snap({
  String balance = '3000.00',
  List<Claim> claims = const [],
  List<LedgerEvent> events = const [],
  List<CardTerms> cards = const [],
  DateTime? oldestConfirmationAt,
}) =>
    computePlan(PlanInput(
      currency: eurCode,
      now: now,
      utcOffset: cest,
      includedAccounts: const [bank],
      openingBalances: {bank: eur(balance)},
      claims: claims,
      events: events,
      cards: cards,
      oldestConfirmationAt: oldestConfirmationAt,
    ),);

AppState fundedState({String balance = '3000.00', bool withExpense = false}) {
  final state = AppState(now: now, utcOffset: cest)
    ..completeOnboarding(
      OnboardingDraft()
        ..currentBalance = eur(balance)
        ..incomeAmount = eur('2000.00')
        ..nextIncomeDate = LocalDate.parse('2026-10-28')
        ..rent = eur('1200.00')
        ..essentials = eur('400.00')
        ..goalAmount = eur('200.00'),
    );
  if (withExpense) state.recordExpense(eur('25.00'));
  return state;
}

Widget heroPage(PlanSnapshot s, String caption) => Builder(
      builder: (context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(caption, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                StsHero(snapshot: s, onConfirmBalance: () {}, onResolve: () {}),
              ],
            ),
          ),
        ),
      ),
    );

Future<void> shoot(
  WidgetTester tester,
  String name,
  Widget child, {
  Brightness brightness = Brightness.light,
  Size size = const Size(400, 900),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    RepaintBoundary(
      key: boundary,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(brightness: brightness, fontFamily: 'UpinoSans'),
        home: child,
      ),
    ),
  );
  await tester.pump();
  await expectLater(
    find.byKey(boundary),
    matchesGoldenFile('screenshots/$name.png'),
  );
}

Future<void> shootApp(
  WidgetTester tester,
  String name,
  AppState state, {
  Size size = const Size(400, 900),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    RepaintBoundary(key: boundary, child: UpinoApp(state: state, fontFamily: 'UpinoSans')),
  );
  await tester.pump();
  await expectLater(
    find.byKey(boundary),
    matchesGoldenFile('screenshots/$name.png'),
  );
}

/// The test binding ships only Ahem, which draws every glyph as a filled box.
/// Load a real face so the screenshots show actual words.
Future<void> loadFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      final bytes = File('test/fonts/$file').readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
    await loader.load();
  }

  await load('UpinoSans', ['Roboto-Regular.ttf', 'Roboto-Bold.ttf']);
  // Without this the Material glyphs draw as filled boxes.
  await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
}

void main() {
  setUpAll(loadFonts);

  testWidgets('01 onboarding', (tester) async {
    await shootApp(
      tester,
      '01-onboarding',
      AppState(now: now, utcOffset: cest),
      size: const Size(400, 1400),
    );
  });

  testWidgets('02 home', (tester) async {
    await shootApp(tester, '02-home', fundedState());
  });

  testWidgets('03 home after an expense', (tester) async {
    await shootApp(
      tester,
      '03-home-after-expense',
      fundedState(withExpense: true),
    );
  });

  testWidgets('03b activity with a removed entry', (tester) async {
    final state = fundedState(withExpense: true)..recordExpense(eur('9.99'));
    state.removeEvent(state.activity[1].eventId);
    tester.view
      ..physicalSize = const Size(400, 700)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundary,
        child: UpinoApp(state: state, fontFamily: 'UpinoSans'),
      ),
    );
    await tester.pump();
    await tester.tap(find.byIcon(Icons.receipt_long_rounded));
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(boundary),
      matchesGoldenFile('screenshots/03b-activity.png'),
    );
  });

  testWidgets('03c plan', (tester) async {
    final state = fundedState();
    tester.view
      ..physicalSize = const Size(400, 1250)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundary,
        child: UpinoApp(state: state, fontFamily: 'UpinoSans'),
      ),
    );
    await tester.pump();
    await tester.tap(find.byIcon(Icons.account_balance_wallet_rounded));
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(boundary),
      matchesGoldenFile('screenshots/03c-plan.png'),
    );
  });

  testWidgets('04 hero S1 trusted', (tester) async {
    await shoot(
      tester,
      '04-s1-trusted',
      heroPage(
        snap(claims: [
          claim('rent', Priority.p2HardObligation, '1200.00', 'Rent and bills'),
        ],),
        'S1 — everything current',
      ),
      size: const Size(400, 380),
    );
  });

  testWidgets('05 hero S2 degraded', (tester) async {
    await shoot(
      tester,
      '05-s2-degraded',
      heroPage(
        snap(
          claims: [
            claim('rent', Priority.p2HardObligation, '1200.00', 'Rent and bills'),
          ],
          oldestConfirmationAt: now.subtract(const Duration(days: 8)),
        ),
        'S2 — balance 8 days old: de-emphasis, not alarm',
      ),
      size: const Size(400, 420),
    );
  });

  testWidgets('06 hero S3 funding gap', (tester) async {
    await shoot(
      tester,
      '06-s3-funding-gap',
      heroPage(
        snap(
          balance: '900.00',
          claims: [
            claim('rent', Priority.p2HardObligation, '500.00', 'Rent and bills'),
            claim('ess', Priority.p4EssentialLiving, '300.00', 'Food and transport'),
            claim('goal', Priority.p7HardGoal, '300.00', 'Savings goal'),
          ],
        ),
        'S3 — committed more than available',
      ),
      size: const Size(400, 460),
    );
  });

  testWidgets('07 hero S4 review required', (tester) async {
    await shoot(
      tester,
      '07-s4-review',
      heroPage(
        snap(oldestConfirmationAt: now.subtract(const Duration(days: 22))),
        'S4 — evidence too old to present as trusted',
      ),
      size: const Size(400, 420),
    );
  });

  testWidgets('08 dark mode trusted', (tester) async {
    await shoot(
      tester,
      '08-dark-trusted',
      heroPage(
        snap(claims: [
          claim('rent', Priority.p2HardObligation, '1200.00', 'Rent and bills'),
        ],),
        'S1 — dark mode',
      ),
      brightness: Brightness.dark,
      size: const Size(400, 380),
    );
  });

  testWidgets('09 dark mode funding gap', (tester) async {
    await shoot(
      tester,
      '09-dark-gap',
      heroPage(
        snap(
          balance: '900.00',
          claims: [
            claim('rent', Priority.p2HardObligation, '500.00', 'Rent and bills'),
            claim('goal', Priority.p7HardGoal, '700.00', 'Savings goal'),
          ],
        ),
        'S3 — dark mode',
      ),
      brightness: Brightness.dark,
      size: const Size(400, 460),
    );
  });
}
