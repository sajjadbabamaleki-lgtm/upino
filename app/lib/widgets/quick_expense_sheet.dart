/// Quick Expense, §18 step 4: amount → reason → save.
///
/// §18 targets roughly three seconds on the normal path, so the keypad opens
/// focused, the reason is optional and nothing else stands between the user
/// and Save.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';

class QuickExpenseSheet extends StatefulWidget {
  const QuickExpenseSheet({required this.currency, super.key});

  final String currency;

  static Future<Money?> show(BuildContext context, String currency) =>
      showModalBottomSheet<Money>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => QuickExpenseSheet(currency: currency),
      );

  @override
  State<QuickExpenseSheet> createState() => _QuickExpenseSheetState();
}

class _QuickExpenseSheetState extends State<QuickExpenseSheet> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
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
      return money.minor > 0 ? money : null;
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
    final dark = theme.brightness == Brightness.dark;
    final amount = _parsed;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          UpinoTokens.gutter,
          12,
          UpinoTokens.gutter,
          UpinoTokens.gutter,
        ),
        decoration: BoxDecoration(
          color: dark ? UpinoTokens.darkSurfaceRaised : UpinoTokens.surfaceRaised,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(UpinoTokens.radiusCard + 4),
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
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dark
                        ? UpinoTokens.darkBorderSubtle
                        : UpinoTokens.borderSubtle,
                    borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('How much did you spend?',
                  style: theme.textTheme.headlineMedium,),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                focusNode: _focus,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _save(),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 44,
                  fontFeatures: moneyFeatures,
                ),
                decoration: InputDecoration(
                  prefixText: Currency.of(widget.currency).symbol,
                  prefixStyle: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 44,
                    color: dark
                        ? UpinoTokens.darkTextTertiary
                        : UpinoTokens.textTertiary,
                  ),
                  hintText: '0.00',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: amount == null ? null : _save,
                child: const Text('Save'),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
