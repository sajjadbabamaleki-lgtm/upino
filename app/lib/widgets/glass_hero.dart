/// The frosted-glass card at the top of Home and Ask.
///
/// Glass lit from behind by a strong blue light right of centre and a violet
/// one low on the left, with a little of the blue spilling above the card.
/// The card carries its own dark ground, so it looks the same on a light or
/// a dark page. The blue light is drawn from the hero gradient tokens, which
/// appear nowhere else.
library;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/tokens.dart';

class GlassHero extends StatelessWidget {
  const GlassHero({required this.child, super.key});

  /// The card is as tall as this and its padding, no taller: Home and Ask
  /// are laid out to come to the same height on their own.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final blue =
        dark ? UpinoTokens.darkGradientStart : UpinoTokens.gradientStart;
    final radius = BorderRadius.circular(UpinoTokens.radiusHero);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // The light spilling above the card, onto the page behind it.
        Positioned(
          left: 60,
          right: -20,
          top: -70,
          height: 180,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    blue.withValues(alpha: dark ? 0.38 : 0.22),
                    blue.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: radius,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: const Color(0xFF0E0F16),
            ),
            child: Stack(
              children: [
                // The blue light, strongest right of centre.
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.45, 0.05),
                        radius: 0.95,
                        colors: [blue, blue, blue.withValues(alpha: 0)],
                        stops: const [0, 0.12, 1],
                      ),
                    ),
                  ),
                ),
                // The violet one, low on the left.
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.75, 1.05),
                        radius: 0.7,
                        colors: [Color(0x805A3AE8), Color(0x005A3AE8)],
                      ),
                    ),
                  ),
                ),
                // The frost: a faint white veil, lit along the top edge,
                // inside a hairline.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      border: Border.all(color: const Color(0x24FFFFFF)),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x26FFFFFF),
                          Color(0x10FFFFFF),
                          Color(0x0AFFFFFF),
                        ],
                        stops: [0, 0.25, 1],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The white button at the foot of a glass hero: ink label, leading icon.
class GlassHeroButton extends StatelessWidget {
  const GlassHeroButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.buttonKey,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: FilledButton(
          key: buttonKey,
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF0B0B0E),
            minimumSize: const Size.fromHeight(52),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 8),
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      );
}
