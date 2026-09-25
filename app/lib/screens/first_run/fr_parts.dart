/// Pieces shared by the first-run screens: the waterfall that is their
/// signature, the big amount field, the day strip and the tiles.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design/icon.dart';
import '../../design/parts.dart';
import '../../design/theme.dart';
import '../../design/tokens.dart';
import '../../engine/clock.dart';
import '../../engine/money.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/dates.dart';

const lime = UpinoTokens.lime;
const _ease = Cubic(0.23, 1, 0.32, 1);

Color inkOf(BuildContext c) =>
    isDark(c) ? UpinoTokens.darkTextPrimary : UpinoTokens.textPrimary;
Color subOf(BuildContext c) =>
    isDark(c) ? UpinoTokens.darkTextSecondary : UpinoTokens.textSecondary;
Color tertOf(BuildContext c) =>
    isDark(c) ? const Color(0xFF6E6E78) : UpinoTokens.textTertiary;
Color blueOf(BuildContext c) =>
    isDark(c) ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
Color pageOf(BuildContext c) =>
    isDark(c) ? UpinoTokens.darkSurfacePage : UpinoTokens.surfacePage;

/// One tier of the waterfall.
class Tier {
  const Tier(this.label, this.share);
  final String label;

  /// How much of the source this tier takes, 0–1.
  final double share;
}

/// The money pouring down: a source bar, tiers each taking their share, and
/// what is left pooling in lime. [t] runs 0→4: the source fills (0–1), the
/// tiers take their share one after another (1–3), the pool appears (3–4).
class WaterfallPainter extends CustomPainter {
  WaterfallPainter({
    required this.t,
    required this.source,
    required this.tiers,
    required this.pool,
    required this.poolLabel,
    required this.dark,
  });

  final double t;
  final String source;
  final List<Tier> tiers;
  final String pool;
  final String poolLabel;
  final bool dark;

  static double _seg(double t, double a, double b) =>
      _ease.transform(((t - a) / (b - a)).clamp(0.0, 1.0));

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final rows = tiers.length + 2;
    const gap = 16.0;
    final poolH = 64.0;
    final rowH = (size.height - poolH - gap * (rows - 1)) / (rows - 1);
    final track = dark ? const Color(0xFF141418) : Colors.white;
    final edge = dark ? const Color(0xFF26262C) : const Color(0xFFE6E6EA);
    const blue = Color(0xFF2F3AE8);
    final ink = dark ? UpinoTokens.darkTextPrimary : UpinoTokens.textPrimary;
    final sub =
        dark ? UpinoTokens.darkTextSecondary : UpinoTokens.textSecondary;
    final r = Radius.circular(rowH * 0.34);

