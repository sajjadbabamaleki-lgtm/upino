/// Ask Before You Spend (Strategic Evolution §3.3).
///
/// Every figure here comes from the same engine that produces the live plan,
/// run on inputs that differ only by the contemplated purchase. Nothing is
/// recorded, nothing is mutated, and no scenario is arithmetic performed on
/// top of a snapshot.
///
/// The screen shows consequences and never a verdict. There is no yes, no no,
/// and no recommended option — §7 puts the decision with the user, and a
/// product that answers "should I?" for someone is answering a question it
/// cannot know the whole of.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../engine/plan.dart';
import '../l10n/app_localizations.dart';
import '../l10n/dates.dart';
import '../l10n/labels.dart';
import '../state/app_state.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({required this.state, super.key});

  final AppState state;

  static Future<void> open(BuildContext context, AppState state) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => AskScreen(state: state)),
      );

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _amount = TextEditingController();
  SpendScenarios? _result;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Money? get _parsed {
    final text = _amount.text.trim();
    if (text.isEmpty) return null;
    try {
      final m = Money.parse(text, widget.state.currency);
      return m.isZero ? null : m;
    } on ArgumentError {
      return null;
    }
  }

  void _run() {
    final amount = _parsed;
    if (amount == null) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _result = widget.state.simulatePurchase(amount));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final decimals = Currency.of(widget.state.currency).exponent;
    final result = _result;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(l.askTitle, style: theme.textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          UpinoTokens.gutter,
          4,
          UpinoTokens.gutter,
          40,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 18),
            child: Text(l.askBlurb, style: theme.textTheme.bodySmall),
          ),

          UpinoCard(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.askAmountLabel, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: sunkenColor(context),
                    borderRadius:
                        BorderRadius.circular(UpinoTokens.radiusInner),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        Currency.of(widget.state.currency).symbol,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(color: UpinoTokens.textTertiary),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          key: const Key('ask-amount'),
                          controller: _amount,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: decimals > 0,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              decimals > 0
                                  ? RegExp(r'[0-9.]')
                                  : RegExp(r'[0-9]'),
                            ),
                          ],
                          onChanged: (_) => setState(() => _result = null),
                          onSubmitted: (_) => _run(),
                          style: theme.textTheme.headlineSmall,
                          decoration: InputDecoration(
                            hintText: l.tapToType,
                            hintStyle: theme.textTheme.bodyMedium
                                ?.copyWith(color: UpinoTokens.textTertiary),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          FilledButton(
            key: const Key('ask-run'),
            onPressed: _parsed == null ? null : _run,
            child: Text(l.askRun),
          ),

          if (result != null) ...[
            const SizedBox(height: 26),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
        ],
      ),
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
