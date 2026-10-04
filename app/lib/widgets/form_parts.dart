/// The pieces the editing sheets are built from, so a bill, an account and
/// a goal are asked for the same way.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';

/// The frame every editing sheet sits in: raised surface, a handle, a title.
class EditorSheetFrame extends StatelessWidget {
  const EditorSheetFrame({required this.title, required this.children, super.key});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Text(title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 18),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      );
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );
}

class SunkenField extends StatelessWidget {
  const SunkenField({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
        ),
        child: child,
      );
}

InputDecoration plainInput(ThemeData theme, String hint) => InputDecoration(
      hintText: hint,
      hintStyle:
          theme.textTheme.bodyMedium?.copyWith(color: UpinoTokens.textTertiary),
      border: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
    );

/// A money field: the currency's symbol, then digits.
class MoneyField extends StatelessWidget {
  const MoneyField({
    required this.controller,
    required this.currency,
    required this.hint,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String currency;
  final String hint;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SunkenField(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            Currency.of(currency).symbol,
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: UpinoTokens.textTertiary),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (_) => onChanged(),
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontFeatures: moneyFeatures),
              decoration: plainInput(theme, hint),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reads a money field, or null when it holds nothing usable.
Money? parseMoneyField(String text, String currency, {bool allowZero = false}) {
  final t = text.trim();
  if (t.isEmpty) return allowZero ? Money.zero(currency) : null;
  try {
    final m = Money.parse(t, currency);
    if (m.minor < 0 || (m.isZero && !allowZero)) return null;
    return m;
  } on ArgumentError {
    return null;
  }
}

/// One of a few choices, all visible at once.
class PillChoice extends StatelessWidget {
  const PillChoice({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final active =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? active : sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : (dark
                    ? UpinoTokens.darkTextSecondary
                    : UpinoTokens.textSecondary),
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