    void text(
      String s,
      Offset at,
      Color c,
      double size,
      FontWeight wt, {
      double spacing = 0,
      double? maxW,
      TextAlign align = TextAlign.left,
    }) {
      final tp = TextPainter(
        text: TextSpan(
          text: s,
          style: TextStyle(
            color: c,
            fontSize: size,
            fontWeight: wt,
            letterSpacing: spacing,
            fontFamily: 'Geist',
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: align,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: maxW ?? w);
      final dx = align == TextAlign.right ? at.dx - tp.width : at.dx;
      tp.paint(canvas, Offset(dx, at.dy - tp.height / 2));
    }

    // Source.
    final s0 = _seg(t, 0, 1);
    final srcRect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, rowH), r);
    canvas.drawRRect(srcRect, Paint()..color = track);
    canvas.drawRRect(
        srcRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = edge,);
    canvas.save();
    canvas.clipRRect(srcRect);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w * s0, rowH),
      Paint()
        ..color = (dark ? const Color(0xFF1E1E23) : const Color(0xFFF1F1F4)),
    );
    canvas.restore();
    text(source, Offset(16, rowH / 2), ink.withValues(alpha: s0), 15,
        FontWeight.w600,);

    // Tiers: each takes its share from the left edge of what is still free,
    // so the fills step right like water finding its level.
    var start = 0.0;
    var prevY = rowH;
    for (var i = 0; i < tiers.length; i++) {
      final y = (rowH + gap) * (i + 1);
      final a = 1 + i * (2 / tiers.length);
      final p = _seg(t, a, a + 0.9);
      final rect = RRect.fromRectAndRadius(Rect.fromLTWH(0, y, w, rowH), r);
      final appear = _seg(t, a - 0.3, a + 0.2);
      canvas.drawRRect(rect, Paint()..color = track.withValues(alpha: appear));
      canvas.drawRRect(
        rect,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = edge.withValues(alpha: appear),
      );
      final fillW = w * tiers[i].share;
      final x = w * start;
      // The stream from the tier above into this one.
      if (p > 0) {
        final sw = math.max(6.0, fillW * 0.22);
        final sx = x + fillW / 2 - sw / 2;
        final streamRect = Rect.fromLTWH(sx, prevY, sw, (y - prevY) * p + 2);
        canvas.drawRRect(
          RRect.fromRectAndRadius(streamRect, Radius.circular(sw / 2)),
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                blue.withValues(alpha: 0.9),
                blue.withValues(alpha: 0.3),
              ],
            ).createShader(streamRect),
        );
      }
      canvas.save();
      canvas.clipRRect(rect);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, fillW * p, rowH), r),
        Paint()..color = blue.withValues(alpha: 0.95 - i * 0.2),
      );
      canvas.restore();
      text(
        tiers[i].label,
        Offset(14, y + rowH / 2),
        (p > 0.5 && x < 40 ? Colors.white : sub).withValues(alpha: appear),
        12.5,
        FontWeight.w600,
      );
      start += tiers[i].share;
      prevY = y + rowH;
    }

    // The pool: what is left, in lime.
    final py = (rowH + gap) * (tiers.length + 1);
    final pp = _seg(t, 3, 4);
    if (pp > 0) {
      final sx = w * start + (w * (1 - start)) / 2;
      final streamRect = Rect.fromLTWH(sx - 4, prevY, 8, (py - prevY) * pp + 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(streamRect, const Radius.circular(4)),
        Paint()..color = lime.withValues(alpha: 0.7),
      );
      final scale = 0.94 + 0.06 * pp;
      canvas.save();
      canvas.translate(w / 2, py + poolH / 2);
      canvas.scale(scale);
      canvas.translate(-w / 2, -(py + poolH / 2));
      final poolRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, py, w, poolH),
        const Radius.circular(20),
      );
      canvas.drawRRect(poolRect, Paint()..color = lime.withValues(alpha: pp));
      text(
        poolLabel,
        Offset(18, py + 20),
        const Color(0xFF0F1012).withValues(alpha: pp),
        10,
        FontWeight.w700,
        spacing: 1.4,
      );
      text(
        pool,
        Offset(18, py + 44),
        const Color(0xFF0F1012).withValues(alpha: pp),
        24,
        FontWeight.w700,
        spacing: -0.8,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(WaterfallPainter old) =>
      old.t != t || old.dark != dark || old.source != source;
}

/// A big amount, typed: the number is the design, the field disappears.
class BigAmountField extends StatelessWidget {
  const BigAmountField({
    required this.controller,
    required this.currency,
    required this.onChanged,
    this.autofocus = false,
    this.size = 44,
    this.fieldKey,
    super.key,
  });

