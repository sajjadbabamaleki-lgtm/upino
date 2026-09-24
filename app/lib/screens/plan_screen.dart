/// Plan — the commitments behind the figure, and how to change them (§32.9).
///
/// Rows are listed in waterfall order, so the screen reads the way the money
/// is actually assigned rather than the order things were typed in.
library;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../domain/account.dart';
import '../domain/bill.dart';
import '../domain/goal.dart';
import '../domain/holding.dart';
import '../engine/domain.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';
import '../widgets/account_editor_sheet.dart';
import '../widgets/bill_editor_sheet.dart';
import '../widgets/choice_sheet.dart';
import '../widgets/holding_editor_sheet.dart';

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

  Future<void> _editHolding(BuildContext context, Holding? holding) async {
    final draft = await HoldingEditorSheet.show(
      context,
      currency: state.currency,
      holding: holding,
    );
    if (draft == null) return;
    if (holding == null) {
      state.addHolding(
        name: draft.name,
        quantityMilli: draft.quantityMilli,
        unitPrice: draft.unitPrice,
      );
    } else if (draft.deleted) {
      state.removeHolding(holding.id);
    } else {
      state.updateHolding(
        holding.id,
        name: draft.name,
        quantityMilli: draft.quantityMilli,
        unitPrice: draft.unitPrice,
      );
    }
  }

  Future<void> _confirmBalance(BuildContext context) async {
    final observed = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).askBalanceTitle,
      explanation: AppLocalizations.of(context).askBalanceBlurb,
      initial: state.accountBalance(Account.mainId),
    );
    if (observed != null) state.confirmBalance(observed.amount);
  }

  Future<void> _recordPay(BuildContext context) async {
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

  Future<void> _addAccount(BuildContext context) async {
    final draft =
        await AccountEditorSheet.show(context, currency: state.currency);
    if (draft == null) return;
    state.addAccount(
      name: draft.name,
      kind: draft.kind,
      opening: draft.opening,
      counted: draft.counted,
    );
  }

  Future<void> _openAccount(BuildContext context, Account a) async {
    final l = AppLocalizations.of(context);
    final targets = [
      (id: Account.mainId, name: l.accountMain),
      for (final o in state.accounts)
        if (o.id != a.id && o.holdsMoney) (id: o.id, name: o.name),
    ];
    final choice = await ChoiceSheet.show<String>(
      context,
      title: a.name,
      subtitle: accountKindLabel(l, a.kind),
      choices: [
        if (a.holdsMoney) Choice('confirm', l.accountConfirm),
        if (a.holdsMoney)
          for (final t in targets)
            Choice('move:${t.id}', l.accountMoveTo(t.name)),
        if (a.kind == AccountKind.card)
          Choice('pay', l.accountPayCard, detail: l.accountPayBlurb),
        if (a.holdsMoney)
          Choice(
            'count',
            a.counted ? l.accountStopCounting : l.accountCounted,
            detail: l.accountCountedSub,
          ),
        Choice(
          'remove',
          l.accountRemove,
          detail: state.accountInUse(a.id) ? l.accountInUse : null,
          destructive: true,
        ),
      ],
    );
    if (choice == null || !context.mounted) return;
    if (choice == 'confirm') {
      final observed = await AmountSheet.show(
        context,
        currency: state.currency,
        title: l.accountConfirm,
        initial: state.accountBalance(a.id),
        allowZero: true,
      );
      if (observed != null) state.confirmAccountBalance(a.id, observed.amount);
    } else if (choice.startsWith('move:')) {
      final to = choice.substring(5);
      final amount = await AmountSheet.show(
        context,
        currency: state.currency,
        title: l.accountMove,
        explanation: l.accountMoveBlurb,
      );
      if (amount != null) {
        state.transfer(from: a.id, to: to, amount: amount.amount);
      }
    } else if (choice == 'pay') {
      final amount = await AmountSheet.show(
        context,
        currency: state.currency,
        title: l.accountPayCard,
        explanation: l.accountPayBlurb,
        initial: state.accountBalance(a.id),
      );
      if (amount != null) state.payCard(a.id, amount.amount);
    } else if (choice == 'count') {
      state.updateAccount(a.id, counted: !a.counted);
    } else if (choice == 'remove') {
      state.removeAccount(a.id);
    }
  }

  Future<void> _addBill(BuildContext context) async {
    final draft = await BillEditorSheet.show(context, state: state);
    if (draft == null) return;
    state.addBill(
      name: draft.name,
      amount: draft.amount,
      every: draft.every,
      nextDue: draft.nextDue,
      kind: draft.kind,
      debtAccountId: draft.debtAccountId,
    );
  }

  Future<void> _openBill(BuildContext context, Bill bill) async {
    final l = AppLocalizations.of(context);
    final choice = await ChoiceSheet.show<String>(
      context,
      title: bill.name,
      subtitle: '${bill.amount.display()}${UpinoTokens.separator}'
          '${billEveryLabel(l, bill.every)}',
      choices: [
        Choice(
          'pay',
          l.billPay,
          detail: formatDate(context, bill.nextDue),
        ),
        Choice('edit', l.billEdit),
      ],
    );
    if (choice == null || !context.mounted) return;
    if (choice == 'pay') {
      state.payBill(bill.id);
      return;
    }
    final draft = await BillEditorSheet.show(context, state: state, bill: bill);
    if (draft == null) return;
    if (draft.deleted) {
      state.removeBill(bill.id);
      return;
    }
    state.updateBill(
      bill.id,
      name: draft.name,
      amount: draft.amount,
      every: draft.every,
      nextDue: draft.nextDue,
      kind: draft.kind,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final claims = state.editableClaims;
    final existing = {for (final c in claims) c.id};
    final addable =
        AppState.addableClaims.where((c) => !existing.contains(c.id)).toList();
    final income = state.nextIncome;

    return ListView(
      padding: padding,
      children: revealed([
        // The page's name is in the capsule above.
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
          child: Text(
            l.planBlurb,
            style: theme.textTheme.bodySmall,
          ),
        ),
        SectionHeading(l.planMoneyAndIncome),
        ActionRow(
          key: const Key('plan-balance'),
          title: state.accounts.isEmpty ? l.planMoneyYouHave : l.accountMain,
          subtitle: state.accountBalance(Account.mainId).display(),
          onTap: () => _confirmBalance(context),
        ),
        const SizedBox(height: 10),
        for (final a in state.accounts) ...[
          ActionRow(
            key: Key('plan-account-${a.id}'),
            title: a.name,
            subtitle: [
              accountKindLabel(l, a.kind),
              if (a.isDebt)
                l.accountOwed(state.accountBalance(a.id).display())
              else
                state.accountBalance(a.id).display(),
              if (a.holdsMoney && !a.counted) l.accountNotCounted,
            ].join(UpinoTokens.separator),
            onTap: () => _openAccount(context, a),
          ),
          const SizedBox(height: 10),
        ],
        ActionRow(
          key: const Key('plan-account-add'),
          title: l.accountAdd,
          subtitle: l.accountAddSub,
          trailing: const RowAffordance(icon: 'add'),
          onTap: () => _addAccount(context),
        ),
        const SizedBox(height: 10),
        ActionRow(
          key: const Key('plan-income'),
          title: l.planNextPay,
          subtitle: income == null
              ? l.planNotSet
              : '${income.isRange ? l.incomeRange(
                      income.expectedAmount.display(),
                      income.expectedUpperAmount!.display(),
                    ) : income.expectedAmount.display()}'
                  '${UpinoTokens.separator}'
                  '${formatDate(context, income.expectedDate)}',
          onTap: () => _editIncome(context),
        ),
        if (income != null && income.isRange) ...[
          const SizedBox(height: 10),
          UpinoCard(
            key: const Key('plan-income-range'),
            child: Text(
              l.incomeRangeNote(income.expectedAmount.display()),
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
        if (income != null) ...[
          const SizedBox(height: 10),
          ActionRow(
            key: const Key('plan-pay-arrived'),
            title: l.planRecordPay,
            subtitle: l.planRecordPaySub,
            trailing: const RowAffordance(icon: 'add'),
            onTap: () => _recordPay(context),
          ),
        ],
        // Bills come before goals because the waterfall funds them first.
        const SizedBox(height: 20),
        SectionHeading(
          l.billsTitle,
          count: state.bills.isEmpty ? null : state.bills.length,
        ),
        for (final bill in state.bills) ...[
          ActionRow(
            key: Key('plan-bill-${bill.id}'),
            title: bill.name,
            subtitle: bill.nextDue < state.today
                ? l.billOverdue(formatDate(context, bill.nextDue))
                : l.billRow(
                    billEveryLabel(l, bill.every),
                    formatDate(context, bill.nextDue),
                  ),
            titleColor: bill.nextDue < state.today
                ? (isDark(context)
                    ? UpinoTokens.darkCritical
                    : UpinoTokens.critical)
                : null,
            trailing: _Amount(bill.amount),
            onTap: () => _openBill(context, bill),
          ),
          const SizedBox(height: 10),
        ],
        ActionRow(
          key: const Key('plan-bill-add'),
          title: l.billAdd,
          subtitle: l.billAddSub,
          trailing: const RowAffordance(icon: 'add'),
          onTap: () => _addBill(context),
        ),
        const SizedBox(height: 20),
        SectionHeading(
          l.planGoals,
          count: state.goals.isEmpty ? null : state.goals.length,
        ),
        if (state.goals.isEmpty)
          ActionRow(
            key: const Key('plan-goals'),
            title: l.planSaveToward,
            subtitle: l.planSaveTowardSub,
            trailing: const RowAffordance(icon: 'add'),
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
        const SizedBox(height: 20),
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
          const SizedBox(height: 10),
          SectionHeading(l.planAddToPlan),
          for (final option in addable) ...[
            ActionRow(
              key: Key('plan-add-${option.id}'),
              title: labelForClaim(l, option.id, option.label),
              subtitle: _priorityExplanation(l, option.priority),
              trailing: const RowAffordance(icon: 'add'),
              onTap: () => _editClaim(
                context,
                id: option.id,
                label: labelForClaim(l, option.id, option.label),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
        // Last, because the screen reads in the order money is assigned and
        // holdings are assigned nothing: they sit beside the plan.
        const SizedBox(height: 20),
        SectionHeading(
          l.holdingsTitle,
          count: state.holdings.isEmpty ? null : state.holdings.length,
        ),
        for (final h in state.holdings) ...[
          ActionRow(
            key: Key('plan-holding-${h.id}'),
            title: h.name,
            subtitle: l.holdingSummary(
              formatQuantity(h.quantityMilli),
              h.unitPrice.display(),
              formatDateShort(context, h.pricedOn),
            ),
            trailing: _Amount(h.value),
            onTap: () => _editHolding(context, h),
          ),
          const SizedBox(height: 10),
        ],
        if (state.holdings.length > 1) ...[
          UpinoCard(
            key: const Key('plan-holdings-total'),
            child: Row(
              children: [
                Expanded(
                  child: Text(l.holdingsTotal,
                      style: theme.textTheme.titleMedium,),
                ),
                Text(
                  state.holdingsTotal.display(),
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontFeatures: moneyFeatures),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        ActionRow(
          key: const Key('plan-holding-add'),
          title: l.holdingsAdd,
          subtitle: state.holdings.isEmpty ? l.holdingsBlurb : l.holdingsAddSub,
          trailing: const RowAffordance(icon: 'add'),
          onTap: () => _editHolding(context, null),
        ),
      ]),
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
