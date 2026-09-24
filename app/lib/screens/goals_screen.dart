/// Goals (§10).
///
/// Each goal shows what it needs this period, not just its target, because
/// that is the number the plan actually holds back.
library;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../domain/goal.dart';
import '../domain/inflation.dart';
import '../engine/clock.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';
import '../widgets/goal_editor_sheet.dart';
import '../widgets/goal_projection_view.dart';
import '../state/projection.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  Future<void> _create(BuildContext context) async {
    final draft = await GoalEditorSheet.show(context, state: state);
    if (draft == null) return;
    state.addGoal(
      name: draft.name,
      target: draft.target,
      targetDate: draft.targetDate,
      kind: draft.kind,
    );
  }

  Future<void> _edit(BuildContext context, Goal goal) async {
    final draft = await GoalEditorSheet.show(context, state: state, goal: goal);
    if (draft == null) return;
    if (draft.deleted) {
      state.removeGoal(goal.id);
      return;
    }
    state.updateGoal(
      goal.id,
      name: draft.name,
      target: draft.target,
      targetDate: draft.targetDate,
      kind: draft.kind,
    );
  }

  Future<void> _contribute(BuildContext context, Goal goal) async {
    final amount = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).goalsAddTo(goal.name),
      explanation: AppLocalizations.of(context).goalsAddBlurb,
    );
    if (amount != null) state.contributeToGoal(goal.id, amount.amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final goals = state.goals;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => ListView(
        padding: padding,
        children: revealed([
          // The page's name is in the capsule above.
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
            child: Text(
              goals.isEmpty ? l.goalsBlurbEmpty : l.goalsBlurb,
              style: theme.textTheme.bodySmall,
            ),
          ),
          if (goals.isEmpty)
            UpinoCard(
              child: Text(
                l.goalsEmptyCard,
                style: theme.textTheme.bodySmall,
              ),
            )
          else
            for (final goal in goals) ...[
              _GoalCard(
                state: state,
                goal: goal,
                inflated: state.inflatedTarget(goal),
                rate: state.inflationBasisPoints,
                today: state.today,
                payCycleDays: state.payCycleDays,
                onEdit: () => _edit(context, goal),
                onContribute: () => _contribute(context, goal),
              ),
              const SizedBox(height: 12),
            ],
          const SizedBox(height: 10),
          if (goals.isNotEmpty) ...[
            _InflationRow(state: state),
            const SizedBox(height: 10),
          ],
          // A floating button would sit on top of the nav bar, so the one
          // action this tab has lives in the list like the Plan tab's adds.
          ActionRow(
            key: const Key('goals-new'),
            title: l.goalsNew,
            subtitle: l.goalsNewSub,
            trailing: const RowAffordance(icon: 'add'),
            onTap: () => _create(context),
          ),
        ]),
      ),
    );
  }
}

class _GoalCard extends StatefulWidget {
  const _GoalCard({
    required this.state,
    required this.goal,
    required this.today,
    this.inflated,
    this.rate,
    required this.payCycleDays,
    required this.onEdit,
    required this.onContribute,
  });

  final AppState state;
  final Goal goal;

  /// The target at the expected inflation on its date, when that is more.
  final Money? inflated;
  final int? rate;
  final LocalDate today;
  final int payCycleDays;
  final VoidCallback onEdit;
  final VoidCallback onContribute;

  @override
  State<_GoalCard> createState() => _GoalCardState();

  static String _status(AppLocalizations l, Goal goal, int cycles) =>
      switch (goal.kind) {
        GoalKind.paused => l.goalsPausedStatus,
        GoalKind.flexible => l.goalsFlexibleStatus,
        GoalKind.hard when goal.isComplete => l.goalsDone,
        GoalKind.hard => l.goalsPeriodsToGo(cycles),
      };
}

