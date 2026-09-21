/// Home, §18 steps 3, 5 and 6.
///
/// The decision comes first and charts stay secondary (§18). An expense
/// recorded here updates the figure immediately, with its reason code (§14).
library;

import 'package:flutter/material.dart';

import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/allocate.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../state/app_state.dart';
import '../widgets/quick_expense_sheet.dart';
import '../widgets/sts_hero.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.state, super.key});

  final AppState state;

  Future<void> _recordExpense(BuildContext context) async {
    final amount = await QuickExpenseSheet.show(context, state.currency);
    if (amount != null) state.recordExpense(amount);
  }

  Future<void> _confirmBalance(BuildContext context) async {
    final observed = await QuickExpenseSheet.show(context, state.currency);
    if (observed != null) state.confirmBalance(observed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snapshot = state.snapshot;
    final justRecorded = state.lastRecordedExpense;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _recordExpense(context),
        backgroundColor: UpinoTokens.actionPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Spent'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            UpinoTokens.gutter,
            16,
            UpinoTokens.gutter,
            96,
          ),
          children: [
            Text('Your plan', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            StsHero(
              snapshot: snapshot,
              onConfirmBalance: () => _confirmBalance(context),
              onResolve: () => _showBreakdown(context, snapshot),
            ),

            // A confirmation marks a moment that just happened; it never
            // becomes a persistent state and never touches the figure (§32.7).
            if (justRecorded != null) ...[
              const SizedBox(height: 12),
              _ConfirmationBadge(
                amount: justRecorded,
                onDismiss: state.clearExpenseConfirmation,
              ),
            ],

            const SizedBox(height: 24),
            if (snapshot.projectedSafeToSpend > snapshot.safeToSpendNow)
              _ProjectedCard(snapshot: snapshot),
            const SizedBox(height: 12),
            _ProtectedList(snapshot: snapshot),
            const SizedBox(height: 12),
            _WhyCard(snapshot: snapshot),
          ],
        ),
      ),
    );
  }

  void _showBreakdown(BuildContext context, PlanSnapshot snapshot) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _BreakdownSheet(snapshot: snapshot),
    );
  }
}

class _ConfirmationBadge extends StatelessWidget {
  const _ConfirmationBadge({required this.amount, required this.onDismiss});

  final Money amount;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: UpinoTokens.accentConfirm,
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle,
                size: 18, color: UpinoTokens.textPrimary,),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${amount.display()} recorded',
                style: const TextStyle(
                  color: UpinoTokens.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFeatures: moneyFeatures,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close,
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
    return _Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('After your next pay arrives',
                    style: theme.textTheme.bodySmall,),
                const SizedBox(height: 4),
                Text(
                  snapshot.projectedSafeToSpend.display(),
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontFeatures: moneyFeatures),
                ),
              ],
            ),
          ),
          Icon(Icons.trending_up,
              color: theme.textTheme.bodySmall?.color, size: 22,),
        ],
      ),
    );
  }
}

class _ProtectedList extends StatelessWidget {
  const _ProtectedList({required this.snapshot});

  final PlanSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = snapshot.allocations
        .where((a) => a.requiredNow.minor > 0)
        .toList();
    if (rows.isEmpty) return const SizedBox.shrink();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set aside first', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'These are protected before anything is spendable.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          for (final a in rows) _AllocationRow(allocation: a),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.allocation});

  final Allocation allocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final short = allocation.shortfall.minor > 0;

    // A non-mandatory shortfall never borrows the critical token: rendering a
    // policy shortfall as a failure teaches the user to distrust a signal that
    // is not one (§32.4).
    final critical = short && allocation.priority.isMandatory;
    final criticalColor =
        dark ? UpinoTokens.darkCritical : UpinoTokens.critical;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(allocation.label, style: theme.textTheme.bodyMedium),
                if (short)
                  Text(
                    '${allocation.shortfall.display()} not covered',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: critical ? criticalColor : null,
                      fontFeatures: moneyFeatures,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            allocation.allocated.display(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: moneyFeatures,
            ),
          ),
        ],
      ),
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
    ReasonCode.reservationConsumed: 'A bill you had set money aside for was paid.',
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
    if (lines.isEmpty) return const SizedBox.shrink();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Why this number', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 10),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.textTheme.bodySmall?.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(line, style: theme.textTheme.bodySmall),
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
    final dark = theme.brightness == Brightness.dark;
    final unfunded = snapshot.allocations
        .where((a) => a.shortfall.minor > 0 && a.priority.isMandatory)
        .toList();

    return Container(
      padding: const EdgeInsets.all(UpinoTokens.gutter + 4),
      decoration: BoxDecoration(
        color: dark ? UpinoTokens.darkSurfaceRaised : UpinoTokens.surfaceRaised,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UpinoTokens.radiusCard + 4),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What is short', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(
              'Nothing here is moved or delayed for you. These are the '
              'commitments your current money does not cover.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 18),
            for (final a in unfunded) _AllocationRow(allocation: a),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UpinoTokens.cardPadding),
      decoration: BoxDecoration(
        color: dark ? UpinoTokens.darkSurfaceCard : UpinoTokens.surfaceCard,
        borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
      ),
      child: child,
    );
  }
}
