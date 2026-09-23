/// Currency choice, the first thing onboarding asks (§18).
///
/// It comes first because every amount the user types afterwards is stored in
/// minor units of whatever they pick, and currencies disagree about how many
/// minor units there are: a rial has none, a dinar has three. Asking later
/// would mean reinterpreting numbers already entered.
library;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/parts.dart';
import '../design/icon.dart';
import '../design/tokens.dart';
import '../engine/currencies.dart';
import '../l10n/app_localizations.dart';

class CurrencyPicker extends StatefulWidget {
  const CurrencyPicker({
    required this.selected,
    required this.onSelect,
    this.padding = const EdgeInsets.fromLTRB(
      UpinoTokens.gutter,
      4,
      UpinoTokens.gutter,
      28,
    ),
    super.key,
  });

  /// Null on the way in, so no row is marked before a choice is made. It is
  /// set when the list is reopened to change an existing choice, which is the
  /// only time the highlight has anything to say — picking closes the list.
  final String? selected;
  final ValueChanged<String> onSelect;
  final EdgeInsets padding;

  @override
  State<CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final matches = currencyCatalogue.where((c) => c.matches(_query)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            widget.padding.left + 4,
            widget.padding.top,
            widget.padding.right + 4,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.currencyTitle, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 6),
              Text(
                l.currencyBlurb,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            widget.padding.left,
            16,
            widget.padding.right,
            12,
          ),
          child: _SearchField(
            controller: _search,
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: matches.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.padding.left,
                  ),
                  child: UpinoCard(
                    child: Text(
                      l.currencyNoMatch(_query),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    widget.padding.left,
                    0,
                    widget.padding.right,
                    widget.padding.bottom,
                  ),
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, i) => Reveal(
                    index: i,
                    child: _CurrencyRow(
                      info: matches[i],
                      selected: matches[i].code == widget.selected,
                      onTap: () => widget.onSelect(matches[i].code),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: const Key('currency-search-bar'),
      height: _CurrencyRow.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
      ),
      child: Row(
        children: [
          const UpinoIcon(
            'search',
            size: 20,
            color: UpinoTokens.textTertiary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              key: const Key('currency-search'),
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).currencySearchHint,
                hintStyle: theme.textTheme.bodyMedium
                    ?.copyWith(color: UpinoTokens.textTertiary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One line, the height of the search field above it: flag, country, what the
/// money is called, then its symbol. The trailing slot is reserved on every
/// row whether or not the tick is in it, so the text has the same width to
/// work with on the selected row as on any other.
class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.info,
    required this.selected,
    required this.onTap,
  });

  static const height = 44.0;

  final CurrencyInfo info;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final accent =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        key: Key('currency-${info.code}'),
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected
              ? (dark ? UpinoTokens.darkActionTint : UpinoTokens.actionTint)
              : cardColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Row(
          children: [
            CountryFlag(info.flagCountry, size: 21),
            const SizedBox(width: 11),
            // One text run rather than two flexed boxes. Two boxes split the
            // width by a fixed ratio, so "Australian dollar" was clipped while
            // the space beside a short country name went unused. As one run
            // the line fills what is there and the ellipsis, when it is
            // needed at all, falls at the end.
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: info.country,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color:
                            selected && !dark ? UpinoTokens.actionOnTint : null,
                      ),
                    ),
                    TextSpan(
                      text: '  ${info.name}',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Code then symbol, each right-aligned in a fixed slot so they
            // line up down the list rather than drifting with the text.
            SizedBox(
              width: 32,
              child: Text(
                info.code,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            // Held off the right edge: flush against it the symbol read as
            // pinned to the side of the card rather than as the last column
            // of the row. The slot keeps its fixed width, so the symbols
            // still line up down the list.
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: SizedBox(
                width: 38,
                child: Text(
                  // Fifty-four of these have no glyph of their own and carry
                  // the code as their symbol. Printing it twice would read as
                  // a mistake, so the slot is left empty for them.
                  info.symbol == info.code ? '' : info.symbol,
                  textAlign: TextAlign.right,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 13.5,
                    color: selected ? accent : UpinoTokens.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
