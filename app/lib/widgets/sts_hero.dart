/// The Safe-to-Spend hero, §32.6 states S1–S4.
///
/// Presentation is a function of confidence_state and mandatory_funding_gap
/// only. It is never modulated for celebration, engagement or retention.
library;

import 'package:flutter/material.dart';

import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/money.dart';
import '../engine/plan.dart';

/// §32.5 — when conditions co-occur, the highest state wins. A confidently
/// styled funding gap computed from data already marked untrustworthy is a
/// worse failure than a gap warning shown one step later.
enum HeroState { trusted, degraded, fundingGap, reviewRequired }

HeroState heroStateFor(PlanSnapshot s) {
  if (s.confidenceState == ConfidenceState.reviewRequired) {
    return HeroState.reviewRequired;
  }
  if (s.hasMandatoryGap) return HeroState.fundingGap;
  if (s.confidenceState == ConfidenceState.degraded) return HeroState.degraded;
  return HeroState.trusted;
}

class StsHero extends StatelessWidget {
  const StsHero({
    required this.snapshot,
    required this.onConfirmBalance,
    required this.onResolve,
    super.key,
  });

  final PlanSnapshot snapshot;
  final VoidCallback onConfirmBalance;
  final VoidCallback onResolve;

  @override
  Widget build(BuildContext context) {
    final state = heroStateFor(snapshot);
    return switch (state) {
      HeroState.trusted || HeroState.degraded => _GradientHero(
          snapshot: snapshot,
          degraded: state == HeroState.degraded,
          onConfirmBalance: onConfirmBalance,
        ),
      HeroState.fundingGap =>
        _GapHero(snapshot: snapshot, onResolve: onResolve),
      HeroState.reviewRequired =>
        _ReviewHero(snapshot: snapshot, onConfirmBalance: onConfirmBalance),
    };
  }
}

/// States S1 and S2. The fill is identical in both: age is de-emphasis, not
/// alarm (§15.2). The gradient appears nowhere else in the app, so its
/// presence alone says the number is current.
class _GradientHero extends StatelessWidget {
  const _GradientHero({
    required this.snapshot,
    required this.degraded,
    required this.onConfirmBalance,
  });

  final PlanSnapshot snapshot;
  final bool degraded;
  final VoidCallback onConfirmBalance;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return _HeroShell(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [UpinoTokens.darkGradientStart, UpinoTokens.darkGradientEnd]
              : const [UpinoTokens.gradientStart, UpinoTokens.gradientEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeroLabel('Safe to spend now'),
          const SizedBox(height: 10),
          _Figure(snapshot.safeToSpendNow, color: UpinoTokens.textOnInverse),
          const SizedBox(height: 14),
          _HeroSupport(
            'Until ${_formatDate(snapshot.decisionHorizonEnd)}'
            '${UpinoTokens.separator}'
            '${snapshot.protectedTotal.display()} protected',
          ),
          if (degraded) ...[
            const SizedBox(height: 16),
            _FreshnessRow(
              snapshot: snapshot,
              onConfirmBalance: onConfirmBalance,
            ),
          ],
        ],
      ),
    );
  }
}

/// State S3. Not the celebratory gradient: the figure is zero and the gap is
/// named, in the lighter critical token that is legible on this surface.
class _GapHero extends StatelessWidget {
  const _GapHero({required this.snapshot, required this.onResolve});

  final PlanSnapshot snapshot;
  final VoidCallback onResolve;

  @override
  Widget build(BuildContext context) {
    final top = snapshot.topUnfundedClaim;
    return _HeroShell(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        color: UpinoTokens.surfaceInverse,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeroLabel('Safe to spend now'),
          const SizedBox(height: 10),
          _Figure(snapshot.safeToSpendNow, color: UpinoTokens.textOnInverse),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.error_outline,
                  size: 18, color: UpinoTokens.criticalOnInverse,),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${snapshot.mandatoryFundingGap.display()} short of what you '
                  'have committed',
                  style: const TextStyle(
                    color: UpinoTokens.criticalOnInverse,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFeatures: moneyFeatures,
                  ),
                ),
              ),
            ],
          ),
          if (top != null) ...[
            const SizedBox(height: 6),
            _HeroSupport('${top.label}${UpinoTokens.separator}'
                '${top.shortfall.display()} unfunded'),
          ],
          const SizedBox(height: 18),
          _HeroButton(label: 'See what is short', onPressed: onResolve),
        ],
      ),
    );
  }
}

/// State S4. The figure is not presented as authoritative, because the
/// evidence behind it is not (§15.2).
class _ReviewHero extends StatelessWidget {
  const _ReviewHero({required this.snapshot, required this.onConfirmBalance});

  final PlanSnapshot snapshot;
  final VoidCallback onConfirmBalance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(UpinoTokens.cardPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
        color: dark ? UpinoTokens.darkSurfaceCard : UpinoTokens.surfaceCard,
        border: Border.all(
          color: dark ? UpinoTokens.darkBorderSubtle : UpinoTokens.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Safe to spend', style: theme.textTheme.bodySmall),
          const SizedBox(height: 6),
          Text(
            snapshot.safeToSpendNow.display(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: dark
                  ? UpinoTokens.darkTextSecondary
                  : UpinoTokens.textSecondary,
              fontFeatures: moneyFeatures,
            ),
          ),
          const SizedBox(height: 4),
          Text('Not up to date', style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: dark
                  ? UpinoTokens.darkCriticalSurface
                  : UpinoTokens.criticalSurface,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 18,
                  color: dark ? UpinoTokens.darkCritical : UpinoTokens.critical,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Check your balance so this number can be trusted again.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: dark
                          ? UpinoTokens.darkTextPrimary
                          : UpinoTokens.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onConfirmBalance,
            child: const Text('Confirm balance'),
          ),
        ],
      ),
    );
  }
}

class _HeroShell extends StatelessWidget {
  const _HeroShell({required this.decoration, required this.child});

  final BoxDecoration decoration;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(UpinoTokens.cardPadding + 4),
        decoration: decoration,
        child: child,
      );
}

class _HeroLabel extends StatelessWidget {
  const _HeroLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      );
}

class _HeroSupport extends StatelessWidget {
  const _HeroSupport(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 13.5),
      );
}

/// Age alone never gets warning styling: a low-emphasis line and an
/// unobtrusive action, nothing more (§15.2, check D02).
class _FreshnessRow extends StatelessWidget {
  const _FreshnessRow({required this.snapshot, required this.onConfirmBalance});

  final PlanSnapshot snapshot;
  final VoidCallback onConfirmBalance;

  @override
  Widget build(BuildContext context) {
    final confirmedAt = snapshot.oldestConfirmationAt;
    final days = confirmedAt == null
        ? null
        : DateTime.now().toUtc().difference(confirmedAt).inDays;
    return Row(
      children: [
        Expanded(
          child: Text(
            days == null
                ? 'Balance not confirmed yet'
                : 'Balance confirmed $days days ago',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ),
        TextButton(
          onPressed: onConfirmBalance,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            visualDensity: VisualDensity.compact,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: UpinoTokens.surfaceInverse,
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(label),
        ),
      );
}

/// Authoritative amounts are rendered exactly as the engine returns them:
/// grouped, never abbreviated, never re-rounded (§32.8, §5.1).
class _Figure extends StatelessWidget {
  const _Figure(this.amount, {required this.color});

  final Money amount;
  final Color color;

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          amount.display(),
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: color, fontFeatures: moneyFeatures),
        ),
      );
}

String _formatDate(Object date) => date.toString();
