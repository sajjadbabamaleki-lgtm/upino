// What someone said, as an amount and a category.

import 'package:flutter_test/flutter_test.dart';
import 'package:upino/domain/category.dart';
import 'package:upino/domain/spoken_spend.dart';
import 'package:upino/engine/money.dart';

SpokenSpend irr(String s) => parseSpokenSpend(s, planCurrency: 'IRR');
SpokenSpend eur(String s) => parseSpokenSpend(s, planCurrency: 'EUR');

void main() {
  group('Persian', () {
    test('number words', () {
      expect(irr('دویست و پنجاه هزار ریال').amount, Money(250000, 'IRR'));
      expect(irr('سه میلیون و چهارصد هزار').amount, Money(3400000, 'IRR'));
      expect(irr('هزار و پانصد').amount, Money(1500, 'IRR'));
    });

    test('tomans are ten rials', () {
      expect(irr('دویست و پنجاه هزار تومن نون').amount, Money(2500000, 'IRR'));
    });

    test('a half', () {
      expect(irr('یک و نیم میلیون').amount, Money(1500000, 'IRR'));
    });

    test('digits, Persian digits and a mix of digits and words', () {
      expect(irr('250 هزار').amount, Money(250000, 'IRR'));
      expect(irr('۲۵۰ هزار تومان').amount, Money(2500000, 'IRR'));
      expect(irr('۲۵۰هزار').amount, Money(250000, 'IRR'));
      expect(irr('1,500,000').amount, Money(1500000, 'IRR'));
    });

    test('the category from what was bought', () {
      expect(irr('دویست هزار تومن نون').category, SpendCategory.food);
      expect(irr('اسنپ هشتاد هزار').category, SpendCategory.transport);
      expect(irr('قبض برق سیصد هزار').category, SpendCategory.bills);
      expect(irr('داروخانه صد و بیست').category, SpendCategory.health);
    });

    test('the number stops at the first other word', () {
      expect(irr('نون بیست هزار و دو تا شیر').amount, Money(20000, 'IRR'));
    });

    test('nothing numeric gives no amount', () {
      final s = irr('نون');
      expect(s.amount, isNull);
      expect(s.category, SpendCategory.food);
    });
  });

  group('English', () {
    test('words', () {
      expect(eur('two hundred fifty').amount, Money.parse('250.00', 'EUR'));
      expect(eur('a thousand and five').amount, Money.parse('1005.00', 'EUR'));
      expect(eur('one and a half thousand').amount,
          Money.parse('1500.00', 'EUR'),);
    });

    test('decimals and cents', () {
      expect(eur('12.50 coffee').amount, Money.parse('12.50', 'EUR'));
      expect(eur('twelve euros fifty').amount, Money.parse('12.50', 'EUR'));
      expect(eur('€45').amount, Money.parse('45.00', 'EUR'));
      expect(eur('25k').amount, Money.parse('25000.00', 'EUR'));
    });

    test('category', () {
      expect(eur('coffee 4.20').category, SpendCategory.food);
      expect(eur('uber twenty').category, SpendCategory.transport);
    });

    test('a half unit survives where the currency has cents', () {
      expect(eur('ten and a half').amount, Money.parse('10.50', 'EUR'));
    });
  });
}
