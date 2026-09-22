/// Plan — the commitments behind the figure, and how to change them (§32.9).
///
/// Rows are listed in waterfall order, so the screen reads the way the money
/// is actually assigned rather than the order things were typed in.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';
import '../widgets/sts_hero.dart' show formatDate;

class PlanScreen extends StatelessWidget {
  const PlanScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

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
          ? 'How much do you need to set aside for this?'
          : 'Change the amount, or remove it from your plan.',
      initial: current,
      allowZero: true,
      removeLabel: current == null ? null : 'Remove from plan',
    );
    if (amount != null) state.setClaimAmount(id, amount);
  }

  Future<void> _editIncome(BuildContext context) async {
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: 'Your next pay',
      explanation:
          'This is only expected, so it stays out of what you can spend now.',
      initial: state.nextIncome?.expectedAmount,
    );
    if (amount != null) state.setExpectedIncome(amount: amount);
  }

  Future<void> _confirmBalance(BuildContext context) async {
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
              Text('Plan', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 2),
              Text(
                'What your money is promised to, before anything is spendable.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const SectionHeading('Money and income'),
        ActionRow(
          key: const Key('plan-balance'),
          title: 'Money you have',
          subtitle: snapshot.trustedAllocatableLiquidity.display(),
          onTap: () => _confirmBalance(context),
        ),
        const SizedBox(height: 10),
        ActionRow(
          key: const Key('plan-income'),
          title: 'Next pay',
          subtitle: income == null
              ? 'Not set'
              : '${income.expectedAmount.display()}'
                  '${UpinoTokens.separator}'
                  '${formatDate(income.expectedDate)}',
          onTap: () => _editIncome(context),
        ),

        const SizedBox(height: 26),
        SectionHeading('Set aside first', count: claims.isEmpty ? null : claims.length),
        if (claims.isEmpty)
          UpinoCard(
            child: Text(
              'Nothing is set aside, so everything you have is spendable.',
              style: theme.textTheme.bodySmall,
            ),
          )
        else
          for (final claim in claims) ...[
            ActionRow(
              key: Key('plan-claim-${claim.id}'),
              title: claim.label,
              subtitle: _subtitleFor(claim),
              trailing: _Amount(claim.amount),
              onTap: () => _editClaim(
                context,
                id: claim.id,
                label: claim.label,
                current: claim.amount,
              ),
            ),
            const SizedBox(height: 10),
          ],

        if (addable.isNotEmpty) ...[
          const SizedBox(height: 16),
          const SectionHeading('Add to your plan'),
          for (final option in addable) ...[
            ActionRow(
              key: Key('plan-add-${option.id}'),
              title: option.label,
              subtitle: _priorityExplanation(option.priority),
              trailing: const RowAffordance(icon: Icons.add_rounded),
              onTap: () => _editClaim(
                context,
                id: option.id,
                label: option.label,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }

  String _subtitleFor(Claim claim) {
    final due = claim.dueDate;
    final when = due == null ? '' : '${UpinoTokens.separator}due ${formatDate(due)}';
    return '${_priorityExplanation(claim.priority)}$when';
  }

  /// Plain language for where a commitment sits in the waterfall, so the
  /// order on screen is explained rather than just asserted.
  static String _priorityExplanation(Priority priority) => switch (priority) {
        Priority.p2HardObligation => 'Must be paid — comes first',
        Priority.p3CardSpendReserve => 'Already spent on a card',
        Priority.p4EssentialLiving => 'Day-to-day needs',
        Priority.p5SinkingCatchup => 'Saving for a known bill',
        Priority.p6Buffer => 'Kept back for emergencies',
        Priority.p7HardGoal => 'A goal you have committed to',
        Priority.p8Flexible => 'Nice to have — yields first',
        _ => 'Protected',
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
