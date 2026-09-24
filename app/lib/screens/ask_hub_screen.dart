/// The Ask tab: a door to the conversation, the questions most people ask
/// with a glimpse of their answers, and the conversations already had.
///
/// The chat itself opens on its own page. A tab that is only a text box
/// asks the person to know what to type; this one shows what can be asked,
/// and answers the common questions before they are asked.
library;

import 'package:flutter/material.dart';

import '../design/motion.dart';
import '../design/parts.dart';
import '../design/tokens.dart';
import '../domain/conversation.dart';
import '../engine/clock.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../state/app_state.dart';
import '../state/ask_answers.dart';
import '../widgets/amount_sheet.dart' show categoryLabel;
import '../widgets/top_bar.dart' show UpinoMark;
import 'ask_chat_screen.dart';

class AskHubScreen extends StatelessWidget {
  const AskHubScreen({required this.state, required this.padding, super.key});

  final AppState state;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final conversations = state.conversations
        .where((c) => c.turns.isNotEmpty)
        .toList();
    final common = suggestedQuestions(l);

    return ListView(
      padding: padding,
      children: revealed([
        _AskHero(state: state),
        const SizedBox(height: 20),
        SectionHeading(l.askHubCommon),
        for (final (q, text) in common) ...[
          _CommonQuestion(
            key: Key('ask-common-${q.name}'),
            question: text,
            preview: answerPreview(context, answerSuggested(q, state)),
            onTap: () => ChatPage.open(context, state, firstQuestion: text),
          ),
          const SizedBox(height: 10),
        ],
        if (conversations.isNotEmpty) ...[
          const SizedBox(height: 10),
          SectionHeading(l.askHubHistory, count: conversations.length),
          for (final c in conversations) ...[
            _PastConversation(state: state, conversation: c),
            const SizedBox(height: 10),
          ],
        ],
      ]),
    );
  }
}

class _AskHero extends StatelessWidget {
  const _AskHero({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dark = isDark(context);
    final g = greet(state);
    return Container(
      key: const Key('ask-hero'),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusHero),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? const [UpinoTokens.darkGradientStart, UpinoTokens.darkGradientEnd]
              : const [UpinoTokens.gradientStart, UpinoTokens.gradientEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const UpinoMark(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.askHubTitle,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: UpinoTokens.textOnInverse),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            switch (g.acquaintance) {
              Acquaintance.newcomer => l.askHubNew,
              Acquaintance.learning => l.askHubLearning(g.daysToSeason),
              Acquaintance.familiar => l.askHubFamiliar,
            },
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: UpinoTokens.textOnInverse),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('ask-start'),
              onPressed: () => ChatPage.open(context, state),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: UpinoTokens.actionPrimary,
                minimumSize: const Size.fromHeight(52),
              ),
              child: Text(l.askHubStart),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommonQuestion extends StatelessWidget {
  const _CommonQuestion({
    required this.question,
    required this.preview,
    required this.onTap,
    super.key,
  });

  final String question;
  final String preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: UpinoCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  // Part of the real answer, worked out now, so the card
                  // already says something before it is opened.
                  Text(
                    preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const RowAffordance(icon: 'chat'),
          ],
        ),
      ),
    );
  }
}

class _PastConversation extends StatelessWidget {
  const _PastConversation({required this.state, required this.conversation});

  final AppState state;
  final Conversation conversation;

  Future<bool> _confirmDelete(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cardColor(dialogContext),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        ),
        title: Text(l.askHubDeleteTitle),
        content: Text(l.askHubDeleteBlurb),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.no),
          ),
          TextButton(
            key: const Key('ask-delete-yes'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l.yes,
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
    return yes ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = conversation;
    final started = LocalDate.at(c.startedAt, state.utcOffset);
    return Dismissible(
      key: Key('ask-past-${c.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) => state.deleteConversation(c.id),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: (isDark(context)
                  ? UpinoTokens.darkCritical
                  : UpinoTokens.critical)
              .withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        ),
        child: Text(l.askHubDeleteTitle),
      ),
      child: ActionRow(
        title: c.title ?? '',
        subtitle: '${formatDateShort(context, started)}'
            '${UpinoTokens.separator}${l.askHubTurns(c.turns.length)}',
        onTap: () => ChatPage.open(context, state, conversationId: c.id),
      ),
    );
  }
}

/// A line or two of an answer, as plain text, for the common questions.
String answerPreview(BuildContext context, AskAnswer answer) {
  final l = AppLocalizations.of(context);
  return switch (answer) {
    SafeToSpendAnswer(:final amount, :final until, :final perDay, :final days)
        when !amount.isZero =>
      [
        l.chatSafe(amount.display(), formatDate(context, until)),
        if (days > 1) l.chatSafePerDay(perDay.display(), days),
      ].join(' '),
    SafeToSpendAnswer(:final until) =>
      l.chatSafeNothing(formatDate(context, until)),
    NextPayAnswer(:final income) when income != null => l.chatPay(
        income.expectedAmount.display(),
        formatDate(context, income.expectedDate),
      ),
    NextPayAnswer() => l.chatPayNone,
    WhereItWentAnswer(:final rows, :final daysSeen) when rows.isEmpty =>
      daysSeen < 7 ? l.chatWhereTooSoon : l.chatWhereNone,
    WhereItWentAnswer(:final rows) => rows
        .take(3)
        .map((r) => '${categoryLabel(l, r.category)} ${r.total.display()}')
        .join(UpinoTokens.separator),
    SetAsideAnswer(:final total, :final claims) =>
      l.askHubAsidePreview(total.display(), claims.length),
    AdviceAnswer(:final acquaintance) when
        acquaintance == Acquaintance.newcomer =>
      l.chatAdviceTooSoon,
    AdviceAnswer(:final biggest, :final biggestTotal, :final tenPercent)
        when biggest != null =>
      l.chatAdviceBiggest(
        categoryLabel(l, biggest),
        biggestTotal!.display(),
        tenPercent!.display(),
      ),
    AdviceAnswer() => l.chatAdviceSort,
    _ => '',
  };
}
