/// Month Close (Strategy §13): what happened over the last thirty days,
/// where things stand, what the next thirty need, and anything worth
/// knowing — the same on Activity and in the chat. No score, no grade: what
/// went out and came in, what moved, and what is coming.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import '../state/insights.dart';
import 'amount_sheet.dart' show categoryLabel;
import 'form_parts.dart' show EditorSheetFrame;
import 'scrub_bars.dart';

/// The last thirty days as sentences, in the order they are best read.
List<String> monthReviewLines(AppLocalizations l, MonthReview r) {
  if (!r.ready) return [l.monthTooSoon(r.daysToReady)];
  final change = r.change;
  return [
    if (r.spent.isZero) l.monthNothing else l.monthSpent(r.spent.display()),
    if (change != null && !r.spent.isZero)
      if (r.aboutTheSame)
        l.monthSame
      else if (change.minor > 0)
        l.monthMore(change.display())
      else
        l.monthLess((-change).display()),
    if ((r.income?.minor ?? 0) > 0) l.monthIncome(r.income!.display()),
    if ((r.toGoals?.minor ?? 0) > 0) l.monthToGoals(r.toGoals!.display()),
    if (r.up case final up?) l.monthUp(categoryLabel(l, up), r.upBy!.display()),
    if (r.down case final down?)
      l.monthDown(categoryLabel(l, down), r.downBy!.display()),
    if (r.goals > 0) l.monthGoals(r.goalsOnTrack, r.goals),
  ];
}

/// The whole close: behind, now, ahead and worth knowing.
({List<String> past, List<String> ahead, List<String> worth}) monthClose(
  BuildContext context,
  AppState state,
) {
  final l = AppLocalizations.of(context);
  final r = state.monthReview;
  final s = state.snapshot;
  final a = state.monthAhead;
  final short = a.shortOn;
  final tight = a.tightest;
  return (
    past: [
      ...monthReviewLines(l, r),
      if (r.ready)
        l.monthNow(s.safeToSpendNow.display(), s.protectedTotal.display()),
    ],
    ahead: [
      if (a.billCount > 0) l.monthAheadBills(a.billCount, a.billTotal.display()),
      if (a.nextPay != null) l.monthAheadPay(formatDate(context, a.nextPay!)),
      if (short != null)
        l.monthAheadShort(formatDate(context, short.day), short.gap!.display())
      else if (tight != null)
        l.monthAheadTightest(
          formatDate(context, tight.day),
          tight.free!.display(),
        ),
    ],
    worth: [
      for (final i in state.insights) ...[
        l.insightUp(categoryLabel(l, i.category), i.up.display()),
        if (i.goal != null && (i.goalDays ?? 0) > 0)
          l.insightGoal(i.goalDays!, i.goal!.name),
      ],
    ],
  );
}

class MonthReviewCard extends StatelessWidget {
  const MonthReviewCard({required this.state, this.bare = false, super.key});

  final AppState state;

  /// Without its own card and title, for a sheet that has both.
  final bool bare;

  /// The close in a sheet, from Home's quick menu. Before the first month
  /// it still says what is coming and when the look back will be ready.
  static Future<void> show(BuildContext context, AppState state) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => EditorSheetFrame(
          title: AppLocalizations.of(context).monthTitle,
          children: [MonthReviewCard(state: state, bare: true)],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final close = monthClose(context, state);

    Widget lines(List<String> items) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              Text(
                items[i],
                style: i == 0
                    ? theme.textTheme.bodyMedium
                    : theme.textTheme.bodySmall,
              ),
              if (i != items.length - 1) const SizedBox(height: 6),
            ],
          ],
        );

    final body = Column(
        key: const Key('month-review'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!bare) ...[
            Text(l.monthTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 2),
          ],
          Text(l.monthWindow, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          _MonthBars(state: state),
          lines(close.past),
          if (close.ahead.isNotEmpty) ...[
            Divider(height: 28, color: borderColor(context)),
            Text(l.monthAheadTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            lines(close.ahead),
          ],
          if (close.worth.isNotEmpty) ...[
            Divider(height: 28, color: borderColor(context)),
            Text(
              l.monthWorthKnowing,
              key: const Key('month-worth-knowing'),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            lines(close.worth),
          ],
        ],
      );
    return bare ? body : UpinoCard(child: body);
  }
}

/// What went out each thirty days, the current stretch in colour and the
/// ones before in grey, with their average as a dotted line: the month's
/// spending against its own history, at a glance.
class _MonthBars extends StatefulWidget {
  const _MonthBars({required this.state});

  final AppState state;

  @override
  State<_MonthBars> createState() => _MonthBarsState();
}

class _MonthBarsState extends State<_MonthBars> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final months = widget.state.monthlySpending();
    // One stretch has nothing to be set against.
    if (months.length < 2) return const SizedBox.shrink();
    final earlier = months.sublist(0, months.length - 1);
    final average = earlier.fold<int>(0, (a, m) => a + m.minor) /
        earlier.length;
    final i = (_selected ?? months.length - 1).clamp(0, months.length - 1);
    final today = widget.state.today;
    final primary = isDark(context)
        ? UpinoTokens.darkActionPrimary
        : UpinoTokens.actionPrimary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ScrubBars(
        key: const Key('month-bars'),
        values: [for (final m in months) m.minor.toDouble()],
        selected: i,
        onSelect: (n) => setState(() => _selected = n),
        color: primary,
        pill: months[i].display(),
        guide: average,
        guideLabel: l.chartAvg,
        // Each stretch is named by the month at its middle: named by its
        // last day, two stretches can both end in the same month.
        labels: [
          for (var k = months.length - 1; k >= 0; k--)
            formatMonthShort(context, today.addDays(-k * 30 - 15)),
        ],
        maxBarWidth: 34,
        height: 160,
      ),
    );
  }
}
