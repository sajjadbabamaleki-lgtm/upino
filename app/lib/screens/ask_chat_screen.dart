/// Ask, as a conversation on its own page: questions about the plan,
/// answered by the plan.
///
/// Every answer is built from the engine's own snapshot or, for a purchase,
/// the same three full plans the scenario cards show (Strategic Evolution
/// §3.3). It never says yes or no to a purchase; it shows what each choice
/// would leave, and the decision stays with the person (§7).
///
/// A reply comes back in the language the question was written in, whatever
/// the app itself is set to: Persian typed into an app following an English
/// phone gets Persian back.
library;

import 'package:flutter/material.dart';

import '../design/icon.dart';
import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../device/voice.dart';
import '../domain/conversation.dart';
import '../engine/clock.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import '../state/ask_answers.dart';
import '../widgets/amount_sheet.dart' show categoryLabel;
import '../widgets/best_move_card.dart' show bestMoveLines, moveTag;
import '../widgets/month_review.dart';
import '../widgets/purchase_scenarios.dart';
import '../widgets/timeline_card.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.state,
    this.conversationId,
    this.firstQuestion,
    super.key,
  });

  final AppState state;

  /// An earlier conversation to carry on, or null to start a new one.
  final String? conversationId;

  /// Asked as soon as the page opens, for a question chosen elsewhere.
  final String? firstQuestion;

  static Future<void> open(
    BuildContext context,
    AppState state, {
    String? conversationId,
    String? firstQuestion,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChatPage(
            state: state,
            conversationId: conversationId,
            firstQuestion: firstQuestion,
          ),
        ),
      );

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  late String _id;
  bool _listening = false;

  AppState get state => widget.state;

  @override
  void initState() {
    super.initState();
    _id = widget.conversationId ?? state.startConversation();
    final first = widget.firstQuestion;
    if (first != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ask(first));
    }
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ask(String question) {
    final q = question.trim();
    if (q.isEmpty || !mounted) return;
    final app = Localizations.localeOf(context).languageCode;
    state.ask(_id, q, language: replyLanguage(q, app));
    _input.clear();
    _toBottom();
  }

  void _newConversation() => setState(() => _id = state.startConversation());

  void _toBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _speak() async {
    final voice = VoiceInput.instance;
    if (voice == null) return;
    if (_listening) {
      await voice.stop();
      return;
    }
    final language = Localizations.localeOf(context).languageCode;
    setState(() => _listening = true);
    final result = await voice.listen(
      localeId: language == 'fa' ? 'fa_IR' : language,
      onPartial: (words) {
        if (mounted) setState(() => _input.text = words);
      },
    );
    if (!mounted) return;
    setState(() => _listening = false);
    final text = result.text;
    if (text != null) _ask(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: _PageDirection(
          direction: Directionality.of(context),
          child: AnimatedBuilder(
            animation: state,
            builder: (context, _) {
              final conversation = state.conversation(_id);
              final turns = conversation?.turns ?? const <ChatTurn>[];
              final resumed = turns.isNotEmpty &&
                  LocalDate.at(turns.first.askedAt, state.utcOffset) !=
                      state.today;
              return Column(
                children: [
                  _ChatHeader(
                    onBack: () => Navigator.of(context).pop(),
                    onNew: turns.isEmpty ? null : _newConversation,
                  ),
                  Expanded(
                    child: ListView(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(
                        UpinoTokens.gutter,
                        4,
                        UpinoTokens.gutter,
                        12,
                      ),
                      children: [
                        // The opening follows the conversation's language
                        // once there is one.
                        _InLanguage(
                          language: turns.firstOrNull?.language,
                          child: _AnswerView(answer: greet(state), state: state),
                        ),
                        if (resumed) ...[
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              l.chatResumed,
                              key: const Key('chat-resumed'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                        for (final turn in turns) ...[
                          const SizedBox(height: 10),
                          _Bubble(
                            fromPlan: false,
                            child: Text(
                              turn.question,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          _InLanguage(
                            language: turn.language,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final answer
                                    in reply(turn.question, state)) ...[
                                  const SizedBox(height: 10),
                                  _AnswerView(answer: answer, state: state),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _InLanguage(
                    language: turns.lastOrNull?.language,
                    child: _Suggestions(onAsk: _ask),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      UpinoTokens.gutter,
                      10,
                      UpinoTokens.gutter,
                      12,
                    ),
                    child: Container(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(18, 4, 6, 4),
                      decoration: BoxDecoration(
                        color: cardColor(context),
                        borderRadius:
                            BorderRadius.circular(UpinoTokens.radiusPill),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('chat-input'),
                              controller: _input,
                              textInputAction: TextInputAction.send,
                              onSubmitted: _ask,
                              style: theme.textTheme.bodyMedium,
                              decoration: InputDecoration(
                                hintText: l.chatHint,
                                hintStyle: theme.textTheme.bodyMedium
                                    ?.copyWith(color: UpinoTokens.textTertiary),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (VoiceInput.instance != null)
                            IconButton(
                              key: const Key('chat-voice'),
                              onPressed: _speak,
                              icon: UpinoIcon(
                                'mic',
                                size: 21,
                                color: _listening
                                    ? (isDark(context)
                                        ? UpinoTokens.darkActionPrimary
                                        : UpinoTokens.actionPrimary)
                                    : UpinoTokens.textTertiary,
                              ),
                            ),
                          IconButton.filled(
                            key: const Key('chat-send'),
                            onPressed: () => _ask(_input.text),
                            icon: const Icon(
                              Icons.arrow_upward_rounded,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// One-tap questions above the input, in the conversation's language.
class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onAsk});

  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    final suggestions = suggestedQuestions(AppLocalizations.of(context));
    return SizedBox(
      height: 40,
      child: ListView.separated(
        key: const Key('chat-suggestions'),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: UpinoTokens.gutter),
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) => ActionChip(
          key: Key('chat-suggest-${suggestions[i].$1.name}'),
          label: Text(suggestions[i].$2),
          onPressed: () => onAsk(suggestions[i].$2),
        ),
      ),
    );
  }
}

/// The questions offered as chips and as the hub's common questions, in the
/// words a person would type them.
List<(SuggestedQuestion, String)> suggestedQuestions(AppLocalizations l) => [
      (SuggestedQuestion.safeToSpend, l.chatSuggestSafe),
      (SuggestedQuestion.bestMove, l.chatSuggestMove),
      (SuggestedQuestion.nextPay, l.chatSuggestPay),
      (SuggestedQuestion.comingUp, l.chatSuggestComing),
      (SuggestedQuestion.whereItWent, l.chatSuggestWhere),
      (SuggestedQuestion.setAside, l.chatSuggestAside),
      (SuggestedQuestion.monthReview, l.chatSuggestMonth),
      (SuggestedQuestion.advice, l.chatSuggestAdvice),
    ];

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.onBack, this.onNew});

  final VoidCallback onBack;
  final VoidCallback? onNew;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Row(
        children: [
          IconButton(
            key: const Key('chat-back'),
            onPressed: onBack,
            icon: const UpinoIcon('back', size: 24),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          Expanded(
            child: Text(l.chatTitle, style: theme.textTheme.titleLarge),
          ),
          if (onNew != null)
            TextButton(
              key: const Key('chat-new'),
              onPressed: onNew,
              child: Text(l.chatNew),
            ),
        ],
      ),
    );
  }
}

/// The page's own direction, carried past a reply shown in another language
/// so bubbles keep their sides while their text reads its own way.
class _PageDirection extends InheritedWidget {
  const _PageDirection({required this.direction, required super.child});

  final TextDirection direction;

  static TextDirection of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PageDirection>()?.direction ??
      Directionality.of(context);

  @override
  bool updateShouldNotify(_PageDirection old) => old.direction != direction;
}

/// Shows [child] in [language] when there is one: its words, its dates and
/// its direction.
class _InLanguage extends StatelessWidget {
  const _InLanguage({required this.language, required this.child});

  final String? language;
  final Widget child;

  @override
  Widget build(BuildContext context) => language == null
      ? child
      : Localizations.override(
          context: context,
          locale: Locale(language!),
          child: child,
        );
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.fromPlan, required this.child});

  final bool fromPlan;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    const r = Radius.circular(20);
    // Sides follow the page, not the reply: a Persian answer in an English
    // app is still the app's side of the conversation.
    final rtl = _PageDirection.of(context) == TextDirection.rtl;
    final onLeft = fromPlan != rtl;
    return Align(
      alignment: onLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.82,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: fromPlan
                ? cardColor(context)
                : (dark
                    ? UpinoTokens.darkActionPrimary
                    : UpinoTokens.actionPrimary),
            // The small corner points at whoever said it.
            borderRadius: BorderRadius.only(
              topLeft: r,
              topRight: r,
              bottomLeft: onLeft ? const Radius.circular(6) : r,
              bottomRight: onLeft ? r : const Radius.circular(6),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _AnswerView extends StatelessWidget {
  const _AnswerView({required this.answer, required this.state});

  final AskAnswer answer;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final body = theme.textTheme.bodyMedium;
    final money = body?.copyWith(fontFeatures: moneyFeatures);

    Widget say(Key key, List<String> parts) => _Bubble(
          fromPlan: true,
          child: Text(parts.join(' '), key: key, style: body),
        );

    Widget rows(List<(String, String)> lines) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (label, value) in lines)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(label, style: theme.textTheme.bodySmall),
                    ),
                    Text(value, style: money),
                  ],
                ),
              ),
          ],
        );

    return switch (answer) {
      GreetingAnswer(
        :final acquaintance,
        :final days,
        :final spends,
        :final alerts,
        :final daysToSeason,
      ) =>
        say(const Key('chat-greeting'), [
          switch (acquaintance) {
            Acquaintance.newcomer => l.chatHelloNew,
            Acquaintance.learning =>
              l.chatHelloLearning(days, spends, daysToSeason),
            Acquaintance.familiar => l.chatHelloFamiliar(days),
          },
          if (alerts > 0) l.chatHelloAlerts(alerts),
        ]),
      PurchaseAnswer(:final scenarios) => Column(
          key: const Key('chat-answer-purchase'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            say(const Key('chat-purchase-summary'), [
              l.chatPurchase(scenarios.amount.display()),
              if (!scenarios.breaksNow)
                l.chatPurchaseFits(scenarios.buyNow.safeToSpendNow.display())
              else if (scenarios.waitingHelps)
                l.chatPurchaseWait(formatDate(context, scenarios.incomeDate!))
              else if (scenarios.buyAfterIncome != null)
                l.chatPurchaseStillShort(
                  formatDate(context, scenarios.incomeDate!),
                )
              else
                l.chatPurchaseShort,
              if (scenarios.goalDelays.firstOrNull case final g?)
                l.chatPurchaseGoal(
                  labelForClaim(l, g.claimId, g.label),
                  g.days,
                ),
            ]),
            const SizedBox(height: 10),
            // The three plans side by side over time, before the cards.
            TimelineCard(state: state, purchase: scenarios.amount),
            const SizedBox(height: 12),
            // The cards carry the "no verdict" line themselves.
            PurchaseScenarios(result: scenarios),
          ],
        ),
      MonthReviewAnswer() => () {
          final close = monthClose(context, state);
          return Column(
            key: const Key('chat-answer-month'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              say(const Key('chat-month-past'), close.past),
              if (close.ahead.isNotEmpty) ...[
                const SizedBox(height: 8),
                say(
                  const Key('chat-month-ahead'),
                  ['${l.monthAheadTitle}:', ...close.ahead],
                ),
              ],
              if (close.worth.isNotEmpty) ...[
                const SizedBox(height: 8),
                say(
                  const Key('chat-month-worth'),
                  ['${l.monthWorthKnowing}:', ...close.worth],
                ),
              ],
            ],
          );
        }(),
      BestMoveAnswer(:final move) => move == null
          ? say(const Key('chat-answer-move'), [l.moveNone])
          : () {
              final (what, why) = bestMoveLines(context, move);
              return say(
                const Key('chat-answer-move'),
                ['${moveTag(l, move.kind)}:', what, why],
              );
            }(),
      ComingUpAnswer(:final bills, :final total) => bills.isEmpty
          ? say(const Key('chat-answer-coming'), [l.chatComingNone])
          : _Bubble(
              fromPlan: true,
              child: Column(
                key: const Key('chat-answer-coming'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.homeComingUpTotal(total.display()), style: body),
                  rows([
                    for (final b in bills.take(6))
                      (
                        '${b.bill.name}${UpinoTokens.separator}'
                            '${formatDate(context, b.due)}',
                        b.bill.amount.display(),
                      ),
                  ]),
                ],
              ),
            ),
      SafeToSpendAnswer(
        :final amount,
        :final until,
        :final days,
        :final trusted,
      ) =>
        say(const Key('chat-answer-safe'), [
          if (amount.isZero)
            l.chatSafeNothing(formatDate(context, until))
          else ...[
            l.chatSafe(amount.display(), formatDate(context, until)),
            if (days > 1) l.chatSafeLasts(days),
          ],
          if (!trusted) l.chatSafeStale,
        ]),
      NextPayAnswer(:final income, :final inDays) => say(
          const Key('chat-answer-pay'),
          [
            if (income == null)
              l.chatPayNone
            else ...[
              l.chatPay(
                income.isRange
                    ? l.incomeRange(
                        income.expectedAmount.display(),
                        income.expectedUpperAmount!.display(),
                      )
                    : income.expectedAmount.display(),
                formatDate(context, income.expectedDate),
              ),
              if (inDays != null && inDays > 0) l.chatPayIn(inDays),
              if (inDays != null && inDays < 0) l.chatPayLate,
              if (income.isRange) l.chatPayRange,
            ],
          ],
        ),
      WhereItWentAnswer(:final rows, :final daysSeen) when rows.isEmpty =>
        say(const Key('chat-answer-where'), [
          if (daysSeen < 7) l.chatWhereTooSoon else l.chatWhereNone,
        ]),
      final WhereItWentAnswer where => _Bubble(
          fromPlan: true,
          child: Column(
            key: const Key('chat-answer-where'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                [
                  if (where.daysSeen < 30)
                    l.chatWhereSoFar(where.daysSeen)
                  else
                    l.chatWhere,
                ].join(' '),
                style: body,
              ),
              rows([
                for (final r in where.rows)
                  (categoryLabel(l, r.category), r.total.display()),
              ]),
              if (where.topShare != null) ...[
                const SizedBox(height: 8),
                Text(
                  l.chatWhereTop(
                    categoryLabel(
                      l,
                      where.rows.firstWhere((r) => r.category != null).category,
                    ),
                    where.topShare!,
                  ),
                  style: body,
                ),
              ],
            ],
          ),
        ),
      SetAsideAnswer(:final total, :final claims) => _Bubble(
          fromPlan: true,
          child: Column(
            key: const Key('chat-answer-aside'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.chatAside(total.display()), style: body),
              rows([
                for (final c in claims)
                  (labelForClaim(l, c.claimId, c.label), c.amount.display()),
              ]),
            ],
          ),
        ),
      final AdviceAnswer a => say(
          const Key('chat-answer-advice'),
          [
            if (a.acquaintance == Acquaintance.newcomer)
              l.chatAdviceTooSoon
            else ...[
              if (a.biggest != null)
                l.chatAdviceBiggest(
                  categoryLabel(l, a.biggest),
                  a.biggestTotal!.display(),
                  a.tenPercent!.display(),
                )
              else
                l.chatAdviceSort,
              if (a.previousTotal != null && a.lastTotal != null)
                a.lastTotal! > a.previousTotal!
                    ? l.chatAdviceMore(
                        (a.lastTotal! - a.previousTotal!).display(),
                      )
                    : l.chatAdviceLess(
                        (a.previousTotal! - a.lastTotal!).display(),
                      ),
              if (a.acquaintance == Acquaintance.learning)
                l.chatAdviceLearning,
            ],
          ],
        ),
      SmallTalkAnswer(:final kind) => say(
          const Key('chat-answer-smalltalk'),
          [
            switch (kind) {
              SmallTalk.hello => l.chatSmallHello,
              SmallTalk.thanks => l.chatSmallThanks,
              SmallTalk.whoAreYou => l.chatSmallWho,
              SmallTalk.howAreYou => l.chatSmallHowAreYou,
              SmallTalk.bye => l.chatSmallBye,
              SmallTalk.okay => l.chatSmallOkay,
              SmallTalk.hi => l.chatSmallHi,
              SmallTalk.hiFine => l.chatSmallHiFine,
            },
          ],
        ),
      WhyAnswer(:final have, :final setAside, :final left) => _Bubble(
          fromPlan: true,
          child: Column(
            key: const Key('chat-answer-why'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.chatWhy, style: body),
              rows([
                (l.chatWhyHave, have.display()),
                (l.chatWhySetAside, '−${setAside.display()}'),
                (l.chatWhyLeft, left.display()),
              ]),
            ],
          ),
        ),
      HelpAnswer() => say(const Key('chat-answer-help'), [l.chatHelp]),
    };
  }
}
