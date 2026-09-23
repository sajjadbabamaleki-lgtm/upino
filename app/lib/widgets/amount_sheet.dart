/// One amount, asked for once. Used by Quick Expense, balance confirmation
/// and every editor on the Plan screen, so the keypad path is identical
/// wherever money is entered.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';

class AmountSheet extends StatefulWidget {
  const AmountSheet({
    required this.currency,
    required this.title,
    this.explanation,
    this.initial,
    this.confirmLabel,
    this.allowZero = false,
    this.onRemove,
    this.removeLabel,
    super.key,
  });

  final String currency;
  final String title;
  final String? explanation;
  final Money? initial;
  /// Null takes the localized default.
  final String? confirmLabel;

  /// Plan editors accept zero, which clears the commitment. Quick Expense
  /// does not, because recording nothing is never what was meant.
  final bool allowZero;
  final VoidCallback? onRemove;
  final String? removeLabel;

  static Future<Money?> show(
    BuildContext context, {
    required String currency,
    required String title,
    String? explanation,
    Money? initial,
    String? confirmLabel,
    bool allowZero = false,
    String? removeLabel,
  }) =>
      showModalBottomSheet<Money>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => AmountSheet(
          currency: currency,
          title: title,
          explanation: explanation,
          initial: initial,
          confirmLabel: confirmLabel,
          allowZero: allowZero,
          removeLabel: removeLabel,
          onRemove: removeLabel == null
              ? null
              : () => Navigator.of(sheetContext).pop(Money.zero(currency)),
        ),
      );

  @override
  State<AmountSheet> createState() => _AmountSheetState();
}

class _AmountSheetState extends State<AmountSheet> {
  late final TextEditingController _controller;
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _controller = TextEditingController(
      text: initial == null || initial.isZero
          ? ''
          : initial.display(withSymbol: false, grouped: false),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Money? get _parsed {
    final text = _controller.text.trim();
    if (text.isEmpty) return null;
    try {
      final money = Money.parse(text, widget.currency);
      if (money.minor < 0) return null;
      if (money.isZero && !widget.allowZero) return null;
      return money;
    } on ArgumentError {
      return null;
    }
  }

  void _save() {
    final amount = _parsed;
    if (amount != null) Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = _parsed;
    final decimals = Currency.of(widget.currency).exponent;

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
                    borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(widget.title, style: theme.textTheme.headlineMedium),
              if (widget.explanation != null) ...[
                const SizedBox(height: 6),
                Text(widget.explanation!, style: theme.textTheme.bodySmall),
              ],
              const SizedBox(height: 18),
              UpinoCard(
                color: sunkenColor(context),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      Currency.of(widget.currency).symbol,
                      style: theme.textTheme.displayMedium
                          ?.copyWith(color: UpinoTokens.textTertiary),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focus,
                        autofocus: true,
                        // A currency with no minor unit rejects a decimal
                        // point on parse, so it is not offered or accepted.
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: decimals > 0,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            decimals > 0 ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
                          ),
                        ],
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _save(),
                        style: theme.textTheme.displayMedium
                            ?.copyWith(fontFeatures: moneyFeatures),
                        decoration: InputDecoration(
                          hintText: decimals == 0
                              ? '0'
                              : '0.${'0' * decimals}',
                          hintStyle: theme.textTheme.displayMedium
                              ?.copyWith(color: UpinoTokens.textTertiary),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: amount == null ? null : _save,
                child: Text(
                  widget.confirmLabel ?? AppLocalizations.of(context).save,
                ),
              ),
              if (widget.onRemove != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: widget.onRemove,
                    child: Text(
                      widget.removeLabel!,
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
    );
  }
}
