/// A column chart you can run a finger along (Strategy §8): one rounded
/// column per day or week, the one under the finger solid, the rest pale.
/// Columns read at a glance where lines turned into noise, and a day is a
/// thing you can point at.
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
    this.ghost,
    this.ghostColor,
    this.alert = const {},
    this.alertColor,
    this.marks = const [],
    this.guide,
    this.height = 150,
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
  final ValueChanged<int> onSelect;
  final Color color;

  /// Positions drawn in [alertColor]: a day something that must be paid is
  /// short.
  final Set<int> alert;
  final Color? alertColor;

  /// Dots under the columns: pay days, a goal's dates.
  final List<BarMark> marks;

  /// A horizontal line, such as a target.
  final double? guide;
  final double height;
  final String? semanticLabel;

  int get count => values.length;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Time runs left to right in every language, as on any financial chart.
    return Semantics(
      label: semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, box) {
            void pick(Offset p) {
              if (count == 0) return;
              final i = (p.dx / box.maxWidth * count)
                  .floor()
                  .clamp(0, count - 1);
              if (i == selected) return;
              if (marks.any((m) => m.index == i)) {
                HapticFeedback.selectionClick();
              }
              onSelect(i);
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
                  ghostColor: ghostColor ?? color.withValues(alpha: 0.14),
                  alert: alert,
                  alertColor: alertColor ?? const Color(0xFFCC2E26),
                  marks: marks,
                  guide: guide,
                  ink: dark ? const Color(0xFFF2F2F4) : const Color(0xFF17171A),
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
    required this.ghostColor,
    required this.alert,
    required this.alertColor,
    required this.marks,
    required this.guide,
    required this.ink,
  });

  final List<double?> values;
  final List<double?>? ghost;
  final int selected;
  final Color color;
  final Color ghostColor;
  final Set<int> alert;
  final Color alertColor;
  final List<BarMark> marks;
  final double? guide;
  final Color ink;

  static const _markBand = 14.0;
  static const _stub = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    final floor = size.height - _markBand;

    var hi = guide ?? 0.0;
    for (final v in [...values, ...?ghost]) {
      if (v != null && v > hi) hi = v;
    }
    if (hi <= 0) hi = 1;
    hi *= 1.08;

    final slot = size.width / n;
    // Thin columns for many days, fuller ones for a few weeks.
    final gapRatio = n > 40 ? 0.34 : 0.28;
    final barW = (slot * (1 - gapRatio)).clamp(2.0, 28.0);
    final radius = Radius.circular(barW / 2);

    double h(double v) => (v / hi * floor).clamp(0.0, floor);

    RRect column(int i, double height) {
      final cx = slot * i + slot / 2;
      final top = floor - (height < _stub ? _stub : height);
      return RRect.fromRectAndCorners(
        Rect.fromLTRB(cx - barW / 2, top, cx + barW / 2, floor),
        topLeft: radius,
        topRight: radius,
        bottomLeft: const Radius.circular(1.5),
        bottomRight: const Radius.circular(1.5),
      );
    }

    if (guide != null) {
      final y = floor - h(guide!);
      final paint = Paint()
        ..color = ink.withValues(alpha: 0.3)
        ..strokeWidth = 1.2;
      for (var x = 0.0; x < size.width; x += 9) {
        canvas.drawLine(Offset(x, y), Offset(x + 4, y), paint);
      }
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
      final base = isAlert ? alertColor : color;
      final chosen = i == selected;
      canvas.drawRRect(
        column(i, v == null ? 0 : h(v)),
        Paint()
          ..color = chosen
              ? base
              : base.withValues(alpha: g != null ? 0.55 : 0.32),
      );
    }

    // A soft halo over the chosen column, so it reads without a cursor.
    final sv = values[selected];
    if (sv != null) {
      final r = column(selected, h(sv)).inflate(3);
      canvas.drawRRect(
        r,
        Paint()
          ..color = color.withValues(alpha: 0.16)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }

    // The floor, and the marks under it.
    canvas.drawLine(
      Offset(0, floor + 0.5),
      Offset(size.width, floor + 0.5),
      Paint()
        ..color = ink.withValues(alpha: 0.08)
        ..strokeWidth = 1,
    );
    for (final m in marks) {
      if (m.index < 0 || m.index >= n) continue;
      canvas.drawCircle(
        Offset(slot * m.index + slot / 2, size.height - _markBand / 2 + 1),
        2.8,
        Paint()..color = m.color,
      );
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.selected != selected ||
      old.values != values ||
      old.ghost != ghost ||
      old.color != color ||
      old.ink != ink;
}
