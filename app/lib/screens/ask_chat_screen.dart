/// Ask, as a conversation: questions about the plan, answered by the plan.
///
/// Every answer is built from the engine's own snapshot or, for a purchase,
/// the same three full plans the Ask screen shows (Strategic Evolution
/// §3.3). The chat never says yes or no to a purchase; it shows what each
/// choice would leave, and the decision stays with the person (§7).
library;

import 'package:flutter/material.dart';

import '../design/icon.dart';
import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../device/voice.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import '../state/ask_answers.dart';
import '../widgets/amount_sheet.dart' show categoryLabel;
import '../widgets/purchase_scenarios.dart';

/// One exchange: what was asked, and what the plan answered.
class ChatEntry {
  const ChatEntry({required this.question, required this.answer});
  final String question;
  final AskAnswer answer;
}

/// Kept by the home screen, so the conversation survives switching tabs.
/// Not saved: every answer is recomputed from the plan on demand, and an old
/// answer to an old plan is not worth keeping.
class ChatLog extends ChangeNotifier {
  final List<ChatEntry> _entries = [];
  List<ChatEntry> get entries => List.unmodifiable(_entries);

  void add(ChatEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }
}

class AskChatScreen extends StatefulWidget {
  const AskChatScreen({
    required this.state,
    required this.log,
    required this.padding,
    super.key,
  });

  final AppState state;
  final ChatLog log;
  final EdgeInsets padding;

  @override
  State<AskChatScreen> createState() => _AskChatScreenState();
}

class _AskChatScreenState extends State<AskChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _listening = false;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _ask(String question) {
    final q = question.trim();
    if (q.isEmpty) return;
    widget.log.add(
      ChatEntry(question: q, answer: answerQuestion(q, widget.state)),
    );
    _input.clear();
    _toBottom();
  }

  void _askSuggested(SuggestedQuestion q, String asText) {
    widget.log.add(
      ChatEntry(question: asText, answer: answerSuggested(q, widget.state)),
    );
    _toBottom();
  }

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
    final suggestions = [
      (SuggestedQuestion.safeToSpend, l.chatSuggestSafe),
      (SuggestedQuestion.nextPay, l.chatSuggestPay),
      (SuggestedQuestion.whereItWent, l.chatSuggestWhere),
      (SuggestedQuestion.setAside, l.chatSuggestAside),
    ];

    return AnimatedBuilder(
      animation: widget.log,
      builder: (context, _) {
        final entries = widget.log.entries;
        return Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: widget.padding.copyWith(bottom: 12),
                children: [
                  _Bubble(
                    fromPlan: true,
                    child: Text(l.chatIntro, style: theme.textTheme.bodyMedium),
                  ),
                  for (final e in entries) ...[
                    const SizedBox(height: 10),
                    _Bubble(
                      fromPlan: false,
                      child: Text(
                        e.question,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _AnswerView(answer: e.answer),
                  ],
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                key: const Key('chat-suggestions'),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: UpinoTokens.gutter,
                ),
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => ActionChip(
                  key: Key('chat-suggest-${suggestions[i].$1.name}'),
                  label: Text(suggestions[i].$2),
                  onPressed: () =>
                      _askSuggested(suggestions[i].$1, suggestions[i].$2),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                UpinoTokens.gutter,
                10,
                UpinoTokens.gutter,
                widget.padding.bottom,
              ),
              child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 4, 6, 4),
                decoration: BoxDecoration(
                  color: cardColor(context),
                  borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
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
                      icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.fromPlan, required this.child});

  final bool fromPlan;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    const r = Radius.circular(20);
    return Align(
      alignment: fromPlan
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
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
            borderRadius: BorderRadiusDirectional.only(
              topStart: r,
              topEnd: r,
              bottomStart: fromPlan ? const Radius.circular(6) : r,
              bottomEnd: fromPlan ? r : const Radius.circular(6),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _AnswerView extends StatelessWidget {
  const _AnswerView({required this.answer});

  final AskAnswer answer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final body = theme.textTheme.bodyMedium;
    final money = body?.copyWith(fontFeatures: moneyFeatures);

    Widget rows(List<(String, String)> lines) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (label, value) in lines)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
                    Text(value, style: money),
                  ],
                ),
              ),
          ],
        );

    return switch (answer) {
      PurchaseAnswer(:final scenarios) => Column(
          key: const Key('chat-answer-purchase'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Bubble(
              fromPlan: true,
              child: Text(
                l.chatPurchase(scenarios.amount.display()),
                style: body,
              ),
            ),
            const SizedBox(height: 10),
            // The cards carry the "no verdict" line themselves.
            PurchaseScenarios(result: scenarios),
          ],
        ),
      SafeToSpendAnswer(:final amount, :final until, :final trusted) =>
        _Bubble(
          fromPlan: true,
          child: Text(
            [
              l.chatSafe(amount.display(), formatDate(context, until)),
              if (!trusted) l.chatSafeStale,
            ].join(' '),
            key: const Key('chat-answer-safe'),
            style: body,
          ),
        ),
      NextPayAnswer(:final income) => _Bubble(
          fromPlan: true,
          child: Text(
            income == null
                ? l.chatPayNone
                : l.chatPay(
                    income.isRange
                        ? l.incomeRange(
                            income.expectedAmount.display(),
                            income.expectedUpperAmount!.display(),
                          )
                        : income.expectedAmount.display(),
                    formatDate(context, income.expectedDate),
                  ),
            key: const Key('chat-answer-pay'),
            style: body,
          ),
        ),
      WhereItWentAnswer(:final rows) when rows.isEmpty => _Bubble(
          fromPlan: true,
          child: Text(
            l.chatWhereNone,
            key: const Key('chat-answer-where'),
            style: body,
          ),
        ),
      WhereItWentAnswer(rows: final list) => _Bubble(
          fromPlan: true,
          child: Column(
            key: const Key('chat-answer-where'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.chatWhere, style: body),
              rows([
                for (final r in list)
                  (categoryLabel(l, r.category), r.total.display()),
              ]),
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
      HelpAnswer() => _Bubble(
          fromPlan: true,
          child: Text(
            l.chatHelp,
            key: const Key('chat-answer-help'),
            style: body,
          ),
        ),
    };
  }
}
