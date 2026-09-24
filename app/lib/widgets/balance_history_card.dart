/// The balance over time (Strategy §8), as recorded: a smooth line you can
/// run a finger along, over one, three or six months or a year.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/clock.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import '../state/projection.dart';
import 'charts.dart';

class BalanceHistoryCard extends StatefulWidget {
  const BalanceHistoryCard({required this.state, super.key});

  final AppState state;

  @override
  State<BalanceHistoryCard> createState() => _BalanceHistoryCardState();
}

class _BalanceHistoryCardState extends State<BalanceHistoryCard> {
  /// Days back and the step between samples, so a year is not 365 runs.
  static const _ranges = [(30, 1), (90, 3), (180, 6), (365, 12)];
  int _range = 0;
  int? _selected;
  PlanSnapshot? _for;
  int? _forRange;
  List<({LocalDate day, Money balance})> _points = const [];

  void _refresh() {
    final snap = widget.state.snapshot;
    if (identical(snap, _for) && _forRange == _range) return;
    _for = snap;
    _forRange = _range;
    final (days, step) = _ranges[_range];
    _points = widget.state.balanceHistory(days: days, step: step);
    _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final primary =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    final points = _points;
    final i = (_selected ?? points.length - 1).clamp(0, points.length - 1);
    final p = points[i];
    final first = points.first.balance;
    final change = p.balance - first;

    return UpinoCard(
      key: const Key('balance-history'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.balanceHistoryTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Text(
            p.balance.display(),
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontFeatures: moneyFeatures),
          ),
          const SizedBox(height: 2),
          Text(
            '${formatDate(context, p.day)}${UpinoTokens.separator}'
            '${change.minor >= 0 ? '+' : '−'}'
            '${(change.minor >= 0 ? change : -change).display()}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFeatures: moneyFeatures,
              color: change.minor >= 0
                  ? null
                  : (dark ? UpinoTokens.darkCritical : UpinoTokens.critical),
            ),
          ),
          const SizedBox(height: 12),
          AreaLine(
            key: const Key('balance-history-chart'),
            values: [for (final q in points) q.balance.minor.toDouble()],
            selected: i,
            onSelect: (n) => setState(() => _selected = n),
            color: primary,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (var k = 0; k < _ranges.length; k++)
                ChoiceChip(
                  key: Key('balance-range-$k'),
                  label: Text(
                    k == _ranges.length - 1
                        ? l.rangeYear
                        : l.rangeMonths(_ranges[k].$1 ~/ 30),
                  ),
                  selected: _range == k,
                  onSelected: (_) => setState(() => _range = k),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
