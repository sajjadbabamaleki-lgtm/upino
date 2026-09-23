/// One way of opening things from the bottom edge.
///
/// Anything the app asks as a question rather than a screen — which language,
/// which currency — arrives this way: the page stays visible and dimmed
/// behind it, so the sheet reads as a layer over the work rather than a place
/// the user has been sent to. Coming back is a swipe down or a tap outside,
/// neither of which needs a back button.
///
/// The motion is the Material 3 emphasised pair: a long decelerating entry so
/// the sheet appears to settle, and a short accelerating exit so dismissing
/// feels immediate. Flutter's own defaults (250ms/200ms, one curve) are
/// quicker on the way in and read as a snap.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/icon.dart';
import '../design/parts.dart';
import '../design/tokens.dart';

class UpinoSheet extends StatelessWidget {
  const UpinoSheet({
    required this.child,
    this.heightFactor,
    this.onClose,
    super.key,
  });

  /// M3: emphasised decelerate on the way in, emphasised accelerate out.
  static const enterDuration = Duration(milliseconds: 400);
  static const exitDuration = Duration(milliseconds: 200);

  static const animation = AnimationStyle(
    duration: enterDuration,
    curve: Easing.emphasizedDecelerate,
    reverseDuration: exitDuration,
    reverseCurve: Easing.emphasizedAccelerate,
  );

  /// The share of the screen a picker sheet takes. Reached by measurement
  /// rather than taste: at [defaultHeight] the top edge of the sheet sits
  /// around two fifths of the way down a phone screen, which leaves the page
  /// it belongs to plainly in view above it. Taller than this and the sheet
  /// reads as a new screen that happened to slide, which is the thing it was
  /// built to stop doing.
  static const defaultHeight = 0.6;

  /// Null lets the sheet take the height of its content, which only suits a
  /// short one; a factor between 0 and 1 is that share of the whole screen.
  /// It is measured against the screen, not against the room left over, so
  /// the keyboard coming up does not change how tall the sheet wants to be.
  final double? heightFactor;

  /// Given a close button when there is one; a list that closes on choosing
  /// does not need it, but a sheet the user may leave without answering does.
  final VoidCallback? onClose;

  final Widget child;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // The page behind stays readable but clearly inactive.
        barrierColor: const Color(0x66101018),
        // Keeps the sheet clear of the status bar, so the rounded top is
        // never cut off by the notch on a full-height sheet.
        useSafeArea: true,
        sheetAnimationStyle: animation,
        builder: builder,
      );

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final sheet = Container(
      decoration: BoxDecoration(
        color: dark ? UpinoTokens.darkSurfacePage : UpinoTokens.surfacePage,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(UpinoTokens.radiusHero),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetHead(onClose: onClose),
            heightFactor == null ? child : Expanded(child: child),
          ],
        ),
      ),
    );

    final factor = heightFactor;
    return Padding(
      // The search field inside a picker must stay above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: factor == null
          ? sheet
          : LayoutBuilder(
              builder: (context, constraints) {
                final wanted = MediaQuery.sizeOf(context).height * factor;
                // The keyboard eats into what is left; the sheet gives way to
                // it rather than pushing its own top off the screen.
                final room = constraints.maxHeight;
                return SizedBox(
                  height: room.isFinite ? math.min(wanted, room) : wanted,
                  child: sheet,
                );
              },
            ),
    );
  }
}

/// The grab handle, and the close button beside it when the sheet has one.
/// The handle is centred on the sheet rather than on the space left of the
/// button, because it is read as the middle of the sheet's edge.
class _SheetHead extends StatelessWidget {
  const _SheetHead({required this.onClose});

  final VoidCallback? onClose;

  static const height = 34.0;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: Stack(
          children: [
            Center(
              child: Container(
                key: const Key('sheet-handle'),
                width: 42,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: borderColor(context),
                  borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                ),
              ),
            ),
            if (onClose != null)
              Positioned(
                top: 2,
                right: UpinoTokens.gutter,
                child: GestureDetector(
                  key: const Key('sheet-close'),
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sunkenColor(context),
                      shape: BoxShape.circle,
                    ),
                    child: const UpinoIcon(
                      'close',
                      size: 16,
                      color: UpinoTokens.textTertiary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
