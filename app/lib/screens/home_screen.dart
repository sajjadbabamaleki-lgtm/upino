/// Home, §18 steps 3, 5 and 6.
///
/// The decision comes first and charts stay secondary (§18). An expense
/// recorded here updates the figure immediately, with its reason code (§14).
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/account.dart';
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
import '../device/device_bridge.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import 'first_run/reveal_screen.dart';
import '../widgets/amount_sheet.dart';
import '../widgets/best_move_card.dart';
import '../widgets/bills_sheet.dart';
import '../widgets/charts.dart';
import '../widgets/month_review.dart';
import '../widgets/quick_actions.dart';
import '../state/insights.dart';
import '../widgets/bill_editor_sheet.dart' show relativeDay;
import '../widgets/alerts_sheet.dart';
import '../widgets/bank_suggestions_sheet.dart';
import '../widgets/top_bar.dart';
import 'ask_chat_screen.dart';
import 'ask_hub_screen.dart';
import 'activity_screen.dart';
import 'goals_screen.dart';
import 'plan_screen.dart';
import 'profile_screen.dart';
import '../widgets/sts_hero.dart';
import '../widgets/pay_gauge_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.state, super.key});

  final AppState state;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  StreamSubscription<void>? _spendRequests;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final bridge = DeviceBridge.instance;
    if (bridge != null) {
      // The widget's button and the evening reminder both land here.
      _spendRequests = bridge.spendRequests.listen((_) => _recordExpense());
      if (bridge.takePendingSpend()) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => unawaited(_recordExpense()));
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_spendRequests?.cancel());
    super.dispose();
  }

  /// Coming back to the app is when a new bank message is most likely to be
  /// waiting, usually from the payment just made.
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (lifecycle == AppLifecycleState.resumed) {
      unawaited(DeviceBridge.instance?.readInbox());
    }
  }

  /// Above the gesture bar, not against it. 7 put the pill's shadow on the
  /// edge of the display.
  static const _navBottomGap = 15.0;
  static const _navHeight = UpinoNavBar.itemHeight + UpinoNavBar.inset * 2;

  int _tab = 0;

  static const _askTab = 4;
  static const _profileTab = 5;

  AppState get state => widget.state;

  String _titleFor(AppLocalizations l) => switch (_tab) {
        1 => l.navPlan,
        2 => l.navGoals,
        3 => l.navActivity,
        _askTab => l.navAsk,
        _profileTab => l.profileTitle,
        _ => l.navHome,
      };

  Future<void> _openAlerts() => AlertsSheet.show(
        context,
        state: state,
        onAct: (alert) {
          switch (alert) {
            case UnfundedAlert():
              setState(() => _tab = 0);
              _showBreakdown(state.snapshot);
            case BalanceStaleAlert():
              unawaited(_confirmBalance());
            case IncomeLateAlert():
              unawaited(_recordPay());
            case GoalBehindAlert():
              setState(() => _tab = 2);
            case BankMessagesAlert():
              unawaited(BankSuggestionsSheet.show(context, state));
          }
        },
      );

  Future<void> _recordPay() async {
    final l = AppLocalizations.of(context);
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: l.payArrivedTitle,
      explanation: l.payDueSub,
      initial: state.nextIncome?.expectedAmount,
    );
    if (amount != null) state.confirmIncome(amount.amount);
  }

  Future<void> _recordExpense() async {
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).askSpendTitle,
      allowReceipt: true,
      allowCategory: true,
      allowVoice: true,
      payFrom: [
        for (final a in state.payableAccounts) (id: a.id, name: a.name),
      ],
      suggestCategory: state.suggestCategory,
    );
    if (amount != null) {
      state.recordExpense(
        amount.amount,
        receipt: amount.receipt,
        category: amount.category,
        accountId: amount.accountId,
      );
    }
  }

  Future<void> _confirmBalance() async {
    final observed = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).askBalanceTitle,
      explanation: AppLocalizations.of(context).askBalanceBlurb,
      initial: state.accountBalance(Account.mainId),
    );
    if (observed != null) state.confirmBalance(observed.amount);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final snapshot = state.snapshot;
    final justRecorded = state.lastRecordedExpense;
    final move = state.bestMove;
    final attention =
        snapshot.allocations.where((a) => a.shortfall.minor > 0).toList();

    // Edge to edge, so the view now extends under the gesture bar. Everything
    // that was measured from the bottom of the screen has to clear it.
    final systemBottom = MediaQuery.viewPaddingOf(context).bottom;
    final navBottomGap = _navBottomGap + systemBottom;

    // No top padding: the capsule's own 14 below it is the gap to the
    // first card, the same 14 that separates the cards under it.
    final contentPadding = EdgeInsets.fromLTRB(
      UpinoTokens.gutter,
      0,
      UpinoTokens.gutter,
      120 + systemBottom,
    );

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    UpinoTokens.gutter,
                    8,
                    UpinoTokens.gutter,
                    14,
                  ),
                  child: UpinoTopBar(
                    title: _titleFor(l),
                    alertCount: state.alerts.length,
                    onAlerts: _openAlerts,
                    onProfile: () => setState(() => _tab = _profileTab),
                    profileSelected: _tab == _profileTab,
                  ),
                ),
                Expanded(
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
              4 => AskHubScreen(
                  key: const PageStorageKey('tab-ask'),
                  state: state,
                  padding: contentPadding,
                ),
              5 => ProfileScreen(
                  key: const PageStorageKey('tab-profile'),
                  state: state,
                  padding: contentPadding,
                ),
              _ => ListView(
                  key: const PageStorageKey('tab-home'),
                  padding: contentPadding,
                  children: revealed([
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
                        // A new spend restarts the clock.
                        key: ObjectKey(justRecorded),
                        amount: justRecorded,
                        onDismiss: state.clearExpenseConfirmation,
                        onRemove: state.undoLastExpense,
                      ),
                    ],

                    // What was buried in a tab or at the foot of Home,
                    // one tap from the figure.
                    const SizedBox(height: 12),
                    QuickActions(
                      actions: [
                        QuickAction(
                          keyName: 'home-ask',
                          icon: 'ask',
                          label: l.quickAsk,
                          hint: l.askBlurb,
                          // Straight into a conversation: the question is
                          // usually "can I afford this?".
                          onTap: () => ChatPage.open(context, state),
                        ),
                        QuickAction(
                          keyName: 'home-pay-arrived',
                          icon: 'confirmed',
                          label: l.quickPay,
                          // Pay that should have come is asked about, never
                          // assumed: it counts once the person says so.
                          flagged: state.payDue,
                          hint: state.payDue ? l.quickPayDue : l.payDueSub,
                          onTap: _recordPay,
                        ),
                        QuickAction(
                          keyName: 'home-bills',
                          icon: 'receipt',
                          label: l.quickBills,
                          flagged: state.upcomingBills().any(
                                (u) => u.due < state.today,
                              ),
                          onTap: () => BillsSheet.show(context, state),
                        ),
                        QuickAction(
                          keyName: 'home-month',
                          icon: 'trendingUp',
                          label: l.quickMonth,
                          onTap: () => MonthReviewCard.show(context, state),
                        ),
                      ],
                    ),

                    if (state.bankSuggestions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ActionRow(
                        key: const Key('home-sms'),
                        title: l.smsWaiting(state.bankSuggestions.length),
                        subtitle: l.smsWaitingSub,
                        trailing: const RowAffordance(icon: 'receipt'),
                        onTap: () => BankSuggestionsSheet.show(context, state),
                      ),
                    ],

                    // What setup left out that would change the figure.
                    if (state.setupGaps.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SetupGapsCard(
                        state: state,
                        onEssentials: () async {
                          final r = await AmountSheet.show(
                            context,
                            currency: state.currency,
                            title: AppLocalizations.of(context).frEssentialsSheet,
                          );
                          if (r != null) state.setClaimAmount('essentials', r.amount);
                        },
                        onBill: () => addBillFlow(context, state),
                      ),
                    ],

                    // One suggestion, when one is worth making (§6.2).
                    if (move != null && move.key != state.dismissedMove) ...[
                      const SizedBox(height: 12),
                      BestMoveCard(state: state, move: move),
                    ],

                    const SizedBox(height: 20),

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
                      // With the 10 after the last row, the 20 every heading
                      // has above it.
                      const SizedBox(height: 10),
                    ],

                    // How long the figure has to last, and what the pay
                    // brings: a gauge that drains day by day to the pay.
                    if (state.nextIncome?.isProjectable ?? false) ...[
                      SectionHeading(l.payGaugeTitle),
                      PayGaugeCard(state: state),
                      const SizedBox(height: 20),
                    ],

                    // Money already spoken for, as named payments with dates
                    // rather than one total (§6.3).
                    if (state.upcomingBills().isNotEmpty) ...[
                      SectionHeading(
                        l.homeComingUp,
                        count: state.upcomingBills().length,
                      ),
                      _ComingUpCard(state: state),
                      const SizedBox(height: 20),
                    ],

                    SectionHeading(l.homeSetAsideFirst),
                    _ProtectedCard(snapshot: snapshot),

                    const SizedBox(height: 20),
                    SectionHeading(l.homeWhyThisNumber),
                    _WhyCard(snapshot: snapshot),
                  ]),
                ),
            },
                ),
              ],
            ),
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
              // Profile lives in the capsule, so on Profile no tab is lit.
              index: _tab == _profileTab ? -1 : _tab,
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

