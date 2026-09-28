/// The capsule across the top of every tab: the mark and the page's name on
/// one side, the bell and the profile on the other.
///
/// It is the bottom bar's twin — same surface, same pill radius, same 9px
/// inset around 46px items — so the two read as one frame around the page.
library;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// The app's mark: the Upino glyph — a U whose cut-out is a four-pointed
/// spark — white on a rounded square in the brand colour. The launcher icon
/// and the site use the same drawing.
class UpinoMark extends StatelessWidget {
  const UpinoMark({this.size = 46, super.key});

  final double size;

  /// The glyph on a 32 grid, sitting in the square as it does in the logo.
  static const glyph =
      'M9.21 8.78H13.37A2.17 2.17 0 0 1 15.54 10.95V12.96A2.04 2.04 0 0 1 13.5 15H10.82A0.48 0.48 0 0 0 10.82 15.97H13.75A1.79 1.79 0 0 1 15.54 17.76V20.67A0.46 0.46 0 0 0 16.46 20.67V17.76A1.79 1.79 0 0 1 18.25 15.97H21.18A0.48 0.48 0 0 0 21.18 15H18.5A2.04 2.04 0 0 1 16.46 12.96V10.95A2.17 2.17 0 0 1 18.63 8.78H22.79A1.53 1.53 0 0 1 24.32 10.31V15.95A8.32 7.86 0 0 1 7.68 15.95V10.31A1.53 1.53 0 0 1 9.21 8.78Z';

  @override
  Widget build(BuildContext context) {
    final tile = isDark(context)
        ? UpinoTokens.darkActionPrimary
        : UpinoTokens.actionPrimary;
    final hex = (tile.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return SizedBox(
      key: const Key('upino-mark'),
      width: size,
      height: size,
      child: Center(
        child: SvgPicture.string(
          '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32">'
          '<rect width="32" height="32" rx="10" fill="#$hex"/>'
          '<path fill="#F2F2F2" d="$glyph"/></svg>',
          width: size * 0.76,
          height: size * 0.76,
        ),
      ),
    );
  }
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
                    color:
                        dark ? UpinoTokens.darkCritical : UpinoTokens.critical,
                    borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
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
