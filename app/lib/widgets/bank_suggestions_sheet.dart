/// Spends the bank's messages describe, each waiting for a yes or a no.
///
/// Nothing a message says reaches the plan until the person taps Record: a
/// parser that misread a message must not be able to move the figure.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';

class BankSuggestionsSheet extends StatelessWidget {
  const BankSuggestionsSheet({required this.state, super.key});

  final AppState state;

  static Future<void> show(BuildContext context, AppState state) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BankSuggestionsSheet(state: state),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final suggestions = state.bankSuggestions;
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
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
                Text(l.smsReviewTitle, style: theme.textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(l.smsReviewBlurb, style: theme.textTheme.bodySmall),
                const SizedBox(height: 16),
                if (suggestions.isEmpty)
                  Text(l.smsReviewDone, style: theme.textTheme.bodyMedium)
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) => _SuggestionCard(
                        suggestion: suggestions[i],
                        onRecord: () =>
                            state.acceptSuggestion(suggestions[i].messageId),
                        onSkip: () =>
                            state.dismissSuggestion(suggestions[i].messageId),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.suggestion,
    required this.onRecord,
    required this.onSkip,
  });

  final BankSuggestion suggestion;
  final VoidCallback onRecord;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return UpinoCard(
      key: Key('sms-${suggestion.messageId}'),
      color: sunkenColor(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  suggestion.sender ?? '',
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                suggestion.amount.display(),
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontFeatures: moneyFeatures),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // The message itself, so the person can see what was read rather
          // than trust that it was read right.
          Text(
            suggestion.body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  key: Key('sms-record-${suggestion.messageId}'),
                  onPressed: onRecord,
                  child: Text(l.smsRecord),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                key: Key('sms-skip-${suggestion.messageId}'),
                onPressed: onSkip,
                child: Text(l.smsSkip),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
