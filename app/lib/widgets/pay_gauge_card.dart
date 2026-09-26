/// How long the money has to last (Strategy §6.1, the decision horizon): a
/// half ring with a segment for each day of the pay period, lit for the days
/// already gone, so it fills toward the pay as the period runs. The figure
/// itself is in the hero above; this says how long it must last and what
/// the pay brings. It arrives: the segments light one after another and the
/// days count down to where they are.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/clock.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../state/projection.dart';

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
    final dark = isDark(context);
    final ink = dark ? UpinoTokens.darkTextPrimary : UpinoTokens.textPrimary;
    final label = theme.textTheme.bodySmall?.copyWith(
      fontSize: 11.5,
      letterSpacing: 0.6,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: dark ? const Color(0xFF6E6E78) : UpinoTokens.textTertiary,
    );
    final figure = theme.textTheme.titleMedium?.copyWith(
      fontSize: 17,
      height: 1.15,
      fontWeight: FontWeight.w600,
      fontFeatures: moneyFeatures,
    );
    return UpinoCard(
      key: const Key('pay-gauge'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The figures sit up beside the foot of the dial, where it opens,
          // rather than below it.
          SizedBox(
            height: 232,
            child: Stack(
              children: [
                SizedBox(
                  height: 210,
                  child: CustomPaint(
                    key: const Key('pay-gauge-ring'),
                    painter: _DialPainter(
                      period: period,
                      gone: gone,
                      t: t,
                      ink: ink,
                      rest: dark
                          ? const Color(0xFF34343C)
                          : const Color(0xFFDCDCE2),
                      restMinor: dark
                          ? const Color(0xFF26262C)
                          : const Color(0xFFEAEAEE),
                      goneMinor: dark
                          ? const Color(0xFF8A8A94)
                          : const Color(0xFF9A9AA3),
                      primary: UpinoTokens.lime,
                      dark: dark,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$shownDays',
                              key: const Key('pay-gauge-days'),
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontSize: 63,
                                height: 1.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -2.6,
                                fontFeatures: moneyFeatures,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l.payGaugeDaysLabel(daysLeft),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: dark
                                    ? UpinoTokens.darkTextSecondary
                                    : UpinoTokens.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.payGaugeToLast.toUpperCase(), style: label),
                            const SizedBox(height: 2),
                            Text(
                              state.snapshot.safeToSpendNow.display(),
                              style: figure,
                            ),
                          ],
                        ),
                      ),
                      if (after != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(l.payGaugeNextPay.toUpperCase(), style: label),
                            const SizedBox(height: 2),
                            if (dark)
                              Text(
                                after.display(),
                                style:
                                    figure?.copyWith(color: UpinoTokens.lime),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: UpinoTokens.lime,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(after.display(), style: figure),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The pay period as a watch dial: four fine ticks a day round most of a
/// circle, lit up to today, the last one blue for the pay.
class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.period,
    required this.gone,
    required this.t,
    required this.ink,
    required this.rest,
    required this.restMinor,
    required this.goneMinor,
    required this.primary,
    required this.dark,
  });

  final int period;
  final int gone;
  final double t;
  final Color ink;
  final Color rest;
  final Color restMinor;
  final Color goneMinor;
  final Color primary;
  final bool dark;

  static const _from = -215 * math.pi / 180;
  static const _to = 35 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2 + 6);
    final r = math.min(size.height / 2 - 8, size.width / 2 - 12);
    final n = period * 4;
    final lit = gone * t;
    Offset at(double a, double radius) =>
        c + Offset(math.cos(a), math.sin(a)) * radius;
    final paint = Paint()..strokeCap = StrokeCap.round;
    for (var i = 0; i <= n; i++) {
      final day = i / 4;
      final major = i % 4 == 0;
      final a = _from + (_to - _from) * i / n;
      final on = day <= lit;
      paint
        ..strokeWidth = major ? 2 : 1.2
        ..color = i == n
            ? primary
            : on
                ? (major ? ink : goneMinor)
                : (major ? rest : restMinor);
      canvas.drawLine(at(a, r - (major ? 16 : 9)), at(a, r), paint);
    }
    final today = _from + (_to - _from) * (lit / period);
    canvas
      ..drawCircle(at(today, r + 9), 4, Paint()..color = ink)
      ..drawCircle(
        at(_to, r + 9),
        9,
        Paint()..color = primary.withValues(alpha: 0.22),
      )
      ..drawCircle(at(_to, r + 9), 4.5, Paint()..color = primary);
    // On white the lime needs an edge to hold its shape.
    if (!dark) {
      canvas.drawCircle(
        at(_to, r + 9),
        4.5,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0x33000000),
      );
    }
  }

  @override
  bool shouldRepaint(_DialPainter old) =>
      old.t != t ||
      old.gone != gone ||
      old.period != period ||
      old.ink != ink ||
      old.primary != primary;
}
