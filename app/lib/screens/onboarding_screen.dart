/// Onboarding, §18 steps 1 and 2.
///
/// §18 requires a first plan in under five minutes, so every field past the
/// first two is optional and the payoff — the first Safe-to-Spend — arrives
/// immediately on finishing.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/theme.dart';
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
            24,
            UpinoTokens.gutter,
            32,
          ),
          children: [
            Text('Set up your plan', style: theme.textTheme.displayLarge
                ?.copyWith(fontSize: 34, letterSpacing: -1),),
            const SizedBox(height: 8),
            Text(
              'Two answers are enough to start. Everything else can wait.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: UpinoTokens.textSecondary),
            ),
            const SizedBox(height: 28),
            _Field(
              key: const Key('field-balance'),
              controller: _balance,
              label: 'How much do you have right now?',
              hint: 'Across the accounts you spend from',
              currency: _draft.currency,
              required: true,
              onChanged: () => setState(() {}),
            ),
            _Field(
              key: const Key('field-income'),
              controller: _income,
              label: 'How much is your next pay?',
              hint: 'Your usual amount is fine',
              currency: _draft.currency,
              required: true,
              onChanged: () => setState(() {}),
            ),
            _PayDayField(
              days: _payDayOffset,
              onChanged: (v) => setState(() => _payDayOffset = v),
            ),
            const SizedBox(height: 8),
            Text('Optional', style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
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
            const SizedBox(height: 12),
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
    this.required = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String currency;
  final VoidCallback onChanged;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(hint, style: theme.textTheme.bodySmall),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: (_) => onChanged(),
            style: theme.textTheme.titleMedium
                ?.copyWith(fontSize: 20, fontFeatures: moneyFeatures),
            decoration: InputDecoration(
              prefixText: '${Currency.of(currency).symbol} ',
              hintText: '0.00',
              filled: true,
              fillColor:
                  dark ? UpinoTokens.darkSurfaceCard : UpinoTokens.surfaceCard,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('When is your next pay?', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [7, 14, 30]
                .map((d) => ChoiceChip(
                      label: Text('In $d days'),
                      selected: days == d,
                      onSelected: (_) => onChanged(d),
                    ),)
                .toList(),
          ),
        ],
      ),
    );
  }
}
