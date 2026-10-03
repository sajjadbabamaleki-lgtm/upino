/// Best Financial Move (Strategy §6.2): one suggestion when a meaningful
/// decision exists, with why it is relevant and what accepting it changes.
/// Decision support, never an instruction: it can always be set aside.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';
import '../state/insights.dart';

/// The suggestion and its reason, as two lines, for the card and the chat.
(String, String) bestMoveLines(BuildContext context, BestMove m) {
  final l = AppLocalizations.of(context);
  return switch (m.kind) {
    MoveKind.move => (
        l.moveMove(m.amount!.display(), m.from!.name),
        l.moveMoveWhy(labelForClaim(l, m.claimId!, m.claimLabel!)),
      ),
    MoveKind.wait when m.waitForGap => (
        l.moveWaitGap(formatDate(context, m.date!), m.amount!.display()),
        l.moveWaitGapWhy,
      ),
    MoveKind.wait => (
        l.moveWaitPay(m.days!, m.amount!.display(), m.later!.display()),
        l.moveWaitPayWhy,
      ),
    MoveKind.save => (
        l.moveSave(m.amount!.display(), m.from!.name, m.goal!.name),
        l.moveSaveWhy(m.days!),
      ),
    MoveKind.spend => (
        l.moveSpend(m.amount!.display(), formatDate(context, m.date!)),
        l.moveSpendWhy,
      ),
  };
}

String moveTag(AppLocalizations l, MoveKind k) => switch (k) {
      MoveKind.move => l.moveTagMove,
      MoveKind.wait => l.moveTagWait,
      MoveKind.save => l.moveTagSave,
      MoveKind.spend => l.moveTagSpend,
    };

class BestMoveCard extends StatelessWidget {
  const BestMoveCard({required this.state, required this.move, super.key});

  final AppState state;
  final BestMove move;

  void _accept() {
    final m = move;
    switch (m.kind) {
      case MoveKind.move:
        state.transfer(from: m.from!.id, to: 'main', amount: m.amount!);
      case MoveKind.save:
        state.saveTowardGoal(m.goal!.id, m.amount!);
      case MoveKind.wait:
      case MoveKind.spend:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final (what, why) = bestMoveLines(context, move);
    final acts = move.kind == MoveKind.move || move.kind == MoveKind.save;

    return UpinoCard(
      key: const Key('best-move'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l.moveTitle, style: theme.textTheme.bodySmall),
              ),
              UpinoBadge(
                moveTag(l, move.kind),
                key: Key('best-move-${move.kind.name}'),
                background: dark
                    ? UpinoTokens.darkActionTint
                    : UpinoTokens.actionTint,
                foreground: dark
                    ? UpinoTokens.darkTextPrimary
                    : UpinoTokens.actionOnTint,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(what, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(why, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          Row(
            children: [
              if (acts) ...[
                FilledButton(
                  key: const Key('best-move-accept'),
                  onPressed: _accept,
                  child: Text(l.moveDoIt),
                ),
                const SizedBox(width: 8),
              ],
              TextButton(
                key: const Key('best-move-dismiss'),
                onPressed: () => state.dismissMove(move.key),
                child: Text(l.moveNotNow),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
