/// A line chart you can run a finger along (Strategy §8): every chart in the
/// app answers a question, and dragging across it is how the question is
/// asked of a particular day.
///
/// It draws what it is given and nothing else. No figure is worked out here;
/// the caller hands over values already computed by the engine and reads
/// the selected index back to say what they mean.
library;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChartSeries {
  const ChartSeries({
    required this.values,
    required this.color,
    this.width = 2.5,
    this.dashFrom,
    this.fill = false,
    this.dashed = false,
  });

  /// One value per x position; null leaves a gap.
  final List<double?> values;
  final Color color;
  final double width;

  /// Drawn dashed from this index on: where fact ends and projection begins.
  final int? dashFrom;

  /// Dashed all the way, for a comparison line.
  final bool dashed;

  /// Shade the area under the line.
  final bool fill;
}

class ChartMark {
  const ChartMark(this.index, this.color, {this.big = false});
  final int index;
  final Color color;
  final bool big;
}

class ScrubChart extends StatelessWidget {
  const ScrubChart({
    required this.count,
    required this.series,
    required this.selected,
    required this.onSelect,
    this.marks = const [],
    this.markerIndex,
    this.guide,
    this.height = 170,
    this.semanticLabel,
    super.key,
  });

  final int count;
  final List<ChartSeries> series;
  final int selected;
  final ValueChanged<int> onSelect;
  final List<ChartMark> marks;

  /// A vertical line that stays put, such as today.
  final int? markerIndex;

  /// A horizontal line, such as a target.
  final double? guide;
  final double height;
  final String? semanticLabel;

  int _indexAt(double dx, double width, bool rtl) {
    if (count <= 1) return 0;
    final x = rtl ? width - dx : dx;
    return (x / width * (count - 1)).round().clamp(0, count - 1);
  }

  @override
  Widget build(BuildContext context) {
    // Time runs left to right in every language, as on any financial chart:
    // mirrored, a rising line would read as a falling one.
    const rtl = false;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: semanticLabel,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, box) {
            void pick(Offset local) {
              final i = _indexAt(local.dx, box.maxWidth, rtl);
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
                painter: _ChartPainter(
                  count: count,
                  series: series,
                  marks: marks,
                  selected: selected,
                  markerIndex: markerIndex,
                  guide: guide,
                  rtl: rtl,
                  ink: dark ? const Color(0xFFF2F2F4) : const Color(0xFF17171A),
                  faint:
                      dark ? const Color(0xFF2E2E36) : const Color(0xFFE8E8EA),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.count,
    required this.series,
    required this.marks,
    required this.selected,
    required this.markerIndex,
    required this.guide,
    required this.rtl,
    required this.ink,
    required this.faint,
  });

  final int count;
  final List<ChartSeries> series;
  final List<ChartMark> marks;
  final int selected;
  final int? markerIndex;
  final double? guide;
  final bool rtl;
  final Color ink;
  final Color faint;

  static const _markBand = 16.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (count == 0) return;
    final plotHeight = size.height - _markBand;

    var lo = 0.0;
    var hi = guide ?? 0.0;
    for (final s in series) {
      for (final v in s.values) {
        if (v == null) continue;
        if (v < lo) lo = v;
        if (v > hi) hi = v;
      }
    }
    if (hi == lo) hi = lo + 1;
    final span = hi - lo;
    hi += span * 0.08;

    double x(int i) {
      final t = count <= 1 ? 0.5 : i / (count - 1);
      return (rtl ? 1 - t : t) * size.width;
    }

    double y(double v) => plotHeight - (v - lo) / (hi - lo) * plotHeight;

    // Zero, when the lines go below it: below zero means owing.
    if (lo < 0) {
      canvas.drawLine(
        Offset(0, y(0)),
        Offset(size.width, y(0)),
        Paint()
          ..color = faint
          ..strokeWidth = 1,
      );
    }

    if (guide != null) {
      _dashedLine(
        canvas,
        Offset(0, y(guide!)),
        Offset(size.width, y(guide!)),
        Paint()
          ..color = ink.withValues(alpha: 0.35)
          ..strokeWidth = 1.2,
      );
    }

    if (markerIndex != null) {
      _dashedLine(
        canvas,
        Offset(x(markerIndex!), 0),
        Offset(x(markerIndex!), plotHeight),
        Paint()
          ..color = ink.withValues(alpha: 0.25)
          ..strokeWidth = 1,
        dash: 3,
        gap: 4,
      );
    }

    for (final s in series) {
      _drawSeries(canvas, s, x, y, plotHeight);
    }

    // Pay days, bills and the like, along the bottom.
    for (final m in marks) {
      if (m.index < 0 || m.index >= count) continue;
      canvas.drawCircle(
        Offset(x(m.index), size.height - _markBand / 2),
        m.big ? 4 : 2.6,
        Paint()..color = m.color,
      );
    }

    // The finger.
    final sx = x(selected);
    canvas.drawLine(
      Offset(sx, 0),
      Offset(sx, plotHeight),
      Paint()
        ..color = ink.withValues(alpha: 0.55)
        ..strokeWidth = 1.2,
    );
    for (final s in series) {
      if (selected >= s.values.length) continue;
      final v = s.values[selected];
      if (v == null) continue;
      canvas
        ..drawCircle(Offset(sx, y(v)), 5.5, Paint()..color = s.color)
        ..drawCircle(
          Offset(sx, y(v)),
          5.5,
          Paint()
            ..color = faint.computeLuminance() > 0.5
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF1C1C21)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
    }
  }

