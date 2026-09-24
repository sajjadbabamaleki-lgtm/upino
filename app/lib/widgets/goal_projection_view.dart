/// A goal's path, drawn (Strategy §8, §10): what is saved so far, where the
/// plan's pace takes it, and — with the slider — where a different pace
/// would. Moving the slider changes nothing until the person says so.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../domain/goal.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import '../state/projection.dart';
import 'scrub_chart.dart';

class GoalProjectionView extends StatefulWidget {
  const GoalProjectionView({required this.state, required this.goal, super.key});

  final AppState state;
  final Goal goal;

  @override
  State<GoalProjectionView> createState() => _GoalProjectionViewState();
}

class _GoalProjectionViewState extends State<GoalProjectionView> {
  int? _selected;

  /// Minor units per period, or null for the plan's own pace.
  int? _pace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final primary =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    final critical = dark ? UpinoTokens.darkCritical : UpinoTokens.critical;
    final faint = dark ? UpinoTokens.darkTextTertiary : UpinoTokens.textTertiary;
    final state = widget.state;
    final goal = widget.goal;
    final currency = goal.target.currency;

    final planned = state.goalProjection(goal);
    final what = _pace == null
        ? planned
        : state.goalProjection(goal, pace: Money(_pace!, currency));
    final i = (_selected ?? what.todayIndex).clamp(0, what.days.length - 1);
    final targetIndex = what.days.indexWhere((d) => d >= goal.targetDate);
    final finishIndex = what.finishes == null
        ? -1
        : what.days.indexWhere((d) => d >= what.finishes!);

    // The slider runs to twice what the goal asks for, or twice the current
    // pace if that is more, in steps a person would actually choose.
    final required = goal.requiredThisCycle(state.today, state.payCycleDays);
    final top = [required.minor * 2, planned.pace.minor * 2, 100]
        .reduce((a, b) => a > b ? a : b);
    final step = _niceStep(top);
    final max = (top / step).ceil() * step;
    final value = (_pace ?? planned.pace.minor).clamp(0, max).toDouble();

    return Column(
      key: Key('goal-projection-${goal.id}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                formatDate(context, what.days[i]),
                style: theme.textTheme.bodySmall,
              ),
            ),
            Text(
              what.saved[i].display(),
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontFeatures: moneyFeatures),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ScrubChart(
          key: Key('goal-chart-${goal.id}'),
          height: 130,
          count: what.days.length,
          selected: i,
          onSelect: (n) => setState(() => _selected = n),
          markerIndex: what.todayIndex,
          guide: goal.target.minor.toDouble(),
          semanticLabel: l.goalChartSemantics(goal.name),
          series: [
            if (_pace != null)
              ChartSeries(
                values: [for (final s in planned.saved) s.minor.toDouble()],
                color: faint,
                width: 1.6,
                dashed: true,
              ),
            ChartSeries(
              values: [for (final s in what.saved) s.minor.toDouble()],
              color: primary,
              dashFrom: what.todayIndex,
              fill: true,
            ),
          ],
          marks: [
            if (targetIndex >= 0) ChartMark(targetIndex, faint, big: true),
            if (finishIndex >= 0)
              ChartMark(
                finishIndex,
                what.onTrack ? primary : critical,
                big: true,
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          l.goalChartTarget(
            goal.target.display(),
            formatDateShort(context, goal.targetDate),
          ),
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 14),
        Text(
          l.goalPaceLabel(Money(value.round(), currency).display()),
          style: theme.textTheme.titleMedium,
        ),
        Slider(
          key: Key('goal-pace-${goal.id}'),
          value: value,
          max: max.toDouble(),
          divisions: (max / step).round().clamp(1, 200),
          onChanged: (v) => setState(() => _pace = v.round()),
        ),
        Text(
          goalOutlook(context, what),
          key: Key('goal-pace-result-${goal.id}'),
          style: theme.textTheme.bodySmall?.copyWith(
            color: what.finishes != null && what.onTrack ? null : critical,
          ),
        ),
        if (_pace != null &&
            what.finishes != null &&
            what.finishes != goal.targetDate &&
            what.pace.minor > 0) ...[
          const SizedBox(height: 10),
          Wrap(
            children: [
              TextButton(
                key: Key('goal-pace-apply-${goal.id}'),
                onPressed: () {
                  state.updateGoal(goal.id, targetDate: what.finishes);
                  setState(() => _pace = null);
                },
                child: Text(
                  l.goalUsePace(formatDateShort(context, what.finishes!)),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _pace = null),
                child: Text(l.cancel),
              ),
            ],
          ),
        ] else ...[
          const SizedBox(height: 6),
          Text(
            l.goalPaceNote,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: UpinoTokens.textTertiary,
            ),
          ),
        ],
      ],
    );
  }

  /// The smallest of 1, 2, 5, 10, 20, 50, … minor units that keeps the
  /// slider to about forty stops.
  static int _niceStep(int top) {
    var base = 1;
    while (true) {
      for (final m in const [1, 2, 5]) {
        if (top / (base * m) <= 40) return base * m;
      }
      base *= 10;
    }
  }
}

/// One line on where a goal is heading, for its card and for the chart.
String goalOutlook(BuildContext context, GoalProjection p) {
  final l = AppLocalizations.of(context);
  if (p.goal.isComplete) return l.goalsDone;
  final f = p.finishes;
  if (f == null) return l.goalNotMoving;
  final late = p.daysLate!;
  if (late <= 0) return l.goalOnTrack(formatDateShort(context, f));
  return l.goalLate(formatDateShort(context, f), late);
}