class _GoalCardState extends State<_GoalCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final today = widget.today;
    final payCycleDays = widget.payCycleDays;
    final inflated = widget.inflated;
    final rate = widget.rate;
    final onEdit = widget.onEdit;
    final onContribute = widget.onContribute;
    final theme = Theme.of(context);
    final dark = isDark(context);
    final required = goal.requiredThisCycle(today, payCycleDays);
    final projection = widget.state.goalProjection(goal);
    final l = AppLocalizations.of(context);
    final cycles = goal.cyclesRemaining(today, payCycleDays);

    return UpinoCard(
      key: Key('goal-card-${goal.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(goal.name, style: theme.textTheme.titleLarge),
              ),
              GestureDetector(
                onTap: onEdit,
                child: const RowAffordance(icon: 'tune'),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            _GoalCard._status(AppLocalizations.of(context), goal, cycles),
            style: theme.textTheme.bodySmall,
          ),
          // Where it is heading at the pace the plan can actually hold for
          // it, which is not always the pace it asks for (§10).
          if (goal.kind != GoalKind.paused && !goal.isComplete) ...[
            const SizedBox(height: 4),
            Text(
              goalOutlook(context, projection),
              key: Key('goal-outlook-${goal.id}'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: projection.onTrack
                    ? null
                    : (dark ? UpinoTokens.darkCritical : UpinoTokens.critical),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                goal.saved.display(),
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context).goalsOf(goal.target.display()),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ProgressBar(
            value: goal.progress,
            muted: goal.kind == GoalKind.paused,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Fact(
                  label: goal.kind == GoalKind.paused
                      ? AppLocalizations.of(context).goalKindPaused
                      : goal.isComplete
                          ? AppLocalizations.of(context).goalsDone
                          : AppLocalizations.of(context).goalsEachPeriod,
                  value: goal.kind == GoalKind.paused || goal.isComplete
                      ? '—'
                      : required.display(),
                ),
              ),
              Container(width: 1, height: 34, color: borderColor(context)),
              Expanded(
                child: _Fact(
                  label: AppLocalizations.of(context).goalsTargetDate,
                  value: formatDateShort(context, goal.targetDate),
                ),
              ),
            ],
          ),
          if (inflated != null && rate != null) ...[
            const SizedBox(height: 14),
            Container(
              key: Key('goal-inflated-${goal.id}'),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: sunkenColor(context),
                borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
              ),
              child: Text(
                AppLocalizations.of(context).goalsInflated(
                  formatRate(rate),
                  inflated.display(),
                ),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
          if (goal.kind != GoalKind.paused && !goal.isComplete) ...[
            const SizedBox(height: 8),
            TextButton(
              key: Key('goal-path-${goal.id}'),
              onPressed: () => setState(() => _open = !_open),
              child: Text(_open ? l.goalHidePath : l.goalShowPath),
            ),
            if (_open) ...[
              const SizedBox(height: 4),
              GoalProjectionView(state: widget.state, goal: goal),
            ],
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: Key('goal-add-${goal.id}'),
              onPressed: onContribute,
              style: FilledButton.styleFrom(
                backgroundColor: sunkenColor(context),
                foregroundColor: dark
                    ? UpinoTokens.darkTextPrimary
                    : UpinoTokens.textPrimary,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(AppLocalizations.of(context).goalsAddMoney),
            ),
          ),
        ],
      ),
    );
  }

}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.muted});

  final double value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final fill = muted
        ? (dark ? UpinoTokens.darkTextTertiary : UpinoTokens.textTertiary)
        : (dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary);
    return ClipRRect(
      borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 9,
        backgroundColor: sunkenColor(context),
        valueColor: AlwaysStoppedAnimation<Color>(fill),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 17,
            fontFeatures: moneyFeatures,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12)),
      ],
    );
  }
}

/// The yearly inflation the person expects. Theirs to set: the app has no
/// network to fetch a figure, and an official one is often not the one a
/// household actually meets at the till.
class _InflationRow extends StatelessWidget {
  const _InflationRow({required this.state});

  final AppState state;

  Future<void> _edit(BuildContext context) async {
    final answer = await showDialog<String>(
      context: context,
      builder: (_) => _InflationDialog(current: state.inflationBasisPoints),
    );
    if (answer == null) return;
    if (answer.trim().isEmpty) {
      state.setInflation(null);
      return;
    }
    final rate = parseRate(answer);
    if (rate != null) state.setInflation(rate);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rate = state.inflationBasisPoints;
    return ActionRow(
      key: const Key('goals-inflation'),
      title: l.inflationTitle,
      subtitle: rate == null ? l.inflationNotSet : l.inflationRate(formatRate(rate)),
      trailing: const RowAffordance(icon: 'trendingUp'),
      onTap: () => _edit(context),
    );
  }
}

class _InflationDialog extends StatefulWidget {
  const _InflationDialog({required this.current});

  final int? current;

  @override
  State<_InflationDialog> createState() => _InflationDialogState();
}

class _InflationDialogState extends State<_InflationDialog> {
  late final _controller = TextEditingController(
    text: widget.current == null ? '' : formatRate(widget.current!),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: cardColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
      ),
      title: Text(l.inflationDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.inflationDialogBlurb,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextField(
            key: const Key('inflation-field'),
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(suffixText: '%'),
            onSubmitted: (v) => Navigator.of(context).pop(v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        TextButton(
          key: const Key('inflation-save'),
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l.save),
        ),
      ],
    );
  }
}
