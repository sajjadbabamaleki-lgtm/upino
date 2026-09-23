/// How things arrive.
///
/// Asked for after using the build on a phone: everything was correct and
/// nothing moved. A screen whose contents are simply there reads as a
/// document; the same contents arriving read as an app that was waiting for
/// you. The movement is small on purpose — 12px and a fade, not a slide
/// across the screen — because it has to survive being seen twenty times a
/// day.
library;

import 'package:flutter/material.dart';

class UpinoMotion {
  const UpinoMotion._();

  /// One card's entrance. Long enough to be seen, short enough that the
  /// screen is settled before a thumb can reach it.
  static const enter = Duration(milliseconds: 340);

  /// Between one card and the next. Eight cards finish 280ms after the
  /// first, so the stagger reads as one movement rather than a queue.
  static const stagger = Duration(milliseconds: 40);

  /// Past this the stagger stops growing: on a long list the tenth row
  /// should not wait half a second for its turn.
  static const maxStaggered = 8;

  static const curve = Curves.easeOutCubic;

  /// The distance travelled. Up, because the content is arriving from the
  /// page rather than falling onto it.
  static const rise = 12.0;
}

/// Fades and lifts its child into place the first time it is built.
///
/// Inside a lazy list this means a row animates when it is first scrolled
/// into view, which is what the eye expects: the row was not there, and now
/// it is.
class Reveal extends StatefulWidget {
  const Reveal({required this.child, this.index = 0, super.key});

  final Widget child;

  /// Position in the stagger, not position in the list: pass 0 for anything
  /// that should arrive first.
  final int index;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    // The wait is an Interval inside one controller rather than a delayed
    // timer: a timer that has not fired when a widget test ends is reported
    // as a leak, and every screen would be carrying one.
    final step = widget.index.clamp(0, UpinoMotion.maxStaggered);
    final wait = UpinoMotion.stagger * step;
    final total = wait + UpinoMotion.enter;
    _c = AnimationController(vsync: this, duration: total);
    _t = CurvedAnimation(
      parent: _c,
      curve: Interval(
        wait.inMicroseconds / total.inMicroseconds,
        1,
        curve: UpinoMotion.curve,
      ),
    );
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Someone who has asked their phone to stop animating gets the content,
    // not a slower version of the same effect.
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return AnimatedBuilder(
      animation: _t,
      builder: (context, child) => Opacity(
        opacity: _t.value,
        child: Transform.translate(
          offset: Offset(0, UpinoMotion.rise * (1 - _t.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Maps a list of children through [Reveal], giving each one the next place
/// in the stagger. A bare spacer takes no place: it has nothing to fade in,
/// and counting it would leave holes in the rhythm.
List<Widget> revealed(List<Widget> children) {
  var i = 0;
  return [
    for (final child in children)
      if (child is SizedBox && child.child == null)
        child
      else
        Reveal(index: i++, child: child),
  ];
}

/// The scrolling itself.
///
/// Android's default stops dead at the end of a list and answers an overscroll
/// with a glow at the edge. The bouncing simulation carries its momentum
/// further and gives the end of a list somewhere to go, which is most of what
/// "smooth" means when someone says a list feels stiff.
class UpinoScrollBehavior extends MaterialScrollBehavior {
  const UpinoScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      );

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      // The list already answers an overscroll by moving; a glow on top of
      // that is two answers to one gesture.
      child;
}
