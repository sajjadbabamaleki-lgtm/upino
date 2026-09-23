/// The two taps a person makes to answer a picker.
///
/// Onboarding asks for the language and the currency in sheets that slide up
/// from the rows carrying the questions, so a test about what comes after the
/// answer opens the sheet the same way rather than reaching into the picker.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pickCurrency(WidgetTester tester, String code) async {
  await tester.tap(find.byKey(const Key('change-currency')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('currency-$code')));
  await tester.pumpAndSettle();
}

Future<void> pickLanguage(WidgetTester tester, String code) async {
  await tester.tap(find.byKey(const Key('change-language')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('language-$code')));
  await tester.pumpAndSettle();
}
