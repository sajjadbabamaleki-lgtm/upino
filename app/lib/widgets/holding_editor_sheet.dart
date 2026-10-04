/// Adding or changing a holding: what it is, how much of it, and what one
/// unit is worth today.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../domain/holding.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';

class HoldingDraft {
  const HoldingDraft({
    required this.name,
    required this.quantityMilli,
    required this.unitPrice,
    this.deleted = false,
  });

  final String name;
  final int quantityMilli;
  final Money unitPrice;
  final bool deleted;
}

class HoldingEditorSheet extends StatefulWidget {
  const HoldingEditorSheet({
    required this.currency,
    this.holding,
    super.key,
  });

  final String currency;
  final Holding? holding;

  static Future<HoldingDraft?> show(
    BuildContext context, {
    required String currency,
    Holding? holding,
  }) =>
      showModalBottomSheet<HoldingDraft>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => HoldingEditorSheet(currency: currency, holding: holding),
      );

  @override
  State<HoldingEditorSheet> createState() => _HoldingEditorSheetState();
}

class _HoldingEditorSheetState extends State<HoldingEditorSheet> {
  late final _name = TextEditingController(text: widget.holding?.name ?? '');
  late final _quantity = TextEditingController(
    text: widget.holding == null
        ? ''
        : formatQuantity(widget.holding!.quantityMilli),
  );
  late final _price = TextEditingController(
    text: widget.holding == null
        ? ''
        : widget.holding!.unitPrice.display(withSymbol: false, grouped: false),
  );

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _price.dispose();
    super.dispose();
  }

  Money? get _parsedPrice {
    try {
      final m = Money.parse(_price.text.trim(), widget.currency);
      return m.minor > 0 ? m : null;
    } on ArgumentError {
      return null;
    }
  }

  int? get _parsedQuantity {
    final q = parseQuantity(_quantity.text);
    return q == null || q <= 0 ? null : q;
  }

  bool get _canSave =>
      _name.text.trim().isNotEmpty &&
      _parsedQuantity != null &&
      _parsedPrice != null;

  void _save() {
    if (!_canSave) return;
    Navigator.of(context).pop(HoldingDraft(
      name: _name.text.trim(),
      quantityMilli: _parsedQuantity!,
      unitPrice: _parsedPrice!,
    ),);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final editing = widget.holding != null;
    final decimals = Currency.of(widget.currency).exponent;
    final presets = [l.holdingUsd, l.holdingEur, l.holdingGold, l.holdingCoin];
    final quantity = _parsedQuantity;
    final price = _parsedPrice;
    final total = quantity == null || price == null
        ? null
        : Money(
            divideRoundHalfEven(quantity * price.minor, 1000),
            widget.currency,
          );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
        decoration: BoxDecoration(
          color: isDark(context)
              ? UpinoTokens.darkSurfaceRaised
              : UpinoTokens.surfaceRaised,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(UpinoTokens.radiusHero),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: borderColor(context),
                      borderRadius:
                          BorderRadius.circular(UpinoTokens.radiusPill),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  editing ? l.holdingEditExisting : l.holdingEditNew,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 18),
                _label(context, l.holdingName),
                _field(
                  context,
                  TextField(
                    key: const Key('holding-name'),
                    controller: _name,
                    onChanged: (_) => setState(() {}),
                    style: theme.textTheme.titleMedium,
                    decoration: _plain(theme, l.holdingNameHint),
                  ),
                ),
                if (!editing) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final p in presets)
                        ActionChip(
                          label: Text(p),
                          onPressed: () => setState(() => _name.text = p),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                _label(context, l.holdingQuantity),
                _field(
                  context,
                  TextField(
                    key: const Key('holding-quantity'),
                    controller: _quantity,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    onChanged: (_) => setState(() {}),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontFeatures: moneyFeatures),
                    decoration: _plain(theme, '0'),
                  ),
                ),
                const SizedBox(height: 16),
                _label(context, l.holdingUnitPrice),
                _field(
                  context,
                  Row(
                    children: [
                      Text(
                        Currency.of(widget.currency).symbol,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: UpinoTokens.textTertiary),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          key: const Key('holding-price'),
                          controller: _price,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: decimals > 0,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              decimals > 0 ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
                            ),
                          ],
                          onChanged: (_) => setState(() {}),
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontFeatures: moneyFeatures),
                          decoration: _plain(theme, l.tapToType),
                        ),
                      ),
                    ],
                  ),
                ),
                if (total != null) ...[
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      l.holdingWorth(total.display()),
                      key: const Key('holding-total'),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                FilledButton(
                  key: const Key('holding-save'),
                  onPressed: _canSave ? _save : null,
                  child: Text(l.save),
                ),
                if (editing) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      key: const Key('holding-delete'),
                      onPressed: () => Navigator.of(context).pop(HoldingDraft(
                        name: widget.holding!.name,
                        quantityMilli: widget.holding!.quantityMilli,
                        unitPrice: widget.holding!.unitPrice,
                        deleted: true,
                      ),),
                      child: Text(
                        l.holdingDelete,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark(context)
                              ? UpinoTokens.darkCritical
                              : UpinoTokens.critical,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );

  Widget _field(BuildContext context, Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
        ),
        child: child,
      );

  InputDecoration _plain(ThemeData theme, String hint) => InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: UpinoTokens.textTertiary),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      );
}