  final TextEditingController controller;
  final String currency;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final double size;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final symbol = Currency.of(currency).symbol;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          symbol,
          style: TextStyle(
            fontSize: size * 0.62,
            fontWeight: FontWeight.w600,
            color: tertOf(context),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: TextField(
            key: fieldKey,
            controller: controller,
            autofocus: autofocus,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            cursorColor: blueOf(context),
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w700,
              letterSpacing: -size * 0.045,
              color: inkOf(context),
              fontFeatures: moneyFeatures,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle:
                  TextStyle(color: tertOf(context).withValues(alpha: 0.5)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}

Money? readMoney(String text, String currency) {
  final t = text.trim();
  if (t.isEmpty) return null;
  try {
    return Money.parse(t, currency);
  } on ArgumentError {
    return null;
  } on FormatException {
    return null;
  }
}

String plainAmount(Money? m) =>
    m == null ? '' : m.display(withSymbol: false, grouped: false);

/// The next [days] days as tappable tiles: dates are chosen, not typed.
class DayStrip extends StatefulWidget {
  const DayStrip({
    required this.from,
    required this.days,
    required this.selected,
    required this.onSelect,
    this.marks = const {},
    super.key,
  });

  final LocalDate from;
  final int days;
  final LocalDate? selected;
  final ValueChanged<LocalDate> onSelect;

  /// Days already carrying something (the next pay, say), dotted.
  final Set<LocalDate> marks;

  @override
  State<DayStrip> createState() => _DayStripState();
}

class _DayStripState extends State<DayStrip> {
  late final _scroll = ScrollController(
    initialScrollOffset: widget.selected == null
        ? 0
        : math.max(0, widget.selected!.differenceInDays(widget.from) - 2) *
            54.0,
  );

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.builder(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        itemCount: widget.days,
        itemBuilder: (context, i) {
          final d = widget.from.addDays(i);
          final on = d == widget.selected;
          final showMonth = i == 0 || isMonthStart(context, d);
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Pressable(
              scale: 0.94,
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onSelect(d);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: _ease,
                width: 48,
                decoration: BoxDecoration(
                  color: on ? lime : sunkenColor(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      showMonth ? formatMonthShort(context, d) : formatWeekdayNarrow(context, d),
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: on ? const Color(0xFF0F1012) : tertOf(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDayNumber(context, d),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: on ? const Color(0xFF0F1012) : inkOf(context),
                        fontFeatures: moneyFeatures,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.marks.contains(d)
                            ? (on ? const Color(0xFF0F1012) : blueOf(context))
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// A soft pill, one of several.
class Pick extends StatelessWidget {
  const Pick(
      {required this.label, required this.on, required this.onTap, super.key,});
  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Pressable(
        scale: 0.95,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: on ? inkOf(context) : sunkenColor(context),
            borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: on ? pageOf(context) : subOf(context),
            ),
          ),
        ),
      );
}

/// An icon in its own soft square.
class IconTile extends StatelessWidget {
  const IconTile(this.icon, {this.on = false, this.size = 40, super.key});
  final String icon;
  final bool on;
  final double size;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? blueOf(context) : sunkenColor(context),
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: UpinoIcon(icon,
            size: size * 0.5, color: on ? Colors.white : subOf(context),),
      );
}

/// Fades and lifts its child in, [delay] after it is first built.
class Arrive extends StatefulWidget {
  const Arrive(
      {required this.child,
      this.delay = Duration.zero,
      this.dy = 14,
      super.key,});
  final Widget child;
  final Duration delay;
  final double dy;

  @override
  State<Arrive> createState() => _ArriveState();
}

class _ArriveState extends State<Arrive> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 520),);

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (context, child) {
        final v = _ease.transform(_c.value);
        return Opacity(
          opacity: v,
          child: Transform.translate(
              offset: Offset(0, widget.dy * (1 - v)), child: child,),
        );
      },
    );
  }
}

/// The primary wide button of the flow.
class FlowButton extends StatelessWidget {
  const FlowButton({
    required this.label,
    required this.onTap,
    this.style = FlowButtonStyle.primary,
    this.buttonKey,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final FlowButtonStyle style;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final (bg, fg) = switch (style) {
      FlowButtonStyle.primary => enabled
          ? (blueOf(context), Colors.white)
          : (sunkenColor(context), tertOf(context)),
      FlowButtonStyle.light => (inkOf(context), pageOf(context)),
      FlowButtonStyle.quiet => (cardColor(context), inkOf(context)),
    };
    return Pressable(
      key: buttonKey,
      onTap: onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onTap!();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),),
        child: Text(label,
            style: TextStyle(
                color: fg, fontSize: 15.5, fontWeight: FontWeight.w700,),),
      ),
    );
  }
}

enum FlowButtonStyle { primary, light, quiet }

