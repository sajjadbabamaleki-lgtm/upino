/// Profile — settings, and the honest state of the data behind the figure.
library;

import 'package:flutter/material.dart';

import '../design/icon.dart';
import '../design/motion.dart';
import '../design/parts.dart';
import '../design/tokens.dart';
import '../engine/currencies.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'backup_section.dart';
import 'faster_entry_section.dart';
import 'currency_screen.dart';
import 'language_screen.dart';
import '../widgets/amount_sheet.dart';
import '../widgets/upino_sheet.dart';

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
    if (observed != null) state.confirmBalance(observed.amount);
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
      children: revealed([
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          child: Text(l.profileTitle, style: theme.textTheme.headlineLarge),
        ),

        SectionHeading(l.profileYourData),
        _CurrencyRow(state: state),
        const SizedBox(height: 10),
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

        const SizedBox(height: 10),
        // §15.3 — a second trust card, because a confirmed balance is a fact
        // about liquidity and not a claim that the list explaining it is
        // complete. Conflating the two is what this exists to prevent.
        UpinoCard(
          key: const Key('profile-ledger'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.profileLedgerTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                switch (snapshot.ledgerCompleteness) {
                  LedgerCompleteness.complete => l.ledgerComplete,
                  LedgerCompleteness.partial => l.ledgerPartial,
                  LedgerCompleteness.unknown => l.ledgerUnknown,
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

        const SizedBox(height: 10),
        _LanguageRow(state: state),

        const SizedBox(height: 26),
        FasterEntrySection(state: state),

        const SizedBox(height: 26),
        BackupSection(state: state),

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
      ]),
    );
  }
}

/// Language sits beside the theme, and for the same reason: it is a
/// preference, it is stored with the plan, and following the phone is the
/// default so nothing is imposed.
///
/// The row opens the same picker onboarding opens, rather than a second
/// layout that would have to be kept in step with it.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.state});

  final AppState state;

  Future<void> _open(BuildContext context) async {
    await UpinoSheet.show<void>(
      context,
      builder: (sheetContext) => UpinoSheet(
        onClose: () => Navigator.of(sheetContext).pop(),
        child: LanguagePicker(
          selected: state.languageCode,
          onSelect: (code) {
            state.setLanguageCode(code);
            Navigator.of(sheetContext).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final code = state.languageCode;
    return ActionRow(
      key: const Key('profile-language'),
      title: l.profileLanguage,
      subtitle: code == null ? l.languagePhone : languageNames[code]!.native,
      trailing: const RowAffordance(icon: 'chevronRight'),
      onTap: () => _open(context),
    );
  }
}

/// The currency the plan is kept in. Onboarding asks it first; this is the
/// way back to it afterwards, through the same picker.
///
/// A change is confirmed before it happens, because it changes what every
/// figure in the plan means and there is no exchange rate behind it.
class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({required this.state});

  final AppState state;

  Future<void> _open(BuildContext context) async {
    final picked = await UpinoSheet.show<String>(
      context,
      builder: (sheetContext) => UpinoSheet(
        onClose: () => Navigator.of(sheetContext).pop(),
        child: CurrencyPicker(
          selected: state.currency,
          onSelect: (code) => Navigator.of(sheetContext).pop(code),
        ),
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
    if (picked == null || picked == state.currency || !context.mounted) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l = AppLocalizations.of(dialogContext);
        return AlertDialog(
          backgroundColor: cardColor(dialogContext),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
          ),
          title: Text(l.currencyChangeTitle(picked)),
          content: Text(l.currencyChangeBlurb(picked)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l.cancel),
            ),
            TextButton(
              key: const Key('currency-change-confirm'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l.currencyChangeConfirm),
            ),
          ],
        );
      },
    );
    if (confirmed ?? false) state.changeCurrency(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final info = currencyCatalogue
        .where((c) => c.code == state.currency)
        .firstOrNull;
    return ActionRow(
      key: const Key('profile-currency'),
      leading: info == null ? null : CountryFlag(info.flagCountry, size: 22),
      title: l.profileCurrency,
      subtitle: info == null ? state.currency : '${info.name} · ${info.code}',
      trailing: const RowAffordance(icon: 'chevronRight'),
      onTap: () => _open(context),
    );
  }
}
