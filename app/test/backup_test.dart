// Sealing a plan with a password and putting it back.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upino/data/backup.dart';
import 'package:upino/data/plan_store.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/engine/clock.dart';
import 'package:upino/engine/money.dart';
import 'package:upino/main.dart';
import 'package:upino/screens/backup_section.dart';
import 'package:upino/state/app_state.dart';

final now = DateTime.utc(2026, 10, 1, 10);
const cest = Duration(hours: 2);

// Stretching at full cost would make the suite slow for no extra coverage.
const fast = 1000;

Money eur(String v) => Money.parse(v, 'EUR');

AppState funded() => AppState(now: now, utcOffset: cest)
  ..completeOnboarding(
    OnboardingDraft()
      ..currentBalance = eur('1000.00')
      ..incomeAmount = eur('2000.00')
      ..nextIncomeDate = LocalDate.parse('2026-10-28')
      ..rent = eur('600.00'),
  )
  ..recordExpense(eur('40.00'), category: SpendCategory.food);

void main() {
  test('a backup opens with its password and lands on the same figure',
      () async {
    final original = funded();
    final sealed =
        await sealBackup(original.toDocument(), 'correct horse', iterations: fast);

    final restored = AppState(now: now, utcOffset: cest, store: InMemoryPlanStore())
      ..replaceWith(await openBackup(sealed, 'correct horse'));

    expect(restored.isOnboarded, isTrue);
    expect(restored.snapshot.safeToSpendNow, original.snapshot.safeToSpendNow);
    expect(restored.categoryFor(restored.activity.single.eventId),
        SpendCategory.food,);
  });

  test('nothing readable about the plan is in the file', () async {
    final sealed =
        await sealBackup(funded().toDocument(), 'secret1', iterations: fast);
    expect(sealed, isNot(contains('Rent')));
    expect(sealed, isNot(contains('EUR')));
    expect(sealed, isNot(contains('secret1')));
  });

  test('two backups of the same plan differ, so neither gives the other away',
      () async {
    final document = funded().toDocument();
    final a = await sealBackup(document, 'secret1', iterations: fast);
    final b = await sealBackup(document, 'secret1', iterations: fast);
    expect(a, isNot(b));
  });

  test('a wrong password is refused', () async {
    final sealed =
        await sealBackup(funded().toDocument(), 'secret1', iterations: fast);
    expect(
      () => openBackup(sealed, 'secret2'),
      throwsA(isA<BackupFailure>()
          .having((f) => f.kind, 'kind', BackupFailureKind.wrongPassword),),
    );
  });

  test('a tampered file is refused rather than half-read', () async {
    final sealed =
        await sealBackup(funded().toDocument(), 'secret1', iterations: fast);
    final json = Map<String, Object?>.from(jsonDecode(sealed) as Map);
    final data = base64Decode(json['data']! as String)..[0] ^= 1;
    json['data'] = base64Encode(data);
    expect(
      () => openBackup(jsonEncode(json), 'secret1'),
      throwsA(isA<BackupFailure>()
          .having((f) => f.kind, 'kind', BackupFailureKind.wrongPassword),),
    );
  });

  test('something that is not a backup says so', () async {
    for (final text in ['', 'hello', '{"format":"other"}', '[]']) {
      expect(
        () => openBackup(text, 'x'),
        throwsA(isA<BackupFailure>()
            .having((f) => f.kind, 'kind', BackupFailureKind.notABackup),),
        reason: text,
      );
    }
  });

  group('the password dialog', () {
    Future<void> openDialog(WidgetTester tester, {required bool confirm}) async {
      await tester.pumpWidget(UpinoApp(state: funded()));
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(Scaffold).first);
      PasswordDialog.show(context, confirm: confirm);
      await tester.pumpAndSettle();
    }

    testWidgets('refuses a short password when saving', (tester) async {
      await openDialog(tester, confirm: true);
      await tester.enterText(find.byKey(const Key('backup-password')), 'abc');
      await tester.enterText(
          find.byKey(const Key('backup-password-repeat')), 'abc',);
      await tester.tap(find.byKey(const Key('backup-password-ok')));
      await tester.pumpAndSettle();
      expect(find.text('At least 6 characters'), findsOneWidget);
    });

    testWidgets('refuses two passwords that differ', (tester) async {
      await openDialog(tester, confirm: true);
      await tester.enterText(
          find.byKey(const Key('backup-password')), 'abcdef',);
      await tester.enterText(
          find.byKey(const Key('backup-password-repeat')), 'abcdeg',);
      await tester.tap(find.byKey(const Key('backup-password-ok')));
      await tester.pumpAndSettle();
      expect(find.text('The two do not match'), findsOneWidget);
    });

    testWidgets('asks only once when opening', (tester) async {
      await openDialog(tester, confirm: false);
      expect(find.byKey(const Key('backup-password-repeat')), findsNothing);
    });
  });
}
