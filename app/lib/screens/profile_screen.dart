/// Profile — settings, and the honest state of the data behind the figure.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
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
            color: selected
                ? Colors.white
                : (dark
                    ? UpinoTokens.darkTextSecondary
                    : UpinoTokens.textSecondary),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  Future<void> _confirmBalance(BuildContext context) async {
    final observed = await AmountSheet.show(
      context,
      currency: state.currency,
      title: AppLocalizations.of(context).askBalanceTitle,
      explanation: AppLocalizations.of(context).askBalanceBlurb,
      initial: state.snapshot.trustedAllocatableLiquidity,
    );
    if (observed != null) state.confirmBalance(observed);
  }

  Future<void> _startOver(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor(dialogContext),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        ),
        title: Text(AppLocalizations.of(dialogContext).profileStartOver),
        content: Text(
          AppLocalizations.of(dialogContext).profileStartOverBlurb,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(AppLocalizations.of(dialogContext).profileKeepPlan),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              AppLocalizations.of(dialogContext).profileDeleteEverything,
              style: TextStyle(
                color: isDark(dialogContext)
                    ? UpinoTokens.darkCritical
                    : UpinoTokens.critical,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await state.startOver();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final snapshot = state.snapshot;
    final age = snapshot.balanceAgeInDays;

    return ListView(
      padding: padding,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          child: Text(l.profileTitle, style: theme.textTheme.headlineLarge),
        ),

        SectionHeading(l.profileYourData),
        ActionRow(
          key: const Key('profile-confirm-balance'),
          title: l.profileConfirmBalance,
          subtitle: switch (age) {
            null => l.profileConfirmedNever,
            0 => l.profileConfirmedToday,
            1 => l.profileConfirmedYesterday,
            _ => l.profileConfirmedDays(age),
          },
          onTap: () => _confirmBalance(context),
        ),
        const SizedBox(height: 10),
        UpinoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.profileTrustTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                switch (snapshot.confidenceState) {
                  ConfidenceState.trusted => l.profileTrustFresh,
                  ConfidenceState.degraded => l.profileTrustDegraded,
                  ConfidenceState.reviewRequired => l.profileTrustReview,
                },
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const SizedBox(height: 26),
        SectionHeading(l.profileAppearance),
        UpinoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.profileTheme, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                l.profileThemeBlurb,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  for (final choice in ThemeChoice.values)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: choice == ThemeChoice.dark ? 0 : 8,
                        ),
                        child: _ThemeOption(
                          key: Key('theme-${choice.name}'),
                          label: switch (choice) {
                            ThemeChoice.system => l.themePhone,
                            ThemeChoice.light => l.themeLight,
                            ThemeChoice.dark => l.themeDark,
                          },
                          selected: state.themeChoice == choice,
                          onTap: () => state.setThemeChoice(choice),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _LanguageCard(state: state),

        const SizedBox(height: 26),
        SectionHeading(l.profileStartAgain),
        ActionRow(
          key: const Key('profile-start-over'),
          title: l.profileDelete,
          subtitle: l.profileDeleteSub,
          titleColor:
              isDark(context) ? UpinoTokens.darkCritical : UpinoTokens.critical,
          onTap: () => _startOver(context),
        ),
      ],
    );
  }
}

/// Language sits beside the theme, and for the same reason: it is a
/// preference, it is stored with the plan, and following the phone is the
/// default so nothing is imposed. Each language is named in itself, because
/// someone who cannot read the current one still has to find their own.
class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.state});

  final AppState state;

  static const _names = <String, String>{
    'en': 'English',
    'zh': '中文',
    'hi': 'हिन्दी',
    'es': 'Español',
    'fr': 'Français',
    'ar': 'العربية',
    'fa': 'فارسی',
    'pt': 'Português',
    'ru': 'Русский',
    'tr': 'Türkçe',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final codes = <String?>[null, ..._names.keys];

    return UpinoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.profileLanguage, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l.profileLanguageBlurb, style: theme.textTheme.bodySmall),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final code in codes)
                _ThemeOption(
                  key: Key('language-${code ?? 'system'}'),
                  label: code == null ? l.languagePhone : _names[code]!,
                  selected: state.languageCode == code,
                  onTap: () => state.setLanguageCode(code),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
