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
import '../device/voice.dart';
import '../domain/category.dart';
import '../domain/spoken_spend.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';

/// What the sheet hands back: the amount, and the receipt photographed for
/// it if there was one.
class RecordedAmount {
  const RecordedAmount(
    this.amount, {
    this.receipt,
    this.category,
    this.accountId,
  });
  final Money amount;

  /// The account it was paid from, when not the main one.
  final String? accountId;

  /// What the spend was for, when the person said.
  final SpendCategory? category;

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
    this.allowCategory = false,
    this.allowVoice = false,
    this.payFrom = const [],
    this.suggestCategory,
    super.key,
  });

  final String currency;

  /// Accounts beyond the main one a spend can be paid from. Empty hides the
  /// choice, so a plan with one account asks nothing more.
  final List<({String id, String name})> payFrom;

  /// A category the record points to for this amount, offered already
  /// chosen and changed with one tap (Strategy §7.1).
  final SpendCategory? Function(Money amount)? suggestCategory;
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

  /// Offered for a spend, never required: an unsorted spend counts exactly
  /// the same, so the question must not stand between a person and Save.
  final bool allowCategory;

  /// A microphone beside the amount, where the phone offers one. What is
  /// heard only fills the fields; Save is still the person's tap.
  final bool allowVoice;

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
    bool allowCategory = false,
    bool allowVoice = false,
    List<({String id, String name})> payFrom = const [],
    SpendCategory? Function(Money amount)? suggestCategory,
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
          allowCategory: allowCategory,
          allowVoice: allowVoice,
          payFrom: payFrom,
          suggestCategory: suggestCategory,
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
  SpendCategory? _category;

  /// True while [_category] is the suggestion, not the person's choice.
  bool _suggested = false;
  bool _categoryTouched = false;
  String? _from;

  /// Offer the record's category for the amount now typed, unless the
  /// person has already chosen one.
  void _refreshSuggestion() {
    if (_categoryTouched || widget.suggestCategory == null) return;
    final amount = _parsed;
    final guess = amount == null ? null : widget.suggestCategory!(amount);
    _category = guess;
    _suggested = guess != null;
  }

  bool _busy = false;

  bool _listening = false;

  /// What the recogniser heard, shown so the person can check it against
  /// the figure it produced. Null before the microphone is used.
  String? _heard;

  /// Why the last attempt produced nothing, when it did.
  VoiceFailure? _voiceFailure;

  Future<void> _listen() async {
    final voice = VoiceInput.instance;
    if (voice == null) return;
    if (_listening) {
      await voice.stop();
      return;
    }
    final language = Localizations.localeOf(context).languageCode;
    setState(() {
      _listening = true;
      _heard = '';
      _voiceFailure = null;
    });
    final result = await voice.listen(
      localeId: switch (language) {
        'fa' => 'fa_IR',
        'ar' => 'ar_SA',
        'en' => 'en_US',
        'es' => 'es_ES',
        'fr' => 'fr_FR',
        'hi' => 'hi_IN',
        'pt' => 'pt_BR',
        'ru' => 'ru_RU',
        'tr' => 'tr_TR',
        'zh' => 'zh_CN',
        _ => language,
      },
      onPartial: (words) {
        if (mounted) setState(() => _heard = words);
      },
    );
    if (!mounted) return;
    applySpoken(result);
  }

  /// Fill the fields from what was said. Public to the sheet's tests, which
  /// have no microphone.
  @visibleForTesting
  void applySpoken(VoiceResult result) {
    final text = result.text;
    final spoken = text == null
        ? const SpokenSpend()
        : parseSpokenSpend(text, planCurrency: widget.currency);
    setState(() {
      _listening = false;
      _heard = text ?? '';
      _voiceFailure = result.failure ??
          (spoken.amount == null ? VoiceFailure.nothingHeard : null);
      final amount = spoken.amount;
      if (amount != null) {
        _controller.text = amount.display(withSymbol: false, grouped: false);
      }
      if (spoken.category != null && widget.allowCategory) {
        _category = spoken.category;
        _categoryTouched = true;
        _suggested = false;
      } else {
        _refreshSuggestion();
      }
    });
  }

  String _voiceMessage(AppLocalizations l) {
    if (_listening) {
      return _heard!.isEmpty
          ? '${l.voiceListening}\n${l.voiceExample}'
          : _heard!;
    }
    return switch (_voiceFailure) {
      null => l.voiceHeard(_heard!),
      VoiceFailure.unavailable => l.voiceUnavailable,
      VoiceFailure.noPermission => l.voiceNoPermission,
      VoiceFailure.network => l.voiceNetwork,
      VoiceFailure.nothingHeard =>
        _heard!.isEmpty ? l.voiceNothing : l.voiceNoAmount(_heard!),
    };
  }

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
      Navigator.of(context).pop(
        RecordedAmount(
          amount,
          receipt: _receipt,
          category: _category,
          accountId: _from,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = _parsed;
    final decimals = Currency.of(widget.currency).exponent;

    return Padding(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                        onChanged: (_) => setState(_refreshSuggestion),
                        onSubmitted: (_) => _save(),
                        style: theme.textTheme.displayMedium
                            ?.copyWith(fontFeatures: moneyFeatures),
                        decoration: InputDecoration(
                          hintText: decimals == 0 ? '0' : '0.${'0' * decimals}',
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
              if (_heard != null) ...[
                const SizedBox(height: 10),
                _VoicePanel(
                  listening: _listening,
                  failed: _voiceFailure != null,
                  message: _voiceMessage(AppLocalizations.of(context)),
                  onStop: _listen,
                  onRetry: _listen,
                ),
              ],
              if (widget.allowCategory) ...[
                const SizedBox(height: 14),
                CategoryChips(
                  selected: _category,
                  // A second tap on the chosen one takes the answer back.
                  onSelect: (c) => setState(() {
                    _category = c == _category ? null : c;
                    _categoryTouched = true;
                    _suggested = false;
                  }),
                ),
                if (_suggested)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
                    child: Text(
                      AppLocalizations.of(context).categorySuggested,
                      key: const Key('amount-category-suggested'),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ),
              ],
              if (widget.payFrom.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  AppLocalizations.of(context).paidFrom,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final (id, name) in [
                      (null, AppLocalizations.of(context).accountMain),
                      for (final a in widget.payFrom) (a.id, a.name),
                    ])
                      ChoiceChip(
                        key: Key('pay-from-${id ?? 'main'}'),
                        label: Text(name),
                        selected: _from == id,
                        onSelected: (_) => setState(() => _from = id),
                      ),
                  ],
                ),
              ],
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
                  listening: _listening,
                  onVoice: widget.allowVoice && VoiceInput.instance != null
                      ? _listen
                      : null,
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
    this.onVoice,
    this.listening = false,
  });

  final String? receipt;
  final bool busy;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onClear;

  /// Saying the spend, beside photographing its receipt: both are ways to
  /// fill the sheet without typing. Null where the phone has no recogniser.
  final VoidCallback? onVoice;
  final bool listening;

  /// A square beside the two photo buttons: the microphone alone, named
  /// for screen readers.
  Widget _voiceButton(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 8),
        child: SizedBox.square(
          dimension: 46,
          child: _ReceiptButton(
            key: const Key('amount-voice'),
            icon: 'mic',
            label: AppLocalizations.of(context).voiceButton,
            iconOnly: true,
            onTap: onVoice!,
            active: listening,
          ),
        ),
      );

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
            child: UpinoIcon(
              'close',
              size: 19,
              color: isDark(context)
                  ? UpinoTokens.darkTextTertiary
                  : UpinoTokens.textTertiary,
            ),
          ),
          if (onVoice != null) _voiceButton(context),
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
        if (onVoice != null) _voiceButton(context),
      ],
    );
  }
}

