/// The Safe-to-Spend hero, §32.6 states S1–S4.
///
/// Presentation is a function of confidence_state and mandatory_funding_gap
/// only. It is never modulated for celebration, engagement or retention.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../engine/clock.dart';
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
    this.onQuickExpense,
    super.key,
  });

  final PlanSnapshot snapshot;
  final VoidCallback onConfirmBalance;
  final VoidCallback onResolve;
  final VoidCallback? onQuickExpense;

  @override
  Widget build(BuildContext context) => switch (heroStateFor(snapshot)) {
        HeroState.trusted || HeroState.degraded => _GradientHero(
            snapshot: snapshot,
            degraded: heroStateFor(snapshot) == HeroState.degraded,
            onConfirmBalance: onConfirmBalance,
            onQuickExpense: onQuickExpense,
          ),
        HeroState.fundingGap => _GapHero(snapshot: snapshot, onResolve: onResolve),
        HeroState.reviewRequired =>
          _ReviewHero(snapshot: snapshot, onConfirmBalance: onConfirmBalance),
      };
}

/// States S1 and S2. The fill is identical in both: age is de-emphasis, not
/// alarm (§15.2). The gradient appears nowhere else in the app, so its
/// presence alone says the number is current.
class _GradientHero extends StatelessWidget {
  const _GradientHero({
    required this.snapshot,
    required this.degraded,
    required this.onConfirmBalance,
    required this.onQuickExpense,
  });

  final PlanSnapshot snapshot;
  final bool degraded;
  final VoidCallback onConfirmBalance;
  final VoidCallback? onQuickExpense;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return _HeroShell(
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
      decoration2: const DotField(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UpinoBadge(
            'Safe to spend now',
            background: Color(0x2EFFFFFF),
            foreground: UpinoTokens.textOnInverse,
          ),
          const SizedBox(height: 16),
          _Figure(snapshot.safeToSpendNow, color: UpinoTokens.textOnInverse),
          const SizedBox(height: 14),
          _HeroMeta(
            'Until ${formatDate(snapshot.decisionHorizonEnd)}'
            '${UpinoTokens.separator}'
            '${snapshot.protectedTotal.display()} set aside',
          ),
          const SizedBox(height: 26),
          if (degraded)
            _FreshnessRow(snapshot: snapshot, onConfirmBalance: onConfirmBalance)
          else if (onQuickExpense != null)
            _HeroButton(label: 'Record a spend', onPressed: onQuickExpense!),
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
        borderRadius: BorderRadius.circular(UpinoTokens.radiusHero),
        color: UpinoTokens.surfaceInverse,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UpinoBadge(
            'Safe to spend now',
            background: Color(0x1FFFFFFF),
            foreground: UpinoTokens.textOnInverse,
          ),
          const SizedBox(height: 16),
          _Figure(snapshot.safeToSpendNow, color: UpinoTokens.textOnInverse),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0x1FFF8A80),
              borderRadius: BorderRadius.circular(UpinoTokens.radiusInner),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 19, color: UpinoTokens.criticalOnInverse,),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        '${snapshot.mandatoryFundingGap.display()} short',
                        style: const TextStyle(
                          color: UpinoTokens.criticalOnInverse,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          fontFeatures: moneyFeatures,
                        ),
                      ),
                    ),
                  ],
                ),
                if (top != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${top.label}${UpinoTokens.separator}'
                    '${top.shortfall.display()} unfunded',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
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
    final dark = isDark(context);
    return UpinoCard(
      radius: UpinoTokens.radiusHero,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UpinoBadge(
            'Not up to date',
            background: dark
                ? UpinoTokens.darkCriticalSurface
                : UpinoTokens.criticalSurface,
            foreground: dark ? UpinoTokens.darkCritical : UpinoTokens.critical,
          ),
          const SizedBox(height: 14),
          Text(
            snapshot.safeToSpendNow.display(),
            style: theme.textTheme.displayMedium?.copyWith(
              color: dark
                  ? UpinoTokens.darkTextSecondary
                  : UpinoTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Check your balance so this number can be trusted again.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 18),
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
  const _HeroShell({
    required this.decoration,
    required this.child,
    this.decoration2,
  });

  final BoxDecoration decoration;
  final Widget child;
  final Widget? decoration2;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusHero),
        child: Container(
          width: double.infinity,
          decoration: decoration,
          child: Stack(
            children: [
              if (decoration2 != null)
                Positioned(top: -6, right: -6, child: decoration2!),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 31, 22, 31),
                child: child,
              ),
            ],
          ),
        ),
      );
}

/// Plain white, no scrim: at the card's proportions this line lands just
/// above the midpoint of the sweep, where white measures 5.3:1. The scrim is
/// reserved for the freshness row, which sits lower.
class _HeroMeta extends StatelessWidget {
  const _HeroMeta(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontFeatures: moneyFeatures,
        ),
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
    final days = snapshot.balanceAgeInDays;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: UpinoTokens.onGradientScrim,
        borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
      ),
      child: Row(
      children: [
        Expanded(
          child: Text(
            switch (days) {
              null => 'Balance not confirmed yet',
              0 => 'Balance confirmed today',
              1 => 'Balance confirmed yesterday',
              _ => 'Balance confirmed $days days ago',
            },
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
        GestureDetector(
          onTap: onConfirmBalance,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                color: UpinoTokens.gradientStart,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }
}

/// The white pill that sits inside a coloured hero.
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
            foregroundColor: UpinoTokens.actionPrimary,
            minimumSize: const Size.fromHeight(52),
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

const _months = <String>[
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Dates read as words. The engine's own `toString` is an ISO string meant
/// for logs and fixtures, never for the person using the app.
String formatDate(LocalDate date) => '${date.day} ${_months[date.month - 1]}';
