/// The capsule across the top of every tab: the mark and the page's name on
/// one side, the bell and the profile on the other.
///
/// It is the bottom bar's twin — same surface, same pill radius, same 9px
/// inset around 46px items — so the two read as one frame around the page.
library;

import 'package:flutter/material.dart';

import '../design/icon.dart';
import '../design/parts.dart';
import '../design/tokens.dart';

class UpinoTopBar extends StatelessWidget {
  const UpinoTopBar({
    required this.title,
    required this.alertCount,
    required this.onAlerts,
    required this.onProfile,
    this.profileSelected = false,
    super.key,
  });

  final String title;

  /// How many things need the person. Zero shows the bell without a count.
  final int alertCount;
  final VoidCallback onAlerts;
  final VoidCallback onProfile;
  final bool profileSelected;

  static const inset = 9.0;
  static const itemHeight = 46.0;
  static const height = itemHeight + inset * 2;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final theme = Theme.of(context);
    return Container(
      key: const Key('top-bar'),
      height: height,
      padding: const EdgeInsets.all(inset),
      decoration: BoxDecoration(
        color: dark ? UpinoTokens.darkChrome : UpinoTokens.surfaceRaised,
        borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
      ),
      child: Row(
        children: [
          const UpinoMark(size: itemHeight),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              key: const Key('top-title'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          _RoundButton(
            key: const Key('top-alerts'),
            icon: 'bell',
            onTap: onAlerts,
            badge: alertCount,
          ),
          const SizedBox(width: 6),
          _RoundButton(
            key: const Key('top-profile'),
            icon: 'profile',
            onTap: onProfile,
            selected: profileSelected,
          ),
        ],
      ),
    );
  }
}

/// The app's mark: a U in the brand colour. A stand-in until there is a
/// real logo; the launcher icon is drawn the same way.
class UpinoMark extends StatelessWidget {
  const UpinoMark({this.size = 46, super.key});

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
        key: const Key('upino-mark'),
        width: size,
        height: size,
        child: Center(
          // The site's mark: a rounded square with the U drawn as one stroke.
          child: CustomPaint(
            size: Size.square(size * 0.76),
            painter: _MarkPainter(isDark(context) ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary),
          ),
        ),
      );
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 32;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(9 * k)),
      Paint()..color = color,
    );
    final u = Path()
      ..moveTo(10 * k, 9 * k)
      ..lineTo(10 * k, 17.2 * k)
      ..arcToPoint(Offset(22 * k, 17.2 * k), radius: Radius.circular(6 * k), clockwise: false)
      ..lineTo(22 * k, 9 * k);
    canvas.drawPath(
      u,
      Paint()
        ..color = const Color(0xFFF2F2F2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2 * k
        ..strokeCap = StrokeCap.round,
    );
  }
  @override
  bool shouldRepaint(_MarkPainter oldDelegate) => oldDelegate.color != color;
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.badge = 0,
    this.selected = false,
    super.key,
  });

  final String icon;
  final VoidCallback onTap;
  final int badge;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final tint = dark ? UpinoTokens.darkActionTint : UpinoTokens.actionTint;
    final glyph =
        dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: UpinoTopBar.itemHeight,
        height: UpinoTopBar.itemHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? tint : sunkenColor(context),
                ),
                alignment: Alignment.center,
                child: UpinoIcon(
                  icon,
                  size: 21,
                  color: selected ? glyph : UpinoTokens.navIdle,
                ),
              ),
            ),
            if (badge > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  key: const Key('top-alerts-count'),
                  constraints:
                      const BoxConstraints(minWidth: 20, minHeight: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: dark ? UpinoTokens.darkCritical : UpinoTokens.critical,
                    borderRadius:
                        BorderRadius.circular(UpinoTokens.radiusPill),
                    border: Border.all(
                      color: dark
                          ? UpinoTokens.darkSurfaceRaised
                          : UpinoTokens.surfaceRaised,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    badge > 9 ? '9+' : '$badge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