class _ReceiptButton extends StatelessWidget {
  const _ReceiptButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.iconOnly = false,
    super.key,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  /// Just the icon, the label kept for screen readers.
  final bool iconOnly;

  /// Lit while it is doing its thing, which for the microphone is listening.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = active
        ? (isDark(context)
            ? UpinoTokens.darkActionPrimary
            : UpinoTokens.actionPrimary)
        : UpinoTokens.textSecondary;
    return Semantics(
      button: true,
      label: iconOnly ? label : null,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: active
                ? (isDark(context)
                    ? UpinoTokens.darkActionTint
                    : UpinoTokens.actionTint)
                : sunkenColor(context),
            borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
          ),
          child: iconOnly
              ? Center(child: UpinoIcon(icon, size: 20, color: color))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UpinoIcon(icon, size: 18, color: color),
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
      ),
    );
  }
}

/// What the microphone is doing, where the amount it fills is: a pulsing
/// microphone while it listens, then what it heard or why it heard nothing,
/// with a way to stop or to try again.
class _VoicePanel extends StatefulWidget {
  const _VoicePanel({
    required this.listening,
    required this.failed,
    required this.message,
    required this.onStop,
    required this.onRetry,
  });

  final bool listening;
  final bool failed;
  final String message;
  final VoidCallback onStop;
  final VoidCallback onRetry;

