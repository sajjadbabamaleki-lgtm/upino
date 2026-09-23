/// Home, §18 steps 3, 5 and 6.
///
/// The decision comes first and charts stay secondary (§18). An expense
/// recorded here updates the figure immediately, with its reason code (§14).
library;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/parts.dart';
import '../design/theme.dart';
import '../design/icon.dart';
import '../design/tokens.dart';
import '../engine/allocate.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';
import 'activity_screen.dart';
import 'ask_screen.dart';
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
  /// Above the gesture bar, not against it. 7 put the pill's shadow on the
  /// edge of the display.
  static const _navBottomGap = 15.0;
  static const _navHeight = UpinoNavBar.itemHeight + UpinoNavBar.inset * 2;

  int _tab = 0;

  AppState get state => widget.state;

  Future<void> _recordExpense() async {
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).askSpendTitle,
      allowReceipt: true,
    );
    if (amount != null) {
      state.recordExpense(amount.amount, receipt: amount.receipt);
    }
  }

  Future<void> _confirmBalance() async {
    final observed = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).askBalanceTitle,
      explanation: AppLocalizations.of(context).askBalanceBlurb,
      initial: state.snapshot.trustedAllocatableLiquidity,
    );
    if (observed != null) state.confirmBalance(observed.amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final snapshot = state.snapshot;
    final justRecorded = state.lastRecordedExpense;
    final attention =
        snapshot.allocations.where((a) => a.shortfall.minor > 0).toList();

    // Edge to edge, so the view now extends under the gesture bar. Everything
    // that was measured from the bottom of the screen has to clear it.
    final systemBottom = MediaQuery.viewPaddingOf(context).bottom;
    final navBottomGap = _navBottomGap + systemBottom;

    final contentPadding = EdgeInsets.fromLTRB(
      UpinoTokens.gutter,
      8,
      UpinoTokens.gutter,
      120 + systemBottom,
    );

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: switch (_tab) {
              1 => PlanScreen(
                  key: const PageStorageKey('tab-plan'),
                  state: state,
                  padding: contentPadding,
                  onOpenGoals: () => setState(() => _tab = 2),
                ),
              2 => GoalsScreen(
                  key: const PageStorageKey('tab-goals'),
                  state: state,
                  padding: contentPadding,
                ),
              3 => ActivityScreen(
                  key: const PageStorageKey('tab-activity'),
                  state: state,
                  padding: contentPadding,
                ),
              4 => ProfileScreen(
                  key: const PageStorageKey('tab-profile'),
                  state: state,
                  padding: contentPadding,
                ),
              _ => ListView(
                  key: const PageStorageKey('tab-home'),
                  padding: contentPadding,
                  children: revealed([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.homeTitle,
                            style: theme.textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l.homeUntilTotal(
                              formatDate(context, snapshot.decisionHorizonEnd),
                              snapshot.trustedAllocatableLiquidity.display(),
                            ),
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

                    const SizedBox(height: 14),
                    ActionRow(
                      key: const Key('home-ask'),
                      title: l.askTitle,
                      subtitle: l.askBlurb,
                      trailing: const RowAffordance(icon: 'ask'),
                      onTap: () => AskScreen.open(context, state),
                    ),

                    const SizedBox(height: 26),

                    if (attention.isNotEmpty) ...[
                      SectionHeading(l.homeAttention, count: attention.length),
                      for (final a in attention) ...[
                        ActionRow(
                          title: labelForClaim(l, a.claimId, a.label),
                          subtitle: l.homeNotCovered(a.shortfall.display()),
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

                    if (snapshot.projectedSafeToSpend >
                        snapshot.safeToSpendNow) ...[
                      SectionHeading(l.homeAfterNextPay),
                      _ProjectedCard(snapshot: snapshot),
                      const SizedBox(height: 26),
                    ],

                    SectionHeading(l.homeSetAsideFirst),
                    _ProtectedCard(snapshot: snapshot),

                    const SizedBox(height: 26),
                    SectionHeading(l.homeWhyThisNumber),
                    _WhyCard(snapshot: snapshot),
                  ]),
                ),
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NavScrim(navHeight: _navHeight, bottomGap: navBottomGap),
          ),
          Positioned(
            left: UpinoTokens.gutter,
            right: UpinoTokens.gutter,
            bottom: navBottomGap,
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
            const UpinoIcon(
              'confirmed',
              size: 19,
              color: UpinoTokens.textPrimary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                AppLocalizations.of(context).homeRecorded(amount.display()),
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
              child: const UpinoIcon(
                'close',
                size: 18,
                color: UpinoTokens.textPrimary,
              ),
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
                  AppLocalizations.of(context).homeOncePayArrives(
                    formatDate(context, snapshot.decisionHorizonEnd),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // The layout mirrors in Arabic and Persian, and a mirrored rising
          // arrow reads as a falling one. The figure it sits beside is a
          // forecast of more money, so this one glyph keeps its direction.
          const Directionality(
            textDirection: TextDirection.ltr,
            child: RowAffordance(icon: 'trendingUp'),
          ),
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
          AppLocalizations.of(context).homeNothingSetAside,
          style: theme.textTheme.bodySmall,
        ),
      );
    }

    return UpinoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).homeProtectedBlurb,
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
              Text(
                labelForClaim(
                  AppLocalizations.of(context),
                  allocation.claimId,
                  allocation.label,
                ),
                style: theme.textTheme.bodyMedium,
              ),
              if (short) ...[
                const SizedBox(height: 2),
                Text(
                  AppLocalizations.of(context)
                      .homeNotCovered(allocation.shortfall.display()),
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

  /// Reason codes are engine output; this turns each into one sentence of
  /// the reader's own language, with no accounting jargon (§18 step 6).
  static String _plain(AppLocalizations l, ReasonCode code) => switch (code) {
        ReasonCode.incomeConfirmed => l.whyPayArrived,
        ReasonCode.incomeLate => l.whyPayLate,
        ReasonCode.fundingGap => l.whyOvercommitted,
        ReasonCode.goalAtRisk => l.whyGoalShort,
        ReasonCode.overdueHardClaim => l.whyOverdue,
        ReasonCode.cardSpendFundingGap => l.whyCardLarger,
        ReasonCode.protectionHorizonExtended => l.whyHeldForBill,
        ReasonCode.reservationConsumed => l.whyBillPaid,
        ReasonCode.duplicateHold => l.whyDuplicate,
        ReasonCode.balanceStale => l.whyStale,
        ReasonCode.bufferShortfall => l.whyBufferShort,
        ReasonCode.flexibleShortfall => l.whyFlexibleLess,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final lines = snapshot.reasonCodes.map((c) => _plain(l, c)).toList();

    if (lines.isEmpty) {
      return UpinoCard(
        child: Text(
          l.whyNoChange,
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
            Text(
              AppLocalizations.of(context).homeWhatIsShort,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).homeShortBlurb,
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
