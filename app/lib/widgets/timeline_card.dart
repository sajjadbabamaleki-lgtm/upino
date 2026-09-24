/// The financial timeline, drawn (Strategy §8): the balance behind you, the
/// room ahead, and any day's figures under your finger.
///
/// With a purchase it becomes the scenario comparison: the plan without it,
/// and with it bought today or after the pay, on one chart.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import '../state/projection.dart';
import 'scrub_bars.dart';

class TimelineCard extends StatefulWidget {
  const TimelineCard({
    required this.state,
    this.purchase,
    this.daysAhead = 45,
    this.startAtPay,
    super.key,
  });

  final AppState state;

  /// A what-if purchase to compare against the plan without it.
  final Money? purchase;
  final int daysAhead;

  /// Open on the next pay day rather than today. Defaults to true without a
  /// purchase: today's figure is already the hero above, so the pay day is
  /// the news. With a purchase, today is where the difference starts.
  final bool? startAtPay;

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard> {
  PlanSnapshot? _for;
  Money? _forPurchase;
  PurchaseTiming? _forTiming;
  late Timeline _base;
  Timeline? _compare;
  int? _selected;
  PurchaseTiming _timing = PurchaseTiming.now;

  /// Worked out once per plan, not on every frame of a drag.
  void _refresh() {
    final snap = widget.state.snapshot;
    if (identical(snap, _for) &&
        widget.purchase == _forPurchase &&
        _timing == _forTiming) {
      return;
    }
    final planChanged = !identical(snap, _for);
    _for = snap;
    _forPurchase = widget.purchase;
    _forTiming = _timing;
    if (planChanged) {
      _base = widget.state.timeline(daysBack: 0, daysAhead: widget.daysAhead);
    }
    _compare = widget.purchase == null
        ? null
        : widget.state.timeline(
            daysBack: 0,
            daysAhead: widget.daysAhead,
            purchase: widget.purchase,
            timing: _timing,
          );
    final max = _base.points.length - 1;
    if (_selected == null || _selected! > max) {
      final atPay = widget.startAtPay ?? widget.purchase == null;
      final pay =
          _base.marks.where((m) => m.kind == TimelineMarkKind.pay).firstOrNull;
      final payIndex =
          pay == null ? -1 : _base.points.indexWhere((p) => p.day == pay.day);
      _selected = atPay && payIndex >= 0 ? payIndex : _base.todayIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final primary =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    final critical = dark ? UpinoTokens.darkCritical : UpinoTokens.critical;

    final base = _base;
    final compare = _compare;
    final i = _selected!;
    final point = base.points[i];
    final withIt = compare?.points[i];
    final shown = withIt ?? point;

    double? v(Money? m) => m?.minor.toDouble();
    final dayMarks = base.marks.where((m) => m.day == point.day).toList();

    return UpinoCard(
      key: const Key('timeline'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The readout: what the finger is on.
          Row(
            children: [
              Expanded(
                child: Text(
                  i == base.todayIndex
                      ? l.timelineToday
                      : formatDate(context, point.day),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              // Never the lime fill: that marks a moment just recorded.
              UpinoBadge(
                i == base.todayIndex
                    ? l.timelineNow
                    : point.projected
                        ? l.timelineProjected
                        : l.timelineRecorded,
                background: sunkenColor(context),
                foreground: dark
                    ? UpinoTokens.darkTextSecondary
                    : UpinoTokens.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (shown.free != null) ...[
            Text(l.timelineFree, style: theme.textTheme.bodySmall),
            Text(
              shown.free!.display(),
              key: const Key('timeline-free'),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontFeatures: moneyFeatures,
                color: withIt != null && withIt.free! < point.free!
                    ? critical
                    : null,
              ),
            ),
            if (withIt != null)
              Text(
                l.timelineWithout(point.free!.display()),
                style: theme.textTheme.bodySmall,
              ),
          ] else ...[
            Text(l.timelineHad, style: theme.textTheme.bodySmall),
            Text(
              point.balance.display(),
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontFeatures: moneyFeatures),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            [
              l.timelineBalance(shown.balance.display()),
              if (shown.setAside != null)
                l.timelineSetAside(shown.setAside!.display()),
              for (final m in dayMarks)
                m.kind == TimelineMarkKind.pay
                    ? l.timelinePayMark(m.amount.display())
                    : '${m.label} ${m.amount.display()}',
            ].join(UpinoTokens.separator),
            style: theme.textTheme.bodySmall
                ?.copyWith(fontFeatures: moneyFeatures),
          ),
          if ((shown.gap?.minor ?? 0) > 0) ...[
            const SizedBox(height: 4),
            Text(
              l.timelineShort(shown.gap!.display()),
              style: theme.textTheme.bodySmall?.copyWith(color: critical),
            ),
          ],
          const SizedBox(height: 14),
          ScrubBars(
            key: const Key('timeline-chart'),
            selected: i,
            onSelect: (n) => setState(() => _selected = n),
            semanticLabel: l.timelineSemantics,
            color: compare == null ? primary : critical,
            // One column a day: the room to spend, or with a purchase the
            // room after it, with the plan without it pale behind.
            values: [for (final p in (compare ?? base).points) v(p.free)],
            ghost: compare == null
                ? null
                : [for (final p in base.points) v(p.free)],
            ghostColor: primary.withValues(alpha: 0.18),
            alert: {
              for (var k = 0; k < (compare ?? base).points.length; k++)
                if (((compare ?? base).points[k].gap?.minor ?? 0) > 0) k,
            },
            alertColor: critical,
            marks: [
              for (final m in base.marks)
                if (m.kind == TimelineMarkKind.pay)
                  BarMark(
                    base.points.indexWhere((p) => p.day == m.day),
                    primary,
                  ),
            ],
          ),
          const SizedBox(height: 6),
          // The dates under the chart run the way the chart does.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    formatDateShort(context, base.points.first.day),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.5),
                  ),
                ),
                const SizedBox(width: 12),
                const Spacer(),
                Flexible(
                  child: Text(
                    formatDateShort(context, base.points.last.day),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
          if (widget.purchase != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  key: const Key('timeline-buy-now'),
                  label: Text(l.askBuyNow),
                  selected: _timing == PurchaseTiming.now,
                  onSelected: (_) =>
                      setState(() => _timing = PurchaseTiming.now),
                ),
                if (widget.state.nextIncome?.isProjectable ?? false)
                  ChoiceChip(
                    key: const Key('timeline-buy-after'),
                    label: Text(l.timelineBuyAfterPay),
                    selected: _timing == PurchaseTiming.afterPay,
                    onSelected: (_) =>
                        setState(() => _timing = PurchaseTiming.afterPay),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            runSpacing: 4,
            children: [
              _Legend(
                color: compare == null
                    ? primary
                    : primary.withValues(alpha: 0.25),
                label: l.timelineFree,
              ),
              if (compare != null)
                _Legend(color: critical, label: l.timelineWithPurchase),
              _Legend(color: primary, label: l.timelinePay, dot: true),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l.timelineAssumptions,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: UpinoTokens.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.dot = false});

  final Color color;
  final String label;
  final bool dot;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dot ? 8 : 14,
            height: dot ? 8 : 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      );
}
