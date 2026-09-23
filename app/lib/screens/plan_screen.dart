/// Plan — the commitments behind the figure, and how to change them (§32.9).
///
/// Rows are listed in waterfall order, so the screen reads the way the money
/// is actually assigned rather than the order things were typed in.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../domain/goal.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({
    required this.state,
    required this.padding,
    required this.onOpenGoals,
    super.key,
  });

  final AppState state;
  final EdgeInsets padding;

  /// Goals has its own destination, so these rows switch tab rather than
  /// pushing a second copy of the screen on top of the bar.
  final VoidCallback onOpenGoals;

  Future<void> _editClaim(
    BuildContext context, {
    required String id,
    required String label,
    Money? current,
  }) async {
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: label,
      explanation: current == null
          ? AppLocalizations.of(context).planHowMuchSetAside
          : AppLocalizations.of(context).planChangeOrRemove,
      initial: current,
      allowZero: true,
      removeLabel:
          current == null ? null : AppLocalizations.of(context).planRemove,
    );
    if (amount != null) state.setClaimAmount(id, amount.amount);
  }

  Future<void> _editIncome(BuildContext context) async {
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).planYourNextPay,
      explanation: AppLocalizations.of(context).planExpectedBlurb,
      initial: state.nextIncome?.expectedAmount,
    );
    if (amount != null) state.setExpectedIncome(amount: amount.amount);
  }

  Future<void> _confirmBalance(BuildContext context) async {
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
    final claims = state.editableClaims;
    final existing = {for (final c in claims) c.id};
    final addable =
        AppState.addableClaims.where((c) => !existing.contains(c.id)).toList();
    final income = state.nextIncome;

    return ListView(
      padding: padding,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.planTitle, style: theme.textTheme.headlineLarge),
              const SizedBox(height: 2),
              Text(
                l.planBlurb,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        SectionHeading(l.planMoneyAndIncome),
        ActionRow(
          key: const Key('plan-balance'),
          title: l.planMoneyYouHave,
          subtitle: snapshot.trustedAllocatableLiquidity.display(),
          onTap: () => _confirmBalance(context),
        ),
        const SizedBox(height: 10),
        ActionRow(
          key: const Key('plan-income'),
          title: l.planNextPay,
          subtitle: income == null
              ? l.planNotSet
              : '${income.expectedAmount.display()}'
                  '${UpinoTokens.separator}'
                  '${formatDate(context, income.expectedDate)}',
          onTap: () => _editIncome(context),
        ),

        const SizedBox(height: 26),
        SectionHeading(
          l.planGoals,
          count: state.goals.isEmpty ? null : state.goals.length,
        ),
        if (state.goals.isEmpty)
          ActionRow(
            key: const Key('plan-goals'),
            title: l.planSaveToward,
            subtitle: l.planSaveTowardSub,
            trailing: const RowAffordance(icon: Icons.add_rounded),
            onTap: () => onOpenGoals(),
          )
        else ...[
          for (final goal in state.goals.take(3)) ...[
            ActionRow(
              key: Key('plan-goal-${goal.id}'),
              title: goal.name,
              subtitle: goal.kind == GoalKind.paused
                  ? l.goalKindPaused
                  : '${goal.saved.display()} ${l.goalsOf(goal.target.display())}',
              trailing: _Amount(
                goal.requiredThisCycle(state.today, state.payCycleDays),
              ),
              onTap: () => onOpenGoals(),
            ),
            const SizedBox(height: 10),
          ],
          ActionRow(
            key: const Key('plan-goals'),
            title: l.planAllGoals,
            subtitle: l.planAllGoalsSub,
            onTap: () => onOpenGoals(),
          ),
        ],

        const SizedBox(height: 26),
        SectionHeading(
          l.planSetAsideFirst,
          count: claims.isEmpty ? null : claims.length,
        ),
        if (claims.isEmpty)
          UpinoCard(
            child: Text(
              l.planNothingSetAside,
              style: theme.textTheme.bodySmall,
            ),
          )
        else
          for (final claim in claims) ...[
            ActionRow(
              key: Key('plan-claim-${claim.id}'),
              title: labelForClaim(l, claim.id, claim.label),
              subtitle: _subtitleFor(context, claim),
              trailing: _Amount(claim.amount),
              onTap: () => _editClaim(
                context,
                id: claim.id,
                label: labelForClaim(l, claim.id, claim.label),
                current: claim.amount,
              ),
            ),
            const SizedBox(height: 10),
          ],

        if (addable.isNotEmpty) ...[
          const SizedBox(height: 16),
          SectionHeading(l.planAddToPlan),
          for (final option in addable) ...[
            ActionRow(
              key: Key('plan-add-${option.id}'),
              title: labelForClaim(l, option.id, option.label),
              subtitle: _priorityExplanation(l, option.priority),
              trailing: const RowAffordance(icon: Icons.add_rounded),
              onTap: () => _editClaim(
                context,
                id: option.id,
                label: labelForClaim(l, option.id, option.label),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }

  String _subtitleFor(BuildContext context, Claim claim) {
    final l = AppLocalizations.of(context);
    final due = claim.dueDate;
    final when = due == null ? '' : l.planDue(formatDate(context, due));
    return '${_priorityExplanation(l, claim.priority)}$when';
  }

  /// Plain language for where a commitment sits in the waterfall, so the
  /// order on screen is explained rather than just asserted.
  static String _priorityExplanation(AppLocalizations l, Priority priority) =>
      switch (priority) {
        Priority.p2HardObligation => l.priorityMandatory,
        Priority.p3CardSpendReserve => l.priorityCard,
        Priority.p4EssentialLiving => l.priorityEssential,
        Priority.p5SinkingCatchup => l.prioritySinkingFund,
        Priority.p6Buffer => l.priorityBuffer,
        Priority.p7HardGoal => l.priorityGoal,
        Priority.p8Flexible => l.priorityDiscretionary,
        _ => l.planSetAsideFirst,
      };
}

class _Amount extends StatelessWidget {
  const _Amount(this.amount);

  final Money amount;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amount.display(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFeatures: moneyFeatures,
                ),
          ),
          const SizedBox(width: 10),
          const RowAffordance(),
        ],
      );
}
