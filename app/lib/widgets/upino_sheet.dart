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
    this.height = pickerHeight,
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

  /// How tall a picker sheet is, in logical pixels. Measured, not chosen:
  /// this is what the language list needs to show all eleven rows at once,
  /// which is the whole point of the sheet — a language you cannot see is a
  /// language you cannot pick. The currency list, at 149 rows, could never
  /// be shown whole, so it takes the same height rather than one of its own:
  /// two pickers opening to two different heights read as two components.
  static const pickerHeight = 714.0;

  /// …but never more of the screen than this. On a small phone the sheet
  /// gives up height rather than the page behind it, and the list scrolls.
  static const maxShare = 0.9;

  /// Fixed in pixels rather than as a share of the screen, so a bigger phone
  /// shows the same sheet with more page above it instead of a taller sheet
  /// with empty space in it. [maxShare] and the room actually left both cap
  /// it, which is how the keyboard takes its space back.
  final double height;

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
            Expanded(child: child),
          ],
        ),
      ),
    );

    return Padding(
      // The search field inside a picker must stay above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: LayoutBuilder(
        builder: (context, constraints) {
          var limit = math.min(
            height,
            MediaQuery.sizeOf(context).height * maxShare,
          );
          // The keyboard eats into what is left; the sheet gives way to it
          // rather than pushing its own top off the screen.
          final room = constraints.maxHeight;
          if (room.isFinite) limit = math.min(limit, room);
          return SizedBox(height: limit, child: sheet);
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

  static const height = 44.0;

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
                margin: const EdgeInsets.only(top: 14),
                decoration: BoxDecoration(
                  color: borderColor(context),
                  borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
                ),
              ),
            ),
            if (onClose != null)
              // 36, not 30, and held further in from the edge: at 30 it was
              // under the 44px a finger actually covers, and it sat close
              // enough to the corner to be reached by accident while
              // scrolling the list.
              Positioned(
                top: 4,
                right: UpinoTokens.gutter + 6,
                child: GestureDetector(
                  key: const Key('sheet-close'),
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sunkenColor(context),
                      shape: BoxShape.circle,
                    ),
                    child: const UpinoIcon(
                      'close',
                      size: 19,
                      color: UpinoTokens.textTertiary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
