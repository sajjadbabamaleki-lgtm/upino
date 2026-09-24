/// Month Close (§13): the last thirty days in a few plain facts, the same
/// on Activity and in the chat. No score, no grade and no advice: what went
/// out, what moved most, and whether the goals are keeping up.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'amount_sheet.dart' show categoryLabel;

/// The review as sentences, in the order they are best read.
List<String> monthReviewLines(AppLocalizations l, MonthReview r) {
  if (!r.ready) return [l.monthTooSoon(r.daysToReady)];
  final change = r.change;
  return [
    if (r.spent.isZero) l.monthNothing else l.monthSpent(r.spent.display()),
    if (change != null && !r.spent.isZero)
      if (r.aboutTheSame)
        l.monthSame
      else if (change.minor > 0)
        l.monthMore(change.display())
      else
        l.monthLess((-change).display()),
    if (r.up case final up?) l.monthUp(categoryLabel(l, up), r.upBy!.display()),
    if (r.down case final down?)
      l.monthDown(categoryLabel(l, down), r.downBy!.display()),
    if (r.goals > 0) l.monthGoals(r.goalsOnTrack, r.goals),
  ];
}

class MonthReviewCard extends StatelessWidget {
  const MonthReviewCard({required this.review, super.key});

  final MonthReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final lines = monthReviewLines(l, review);
    return UpinoCard(
      key: const Key('month-review'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.monthTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(l.monthWindow, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          for (var i = 0; i < lines.length; i++) ...[
            Text(
              lines[i],
              style: i == 0
                  ? theme.textTheme.bodyMedium
                  : theme.textTheme.bodySmall,
            ),
            if (i != lines.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
