/// Home, §18 steps 3, 5 and 6.
///
/// The decision comes first and charts stay secondary (§18). An expense
/// recorded here updates the figure immediately, with its reason code (§14).
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/allocate.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';
import 'activity_screen.dart';
import 'goals_screen.dart';
import 'plan_screen.dart';
import 'profile_screen.dart';
import '../widgets/sts_hero.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.state, super.key});

  final AppState state;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _navBottomGap = 22.0;
  static const _navHeight = UpinoNavBar.itemHeight + UpinoNavBar.inset * 2;

  int _tab = 0;

  AppState get state => widget.state;

  Future<void> _recordExpense() async {
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: 'How much did you spend?',
    );
    if (amount != null) state.recordExpense(amount);
  }

  Future<void> _confirmBalance() async {
    final observed = await AmountSheet.show(
      context,
      currency: state.currency,
      title: 'What is your balance now?',
      explanation:
          'Any difference is recorded as a correction, never as spending.',
      initial: state.snapshot.trustedAllocatableLiquidity,
    );
    if (observed != null) state.confirmBalance(observed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snapshot = state.snapshot;
    final justRecorded = state.lastRecordedExpense;
    final attention = snapshot.allocations
        .where((a) => a.shortfall.minor > 0)
        .toList();

    const contentPadding = EdgeInsets.fromLTRB(
      UpinoTokens.gutter,
      8,
      UpinoTokens.gutter,
      120,
    );

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: switch (_tab) {
              1 => PlanScreen(
                  state: state,
                  padding: contentPadding,
                  onOpenGoals: () => setState(() => _tab = 2),
                ),
              2 => GoalsScreen(state: state, padding: contentPadding),
              3 => ActivityScreen(state: state, padding: contentPadding),
              4 => ProfileScreen(state: state, padding: contentPadding),
              _ => ListView(
                  padding: contentPadding,
                  children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your plan', style: theme.textTheme.headlineLarge),
                      const SizedBox(height: 2),
                      Text(
                        'Until ${formatDate(snapshot.decisionHorizonEnd)}'
                        '${UpinoTokens.separator}'
                        '${snapshot.trustedAllocatableLiquidity.display()} in total',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                StsHero(
                  snapshot: snapshot,
                  onConfirmBalance: _confirmBalance,
                  onResolve: () => _showBreakdown(snapshot),
                  onQuickExpense: _recordExpense,
                ),

                // A confirmation marks a moment that just happened; it never
                // becomes a persistent state and never touches the figure
                // (§32.7).
                if (justRecorded != null) ...[
                  const SizedBox(height: 12),
                  _ConfirmationBanner(
                    amount: justRecorded,
                    onDismiss: state.clearExpenseConfirmation,
                  ),
                ],

                const SizedBox(height: 26),

                if (attention.isNotEmpty) ...[
                  SectionHeading('Needs your attention', count: attention.length),
                  for (final a in attention) ...[
                    ActionRow(
                      title: a.label,
                      subtitle: '${a.shortfall.display()} not covered',
                      titleColor: a.priority.isMandatory
                          ? (isDark(context)
                              ? UpinoTokens.darkCritical
                              : UpinoTokens.critical)
                          : null,
                      onTap: () => _showBreakdown(snapshot),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 16),
                ],

                if (snapshot.projectedSafeToSpend > snapshot.safeToSpendNow) ...[
                  const SectionHeading('After your next pay'),
                  _ProjectedCard(snapshot: snapshot),
                  const SizedBox(height: 26),
                ],

                const SectionHeading('Set aside first'),
                _ProtectedCard(snapshot: snapshot),

                    const SizedBox(height: 26),
                    const SectionHeading('Why this number'),
                    _WhyCard(snapshot: snapshot),
                  ],
                ),
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavScrim(navHeight: _navHeight, bottomGap: _navBottomGap),
          ),
          Positioned(
            left: UpinoTokens.gutter,
            right: UpinoTokens.gutter,
            bottom: _navBottomGap,
            child: UpinoNavBar(
              index: _tab,
              onSelect: (i) => setState(() => _tab = i),
            ),
          ),
        ],
      ),
    );
  }

  void _showBreakdown(PlanSnapshot snapshot) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _BreakdownSheet(snapshot: snapshot),
    );
  }
}

class _ConfirmationBanner extends StatelessWidget {
  const _ConfirmationBanner({required this.amount, required this.onDismiss});

  final Money amount;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => UpinoCard(
        gradient: accentSurfaceGradient,
        radius: UpinoTokens.radiusInner,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                size: 19, color: UpinoTokens.textPrimary,),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${amount.display()} recorded',
                style: const TextStyle(
                  color: UpinoTokens.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                  fontFeatures: moneyFeatures,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close_rounded,
                  size: 18, color: UpinoTokens.textPrimary,),
            ),
          ],
        ),
      );
}

