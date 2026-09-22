/// Creating and changing a goal: a name, a target, a date and which kind it
/// is (§10).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../domain/goal.dart';
import '../engine/clock.dart';
import '../engine/money.dart';
import '../state/app_state.dart';

class GoalDraft {
  const GoalDraft({
    required this.name,
    required this.target,
    required this.targetDate,
    required this.kind,
    this.deleted = false,
  });

  final String name;
  final Money target;
  final LocalDate targetDate;
  final GoalKind kind;
  final bool deleted;
}

class GoalEditorSheet extends StatefulWidget {
  const GoalEditorSheet({required this.state, this.goal, super.key});

  final AppState state;
  final Goal? goal;

  static Future<GoalDraft?> show(
    BuildContext context, {
    required AppState state,
    Goal? goal,
  }) =>
      showModalBottomSheet<GoalDraft>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => GoalEditorSheet(state: state, goal: goal),
      );

  @override
  State<GoalEditorSheet> createState() => _GoalEditorSheetState();
}

class _GoalEditorSheetState extends State<GoalEditorSheet> {
  late final TextEditingController _name;
  late final TextEditingController _target;
  late GoalKind _kind;
  late int _months;

  /// Offered horizons, in months. A date picker is more precision than a
  /// savings target usually deserves, and it is one more thing to get wrong.
  static const _horizons = [3, 6, 12, 24];

  @override
  void initState() {
    super.initState();
    final goal = widget.goal;
    _name = TextEditingController(text: goal?.name ?? '');
    _target = TextEditingController(
      text: goal == null
          ? ''
          : goal.target.display(withSymbol: false, grouped: false),
    );
    _kind = goal?.kind ?? GoalKind.hard;
    _months = goal == null
        ? 12
        : _closestHorizon(goal.targetDate.differenceInDays(widget.state.today));
  }

  static int _closestHorizon(int days) {
    final months = (days / 30).round();
    return _horizons.reduce(
      (a, b) => (a - months).abs() <= (b - months).abs() ? a : b,
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  Money? get _parsedTarget {
    final text = _target.text.trim();
    if (text.isEmpty) return null;
    try {
      final money = Money.parse(text, widget.state.currency);
      return money.minor > 0 ? money : null;
    } on ArgumentError {
      return null;
    }
  }

  bool get _canSave =>
      _name.text.trim().isNotEmpty && _parsedTarget != null;

  void _save() {
    final target = _parsedTarget;
    if (target == null) return;
    Navigator.of(context).pop(GoalDraft(
      name: _name.text.trim(),
      target: target,
      targetDate: widget.state.today.addDays(_months * 30),
      kind: _kind,
    ),);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.goal != null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: borderColor(context),
                      borderRadius:
                          BorderRadius.circular(UpinoTokens.radiusPill),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  editing ? 'Edit goal' : 'What are you saving for?',
                  style: theme.textTheme.headlineMedium,
                ),

                const SizedBox(height: 18),
                _Label('Name'),
                _Sunken(
                  child: TextField(
                    key: const Key('goal-name'),
                    controller: _name,
                    onChanged: (_) => setState(() {}),
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
                    decoration: _plain(theme, 'A trip, a deposit, a laptop'),
                  ),
                ),

                const SizedBox(height: 16),
                _Label('How much in total'),
                _Sunken(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        Currency.of(widget.state.currency).symbol,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(color: UpinoTokens.textTertiary),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          key: const Key('goal-target'),
                          controller: _target,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          ],
                          onChanged: (_) => setState(() {}),
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontFeatures: moneyFeatures),
                          decoration: _plain(theme, 'Tap to type'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _Label('By when'),
                Row(
                  children: [
                    for (final months in _horizons)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: months == _horizons.last ? 0 : 8,
                          ),
                          child: _Pill(
                            key: Key('goal-horizon-$months'),
                            label: months == 12
                                ? '1 year'
                                : months == 24
                                    ? '2 years'
                                    : '$months mo',
                            selected: _months == months,
                            onTap: () => setState(() => _months = months),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                _Label('How firm is it?'),
                for (final kind in GoalKind.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _KindRow(
                      key: Key('goal-kind-${kind.name}'),
                      kind: kind,
                      selected: _kind == kind,
                      onTap: () => setState(() => _kind = kind),
                    ),
                  ),

                const SizedBox(height: 14),
                FilledButton(
                  onPressed: _canSave ? _save : null,
                  child: Text(editing ? 'Save changes' : 'Add this goal'),
                ),
                if (editing) ...[
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      key: const Key('goal-delete'),
                      onPressed: () => Navigator.of(context).pop(
                        GoalDraft(
                          name: widget.goal!.name,
                          target: widget.goal!.target,
                          targetDate: widget.goal!.targetDate,
                          kind: widget.goal!.kind,
                          deleted: true,
                        ),
                      ),
                      child: Text(
                        'Delete this goal',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark(context)
                              ? UpinoTokens.darkCritical
                              : UpinoTokens.critical,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _plain(ThemeData theme, String hint) => InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium
            ?.copyWith(color: UpinoTokens.textTertiary),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      );
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );
}

class _Sunken extends StatelessWidget {
  const _Sunken({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
        ),
        child: child,
      );
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final active =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? active : sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : (dark
                    ? UpinoTokens.darkTextSecondary
                    : UpinoTokens.textSecondary),
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}

class _KindRow extends StatelessWidget {
  const _KindRow({
    required this.kind,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final GoalKind kind;
  final bool selected;
  final VoidCallback onTap;

  static const _copy = <GoalKind, ({String title, String detail})>{
    GoalKind.hard: (
      title: 'Committed',
      detail: 'Held back before anything is spendable',
    ),
    GoalKind.flexible: (
      title: 'Flexible',
      detail: 'Gives way to anything you must pay',
    ),
    GoalKind.paused: (
      title: 'Paused',
      detail: 'Stays visible, nothing held back',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final active =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    final copy = _copy[kind]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
          border: Border.all(
            color: selected ? active : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 20,
              color: selected ? active : UpinoTokens.textTertiary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(copy.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(copy.detail, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
