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
import '../state/insights.dart';
import '../widgets/amount_sheet.dart' show categoryLabel;
import '../widgets/best_move_card.dart' show bestMoveLines;
import '../widgets/month_review.dart';
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
        // Past conversations come first, but only two rows of them: the
        // rest scroll inside their own box, so however many there are, the
        // common questions below stay where they are.
        if (conversations.isNotEmpty) ...[
          SectionHeading(l.askHubHistory, count: conversations.length),
          _ConversationShelf(state: state, conversations: conversations),
          const SizedBox(height: 20),
        ],
        SectionHeading(l.askHubCommon),
        // A question whose honest answer is "nothing to suggest" is left out.
        // One card, the questions split by hairlines. A question whose honest
        // answer is "nothing to suggest" is left out.
        RowGroup(rows: [
          for (final (q, text) in common)
            if (!(q == SuggestedQuestion.bestMove && state.bestMove == null))
              _CommonQuestion(
                key: Key('ask-common-${q.name}'),
                question: text,
                preview: answerPreview(context, answerSuggested(q, state)),
                onTap: () => ChatPage.open(context, state, firstQuestion: text),
              ),
        ],),
      ]),
    );
  }
}

/// Two conversations' height, scrolling within itself when there are more,
/// with the ones beyond fading out at the bottom edge so it is plain there
/// is more to scroll to.
class _ConversationShelf extends StatelessWidget {
  const _ConversationShelf({required this.state, required this.conversations});

  final AppState state;
  final List<Conversation> conversations;

  static const visible = 2;
  static const rowHeight = 74.0;
  static const gap = 10.0;

  @override
  Widget build(BuildContext context) {
    final more = conversations.length > visible;
    final rows = more ? visible : conversations.length;
    // A little of the third row shows when there is one, as the cue.
    final height = rows * rowHeight + (rows - 1) * gap + (more ? 28 : 0);
    final list = ListView.separated(
      key: const Key('ask-history'),
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemCount: conversations.length,
      separatorBuilder: (_, __) => const SizedBox(height: gap),
      itemBuilder: (context, i) => SizedBox(
        height: rowHeight,
        child: _PastConversation(state: state, conversation: conversations[i]),
      ),
    );
    return SizedBox(
      height: height,
      child: !more
          ? list
          : ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.black, Colors.transparent],
                stops: [0, 0.78, 1],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: list,
            ),
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
      child: (inRowGroup(context)
          ? (Widget child) => Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16), child: child)
          : (Widget child) => UpinoCard(child: child))(
        Row(
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
      child: GestureDetector(
        onTap: () => ChatPage.open(context, state, conversationId: c.id),
        behavior: HitTestBehavior.opaque,
        child: UpinoCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // One line: the shelf is a fixed two rows tall.
                    Text(
                      c.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${formatDateShort(context, started)}'
                      '${UpinoTokens.separator}${l.askHubTurns(c.turns.length)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const RowAffordance(),
            ],
          ),
        ),
      ),
    );
  }
}

/// A line or two of an answer, as plain text, for the common questions.
String answerPreview(BuildContext context, AskAnswer answer) {
  final l = AppLocalizations.of(context);
  return switch (answer) {
    SafeToSpendAnswer(:final amount, :final until, :final days)
        when !amount.isZero =>
      [
        l.chatSafe(amount.display(), formatDate(context, until)),
        if (days > 1) l.chatSafeLasts(days),
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
    MonthReviewAnswer(:final review) =>
      monthReviewLines(l, review).take(2).join(' '),
    BestMoveAnswer(:final move) =>
      move == null ? l.moveNone : bestMoveLines(context, move).$1,
    ComingUpAnswer(:final bills, :final total) => bills.isEmpty
        ? l.chatComingNone
        : l.homeComingUpTotal(total.display()),
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
