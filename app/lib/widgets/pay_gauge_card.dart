/// How long the money has to last (Strategy §6.1, the decision horizon): a
/// half ring with a segment for each day of the pay period, lit for the days
/// already gone, so it fills toward the pay as the period runs. The figure
/// itself is in the hero above; this says how long it must last and what
/// the pay brings. It arrives: the segments light one after another and the
/// days count down to where they are.
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

class PayGaugeCard extends StatefulWidget {
  const PayGaugeCard({required this.state, super.key});

  final AppState state;

  @override
  State<PayGaugeCard> createState() => _PayGaugeCardState();
}

class _PayGaugeCardState extends State<PayGaugeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrive = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..forward();

  @override
  void dispose() {
    _arrive.dispose();
    super.dispose();
  }

  PlanSnapshot? _for;
  Money? _afterPay;

  /// The room on pay day, from the engine run forward: worked out once per
  /// plan, not on every build.
  Money? _roomAfterPay(int daysLeft) {
    final snap = widget.state.snapshot;
    if (identical(snap, _for)) return _afterPay;
    _for = snap;
    final t = widget.state.timeline(daysBack: 0, daysAhead: daysLeft + 1);
    final pay =
        t.marks.where((m) => m.kind == TimelineMarkKind.pay).firstOrNull;
    _afterPay = pay == null
        ? null
        : t.points.where((p) => p.day == pay.day).firstOrNull?.free;
    return _afterPay;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final state = widget.state;
    final income = state.nextIncome;
    if (income == null || !income.isProjectable) {
      return const SizedBox.shrink();
    }
    final dark = isDark(context);
    final primary =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    final period = state.payCycleDays.clamp(7, 31);
    final daysLeft =
        income.expectedDate.differenceInDays(state.today).clamp(0, period);
    final after = _roomAfterPay(daysLeft);
    final gone = period - daysLeft;

    if (MediaQuery.disableAnimationsOf(context)) {
      return _card(
        context,
        l,
        theme,
        primary,
        period,
        gone,
        daysLeft,
        after,
        income.expectedDate,
        1,
      );
    }
    return AnimatedBuilder(
      animation: _arrive,
      builder: (context, _) => _card(
        context,
        l,
        theme,
        primary,
        period,
        gone,
        daysLeft,
        after,
        income.expectedDate,
        Curves.easeOutCubic.transform(_arrive.value),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    AppLocalizations l,
    ThemeData theme,
    Color primary,
    int period,
    int gone,
    int daysLeft,
    Money? after,
    LocalDate payDay,
    double t,
  ) {
    final state = widget.state;
    // The count runs down from the whole period to the days left.
    final shownDays = (period - (period - daysLeft) * t).round();
    return UpinoCard(
      key: const Key('pay-gauge'),
      child: Column(
        children: [
          SegmentGauge(
            key: const Key('pay-gauge-ring'),
            value: gone / period * t,
            segments: period,
            size: 250,
            color: primary,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$shownDays',
                  key: const Key('pay-gauge-days'),
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 44,
                    height: 1.0,
                    fontFeatures: moneyFeatures,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.payGaugeDaysLabel(daysLeft),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l.payGaugeLasts(state.snapshot.safeToSpendNow.display()),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          if (after != null) ...[
            const SizedBox(height: 12),
            Container(
              key: const Key('pay-gauge-after'),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                border: Border.all(color: borderColor(context)),
              ),
              child: Text(
                l.payGaugeAfter(
                  formatDate(context, payDay),
                  after.display(),
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontFeatures: moneyFeatures),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
