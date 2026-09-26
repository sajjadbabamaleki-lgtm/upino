/// The first value moment: the plan the engine just computed from the setup
/// answers, poured out tier by tier into Safe-to-Spend. Every figure here is
/// read from the real PlanSnapshot; nothing is worked out on this screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/icon.dart';
import '../../design/parts.dart';
import '../../design/theme.dart';
import '../../engine/domain.dart';
import '../../engine/money.dart';
import '../../l10n/dates.dart';
import '../../state/app_state.dart';
import '../../state/insights.dart';
import '../../widgets/best_move_card.dart';
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
    final cur = s.currency;
    Money sum(bool Function(Priority) where) => Money.sum(
          [
            for (final a in s.allocations)
              if (where(a.priority)) a.allocated,
          ],
          cur,
        );
    final goals =
        sum((p) => p == Priority.p7HardGoal || p == Priority.p8Flexible);
    final bills = sum((p) => p.index <= Priority.p6Buffer.index);
    final pay = state.nextIncome;
    final gaps = state.setupGaps;
    final move = state.bestMove;
    final upcoming = state.upcomingBills(days: 31);

    final rows = <(String, Money, int)>[
      (context.l.frAvailableNow, s.trustedAllocatableLiquidity, 0),
      if (bills.minor > 0) (context.l.frProtectedBills, bills, 1),
      if (goals.minor > 0) (context.l.frProtectedGoal, goals, 2),
    ];

    return Scaffold(
      backgroundColor: pageOf(context),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            children: [
              Opacity(
                opacity: _at(0, 0.15),
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
              const SizedBox(height: 18),
              for (var i = 0; i < rows.length; i++)
                _Row(
                  label: rows[i].$1,
                  amount: rows[i].$2,
                  depth: rows[i].$3,
                  minus: i > 0,
                  v: _at(0.08 + i * 0.12, 0.4 + i * 0.12),
                ),
              if (s.mandatoryFundingGap.minor > 0)
                _Note(
                  v: _at(0.45, 0.6),
                  text: context.l.frNotCovered(s.mandatoryFundingGap.display()),
                ),
              const SizedBox(height: 6),
              _StsCard(
                amount: s.safeToSpendNow,
                v: _at(0.45, 0.8),
                count: _at(0.5, 0.95),
                until: pay != null && pay.isProjectable
                    ? context.l.frUntilIncome(formatDate(context, pay.expectedDate))
                    : null,
              ),
              const SizedBox(height: 14),
              Opacity(
                opacity: _at(0.8, 1),
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - _at(0.8, 1))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (move != null)
                        BestMoveCard(state: state, move: move)
                      else if (upcoming.isNotEmpty)
                        _Fact(
                          title: context.l.frTakenCare.toUpperCase(),
                          text: context.l.frTakenCareBody(
                            upcoming.first.bill.name,
                            upcoming.first.bill.amount.display(),
                            formatDate(context, upcoming.first.due),
                          ),
                        ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          UpinoIcon('su-shield',
                              size: 16, color: tertOf(context),),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              gaps.isEmpty
                                  ? context.l.frBuiltFromAll
                                  : context.l.frGoodEstimate(gaps.length),
                              style: TextStyle(
                                  fontSize: 13, color: subOf(context),),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      FlowButton(
                        buttonKey: const Key('reveal-done'),
                        label: context.l.frGoToPlan,
                        style: FlowButtonStyle.light,
                        onTap: state.finishReveal,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(
      {required this.label,
      required this.amount,
      required this.depth,
      required this.minus,
      required this.v,});
  final String label;
  final Money amount;
  final int depth;
  final bool minus;
  final double v;

  @override
  Widget build(BuildContext context) {
    final blue = blueOf(context);
    return Opacity(
      opacity: v,
      child: Transform.translate(
        offset: Offset(0, -18 * (1 - v)),
        child: Padding(
          padding: EdgeInsets.only(left: 14.0 * depth, bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: depth == 0
                  ? cardColor(context)
                  : blue.withValues(alpha: isDark(context) ? 0.16 : 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: depth == 0 ? subOf(context) : inkOf(context),
                    ),
                  ),
                ),
                Text(
                  '${minus ? '−' : ''}${amount.display()}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: inkOf(context),
                      fontFeatures: moneyFeatures,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StsCard extends StatelessWidget {
  const _StsCard(
      {required this.amount, required this.v, required this.count, this.until,});
  final Money amount;
  final double v;
  final double count;
  final String? until;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF0F1012);
    final shown = Money((amount.minor * count).round(), amount.currency);
    return Opacity(
      opacity: v,
      child: Transform.scale(
        scale: 0.94 + 0.06 * v,
        child: Container(
          key: const Key('reveal-sts'),
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          decoration: BoxDecoration(
              color: lime, borderRadius: BorderRadius.circular(28),),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l.frSafeToSpend.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: ink,),),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  shown.display(),
                  style: const TextStyle(
                    fontSize: 58,
                    height: 1.05,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -2.6,
                    color: ink,
                    fontFeatures: moneyFeatures,
                  ),
                ),
              ),
              if (until != null) ...[
                const SizedBox(height: 4),
                Text(until!,
                    style: TextStyle(
                        fontSize: 13.5, color: ink.withValues(alpha: 0.7),),),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: cardColor(context), borderRadius: BorderRadius.circular(20),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: tertOf(context),),),
            const SizedBox(height: 6),
            Text(text,
                style: TextStyle(
                    fontSize: 14.5, height: 1.4, color: inkOf(context),),),
          ],
        ),
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
