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
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Flag, country, then what the money is called and its symbol — the order
/// someone scans in, with the symbol last because it is the confirmation
/// rather than the thing being looked for.
class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.info,
    required this.selected,
    required this.onTap,
  });

  final CurrencyInfo info;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        key: Key('currency-${info.code}'),
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        decoration: BoxDecoration(
          color: selected
              ? (dark ? UpinoTokens.darkActionTint : UpinoTokens.actionTint)
              : cardColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
        ),
        child: Row(
          children: [
            Text(info.flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info.country,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    info.name,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontSize: 12.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  info.symbol,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: selected
                        ? (dark
                            ? UpinoTokens.darkTextPrimary
                            : UpinoTokens.actionOnTint)
                        : null,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  info.code,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.5,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
            if (selected) ...[
              const SizedBox(width: 10),
              Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: dark
                    ? UpinoTokens.darkActionPrimary
                    : UpinoTokens.actionPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
