/// Onboarding, §18 steps 1 and 2.
///
/// §18 requires a first plan in under five minutes, so every field past the
/// first two is optional and the payoff — the first Safe-to-Spend — arrives
/// immediately on finishing.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../state/app_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.state, super.key});

  final AppState state;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _draft = OnboardingDraft();
  final _balance = TextEditingController();
  final _income = TextEditingController();
  final _rent = TextEditingController();
  final _essentials = TextEditingController();
  final _goal = TextEditingController();

  int _payDayOffset = 30;
  bool _showOptional = false;

  @override
  void dispose() {
    for (final c in [_balance, _income, _rent, _essentials, _goal]) {
      c.dispose();
    }
    super.dispose();
  }

  Money? _read(TextEditingController c) {
    final text = c.text.trim();
    if (text.isEmpty) return null;
    try {
      return Money.parse(text, _draft.currency);
    } on ArgumentError {
      return null;
    }
  }

  bool get _canFinish => _read(_balance) != null && _read(_income) != null;

  void _finish() {
    _draft
      ..currentBalance = _read(_balance)
      ..incomeAmount = _read(_income)
      ..nextIncomeDate = widget.state.today.addDays(_payDayOffset)
      ..rent = _read(_rent)
      ..essentials = _read(_essentials)
      ..goalAmount = _read(_goal);
    widget.state.completeOnboarding(_draft);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            UpinoTokens.gutter,
            20,
            UpinoTokens.gutter,
            36,
          ),
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: UpinoBadge('Takes about a minute'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Set up your plan', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 6),
                  Text(
                    'Two answers are enough to start. Everything else can wait.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _Field(
              key: const Key('field-balance'),
              controller: _balance,
              label: 'How much do you have right now?',
              hint: 'Across the accounts you spend from',
              currency: _draft.currency,
              onChanged: () => setState(() {}),
            ),
            _Field(
              key: const Key('field-income'),
              controller: _income,
              label: 'How much is your next pay?',
              hint: 'Your usual amount is fine',
              currency: _draft.currency,
              onChanged: () => setState(() {}),
            ),
            _PayDayField(
              days: _payDayOffset,
              onChanged: (v) => setState(() => _payDayOffset = v),
            ),

            const SizedBox(height: 6),
            ActionRow(
              title: 'Add your commitments',
              subtitle: _showOptional
                  ? 'Rent, essentials and a goal'
                  : 'Optional, and you can do it later',
              trailing: RowAffordance(
                icon: _showOptional
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
              onTap: () => setState(() => _showOptional = !_showOptional),
            ),

            if (_showOptional) ...[
              const SizedBox(height: 20),
              _Field(
                key: const Key('field-rent'),
                controller: _rent,
                label: 'Rent and fixed bills',
                hint: 'Due before your next pay',
                currency: _draft.currency,
                onChanged: () => setState(() {}),
              ),
              _Field(
                key: const Key('field-essentials'),
                controller: _essentials,
                label: 'Food and transport',
                hint: 'What you need to get through the period',
                currency: _draft.currency,
                onChanged: () => setState(() {}),
              ),
              _Field(
                key: const Key('field-goal'),
                controller: _goal,
                label: 'Saving toward a goal',
                hint: 'What you want to put aside this period',
                currency: _draft.currency,
                onChanged: () => setState(() {}),
              ),
            ],

            const SizedBox(height: 22),
            FilledButton(
              onPressed: _canFinish ? _finish : null,
              child: const Text('See what I can spend'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.currency,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String currency;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: UpinoCard(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(hint, style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5)),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  Currency.of(currency).symbol,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(color: UpinoTokens.textTertiary),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => onChanged(),
                    style: theme.textTheme.headlineSmall,
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: theme.textTheme.headlineSmall
                          ?.copyWith(color: UpinoTokens.textTertiary),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PayDayField extends StatelessWidget {
  const _PayDayField({required this.days, required this.onChanged});

  final int days;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: UpinoCard(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('When is your next pay?', style: theme.textTheme.titleMedium),
            const SizedBox(height: 14),
            Row(
              children: [
                for (final d in [7, 14, 30])
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: d == 30 ? 0 : 8),
                      child: _DayChip(
                        label: '$d days',
                        selected: days == d,
                        onTap: () => onChanged(d),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final active = dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? active : sunkenColor(context),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : UpinoTokens.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
