/// Profile — settings, and the honest state of the data behind the figure.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../engine/plan.dart';
import '../state/app_state.dart';
import '../widgets/amount_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  Future<void> _confirmBalance(BuildContext context) async {
    final observed = await AmountSheet.show(
      context,
      currency: state.currency,
      title: 'What is your balance now?',
      explanation:
          'Any difference is recorded as a correction, never as spending.',
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
        title: const Text('Start over?'),
        content: const Text(
          'Your plan and everything you recorded are deleted. This cannot be '
          'undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep my plan'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Delete everything',
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
    final snapshot = state.snapshot;
    final age = snapshot.balanceAgeInDays;

    return ListView(
      padding: padding,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          child: Text('Profile', style: theme.textTheme.headlineLarge),
        ),

        const SectionHeading('Your data'),
        ActionRow(
          key: const Key('profile-confirm-balance'),
          title: 'Confirm your balance',
          subtitle: switch (age) {
            null => 'Not confirmed yet',
            0 => 'Confirmed today',
            1 => 'Confirmed yesterday',
            _ => 'Confirmed $age days ago',
          },
          onTap: () => _confirmBalance(context),
        ),
        const SizedBox(height: 10),
        UpinoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('How trustworthy is the figure?',
                  style: theme.textTheme.titleMedium,),
              const SizedBox(height: 4),
              Text(
                switch (snapshot.confidenceState) {
                  ConfidenceState.trusted =>
                    'Up to date. Nothing needs your attention.',
                  ConfidenceState.degraded =>
                    'Your balance has not been confirmed for a while. The '
                        'figure is still shown, just less certain.',
                  ConfidenceState.reviewRequired =>
                    'Too old or too uncertain to rely on. Confirm your '
                        'balance to fix it.',
                },
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const SizedBox(height: 26),
        const SectionHeading('Start again'),
        ActionRow(
          key: const Key('profile-start-over'),
          title: 'Delete my plan',
          subtitle: 'Clears everything and returns to setup',
          titleColor:
              isDark(context) ? UpinoTokens.darkCritical : UpinoTokens.critical,
          onTap: () => _startOver(context),
        ),
      ],
    );
  }
}