  @override
  State<_VoicePanel> createState() => _VoicePanelState();
}

class _VoicePanelState extends State<_VoicePanel>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  void _sync() {
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (widget.listening && !still) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_VoicePanel old) {
    super.didUpdateWidget(old);
    _sync();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final action =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    final tint = dark ? UpinoTokens.darkActionTint : UpinoTokens.actionTint;
    final critical = dark ? UpinoTokens.darkCritical : UpinoTokens.critical;
    final accent = widget.failed ? critical : action;

    return Container(
      key: const Key('amount-voice-panel'),
      padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 6, 12),
      decoration: BoxDecoration(
        color: widget.listening ? tint : sunkenColor(context),
        borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 44,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) => CustomPaint(
                painter: _PulsePainter(
                  t: _pulse.value,
                  color: accent,
                  on: widget.listening,
                ),
                child: child,
              ),
              child: Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: widget.listening
                      ? const UpinoIcon('mic', size: 17, color: Colors.white)
                      : Icon(
                          widget.failed
                              ? Icons.priority_high_rounded
                              : Icons.check_rounded,
                          size: 19,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.listening
                      ? l.voiceTitleListening
                      : widget.failed
                          ? l.voiceTitleFailed
                          : l.voiceTitleHeard,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.message,
                  key: const Key('amount-voice-heard'),
                  style: theme.textTheme.bodySmall,
                ),
                if (!widget.listening && !widget.failed)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      l.voicePrivacy,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            key: Key(
              widget.listening ? 'amount-voice-stop' : 'amount-voice-retry',
            ),
            onPressed: widget.listening ? widget.onStop : widget.onRetry,
            child: Text(widget.listening ? l.voiceStop : l.voiceRetry),
          ),
        ],
      ),
    );
  }
}

/// Two rings spreading out from the microphone while it listens.
class _PulsePainter extends CustomPainter {
  _PulsePainter({required this.t, required this.color, required this.on});

  final double t;
  final Color color;
  final bool on;

  @override
  void paint(Canvas canvas, Size size) {
    if (!on) return;
    final c = size.center(Offset.zero);
    for (final phase in [0.0, 0.5]) {
      final p = (t + phase) % 1;
      canvas.drawCircle(
        c,
        17 + p * 5,
        Paint()..color = color.withValues(alpha: 0.35 * (1 - p)),
      );
    }
  }

  @override
  bool shouldRepaint(_PulsePainter old) =>
      old.t != t || old.color != color || old.on != on;
}

/// The words for a category, which belong to the screen and not the state.
String categoryLabel(AppLocalizations l, SpendCategory? c) => switch (c) {
      SpendCategory.food => l.categoryFood,
      SpendCategory.transport => l.categoryTransport,
      SpendCategory.bills => l.categoryBills,
      SpendCategory.shopping => l.categoryShopping,
      SpendCategory.health => l.categoryHealth,
      SpendCategory.fun => l.categoryFun,
      SpendCategory.other => l.categoryOther,
      null => l.categoryUnsorted,
    };

/// One tap to say what a spend was for. Pills rather than a dropdown, so the
/// whole choice is visible at once and costs a single touch.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final SpendCategory? selected;
  final ValueChanged<SpendCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final active =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final c in SpendCategory.values)
          GestureDetector(
            key: Key('category-${c.name}'),
            onTap: () => onSelect(c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: c == selected ? active : sunkenColor(context),
                borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
              ),
              child: Text(
                categoryLabel(l, c),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c == selected
                      ? Colors.white
                      : (dark
                          ? UpinoTokens.darkTextSecondary
                          : UpinoTokens.textSecondary),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
