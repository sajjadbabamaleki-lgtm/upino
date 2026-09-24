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
import '../widgets/charts.dart';
import '../widgets/goal_projection_view.dart';
import '../widgets/goals_orbit.dart';
import 'demo_screen.dart';
import '../design/icon.dart';
import '../state/projection.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  /// Off in tests that look at the person's own goals.
  @visibleForTesting
  static bool samplesWhenFew = true;

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  /// Sample goals, built on first use: a copy that is not the person's
  /// plan and is never saved.
  AppState? _sample;

  /// Set once the person makes a goal of their own here; until then the
  /// page shows the samples while there are fewer than four of their own,
  /// so the rings can be seen whole.
  bool? _sampleChosen;

  bool get _showingSample =>
      _sampleChosen ??
      (GoalsScreen.samplesWhenFew && widget.state.goals.length < 4);

  /// The plan on show: the samples or the person's own.
  AppState get state => _showingSample
      ? (_sample ??= sampleState(context, widget.state))
      : widget.state;
  EdgeInsets get padding => widget.padding;

  /// A key for each goal's card, kept across builds so the rings and tiles
  /// can scroll to it.
  final _cardKeys = <String, GlobalKey>{};

  Future<void> _create(BuildContext context) async {
    // A new goal is always the person's own, so their goals come back.
    final mine = widget.state;
    final draft = await GoalEditorSheet.show(context, state: mine);
    if (draft == null) return;
    if (mounted) setState(() => _sampleChosen = false);
    mine.addGoal(
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

  /// All goals together: what is saved against what was set, goals that
  /// are paused left out.
  static double _overall(List<Goal> goals) {
    var saved = 0, target = 0;
    for (final g in goals) {
      if (g.kind == GoalKind.paused) continue;
      saved += g.saved.minor > g.target.minor ? g.target.minor : g.saved.minor;
      target += g.target.minor;
    }
    return target == 0 ? 0 : saved / target;
  }

  /// The goal's own card further down, found by its key.
  GlobalKey _cardKey(String id) =>
      _cardKeys.putIfAbsent(id, () => GlobalKey(debugLabel: 'goal-$id'));

  /// Scroll down to the goal's card, which holds the whole of it.
  Future<void> _open(BuildContext context, Goal goal) async {
    final target = _cardKeys[goal.id]?.currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final sample = _showingSample;
    final shown = state;

    return AnimatedBuilder(
      animation: Listenable.merge([widget.state, shown]),
      builder: (context, _) {
        final goals = shown.goals;
        return ListView(
          padding: padding,
          children: revealed([
            // The page's name is in the capsule above, and the rings say
            // the rest; a line under the name would only repeat them.
            if (goals.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 14),
                child: Text(
                  l.goalsBlurbEmpty,
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
            else ...[
              // All the goals at once: rings round how far along they are
              // together, on the page itself rather than in a card.
              GoalsOrbit(
                // A new welcome when the page switches between samples and
                // the person's own.
                key: ValueKey(sample),
                goals: [
                  for (var i = 0; i < goals.length && i < 4; i++)
                    (goal: goals[i], color: i),
                ],
                overall: _overall(goals),
                onOpen: (g) => _open(context, g),
              ),
              const SizedBox(height: 10),
              _Summary(state: state),
              const SizedBox(height: 10),
              // A tile for each goal, two to a row, in the colour it has on
              // the rings; the whole goal opens from it.
              for (var i = 0; i < goals.length; i += 2) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _GoalTile(
                        state: state,
                        goal: goals[i],
                        color: goalColor(i),
                        onTap: () => _open(context, goals[i]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: i + 1 < goals.length
                          ? _GoalTile(
                              state: state,
                              goal: goals[i + 1],
                              color: goalColor(i + 1),
                              onTap: () => _open(context, goals[i + 1]),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ],
            // The one action this tab has, where the eye lands after the
            // overview. A floating button would sit on top of the nav bar.
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const Key('goals-new'),
                onPressed: () => _create(context),
                icon: const Icon(Icons.add_rounded),
                label: Text(l.goalsNew),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
              ),
            ),
            // Further down, each goal again, larger and whole: where it is
            // heading, its path, adding money. The rings and tiles above
            // scroll here.
            if (goals.isNotEmpty) ...[
              const SizedBox(height: 20),
              SectionHeading(l.goalsDetailTitle, count: goals.length),
              for (var i = 0; i < goals.length; i++) ...[
                _GoalCard(
                  key: _cardKey(goals[i].id),
                  state: state,
                  goal: goals[i],
                  color: goalColor(i),
                  inflated: state.inflatedTarget(goals[i]),
                  rate: state.inflationBasisPoints,
                  today: state.today,
                  payCycleDays: state.payCycleDays,
                  onEdit: () => _edit(context, goals[i]),
                  onContribute: () => _contribute(context, goals[i]),
                ),
                const SizedBox(height: 12),
              ],
              _InflationRow(state: state),
            ],
          ]),
        );
      },
    );
  }
}

class _GoalCard extends StatefulWidget {
  const _GoalCard({
    super.key,
    this.color,
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

  /// Its colour on the rings above; the app's blue when shown alone.
  final Color? color;

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
          const SizedBox(height: 14),
          // How far along, as a half ring of segments with the amount in the
          // middle, and where it is heading in a pill under it (§10): at the
          // pace the plan can actually hold, not the pace it asks for.
          Center(
            child: SegmentGauge(
              key: Key('goal-gauge-${goal.id}'),
              value: goal.progress,
              size: 230,
              color: goal.kind == GoalKind.paused
                  ? (dark
                      ? UpinoTokens.darkTextTertiary
                      : UpinoTokens.textTertiary)
                  : widget.color ??
                      (dark
                          ? UpinoTokens.darkActionPrimary
                          : UpinoTokens.actionPrimary),
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    goal.saved.display(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFeatures: moneyFeatures,
                    ),
                  ),
                  Text(
                    l.goalsOf(goal.target.display()),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          if (goal.kind != GoalKind.paused && !goal.isComplete) ...[
            const SizedBox(height: 12),
            Center(
              child: Container(
                key: Key('goal-outlook-${goal.id}'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                  border: Border.all(color: borderColor(context)),
                ),
                child: Text(
                  goalOutlook(context, projection),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: projection.onTrack
                        ? null
                        : (dark
                            ? UpinoTokens.darkCritical
                            : UpinoTokens.critical),
                  ),
                ),
              ),
            ),
          ],
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
      subtitle:
          rate == null ? l.inflationNotSet : l.inflationRate(formatRate(rate)),
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

/// How the goals are doing together: what went in this month, how many are
/// on track, and which comes next.
class _Summary extends StatelessWidget {
  const _Summary({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final green = dark ? const Color(0xFF4ADE80) : const Color(0xFF1E9E4A);
    final open = state.goals
        .where((g) => g.kind != GoalKind.paused && !g.isComplete)
        .toList();
    final onTrack = open.where((g) => state.goalProjection(g).onTrack).length;
    final next = ([...open]
          ..sort((a, b) => a.targetDate.compareTo(b.targetDate)))
        .firstOrNull;
    final month = state.toGoalsWithin();
    final added = month.minor > 0;

    return UpinoCard(
      key: const Key('goals-summary'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: (added ? green : borderColor(context))
                    .withValues(alpha: 0.35),
                width: 3,
              ),
            ),
            child: UpinoIcon(
              'trendingUp',
              size: 18,
              color: added ? green : UpinoTokens.textTertiary,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                border: Border.all(
                  color: (added ? green : borderColor(context))
                      .withValues(alpha: 0.35),
                ),
              ),
              // Shrunk to fit rather than cut off: the amount is the point.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  added
                      ? l.goalsThisMonth(month.display())
                      : l.goalsNothingThisMonth,
                  maxLines: 1,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: added ? green : null,
                    fontWeight: FontWeight.w600,
                    fontFeatures: moneyFeatures,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  onTrack == open.length
                      ? l.goalsAllOnTrack
                      : l.goalsOnTrackCount(onTrack, open.length),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleMedium,
                ),
                if (next != null)
                  Text(
                    l.goalsNextUp(
                      next.name,
                      formatDateShort(context, next.targetDate),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
    required this.state,
    required this.goal,
    required this.color,
    required this.onTap,
  });

  final AppState state;
  final Goal goal;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final green = dark ? const Color(0xFF4ADE80) : const Color(0xFF1E9E4A);
    final added = state.toGoalsWithin(goalId: goal.id);
    return GestureDetector(
      key: Key('goal-tile-${goal.id}'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: UpinoCard(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (added.minor > 0) ...[
                  Icon(Icons.arrow_drop_up_rounded, size: 18, color: green),
                  Text(
                    added.display(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: green,
                      fontWeight: FontWeight.w600,
                      fontFeatures: moneyFeatures,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${goalPercent(goal)}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontFeatures: moneyFeatures,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  '/ 100%',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              AppLocalizations.of(context).goalsOf(goal.target.display()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.5),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
              child: LinearProgressIndicator(
                value: goal.progress,
                minHeight: 8,
                backgroundColor: sunkenColor(context),
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal.kind == GoalKind.paused
                      ? UpinoTokens.textTertiary
                      : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
