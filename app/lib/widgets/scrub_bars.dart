/// A column chart you can run a finger along (Strategy §8): grey columns,
/// the one under the finger in colour with its figure in a pill above it.
/// Columns read at a glance, and a day, a week or a month is a thing you
/// can point at.
///
/// It draws what it is given and nothing else: the caller hands over values
/// the engine computed and reads the selected index back.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarMark {
  const BarMark(this.index, this.color);
  final int index;
  final Color color;
}

class ScrubBars extends StatelessWidget {
  const ScrubBars({
    required this.values,
    required this.selected,
    required this.onSelect,
    required this.color,
    this.restColor,
    this.ghost,
    this.ghostColor,
    this.alert = const {},
    this.alertColor,
    this.marks = const [],
    this.labels,
    this.pill,
    this.guide,
    this.guideLabel,
    this.height = 150,
    this.maxBarWidth = 28,
    this.semanticLabel,
    super.key,
  });

  /// One column per position; null draws a stub.
  final List<double?> values;

  /// Drawn pale behind each column: what it would be otherwise, such as the
  /// plan without a purchase.
  final List<double?>? ghost;
  final Color? ghostColor;

  final int selected;
  final ValueChanged<int>? onSelect;

  /// The chosen column.
  final Color color;

  /// Every other column; a neutral grey unless given.
  final Color? restColor;

  /// Positions drawn in [alertColor] when chosen, and tinted with it when
  /// not: a day something that must be paid is short.
  final Set<int> alert;
  final Color? alertColor;

  /// Dots under the columns: pay days, a goal's dates.
  final List<BarMark> marks;

  /// A word under each column, such as a weekday or a month; the chosen one
  /// sits in a pill.
  final List<String>? labels;

  /// The figure shown in a pill above the chosen column.
  final String? pill;

  /// A dotted horizontal line, such as a target or an average, with an
  /// optional tag at its start.
  final double? guide;
  final String? guideLabel;
  final double height;
  final double maxBarWidth;
  final String? semanticLabel;

  int get count => values.length;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final ink = dark ? const Color(0xFFF2F2F4) : const Color(0xFF17171A);
    // Time runs left to right in every language, as on any financial chart.
    return Semantics(
      label: semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, box) {
            void pick(Offset p) {
              final select = onSelect;
              if (count == 0 || select == null) return;
              final i =
                  (p.dx / box.maxWidth * count).floor().clamp(0, count - 1);
              if (i == selected) return;
              if (marks.any((m) => m.index == i)) {
                HapticFeedback.selectionClick();
              }
              select(i);
            }

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => pick(d.localPosition),
              onHorizontalDragStart: (d) => pick(d.localPosition),
              onHorizontalDragUpdate: (d) => pick(d.localPosition),
              child: CustomPaint(
                size: Size(box.maxWidth, height),
                painter: _BarsPainter(
                  values: values,
                  ghost: ghost,
                  selected: selected,
                  color: color,
                  rest: restColor ?? ink.withValues(alpha: dark ? 0.16 : 0.09),
                  ghostColor: ghostColor ?? color.withValues(alpha: 0.14),
                  alert: alert,
                  alertColor: alertColor ?? const Color(0xFFCC2E26),
                  marks: marks,
                  labels: labels,
                  pill: pill,
                  guide: guide,
                  guideLabel: guideLabel,
                  maxBarWidth: maxBarWidth,
                  ink: ink,
                  labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: ink.withValues(alpha: 0.55),
                          ) ??
                      const TextStyle(fontSize: 11),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required this.values,
    required this.ghost,
    required this.selected,
    required this.color,
    required this.rest,
    required this.ghostColor,
    required this.alert,
    required this.alertColor,
    required this.marks,
    required this.labels,
    required this.pill,
    required this.guide,
    required this.guideLabel,
    required this.maxBarWidth,
    required this.ink,
    required this.labelStyle,
  });

  final List<double?> values;
  final List<double?>? ghost;
  final int selected;
  final Color color;
  final Color rest;
  final Color ghostColor;
  final Set<int> alert;
  final Color alertColor;
  final List<BarMark> marks;
  final List<String>? labels;
  final String? pill;
  final double? guide;
  final String? guideLabel;
  final double maxBarWidth;
  final Color ink;
  final TextStyle labelStyle;

  static const _stub = 3.0;

  TextPainter _text(String s, TextStyle style) => TextPainter(
      text: TextSpan(text: s, style: style), textDirection: TextDirection.ltr,)
    ..layout();

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final bottomBand = labels != null ? 22.0 : (marks.isNotEmpty ? 14.0 : 2.0);
    final topBand = pill != null ? 30.0 : 4.0;
    final floor = size.height - bottomBand;
    final usable = floor - topBand;

