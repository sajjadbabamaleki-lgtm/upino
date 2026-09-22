/// Shared surfaces and controls, built to the approved visual direction.
library;

import 'package:flutter/material.dart';

import 'tokens.dart';

bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;

Color cardColor(BuildContext context) =>
    isDark(context) ? UpinoTokens.darkSurfaceCard : UpinoTokens.surfaceCard;

Color sunkenColor(BuildContext context) =>
    isDark(context) ? UpinoTokens.darkSurfaceSunken : UpinoTokens.surfaceSunken;

Color borderColor(BuildContext context) =>
    isDark(context) ? UpinoTokens.darkBorderSubtle : UpinoTokens.borderSubtle;

/// A soft rounded surface. The radius and padding carry most of the product's
/// character, so they come from tokens rather than per-screen values.
class UpinoCard extends StatelessWidget {
  const UpinoCard({
    required this.child,
    this.padding = const EdgeInsets.all(UpinoTokens.cardPadding),
    this.color,
    this.gradient,
    this.radius = UpinoTokens.radiusCard,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  /// Set instead of [color] for the one accent panel that carries a sweep.
  final Gradient? gradient;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null ? color ?? cardColor(context) : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      );
}

/// The accent panel's sweep, lightest at the top, read off the approved
/// direction the same way the hero's was.
const accentSurfaceGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [UpinoTokens.accentSurfaceStart, UpinoTokens.accentSurfaceEnd],
);

/// Small caps pill. The lime fill marks a moment that just happened and never
/// a persistent state (§32.7); other fills carry no such meaning.
class UpinoBadge extends StatelessWidget {
  const UpinoBadge(
    this.label, {
    this.background = UpinoTokens.accentConfirm,
    this.foreground = UpinoTokens.textPrimary,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: foreground,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
      );
}

/// Section heading with an optional count, as on the reference Home screen.
class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {this.count, super.key});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
      child: Row(
        children: [
          // Flexible so a long heading wraps instead of overflowing beside
          // the count.
          Flexible(child: Text(title, style: theme.textTheme.titleLarge)),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sunkenColor(context),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// The small rounded affordance that sits at the right of a list row.
class RowAffordance extends StatelessWidget {
  const RowAffordance({this.icon = Icons.chevron_right, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: sunkenColor(context),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, size: 19, color: UpinoTokens.textTertiary),
      );
}

/// A card that behaves as a single tappable row: title, supporting line, and
/// the affordance on the right.
class ActionRow extends StatelessWidget {
  const ActionRow({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.titleColor,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: UpinoCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 14)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(subtitle!, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            trailing ?? const RowAffordance(),
          ],
        ),
      ),
    );
  }
}

/// Segmented progress, used for funding a goal or a sinking fund across
/// cycles. Chunks rather than a bar, so partial funding is countable.
class SegmentedProgress extends StatelessWidget {
  const SegmentedProgress({
    required this.filled,
    required this.total,
    super.key,
  });

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final active = dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return Row(
      children: List.generate(total, (i) {
        final on = i < filled;
        return Expanded(
          child: Container(
            height: 7,
            margin: EdgeInsets.only(right: i == total - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: on ? active.withValues(alpha: 0.85) : sunkenColor(context),
              borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
            ),
          ),
        );
      }),
    );
  }
}

/// Two figures side by side with a hairline between them.
class StatPair extends StatelessWidget {
  const StatPair({
    required this.leftValue,
    required this.leftCaption,
    required this.rightValue,
    required this.rightCaption,
    super.key,
  });

  final String leftValue;
  final String leftCaption;
  final String rightValue;
  final String rightCaption;

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _Stat(leftValue, leftCaption)),
            Container(width: 1, color: borderColor(context)),
            Expanded(child: _Stat(rightValue, rightCaption)),
          ],
        ),
      );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.caption);

  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 2),
        Text(
          caption,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

/// The floating pill navigation. The active destination carries a tinted pill
/// with its label; the others show glyphs only.
///
/// The bar is padded uniformly and the row stretches, so the selected pill
/// sits the same distance from the bar's top, bottom and outer edge.
class UpinoNavBar extends StatelessWidget {
  const UpinoNavBar({
    required this.index,
    required this.onSelect,
    super.key,
  });

  final int index;
  final ValueChanged<int> onSelect;

  /// Distance from the selected pill to the bar edge, on all three sides.
  static const inset = 9.0;
  static const itemHeight = 46.0;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.account_balance_wallet_rounded, label: 'Plan'),
    (icon: Icons.receipt_long_rounded, label: 'Activity'),
    (icon: Icons.grid_view_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Container(
      key: const Key('nav-bar-surface'),
      padding: const EdgeInsets.all(inset),
      decoration: BoxDecoration(
        color: dark ? UpinoTokens.darkSurfaceRaised : UpinoTokens.surfaceRaised,
        borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
      ),
      child: SizedBox(
        height: itemHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < _items.length; i++)
              _NavItem(
                icon: _items[i].icon,
                label: _items[i].label,
                selected: i == index,
                onTap: () => onSelect(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final tint = dark ? UpinoTokens.darkActionTint : UpinoTokens.actionTint;
    final onTint =
        dark ? UpinoTokens.darkTextPrimary : UpinoTokens.actionOnTint;
    final glyph = dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        key: selected ? const Key('nav-selected-pill') : null,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 18),
        decoration: BoxDecoration(
          color: selected ? tint : Colors.transparent,
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 21,
              color: selected ? glyph : UpinoTokens.navIdle,
            ),
            if (selected) ...[
              const SizedBox(width: 9),
              Text(
                label,
                style: TextStyle(
                  color: onTint,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sits behind the floating navigation and fades scrolling content into the
/// page. It replaces a drop shadow: the bar reads as separated because what
/// passes under it disappears, not because it is outlined.
///
/// The gradient starts fully transparent [fadeHeight] above the bar's top
/// edge and is solid page colour from that edge down.
class NavScrim extends StatelessWidget {
  const NavScrim({
    required this.navHeight,
    required this.bottomGap,
    this.fadeHeight = 15,
    super.key,
  });

  final double navHeight;
  final double bottomGap;
  final double fadeHeight;

  double get height => fadeHeight + navHeight + bottomGap;

  @override
  Widget build(BuildContext context) {
    final page = isDark(context)
        ? UpinoTokens.darkSurfacePage
        : UpinoTokens.surfacePage;
    return IgnorePointer(
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [page.withValues(alpha: 0), page, page],
              stops: [0, fadeHeight / height, 1],
            ),
          ),
        ),
      ),
    );
  }
}

/// The faint dotted field in the corner of the hero, as on the reference.
class DotField extends StatelessWidget {
  const DotField({this.color = Colors.white, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 120,
        height: 92,
        child: CustomPaint(painter: _DotPainter(color)),
      );
}

class _DotPainter extends CustomPainter {
  const _DotPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 11.0;
    const radius = 2.1;
    for (var y = 0.0; y < size.height; y += step) {
      for (var x = 0.0; x < size.width; x += step) {
        // Fade the field out toward the lower left so it reads as texture
        // rather than a block.
        final t = (x / size.width) * 0.65 + (1 - y / size.height) * 0.45;
        if (t < 0.45) continue;
        canvas.drawCircle(
          Offset(x, y),
          radius,
          Paint()..color = color.withValues(alpha: (t - 0.35).clamp(0.0, 0.34)),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotPainter oldDelegate) => oldDelegate.color != color;
}
