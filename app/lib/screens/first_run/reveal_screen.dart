/// The first value moment: the plan the engine just computed from the setup
/// answers, poured out tier by tier into Safe-to-Spend. Every figure here is
/// read from the real PlanSnapshot; nothing is worked out on this screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/icon.dart';
import '../../design/parts.dart';
import '../../design/theme.dart';
import '../../engine/clock.dart';
import '../../engine/money.dart';
import '../../l10n/dates.dart';
import '../../state/app_state.dart';
import '../../widgets/glass_hero.dart';
import 'fr_parts.dart';

class RevealScreen extends StatefulWidget {
  const RevealScreen({required this.state, super.key});
  final AppState state;

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2600),)
    ..forward().whenComplete(() => HapticFeedback.mediumImpact());

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _at(double a, double b) => const Cubic(0.23, 1, 0.32, 1)
      .transform(((_c.value - a) / (b - a)).clamp(0.0, 1.0));

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final s = state.snapshot;
    final pay = state.nextIncome;
    final horizon = s.decisionHorizonEnd;
    final bills = [
      for (final b in state.upcomingBills(days: 62))
        if (b.due.compareTo(horizon) <= 0) b,
    ];
    final essentials = state.allocationFor('essentials');
    final goalRows = [
      for (final g in state.goals)
        if (state.allocationFor('goal:${g.id}') case final a?
            when a.allocated.minor > 0)
          (goal: g, amount: a.allocated),
    ];

    final did = <_Did>[
      for (final b in bills)
        _Did(
          icon: 'goal-home',
          title: context.l.frBillCovered(b.bill.name),
          sub: context.l.frKeptFor(b.bill.amount.display(), formatDate(context, b.due)),
          amount: b.bill.amount,
        ),
      if (essentials != null && essentials.allocated.minor > 0)
        _Did(
          icon: 'su-cart',
          title: context.l.claimEssentials,
          sub: context.l.frAmountUntil(essentials.allocated.display(), formatDate(context, horizon)),
          amount: essentials.allocated,
        ),
      for (final r in goalRows)
        _Did(
          icon: r.goal.icon ?? 'goal-savings',
          title: context.l.frGoalStarted(r.goal.name),
          sub: context.l.frGoalBy(r.goal.target.display(), formatDate(context, r.goal.targetDate)),
          amount: r.amount,
        ),
    ];

    return Scaffold(
      backgroundColor: pageOf(context),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            children: [
              _In(
                v: _at(0, 0.2),
                child: Text(
                  context.l.frPlanReady.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: isDark(context) ? lime : const Color(0xFF4F7A00),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _In(
                v: _at(0.04, 0.26),
                child: Text(
                  context.l.frDidWith(s.trustedAllocatableLiquidity.display()),
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.8,
                    color: inkOf(context),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _In(
                v: _at(0.14, 0.45),
                child: GlassHero(
                  key: const Key('reveal-sts'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l.heroSafeToSpend,
                        style: const TextStyle(color: Color(0xD9FFFFFF), fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 14),
                      _CountUp(amount: s.safeToSpendNow, t: _at(0.2, 0.7)),
                      if (pay != null && pay.isProjectable) ...[
                        const SizedBox(height: 10),
                        Text(
                          context.l.frUntilIncome(formatDate(context, pay.expectedDate)),
                          style: const TextStyle(color: Color(0xBFFFFFFF), fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (s.mandatoryFundingGap.minor > 0) ...[
                const SizedBox(height: 12),
                _Note(
                  v: _at(0.45, 0.6),
                  text: context.l.frNotCovered(s.mandatoryFundingGap.display()),
                ),
              ],
              const SizedBox(height: 16),
              _In(
                v: _at(0.4, 0.7),
                child: _DayStrip(
                  from: state.today,
                  to: horizon,
                  pay: pay?.isProjectable ?? false ? pay!.expectedDate : null,
                  bills: {for (final b in bills) b.due: b.bill.name.split(' / ').first},
                ),
              ),
              const SizedBox(height: 18),
              for (var i = 0; i < did.length; i++)
                _In(
                  v: _at(0.55 + i * 0.08, 0.8 + i * 0.06),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: did[i],
                  ),
                ),
              const SizedBox(height: 14),
              _In(
                v: _at(0.8, 1),
                child: FlowButton(
                  buttonKey: const Key('reveal-done'),
                  label: context.l.frGoToPlan,
                  style: FlowButtonStyle.light,
                  onTap: state.finishReveal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fades and lifts a part in as the reveal plays.
class _In extends StatelessWidget {
  const _In({required this.v, required this.child});
  final double v;
  final Widget child;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 12 * (1 - v)), child: child),
      );
}

/// The Safe-to-Spend figure counting up to the engine's number.
class _CountUp extends StatelessWidget {
  const _CountUp({required this.amount, required this.t});
  final Money amount;
  final double t;

  @override
  Widget build(BuildContext context) {
    final shown = Money((amount.minor * t).round(), amount.currency).display();
    final dot = shown.lastIndexOf('.');
    const big = TextStyle(
      color: Colors.white,
      fontSize: 54,
      fontWeight: FontWeight.w600,
      letterSpacing: -2.4,
      height: 1,
      fontFeatures: moneyFeatures,
    );
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: dot < 0 ? shown : shown.substring(0, dot), style: big),
            if (dot >= 0)
              TextSpan(
                text: shown.substring(dot),
                style: big.copyWith(fontSize: 24, letterSpacing: -0.5, color: const Color(0x99FFFFFF)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Today to the next pay, one tile a day: today in white, a bill's day
/// named in blue, payday in lime.
class _DayStrip extends StatelessWidget {
  const _DayStrip({required this.from, required this.to, required this.pay, required this.bills});
  final LocalDate from;
  final LocalDate to;
  final LocalDate? pay;
  final Map<LocalDate, String> bills;

  @override
  Widget build(BuildContext context) {
    final n = (to.differenceInDays(from) + 1).clamp(1, 45);
    final dark = isDark(context);
    Widget tile(int i) {
      final d = from.addDays(i);
      final today = i == 0;
      final payday = d == pay;
      final bill = bills[d];
      final bg = payday
          ? lime
          : today
              ? (dark ? const Color(0xFFF2F2F5) : const Color(0xFF0F1012))
              : sunkenColor(context);
      final fg = payday
          ? const Color(0xFF0F1012)
          : today
              ? (dark ? const Color(0xFF0F1012) : Colors.white)
              : inkOf(context);
      final label = payday
          ? context.l.activityIncome
          : today
              ? context.l.dayToday
              : bill ?? '';
      return Container(
        padding: const EdgeInsets.fromLTRB(4, 9, 4, 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(formatWeekdayShort(context, d),
                style: TextStyle(fontSize: 10.5, color: fg.withValues(alpha: 0.6)),),
            const SizedBox(height: 2),
            Text(formatDayNumber(context, d),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: fg, fontFeatures: moneyFeatures),),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: bill != null && !payday && !today ? const Color(0xFF8E94FF) : fg,
              ),
            ),
          ],
        ),
      );
    }

    // Edge to edge with the card above: the tiles share the full width
    // while they fit, and only scroll when the pay is further away.
    return SizedBox(
      height: 70,
      child: LayoutBuilder(
        builder: (context, box) {
          const gap = 6.0;
          const minTile = 46.0;
          if (n * minTile + (n - 1) * gap <= box.maxWidth) {
            return Row(
              children: [
                for (var i = 0; i < n; i++) ...[
                  if (i > 0) const SizedBox(width: gap),
                  Expanded(child: tile(i)),
                ],
              ],
            );
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: n,
            separatorBuilder: (_, __) => const SizedBox(width: gap),
            itemBuilder: (_, i) => SizedBox(width: 52, child: tile(i)),
          );
        },
      ),
    );
  }
}

/// One thing the plan did with the money: what, why, how much.
class _Did extends StatelessWidget {
  const _Did({required this.icon, required this.title, required this.sub, required this.amount});
  final String icon;
  final String title;
  final String sub;
  final Money amount;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconTile(icon, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: inkOf(context)),),
                const SizedBox(height: 2),
                Text(sub, style: TextStyle(fontSize: 12.5, color: tertOf(context))),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amount.display(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: inkOf(context), fontFeatures: moneyFeatures),
          ),
        ],
      );
}

class _Note extends StatelessWidget {
  const _Note({required this.v, required this.text});
  final double v;
  final String text;

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: v,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child:
              Text(text, style: TextStyle(fontSize: 13, color: subOf(context))),
        ),
      );
}

/// On Home, after setup: the one or two details that would change the
/// figure, each a few seconds. It goes when they are added or dismissed.
class SetupGapsCard extends StatelessWidget {
  const SetupGapsCard(
      {required this.state,
      required this.onEssentials,
      required this.onBill,
      super.key,});
  final AppState state;
  final VoidCallback onEssentials;
  final VoidCallback onBill;

  @override
  Widget build(BuildContext context) {
    final gaps = state.setupGaps;
    if (gaps.isEmpty) return const SizedBox.shrink();
    return Container(
      key: const Key('setup-gaps'),
      padding: const EdgeInsets.fromLTRB(18, 14, 8, 8),
      decoration: BoxDecoration(
          color: cardColor(context), borderRadius: BorderRadius.circular(24),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(context.l.frGapsTitle,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: inkOf(context),),),
              ),
              IconButton(
                onPressed: state.dismissSetupGaps,
                icon: UpinoIcon('close', size: 18, color: tertOf(context)),
              ),
            ],
          ),
          for (final g in gaps)
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: g == 'essentials' ? onEssentials : onBill,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Row(
                  children: [
                    IconTile(
                        switch (g) {
                          'essentials' => 'su-cart',
                          'yearly' => 'su-calendar',
                          _ => 'receipt'
                        },
                        size: 34,),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        switch (g) {
                          'essentials' => context.l.frGapEssentials,
                          'yearly' => context.l.frGapYearly,
                          _ => context.l.frGapBill,
                        },
                        style: TextStyle(fontSize: 14, color: inkOf(context)),
                      ),
                    ),
                    Text(context.l.frSeconds(g == 'yearly' ? 20 : 15),
                        style:
                            TextStyle(fontSize: 12.5, color: tertOf(context)),),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
