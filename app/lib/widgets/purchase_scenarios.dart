/// Ask Before You Spend (Strategic Evolution §3.3): the scenario cards the
/// Ask chat answers a purchase with.
///
/// Every figure here comes from the same engine that produces the live plan,
/// run on inputs that differ only by the contemplated purchase. Nothing is
/// recorded, nothing is mutated, and no scenario is arithmetic performed on
/// top of a snapshot.
///
/// The cards show consequences and never a verdict. There is no yes, no no,
/// and no recommended option — §7 puts the decision with the user, and a
/// product that answers "should I?" for someone is answering a question it
/// cannot know the whole of.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';

/// The three answers to "what if I bought it?", each a full plan from the
/// engine. Used by the Ask screen and by the chat, so both say it the same
/// way and neither does its own arithmetic.
class PurchaseScenarios extends StatelessWidget {
  const PurchaseScenarios({required this.result, super.key});

  final SpendScenarios result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Scenario(
          key: const Key('ask-do-not-buy'),
          title: l.askDoNotBuy,
          snapshot: result.doNotBuy,
          note: l.askUnchanged,
        ),
        const SizedBox(height: 12),
        _Scenario(
          key: const Key('ask-buy-now'),
          title: l.askBuyNow,
          snapshot: result.buyNow,
          note: result.breaksNow ? l.askBreaks : l.askSafe,
          critical: result.breaksNow,
          costs: result.costsNow,
        ),
        const SizedBox(height: 12),
        if (result.buyAfterIncome != null)
          _Scenario(
            key: const Key('ask-buy-after'),
            title: l.askBuyAfter(formatDate(context, result.incomeDate!)),
            snapshot: result.buyAfterIncome!,
            note: result.breaksAfterIncome ? l.askBreaks : l.askSafe,
            critical: result.breaksAfterIncome,
            // The assumption is printed on the card that depends on it,
            // not in a footnote nobody reads.
            assumption:
                l.askAssumption(formatDate(context, result.incomeDate!)),
          )
        else
          UpinoCard(
            key: const Key('ask-no-income'),
            child: Text(l.askNoIncome, style: theme.textTheme.bodySmall),
          ),
        if (result.waitingHelps) ...[
          const SizedBox(height: 12),
          UpinoCard(
            key: const Key('ask-waiting-helps'),
            gradient: accentSurfaceGradient,
            radius: UpinoTokens.radiusInner,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Text(
              l.askWaitingHelps,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: UpinoTokens.textPrimary),
            ),
          ),
        ],
        const SizedBox(height: 18),
        Center(
          child: Text(
            l.askNoVerdict,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _Scenario extends StatelessWidget {
  const _Scenario({
    required this.title,
    required this.snapshot,
    required this.note,
    this.critical = false,
    this.costs = const [],
    this.assumption,
    super.key,
  });

  final String title;
  final PlanSnapshot snapshot;
  final String note;
  final bool critical;
  final List<({String claimId, String label, Money lost})> costs;
  final String? assumption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final criticalColor =
        isDark(context) ? UpinoTokens.darkCritical : UpinoTokens.critical;

    return UpinoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(l.askStsAfter, style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(
            snapshot.safeToSpendNow.display(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontFeatures: moneyFeatures,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            note,
            style: theme.textTheme.bodySmall?.copyWith(
              color: critical ? criticalColor : null,
            ),
          ),
          if (costs.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(l.askCosts, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            for (final c in costs)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  l.askCostLine(
                    labelForClaim(l, c.claimId, c.label),
                    c.lost.display(),
                  ),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontFeatures: moneyFeatures),
                ),
              ),
          ],
          if (assumption != null) ...[
            const SizedBox(height: 12),
            Text(
              assumption!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: UpinoTokens.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
