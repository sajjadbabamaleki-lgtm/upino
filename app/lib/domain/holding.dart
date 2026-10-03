/// Money kept in something other than the plan's currency: dollars, gold,
/// coins.
///
/// Where a currency loses a third of its value a year, savings rarely sit in
/// it, so a plan that only sees the local currency sees a fraction of what a
/// household owns. Holdings are shown beside the plan and never enter it:
/// Safe-to-Spend is what can be spent now, and selling gold is neither now
/// nor free. The engine forbids mixing currencies (§16), and this keeps it
/// that way.
///
/// A holding is worth what the person last priced it at. The app has no
/// network and does not guess a rate; the date of the price is kept so a
/// stale one is visible as stale.
library;

import '../engine/clock.dart';
import '../engine/money.dart';

class Holding {
  const Holding({
    required this.id,
    required this.name,
    required this.quantityMilli,
    required this.unitPrice,
    required this.pricedOn,
  });

  final String id;
  final String name;

  /// How many units, in thousandths, so 2.5 grams is 2500 and no binary
  /// fraction is involved.
  final int quantityMilli;

  /// What one unit is worth, in the plan's currency.
  final Money unitPrice;
  final LocalDate pricedOn;

  Money get value => Money(
        divideRoundHalfEven(quantityMilli * unitPrice.minor, 1000),
        unitPrice.currency,
      );

  Holding copyWith({
    String? name,
    int? quantityMilli,
    Money? unitPrice,
    LocalDate? pricedOn,
  }) =>
      Holding(
        id: id,
        name: name ?? this.name,
        quantityMilli: quantityMilli ?? this.quantityMilli,
        unitPrice: unitPrice ?? this.unitPrice,
        pricedOn: pricedOn ?? this.pricedOn,
      );
}

/// `2.5` → 2500. Up to three decimals; null for anything else.
int? parseQuantity(String text) {
  final m = RegExp(r'^\s*(\d{1,12})(?:[.,](\d{1,3}))?\s*$').firstMatch(text);
  if (m == null) return null;
  final part = (m.group(2) ?? '').padRight(3, '0');
  return int.parse(m.group(1)!) * 1000 + int.parse(part);
}

/// 2500 → `2.5`.
String formatQuantity(int milli) {
  final whole = milli ~/ 1000;
  final part = milli % 1000;
  if (part == 0) return '$whole';
  return '$whole.${part.toString().padLeft(3, '0').replaceAll(RegExp(r'0+$'), '')}';
}
