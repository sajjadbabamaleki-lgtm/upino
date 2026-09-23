/// Onboarding, §18 steps 1 and 2.
///
/// §18 requires a first plan in under five minutes, so every field past the
/// first two is optional and the payoff — the first Safe-to-Spend — arrives
/// immediately on finishing.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/parts.dart';
import '../design/icon.dart';
import '../design/tokens.dart';
import '../engine/currencies.dart';
import '../engine/money.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'currency_screen.dart';
import 'language_screen.dart';
import '../widgets/upino_sheet.dart';

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
  final _incomeUpper = TextEditingController();
  final _rent = TextEditingController();
  final _essentials = TextEditingController();
  final _goal = TextEditingController();

  int _payDayOffset = 30;
  bool _showOptional = false;

  /// Null until the user picks one. Two things hang on it: nothing on the
  /// currency list looks already chosen on the way in, and the amount fields
  /// stay off the screen until there is a currency to store them in. Every
  /// amount is held in minor units of the chosen currency, and currencies
  /// disagree about how many minor units there are — a rial has none, a
  /// dinar has three — so a number typed before the choice would have to be
  /// reinterpreted afterwards.
  String? _currency;

  @override
  void dispose() {
    for (final c in [
      _balance,
      _income,
      _incomeUpper,
      _rent,
      _essentials,
      _goal,
    ]) {
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
      ..incomeUpperAmount = _read(_incomeUpper)
      ..nextIncomeDate = widget.state.today.addDays(_payDayOffset)
      ..rent = _read(_rent)
      ..essentials = _read(_essentials)
      ..goalAmount = _read(_goal);
    widget.state.completeOnboarding(_draft);
  }

  Future<void> _openLanguage() => UpinoSheet.show<void>(
        context,
        builder: (sheetContext) => UpinoSheet(
          onClose: () => Navigator.of(sheetContext).pop(),
          child: LanguagePicker(
            selected: widget.state.languageCode,
            onSelect: (code) {
              widget.state.setLanguageCode(code);
              Navigator.of(sheetContext).pop();
            },
          ),
        ),
      );

  Future<void> _openCurrency() => UpinoSheet.show<void>(
        context,
        builder: (sheetContext) => UpinoSheet(
          onClose: () => Navigator.of(sheetContext).pop(),
          child: CurrencyPicker(
            selected: _currency,
            onSelect: (code) {
              Navigator.of(sheetContext).pop();
              _chooseCurrency(code);
            },
          ),
        ),
      );

  void _chooseCurrency(String code) {
    // The search keyboard would otherwise still be up over the form the
    // sheet has just uncovered.
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      final changed = code != _currency;
      _currency = code;
      _draft.currency = code;
      if (changed) {
        // Amounts typed under the old currency would be reinterpreted at a
        // different scale, so they are cleared rather than silently rescaled.
        for (final c in [
          _balance,
          _income,
          _incomeUpper,
          _rent,
          _essentials,
          _goal,
        ]) {
          c.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final chosen = _currency;
    final info = chosen == null
        ? null
        : currencyCatalogue.firstWhere((c) => c.code == chosen);
    final language = widget.state.languageCode;
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
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: UpinoBadge(l.onboardingBadge),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.onboardingTitle, style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 6),
                  Text(
                    l.onboardingBlurb,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ActionRow(
              key: const Key('change-language'),
              title: l.profileLanguage,
              subtitle: language == null
                  ? l.languagePhone
                  : languageNames[language]!.native,
              onTap: _openLanguage,
            ),
            const SizedBox(height: 10),
            // Before a choice is made the row carries the question itself,
            // because it is the only thing on the screen left to do.
            ActionRow(
              key: const Key('change-currency'),
              leading:
                  info == null ? null : CountryFlag(info.flagCountry, size: 22),
              title: info?.country ?? l.currencyTitle,
              subtitle: info == null
                  ? l.currencyBlurb
                  : '${info.name} · ${info.code}',
              trailing:
                  RowAffordance(icon: info == null ? 'chevronRight' : 'swap'),
              onTap: _openCurrency,
            ),

            if (info != null) ...[
              const SizedBox(height: 18),

              _Field(
                key: const Key('field-balance'),
                controller: _balance,
                label: l.onboardingBalanceLabel,
                hint: l.onboardingBalanceHint,
                currency: _draft.currency,
                onChanged: () => setState(() {}),
              ),
              // Income is a range because for most people it is one. Forcing a
              // single number would make the plan look precise and be wrong in
              // every month that came in under it.
              _RangeField(
                label: l.onboardingIncomeLabel,
                hint: l.onboardingIncomeHint,
                currency: _draft.currency,
                lowKey: const Key('field-income'),
                highKey: const Key('field-income-upper'),
                low: _income,
                high: _incomeUpper,
                lowLabel: l.onboardingIncomeFrom,
                highLabel: l.onboardingIncomeTo,
                highHint: l.onboardingIncomeToOptional,
                onChanged: () => setState(() {}),
              ),
              _PayDayField(
                days: _payDayOffset,
                onChanged: (v) => setState(() => _payDayOffset = v),
              ),

              const SizedBox(height: 6),
              ActionRow(
                title: l.onboardingCommitments,
                subtitle: _showOptional
                    ? l.onboardingCommitmentsOpen
                    : l.onboardingCommitmentsShut,
                trailing: RowAffordance(
                  icon: _showOptional ? 'chevronUp' : 'chevronDown',
                ),
                onTap: () => setState(() => _showOptional = !_showOptional),
              ),

              if (_showOptional) ...[
                const SizedBox(height: 20),
                _Field(
                  key: const Key('field-rent'),
                  controller: _rent,
                  label: l.onboardingRentLabel,
                  hint: l.onboardingRentHint,
                  currency: _draft.currency,
                  onChanged: () => setState(() {}),
                ),
                _Field(
                  key: const Key('field-essentials'),
                  controller: _essentials,
                  label: l.onboardingEssentialsLabel,
                  hint: l.onboardingEssentialsHint,
                  currency: _draft.currency,
                  onChanged: () => setState(() {}),
                ),
                _Field(
                  key: const Key('field-goal'),
                  controller: _goal,
                  label: l.onboardingGoalLabel,
                  hint: l.onboardingGoalHint,
                  currency: _draft.currency,
                  onChanged: () => setState(() {}),
                ),
              ],

              const SizedBox(height: 22),
              FilledButton(
                onPressed: _canFinish ? _finish : null,
                child: Text(l.onboardingFinish),
              ),
              if (!_canFinish) ...[
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    l.onboardingIncomplete,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// Two amounts on one card: the floor the plan is built on, and an optional
/// ceiling that is shown but never calculated with (INV-20). Leaving the
/// second empty is a fixed income, which is why it is not marked required.
class _RangeField extends StatelessWidget {
  const _RangeField({
    required this.label,
    required this.hint,
    required this.currency,
    required this.low,
    required this.high,
    required this.lowLabel,
    required this.highLabel,
    required this.highHint,
    required this.lowKey,
    required this.highKey,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final String currency;
  final TextEditingController low;
  final TextEditingController high;
  final String lowLabel;
  final String highLabel;
  final String highHint;
  final Key lowKey;
  final Key highKey;
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
            Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _RangeEnd(
                    fieldKey: lowKey,
                    caption: lowLabel,
                    controller: low,
                    currency: currency,
                    hintText: null,
                    onChanged: onChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _RangeEnd(
                    fieldKey: highKey,
                    caption: highLabel,
                    controller: high,
                    currency: currency,
                    hintText: highHint,
                    onChanged: onChanged,
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

class _RangeEnd extends StatelessWidget {
  const _RangeEnd({
    required this.fieldKey,
    required this.caption,
    required this.controller,
    required this.currency,
    required this.hintText,
    required this.onChanged,
  });

  final Key fieldKey;
  final String caption;
  final TextEditingController controller;
  final String currency;
  final String? hintText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decimals = Currency.of(currency).exponent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: sunkenColor(context),
            borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                Currency.of(currency).symbol,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: UpinoTokens.textTertiary),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  key: fieldKey,
                  controller: controller,
                  keyboardType:
                      TextInputType.numberWithOptions(decimal: decimals > 0),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      decimals > 0 ? RegExp(r'[0-9.]') : RegExp(r'[0-9]'),
                    ),
                  ],
                  onChanged: (_) => onChanged(),
                  style: theme.textTheme.titleLarge,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: theme.textTheme.bodySmall
                        ?.copyWith(color: UpinoTokens.textTertiary),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
            Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: sunkenColor(context),
                borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
              ),
              child: Row(
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
                      // A currency with no minor unit — the rial, the yen —
                      // rejects a decimal point on parse, so the keyboard does
                      // not offer one and the formatter does not accept one.
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: Currency.of(currency).exponent > 0,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          Currency.of(currency).exponent > 0
                              ? RegExp(r'[0-9.]')
                              : RegExp(r'[0-9]'),
                        ),
                      ],
                      onChanged: (_) => onChanged(),
                      style: theme.textTheme.headlineSmall,
                      decoration: InputDecoration(
                        // "0.00" read as a filled value on a real phone, so
                        // the placeholder now says what to do instead.
                        hintText: AppLocalizations.of(context).tapToType,
                        hintStyle: theme.textTheme.bodyMedium
                            ?.copyWith(color: UpinoTokens.textTertiary),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
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
            Text(
              AppLocalizations.of(context).onboardingPayDay,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                for (final d in [7, 14, 30])
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: d == 30 ? 0 : 8),
                      child: _DayChip(
                        label: AppLocalizations.of(context).onboardingDays(d),
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
    final active =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
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
