/// Two charts at the top of Activity (Strategy §8): the last seven days of
/// spending, a column a day, and money in and out, week by week.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import 'charts.dart';
import 'scrub_bars.dart';

/// "How much went out this week, and on which days?"
class WeekSpendCard extends StatefulWidget {
  const WeekSpendCard({required this.state, super.key});

  final AppState state;

  @override
  State<WeekSpendCard> createState() => _WeekSpendCardState();
}

class _WeekSpendCardState extends State<WeekSpendCard> {
  int _selected = 6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final days = widget.state.spendingByDay();
    final today = widget.state.today;
    final total = Money.sum(days, widget.state.currency);
    final primary = isDark(context)
        ? UpinoTokens.darkActionPrimary
        : UpinoTokens.actionPrimary;
    return UpinoCard(
      key: const Key('week-spend'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.weekSpentTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Text(
                  days[_selected].display(),
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontFeatures: moneyFeatures),
                ),
                const SizedBox(height: 2),
                Text(
                  _selected == 6
                      ? l.timelineToday
                      : formatDate(context, today.addDays(_selected - 6)),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l.weekSpentTotal(total.display()),
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: ScrubBars(
              key: const Key('week-spend-bars'),
              values: [for (final d in days) d.minor.toDouble()],
              selected: _selected,
              onSelect: (i) => setState(() => _selected = i),
              color: primary,
              labels: [
                for (var k = 6; k >= 0; k--)
                  formatWeekdayNarrow(context, today.addDays(-k)),
              ],
              maxBarWidth: 16,
              height: 118,
            ),
          ),
        ],
      ),
    );
  }
}

/// "What came in and what went out, week by week?"
class FlowsCard extends StatefulWidget {
  const FlowsCard({required this.state, super.key});

  final AppState state;

  @override
  State<FlowsCard> createState() => _FlowsCardState();
}

class _FlowsCardState extends State<FlowsCard> {
  static const weeks = 8;
  int _selected = weeks - 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final flows = widget.state.flowsByWeek(weeks: weeks);
    final f = flows[_selected];
    final start = widget.state.today.addDays(-7 * (weeks - 1 - _selected) - 6);
    return UpinoCard(
      key: const Key('flows'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.flowsTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(l.flowsBlurb, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Text(
            l.flowsWeek(formatDate(context, start)),
            style: theme.textTheme.bodySmall,
          ),
          Text(
            l.flowsInOut(f.moneyIn.display(), f.moneyOut.display()),
            key: const Key('flows-readout'),
            style: theme.textTheme.titleMedium
                ?.copyWith(fontFeatures: moneyFeatures),
          ),
          const SizedBox(height: 12),
          SignedBars(
            ins: [for (final w in flows) w.moneyIn.minor.toDouble()],
            outs: [for (final w in flows) w.moneyOut.minor.toDouble()],
            selected: _selected,
            onSelect: (i) => setState(() => _selected = i),
            inColor: UpinoTokens.lime,
            // spending is ordinary, not an alarm: ink, with income in blue
            outColor: dark ? UpinoTokens.darkTextSecondary : UpinoTokens.textPrimary,
          ),
        ],
      ),
    );
  }
}
