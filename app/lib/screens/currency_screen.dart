/// Currency choice, the first thing onboarding asks (§18).
///
/// It comes first because every amount the user types afterwards is stored in
/// minor units of whatever they pick, and currencies disagree about how many
/// minor units there are: a rial has none, a dinar has three. Asking later
/// would mean reinterpreting numbers already entered.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../engine/currencies.dart';

class CurrencyPicker extends StatefulWidget {
  const CurrencyPicker({
    required this.selected,
    required this.onSelect,
    this.padding = const EdgeInsets.fromLTRB(
      UpinoTokens.gutter,
      20,
      UpinoTokens.gutter,
      28,
    ),
    super.key,
  });

  final String selected;
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
    final matches =
        currencyCatalogue.where((c) => c.matches(_query)).toList();

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
              Text('Which currency?', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 6),
              Text(
                'Everything in your plan is kept in this one. Pick the currency '
                'you are actually paid in.',
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
                      'Nothing matches “$_query”. Try the country, or the '
                      'three-letter code.',
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
                  itemBuilder: (context, i) => _CurrencyRow(
                    info: matches[i],
                    selected: matches[i].code == widget.selected,
                    onTap: () => widget.onSelect(matches[i].code),
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
          const Icon(
            Icons.search_rounded,
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
                hintText: 'Search country or code',
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
    final accent = dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
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
            Text(info.flag, style: const TextStyle(fontSize: 19)),
            const SizedBox(width: 11),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // The country is what people scan for, so it keeps the
                  // larger share when the two cannot both fit.
                  Flexible(
                    flex: 3,
                    child: Text(
                      info.country,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 14.5,
                        color: selected && !dark
                            ? UpinoTokens.actionOnTint
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    flex: 2,
                    child: Text(
                      info.name,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              info.symbol,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 14.5,
                color: selected ? accent : UpinoTokens.textSecondary,
              ),
            ),
            SizedBox(
              width: 22,
              child: selected
                  ? Icon(Icons.check_rounded, size: 17, color: accent)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