  void _drawSeries(
    Canvas canvas,
    ChartSeries s,
    double Function(int) x,
    double Function(double) y,
    double plotHeight,
  ) {
    final solid = Path();
    final dashed = Path();
    final area = Path();
    var started = false;
    var areaStarted = false;
    int? lastIndex;
    Offset? last;

    for (var i = 0; i < s.values.length && i < count; i++) {
      final v = s.values[i];
      if (v == null) {
        started = false;
        continue;
      }
      final p = Offset(x(i), y(v));
      final isDashed = s.dashed || (s.dashFrom != null && i > s.dashFrom!);
      final path = isDashed ? dashed : solid;
      if (!started) {
        path.moveTo(p.dx, p.dy);
        started = true;
      } else {
        // Continue from the previous point on whichever path this segment
        // belongs to, so the switch to dashed leaves no gap.
        path
          ..moveTo(last!.dx, last.dy)
          ..lineTo(p.dx, p.dy);
      }
      if (s.fill) {
        if (!areaStarted) {
          area
            ..moveTo(p.dx, plotHeight)
            ..lineTo(p.dx, p.dy);
          areaStarted = true;
        } else {
          area.lineTo(p.dx, p.dy);
        }
      }
      last = p;
      lastIndex = i;
    }

    if (s.fill && areaStarted && last != null && lastIndex != null) {
      area
        ..lineTo(last.dx, plotHeight)
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(0, 0),
            Offset(0, plotHeight),
            [s.color.withValues(alpha: 0.22), s.color.withValues(alpha: 0.0)],
          ),
      );
    }

    final paint = Paint()
      ..color = s.color
      ..strokeWidth = s.width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(solid, paint);
    for (final metric in dashed.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 6), paint);
        d += 10;
      }
    }
  }

  void _dashedLine(
    Canvas canvas,
    Offset a,
    Offset b,
    Paint paint, {
    double dash = 5,
    double gap = 5,
  }) {
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    var d = 0.0;
    while (d < total) {
      final e = (d + dash).clamp(0.0, total);
      canvas.drawLine(a + dir * d, a + dir * e, paint);
      d += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.selected != selected ||
      old.series != series ||
      old.count != count ||
      old.rtl != rtl ||
      old.ink != ink;
}