/// The projected value is visibly a forecast and is never presented as cash
/// already available (§13, INV-04).
class _ProjectedCard extends StatelessWidget {
  const _ProjectedCard({required this.snapshot});

  final PlanSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UpinoCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.projectedSafeToSpend.display(),
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  'Once your pay arrives on '
                  '${formatDate(snapshot.decisionHorizonEnd)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const RowAffordance(icon: Icons.trending_up_rounded),
        ],
      ),
    );
  }
}

class _ProtectedCard extends StatelessWidget {
  const _ProtectedCard({required this.snapshot});

  final PlanSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows =
        snapshot.allocations.where((a) => a.requiredNow.minor > 0).toList();
    if (rows.isEmpty) {
      return UpinoCard(
        child: Text(
          'Nothing is set aside yet. Everything you have is spendable.',
          style: theme.textTheme.bodySmall,
        ),
      );
    }

    return UpinoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Protected before anything is spendable.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < rows.length; i++) ...[
            _AllocationLine(allocation: rows[i]),
            if (i != rows.length - 1)
              Divider(height: 22, color: borderColor(context)),
          ],
        ],
      ),
    );
  }
}

class _AllocationLine extends StatelessWidget {
  const _AllocationLine({required this.allocation});

  final Allocation allocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final short = allocation.shortfall.minor > 0;

    // A non-mandatory shortfall never borrows the critical token: rendering a
    // policy shortfall as a failure teaches the user to distrust a signal
    // that is not one (§32.4).
    final critical = short && allocation.priority.isMandatory;
    final criticalColor =
        isDark(context) ? UpinoTokens.darkCritical : UpinoTokens.critical;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(allocation.label, style: theme.textTheme.bodyMedium),
              if (short) ...[
                const SizedBox(height: 2),
                Text(
                  '${allocation.shortfall.display()} not covered',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: critical ? criticalColor : null,
                    fontSize: 12.5,
                    fontFeatures: moneyFeatures,
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          allocation.allocated.display(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontFeatures: moneyFeatures,
          ),
        ),
      ],
    );
  }
}

/// §18 step 6: the user can see what changed without accounting jargon.
class _WhyCard extends StatelessWidget {
  const _WhyCard({required this.snapshot});

  final PlanSnapshot snapshot;

  static const _plainLanguage = <ReasonCode, String>{
    ReasonCode.incomeConfirmed: 'Your pay arrived, so the plan was refreshed.',
    ReasonCode.incomeLate: 'Your expected pay has not arrived yet.',
    ReasonCode.fundingGap: 'You have committed to more than you currently have.',
    ReasonCode.goalAtRisk: 'Your savings goal cannot be fully funded right now.',
    ReasonCode.overdueHardClaim: 'Something is past its due date.',
    ReasonCode.cardSpendFundingGap:
        'Your card balance is larger than the money you have.',
    ReasonCode.protectionHorizonExtended:
        'Money is held back for a bill due just after your next pay.',
    ReasonCode.reservationConsumed:
        'A bill you had set money aside for was paid.',
    ReasonCode.duplicateHold: 'A repeated transaction was counted only once.',
    ReasonCode.balanceStale: 'Your balance has not been confirmed recently.',
    ReasonCode.bufferShortfall: 'Your savings buffer is not fully topped up.',
    ReasonCode.flexibleShortfall: 'A flexible goal received less than planned.',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = snapshot.reasonCodes
        .map((c) => _plainLanguage[c])
        .whereType<String>()
        .toList();

    if (lines.isEmpty) {
      return UpinoCard(
        child: Text(
          'Nothing has changed since your last plan.',
          style: theme.textTheme.bodySmall,
        ),
      );
    }

    return UpinoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lines.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == lines.length - 1 ? 0 : 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 11),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: UpinoTokens.accentConfirm,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(lines[i], style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _BreakdownSheet extends StatelessWidget {
  const _BreakdownSheet({required this.snapshot});

  final PlanSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unfunded = snapshot.allocations
        .where((a) => a.shortfall.minor > 0 && a.priority.isMandatory)
        .toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
      decoration: BoxDecoration(
        color: isDark(context)
            ? UpinoTokens.darkSurfaceRaised
            : UpinoTokens.surfaceRaised,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UpinoTokens.radiusHero),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _Grabber()),
            const SizedBox(height: 20),
            Text('What is short', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(
              'Nothing here is moved or delayed for you. These are the '
              'commitments your current money does not cover.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            UpinoCard(
              color: sunkenColor(context),
              child: Column(
                children: [
                  for (var i = 0; i < unfunded.length; i++) ...[
                    _AllocationLine(allocation: unfunded[i]),
                    if (i != unfunded.length - 1)
                      Divider(height: 22, color: borderColor(context)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: borderColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
      );
}
