/// What the bell opens: the things in the plan that need the person, each
/// with the one step that deals with it.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import 'upino_sheet.dart';

class AlertsSheet extends StatelessWidget {
  const AlertsSheet({
    required this.state,
    required this.onAct,
    super.key,
  });

  final AppState state;

  /// Called with the alert tapped, after the sheet has closed.
  final ValueChanged<PlanAlert> onAct;

  static Future<void> show(
    BuildContext context, {
    required AppState state,
    required ValueChanged<PlanAlert> onAct,
  }) async {
    final chosen = await UpinoSheet.show<PlanAlert>(
      context,
      builder: (sheetContext) => UpinoSheet(
        height: 520,
        onClose: () => Navigator.of(sheetContext).pop(),
        child: AlertsSheet(
          state: state,
          onAct: (a) => Navigator.of(sheetContext).pop(a),
        ),
      ),
    );
    if (chosen != null) onAct(chosen);
  }

  static ({String title, String detail}) describe(
    BuildContext context,
    PlanAlert alert,
  ) {
    final l = AppLocalizations.of(context);
    return switch (alert) {
      UnfundedAlert(:final claimId, :final label, :final short) => (
          title: l.alertUnfunded(
            labelForClaim(l, claimId, label),
            short.display(),
          ),
          detail: l.alertUnfundedDetail,
        ),
      BalanceStaleAlert(:final days) => (
          title: l.profileConfirmBalance,
          detail: days == null
              ? l.profileConfirmedNever
              : l.profileConfirmedDays(days),
        ),
      IncomeLateAlert(:final expectedOn) => (
          title: l.alertIncomeLate(formatDate(context, expectedOn)),
          detail: l.alertIncomeLateDetail,
        ),
      GoalBehindAlert(:final name, :final short) => (
          title: l.alertGoalBehind(name, short.display()),
          detail: l.alertGoalBehindDetail,
        ),
      BankMessagesAlert(:final count) => (
          title: l.smsWaiting(count),
          detail: l.smsWaitingSub,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final alerts = state.alerts;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        UpinoTokens.gutter,
        4,
        UpinoTokens.gutter,
        28,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
          child: Text(l.alertsTitle, style: theme.textTheme.headlineLarge),
        ),
        if (alerts.isEmpty)
          UpinoCard(
            key: const Key('alerts-empty'),
            child: Text(l.alertsEmpty, style: theme.textTheme.bodySmall),
          )
        else
          for (var i = 0; i < alerts.length; i++) ...[
            Builder(
              builder: (context) {
                final copy = describe(context, alerts[i]);
                final urgent = alerts[i] is UnfundedAlert;
                return ActionRow(
                  key: Key('alert-$i'),
                  title: copy.title,
                  subtitle: copy.detail,
                  titleColor: urgent
                      ? (isDark(context)
                          ? UpinoTokens.darkCritical
                          : UpinoTokens.critical)
                      : null,
                  onTap: () => onAct(alerts[i]),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}