/// The Upino mark, drawn.
class Mark extends StatelessWidget {
  const Mark({this.size = 48, super.key});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: UpinoTokens.actionPrimary,
          borderRadius: BorderRadius.circular(size * 0.3),
        ),
        child: CustomPaint(painter: _U()),
      );
}

class _U extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.width * 0.12
      ..strokeCap = StrokeCap.round;
    final l = s.width * 0.3,
        r = s.width * 0.7,
        top = s.height * 0.26,
        bot = s.height * 0.56;
    final path = Path()
      ..moveTo(l, top)
      ..lineTo(l, bot)
      ..arcToPoint(Offset(r, bot),
          radius: Radius.circular((r - l) / 2), clockwise: false,)
      ..lineTo(r, top);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(_U old) => false;
}

/// Lime with the light turned down: the watermark tone, for small marks
/// that should be seen but not shout.
Color mutedLime(BuildContext c) =>
    isDark(c) ? const Color(0xFF6E7F45) : const Color(0xFF8AA05A);

/// A compact choice tile for the language and currency grids.
Widget pickTile(
  BuildContext context, {
  required String title,
  required String sub,
  required VoidCallback onTap,
  String? glyph,
  Key? key,
}) =>
    Pressable(
      key: key,
      scale: 0.95,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(11, 9, 10, 9),
        decoration: BoxDecoration(
          color: cardColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            if (glyph != null)
              Positioned(
                right: 0,
                top: 0,
                child: Text(glyph,
                    style: TextStyle(
                      fontSize: glyph.length > 1 ? 15 : 22,
                      fontWeight: FontWeight.w700,
                      color: mutedLime(context),
                    ),),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (glyph == null)
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600,
                          color: isDark(context) ? const Color(0xFFB2B2BB) : inkOf(context),),)
                else
                  const SizedBox.shrink(),
                Text(sub, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.1,
                    color: glyph == null ? mutedLime(context) : tertOf(context),),),
              ],
            ),
          ],
        ),
      ),
    );

/// Swaps its child when [id] changes: the new one rises in from [from]
/// while the old one leaves the other way, so a choice visibly travels.
class SwapSlot extends StatelessWidget {
  const SwapSlot({required this.id, required this.child, this.fromBelow = true, super.key});
  final Object id;
  final Widget child;
  final bool fromBelow;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        reverseDuration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (current, previous) => Stack(
          fit: StackFit.passthrough,
          children: [...previous, if (current != null) current],
        ),
        transitionBuilder: (child, a) {
          final entering = child.key == ValueKey(id);
          final dy = (fromBelow ? 1 : -1) * (entering ? 0.28 : -0.28);
          return FadeTransition(
            opacity: a,
            child: SlideTransition(
              position: Tween(begin: Offset(0, dy), end: Offset.zero).animate(a),
              child: ScaleTransition(scale: Tween(begin: 0.94, end: 1.0).animate(a), child: child),
            ),
          );
        },
        child: KeyedSubtree(key: ValueKey(id), child: child),
      );
}

/// The big faint mark in a hero card, sized so the ink sits the same
/// [margin] from the card's top, bottom and right edges. The text box is
/// taller than its capitals, so it is stretched past the card and nudged
/// right by the glyph's side bearing.
class HeroGlyph extends StatelessWidget {
  const HeroGlyph(this.text, {required this.color, this.cardHeight = 176, this.margin = 18, super.key});
  final String text;
  final Color color;
  final double cardHeight;
  final double margin;

  /// Capital height over the text box, and the right bearing, both measured.
  static const _ink = 0.564;
  static const _bearing = 0.036;

  @override
  Widget build(BuildContext context) {
    final box = (cardHeight - 2 * margin) / _ink;
    final over = (cardHeight - box) / 2;
    return Positioned(
      top: over,
      bottom: over,
      right: margin - _bearing * box,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        alignment: Alignment.centerRight,
        child: Text(
          text,
          textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false, applyHeightToLastDescent: false,),
          style: TextStyle(fontSize: 200, height: 0.74, fontWeight: FontWeight.w700, color: color),
        ),
      ),
    );
  }
}

/// The app's strings, from anywhere a context is at hand.
extension FirstRunStrings on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this);
}