    var hi = guide ?? 0.0;
    for (final v in [...values, ...?ghost]) {
      if (v != null && v > hi) hi = v;
    }
    if (hi <= 0) hi = 1;
    hi *= 1.04;

    final slot = size.width / n;
    final gapRatio = n > 40 ? 0.34 : 0.3;
    final barW = (slot * (1 - gapRatio)).clamp(2.0, maxBarWidth);
    final radius = Radius.circular(barW / 2 > 8 ? 8 : barW / 2);

    double h(double v) => (v / hi * usable).clamp(0.0, usable);
    double cx(int i) => slot * i + slot / 2;

    RRect column(int i, double height) {
      final top = floor - (height < _stub ? _stub : height);
      return RRect.fromRectAndCorners(
        Rect.fromLTRB(cx(i) - barW / 2, top, cx(i) + barW / 2, floor),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );
    }

    // What it would be otherwise, pale, behind.
    final g = ghost;
    if (g != null) {
      for (var i = 0; i < n && i < g.length; i++) {
        final v = g[i];
        if (v == null) continue;
        canvas.drawRRect(column(i, h(v)), Paint()..color = ghostColor);
      }
    }

    for (var i = 0; i < n; i++) {
      final v = values[i];
      final isAlert = alert.contains(i);
      final chosen = i == selected;
      final fill = chosen
          ? (isAlert ? alertColor : color)
          : (isAlert ? alertColor.withValues(alpha: 0.35) : rest);
      canvas.drawRRect(column(i, v == null ? 0 : h(v)), Paint()..color = fill);
    }

    // The dotted line, drawn over the columns so it reads across them.
    if (guide != null) {
      final y = floor - h(guide!);
      final paint = Paint()
        ..color = ink.withValues(alpha: 0.45)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      var start = 0.0;
      final tag = guideLabel;
      if (tag != null) {
        final t = _text(
          tag,
          labelStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        );
        final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(0, y - t.height / 2 - 3, t.width + 12, t.height + 6),
          const Radius.circular(6),
        );
        canvas.drawRRect(r, Paint()..color = ink.withValues(alpha: 0.85));
        t.paint(canvas, Offset(6, y - t.height / 2));
        start = r.right + 4;
      }
      for (var x = start; x < size.width; x += 5) {
        canvas.drawCircle(Offset(x, y), 0.9, paint);
      }
    }

    // The chosen column's figure, in a pill above it.
    final sv = values[selected];
    final label = pill;
    if (label != null && sv != null) {
      final t = _text(
        label,
        labelStyle.copyWith(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      );
      final w = t.width + 14;
      final hgt = t.height + 8;
      final top = floor - (h(sv) < _stub ? _stub : h(sv)) - hgt - 6;
      var left = cx(selected) - w / 2;
      if (left < 0) left = 0;
      if (left + w > size.width) left = size.width - w;
      final c = alert.contains(selected) ? alertColor : color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, w, hgt),
          const Radius.circular(8),
        ),
        Paint()..color = c,
      );
      // A small notch pointing at the column.
      final nx = cx(selected).clamp(left + 8, left + w - 8);
      final notch = Path()
        ..moveTo(nx - 4, top + hgt)
        ..lineTo(nx + 4, top + hgt)
        ..lineTo(nx, top + hgt + 4)
        ..close();
      canvas.drawPath(notch, Paint()..color = c);
      t.paint(canvas, Offset(left + 7, top + 4));
    }

    // Marks and labels under the floor.
    for (final m in marks) {
      if (m.index < 0 || m.index >= n) continue;
      canvas.drawCircle(
        Offset(cx(m.index), floor + 8),
        2.6,
        Paint()..color = m.color,
      );
    }
    final ls = labels;
    if (ls != null) {
      // With many columns, only every few is labelled.
      final every = (n / 8).ceil().clamp(1, n);
      for (var i = 0; i < n && i < ls.length; i++) {
        final chosen = i == selected;
        if (!chosen && i % every != 0 && i != n - 1) continue;
        final t = _text(
          ls[i],
          chosen
              ? labelStyle.copyWith(color: color, fontWeight: FontWeight.w700)
              : labelStyle,
        );
        final x = cx(i) - t.width / 2;
        final y = floor + 6;
        if (chosen) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x - 7, y - 2, t.width + 14, t.height + 4),
              const Radius.circular(8),
            ),
            Paint()..color = color.withValues(alpha: 0.12),
          );
        }
        t.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.selected != selected ||
      old.values != values ||
      old.ghost != ghost ||
      old.color != color ||
      old.pill != pill ||
      old.ink != ink;
}
