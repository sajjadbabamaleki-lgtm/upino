// Reading a bank's text as a spend. The messages are written the way
// Iranian and other banks write them; the parser only ever suggests.

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/domain/bank_sms.dart';
import 'package:upino/engine/money.dart';

Money? irr(String body) =>
    parseBankSms(body, planCurrency: 'IRR')?.amount;

void main() {
  group('Iranian banks', () {
    test('a labelled withdrawal, with the balance on its own line', () {
      expect(
        irr('بانک ملت\nبرداشت:1,500,000\nحساب:1234567890\nمانده:12,340,000\n0701-14:32'),
        Money(1500000, 'IRR'),
      );
    });

    test('Persian digits and separators', () {
      expect(
        irr('بانك ملي ايران\nخرید: ۲۵۰٬۰۰۰ ریال\nمانده: ۵٬۰۰۰٬۰۰۰'),
        Money(250000, 'IRR'),
      );
    });

    test('a trailing minus sign with no word for it', () {
      expect(
        irr('بانک ملی\nانتقال:3,000,000-\nمانده:9,000,000\n1405/07/01'),
        Money(3000000, 'IRR'),
      );
    });

    test('the label and the figure on separate lines', () {
      expect(
        irr('بانک سامان\nخرید از پایانه فروش\nمبلغ 480,000\nمانده 1,200,000'),
        Money(480000, 'IRR'),
      );
      expect(
        irr('بانک سامان\nخرید\n480,000 ریال\nمانده 1,200,000'),
        Money(480000, 'IRR'),
      );
    });

    test('tomans are ten rials', () {
      expect(irr('برداشت 50,000 تومان'), Money(500000, 'IRR'));
    });

    test('a masked card number is not the amount', () {
      expect(
        irr('خرید با کارت 6037***1234\nمبلغ:120,000'),
        Money(120000, 'IRR'),
      );
      expect(
        irr('خرید کارت 6037***1234 مبلغ 120,000 ریال'),
        Money(120000, 'IRR'),
      );
    });

    test('an ungrouped amount beats the date on the same line', () {
      expect(irr('برداشت 1405/07/01 150000 ریال'), Money(150000, 'IRR'));
    });

    test('a figure is never taken from the balance line', () {
      expect(irr('خرید\nمانده:1,200,000'), isNull);
    });

    test('money coming in is not a spend', () {
      expect(irr('بانک ملت\nواریز:2,000,000\nمانده:14,340,000'), isNull);
      expect(irr('واریز حقوق\n+45,000,000\nمانده: -3,000'), isNull);
    });

    test('a message about something else is ignored', () {
      expect(irr('رمز پویا شما: 482913'), isNull);
      expect(irr('Your code is 1234'), isNull);
    });
  });

  group('elsewhere', () {
    test('an explicit currency matching the plan', () {
      expect(
        parseBankSms('Purchase of AED 45.50 at CARREFOUR. Avl bal AED 1,200.00',
                planCurrency: 'AED',)
            ?.amount,
        Money.parse('45.50', 'AED'),
      );
    });

    test('a spend in another currency than the plan is not suggested', () {
      expect(
        parseBankSms('Your card was debited USD 12.00', planCurrency: 'EUR'),
        isNull,
      );
    });

    test('rupees', () {
      expect(
        parseBankSms('Rs.500.00 debited from a/c XX1234. Avl Bal Rs.12,000',
                planCurrency: 'INR',)
            ?.amount,
        Money.parse('500.00', 'INR'),
      );
    });

    test('a rial message cannot be recorded in a euro plan', () {
      expect(
        parseBankSms('برداشت:1,500,000', planCurrency: 'EUR'),
        isNull,
      );
    });
  });
}
