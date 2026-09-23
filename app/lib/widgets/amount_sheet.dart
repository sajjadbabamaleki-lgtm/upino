/// One amount, asked for once. Used by Quick Expense, balance confirmation
/// and every editor on the Plan screen, so the keypad path is identical
/// wherever money is entered.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/icon.dart';
import '../design/tokens.dart';
import 'dart:io';

import '../data/receipt_store.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';

/// What the sheet hands back: the amount, and the receipt photographed for
/// it if there was one.
class RecordedAmount {
  const RecordedAmount(this.amount, {this.receipt});
  final Money amount;

  /// A filename inside the app's own directory, already copied there.
  final String? receipt;
}

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
    this.allowReceipt = false,
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

  /// Offered only where a photograph means something: a spend that happened,
  /// not a plan figure being edited.
  final bool allowReceipt;

  static Future<RecordedAmount?> show(
    BuildContext context, {
    required String currency,
    required String title,
    String? explanation,
    Money? initial,
    String? confirmLabel,
    bool allowZero = false,
    String? removeLabel,
    bool allowReceipt = false,
  }) =>
      showModalBottomSheet<RecordedAmount>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => AmountSheet(
          currency: currency,
          title: title,
          explanation: explanation,
          initial: initial,
          confirmLabel: confirmLabel,
          allowReceipt: allowReceipt,
          allowZero: allowZero,
          removeLabel: removeLabel,
          onRemove: removeLabel == null
              ? null
              : () => Navigator.of(sheetContext)
                  .pop(RecordedAmount(Money.zero(currency))),
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

  String? _receipt;
  bool _busy = false;

  Future<void> _addReceipt(ImageSource source) async {
    setState(() => _busy = true);
    try {
      final name = await const ReceiptStore().capture(source: source);
      if (name != null && mounted) setState(() => _receipt = name);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _save() {
    final amount = _parsed;
    if (amount != null) {
      Navigator.of(context).pop(RecordedAmount(amount, receipt: _receipt));
    }
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
              if (widget.allowReceipt) ...[
                const SizedBox(height: 12),
                _ReceiptRow(
                  receipt: _receipt,
                  busy: _busy,
                  onCamera: () => _addReceipt(ImageSource.camera),
                  onGallery: () => _addReceipt(ImageSource.gallery),
                  onClear: () => setState(() => _receipt = null),
                ),
              ],
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


/// Adding a receipt is offered, never required. A spend with no photograph
/// is still a complete record of the money; the photograph is evidence about
/// the purchase, which is a separate thing (§5, Purchase Lifecycle).
class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.receipt,
    required this.busy,
    required this.onCamera,
    required this.onGallery,
    required this.onClear,
  });

  final String? receipt;
  final bool busy;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    if (busy) {
      return const SizedBox(
        height: 46,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
        ),
      );
    }

    if (receipt != null) {
      return Row(
        key: const Key('receipt-attached'),
        children: [
          FutureBuilder<File?>(
            future: const ReceiptStore().file(receipt!),
            builder: (context, snap) => Container(
              width: 46,
              height: 46,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: sunkenColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: snap.data == null
                  ? const UpinoIcon('activity', size: 20)
                  : Image.file(snap.data!, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(l.receiptAttached, style: theme.textTheme.bodyMedium),
          ),
          GestureDetector(
            key: const Key('receipt-clear'),
            onTap: onClear,
            child: UpinoIcon('close',
              size: 19,
              color: isDark(context)
                  ? UpinoTokens.darkTextTertiary
                  : UpinoTokens.textTertiary,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _ReceiptButton(
            key: const Key('receipt-camera'),
            icon: 'camera',
            label: l.receiptCamera,
            onTap: onCamera,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ReceiptButton(
            key: const Key('receipt-gallery'),
            icon: 'gallery',
            label: l.receiptGallery,
            onTap: onGallery,
          ),
        ),
      ],
    );
  }
}

class _ReceiptButton extends StatelessWidget {
  const _ReceiptButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UpinoIcon(icon, size: 18, color: UpinoTokens.textSecondary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