/// Says a spend was recorded, then goes by itself. Its cross takes that
/// spend back, the moment a mistyped amount is most likely to be noticed,
/// but only after asking: a cross beside an amount is easy to hit by
/// accident. What is removed stays on Activity, marked, like any correction.
class _ConfirmationBanner extends StatefulWidget {
  const _ConfirmationBanner({
    required this.amount,
    required this.onDismiss,
    required this.onRemove,
    super.key,
  });

  final Money amount;
  final VoidCallback onDismiss;
  final VoidCallback onRemove;

  /// Long enough to read and to reach the cross, short enough not to
  /// become a fixture (§32.7).
  static const showFor = Duration(seconds: 6);

  @override
  State<_ConfirmationBanner> createState() => _ConfirmationBannerState();
}

class _ConfirmationBannerState extends State<_ConfirmationBanner> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(_ConfirmationBanner.showFor, widget.onDismiss);
  }

  Future<void> _confirmRemove() async {
    // The banner must not vanish from under the question.
    _timer?.cancel();
    final l = AppLocalizations.of(context);
    final remove = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor(dialogContext),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        ),
        title: Text(l.activityRemoveAmount(widget.amount.display())),
        content: Text(l.activityRemoveDetail),
        actions: [
          TextButton(
            key: const Key('banner-remove-no'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.no),
          ),
          TextButton(
            key: const Key('banner-remove-yes'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l.yes,
              style: TextStyle(
                color: isDark(dialogContext)
                    ? UpinoTokens.darkCritical
                    : UpinoTokens.critical,
              ),
            ),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (remove ?? false) {
      widget.onRemove();
    } else {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        // A tap puts it away early, for anyone who does not want to wait.
        onTap: widget.onDismiss,
        child: UpinoCard(
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
                  AppLocalizations.of(context)
                      .homeRecorded(widget.amount.display()),
                  style: const TextStyle(
                    color: UpinoTokens.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    fontFeatures: moneyFeatures,
                  ),
                ),
              ),
              GestureDetector(
                key: const Key('banner-remove'),
                onTap: _confirmRemove,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: UpinoIcon(
                    'close',
                    size: 18,
                    color: UpinoTokens.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
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
          // Said as money already taken and the date it is held to (§6.3),
          // so the gap between balance and spendable is not a mystery.
          Text(
            AppLocalizations.of(context).homeSpokenFor(
              snapshot.protectedTotal.display(),
              formatDate(context, snapshot.decisionHorizonEnd),
            ),
            key: const Key('home-spoken-for'),
            style: theme.textTheme.bodyMedium,
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

/// The next few payments falling due, soonest first, with what the next
/// thirty days of bills come to.
class _ComingUpCard extends StatelessWidget {
  const _ComingUpCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final upcoming = state.upcomingBills();
    final critical =
        isDark(context) ? UpinoTokens.darkCritical : UpinoTokens.critical;
    return UpinoCard(
      key: const Key('home-coming-up'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.homeComingUpTotal(state.billsDueWithin().display()),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          // Each payment as a stick at its date, as tall as it costs: when
          // the month's bills bunch up is visible before it happens.
          Lollipops(
            key: const Key('home-coming-up-chart'),
            items: [
              for (final u in upcoming)
                Lollipop(
                  at: (u.due.differenceInDays(state.today) / 30)
                      .clamp(0.0, 1.0),
                  value: u.bill.amount.minor.toDouble(),
                  color: u.due < state.today
                      ? critical
                      : (isDark(context)
                          ? UpinoTokens.darkActionPrimary
                          : UpinoTokens.actionPrimary),
                ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < upcoming.length && i < 4; i++) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upcoming[i].bill.name,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        upcoming[i].due < state.today
                            ? l.billOverdue(
                                formatDate(context, upcoming[i].due),
                              )
                            : '${formatDate(context, upcoming[i].due)}'
                                '${UpinoTokens.separator}'
                                '${relativeDay(l, upcoming[i].due, state.today)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: upcoming[i].due < state.today
                              ? critical
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  upcoming[i].bill.amount.display(),
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontFeatures: moneyFeatures),
                ),
              ],
            ),
            if (i != upcoming.length - 1 && i != 3)
              Divider(height: 22, color: borderColor(context)),
          ],
        ],
      ),
    );
  }
}
