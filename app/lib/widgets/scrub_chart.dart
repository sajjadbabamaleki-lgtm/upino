/// A line chart you can run a finger along (Strategy §8): every chart in the
/// app answers a question, and dragging across it is how the question is
/// asked of a particular day.
///
/// It draws what it is given and nothing else. No figure is worked out here;
/// the caller hands over values already computed by the engine and reads
/// the selected index back to say what they mean.
library;

import 'dart:math' as math;
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
    this.prominent = true,
  });

  /// One value per x position; null leaves a gap.
  final List<double?> values;
  final Color color;
  final double width;

  /// Where fact ends and projection begins. Kept for callers; the chart
  /// shows it as a shaded zone from the marker on rather than as dashes.
  final int? dashFrom;

  /// Dashed all the way, for a comparison line.
  final bool dashed;

  /// Shade the area under the line.
  final bool fill;

  /// Gets a dot under the finger. A background line, such as the balance
  /// behind the room to spend, does not.
  final bool prominent;
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

  static const _markBand = 18.0;
  static const _top = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (count == 0) return;
    final plotBottom = size.height - _markBand;
    final plotHeight = plotBottom - _top;

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
    hi += (hi - lo) * 0.06;

    double x(int i) {
      final t = count <= 1 ? 0.5 : i / (count - 1);
      return (rtl ? 1 - t : t) * size.width;
    }

    double y(double v) => _top + plotHeight - (v - lo) / (hi - lo) * plotHeight;

    // Ahead of the marker is projection: a faint wash rather than dashes,
    // which break a line into noise wherever it turns.
    final m = markerIndex;
    // Only when there is a past to set it against; otherwise the whole
    // chart would be one grey box.
    if (m != null && m > 0 && m < count - 1) {
      final left = x(m);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(left, 0, size.width, plotBottom),
          topRight: const Radius.circular(12),
        ),
        Paint()..color = ink.withValues(alpha: 0.035),
      );
    }

    // A quiet floor, and zero when the lines go below it.
    canvas.drawLine(
      Offset(0, plotBottom),
      Offset(size.width, plotBottom),
      Paint()
        ..color = faint
        ..strokeWidth = 1,
    );
    if (lo < 0) {
      _dashedLine(
        canvas,
        Offset(0, y(0)),
        Offset(size.width, y(0)),
        Paint()
          ..color = ink.withValues(alpha: 0.25)
          ..strokeWidth = 1,
      );
    }

    if (guide != null) {
      _dashedLine(
        canvas,
        Offset(0, y(guide!)),
        Offset(size.width, y(guide!)),
        Paint()
          ..color = ink.withValues(alpha: 0.3)
          ..strokeWidth = 1.2,
      );
    }

    if (m != null) {
      canvas.drawLine(
        Offset(x(m), _top - 4),
        Offset(x(m), plotBottom),
        Paint()
          ..color = ink.withValues(alpha: 0.18)
          ..strokeWidth = 1,
      );
    }

    for (final s in series) {
      _drawSeries(canvas, s, x, y, plotBottom);
    }

    // Pay days and bills along the floor.
    for (final mark in marks) {
      if (mark.index < 0 || mark.index >= count) continue;
      final c = Offset(x(mark.index), size.height - _markBand / 2 + 1);
      if (mark.big) {
        canvas
          ..drawCircle(
              c, 5, Paint()..color = mark.color.withValues(alpha: 0.18),)
          ..drawCircle(c, 2.8, Paint()..color = mark.color);
      } else {
        canvas.drawCircle(c, 2.2, Paint()..color = mark.color);
      }
    }

    // The finger: a soft line, and a ringed dot on each line it crosses.
    final sx = x(selected);
    canvas.drawLine(
      Offset(sx, _top - 4),
      Offset(sx, plotBottom),
      Paint()
        ..color = ink.withValues(alpha: 0.35)
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );
    final ring = faint.computeLuminance() > 0.5
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF1C1C21);
    for (final s in series) {
      if (selected >= s.values.length || s.dashed || !s.prominent) continue;
      final v = s.values[selected];
      if (v == null) continue;
      final p = Offset(sx, y(v));
      canvas
        ..drawCircle(p, 9, Paint()..color = s.color.withValues(alpha: 0.16))
        ..drawCircle(p, 5.5, Paint()..color = ring)
        ..drawCircle(p, 3.8, Paint()..color = s.color);
    }
    for (final s in series) {
      if (selected >= s.values.length || !s.dashed) continue;
      final v = s.values[selected];
      if (v == null) continue;
      final p = Offset(sx, y(v));
      canvas
        ..drawCircle(p, 5, Paint()..color = ring)
        ..drawCircle(p, 3.4, Paint()..color = s.color);
    }
  }

  /// A smooth path through the points that never overshoots them
  /// (monotone cubic, Fritsch–Carlson): a flat stretch stays flat and a
  /// step stays a step, only with its corners eased.
  static Path _smooth(List<Offset> p) {
    final path = Path()..moveTo(p.first.dx, p.first.dy);
    if (p.length == 1) return path;
    if (p.length == 2) return path..lineTo(p[1].dx, p[1].dy);
    final n = p.length;
    final d = List<double>.generate(n - 1, (i) {
      final h = p[i + 1].dx - p[i].dx;
      return h == 0 ? 0 : (p[i + 1].dy - p[i].dy) / h;
    });
    final m = List<double>.filled(n, 0);
    m[0] = d[0];
    m[n - 1] = d[n - 2];
    for (var i = 1; i < n - 1; i++) {
      m[i] = d[i - 1] * d[i] <= 0 ? 0 : (d[i - 1] + d[i]) / 2;
    }
    for (var i = 0; i < n - 1; i++) {
      if (d[i] == 0) {
        m[i] = 0;
        m[i + 1] = 0;
        continue;
      }
      final a = m[i] / d[i];
      final b = m[i + 1] / d[i];
      final r = a * a + b * b;
      if (r > 9) {
        final t = 3 / math.sqrt(r);
        m[i] = t * a * d[i];
        m[i + 1] = t * b * d[i];
      }
    }
    for (var i = 0; i < n - 1; i++) {
      final h = (p[i + 1].dx - p[i].dx) / 3;
      path.cubicTo(
        p[i].dx + h,
        p[i].dy + m[i] * h,
        p[i + 1].dx - h,
        p[i + 1].dy - m[i + 1] * h,
        p[i + 1].dx,
        p[i + 1].dy,
      );
    }
    return path;
  }

  void _drawSeries(
    Canvas canvas,
    ChartSeries s,
    double Function(int) x,
    double Function(double) y,
    double plotBottom,
  ) {
    // Runs of consecutive values; a null starts a new run.
    final runs = <List<Offset>>[];
    var run = <Offset>[];
    for (var i = 0; i < s.values.length && i < count; i++) {
      final v = s.values[i];
      if (v == null) {
        if (run.isNotEmpty) runs.add(run);
        run = [];
        continue;
      }
      run.add(Offset(x(i), y(v)));
    }
    if (run.isNotEmpty) runs.add(run);
    if (rtl) {
      for (final r in runs) {
        r.sort((a, b) => a.dx.compareTo(b.dx));
      }
    }

    final line = Paint()
      ..color = s.color
      ..strokeWidth = s.width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final r in runs) {
      final path = _smooth(r);
      if (s.fill) {
        final area = Path.from(path)
          ..lineTo(r.last.dx, plotBottom)
          ..lineTo(r.first.dx, plotBottom)
          ..close();
        final top = r.map((p) => p.dy).reduce((a, b) => a < b ? a : b);
        canvas.drawPath(
          area,
          Paint()
            ..shader = ui.Gradient.linear(
              Offset(0, top),
              Offset(0, plotBottom),
              [
                s.color.withValues(alpha: 0.28),
                s.color.withValues(alpha: 0.02),
              ],
            ),
        );
      }
      if (s.dashed) {
        for (final metric in path.computeMetrics()) {
          var dist = 0.0;
          while (dist < metric.length) {
            canvas.drawPath(metric.extractPath(dist, dist + 7), line);
            dist += 12;
          }
        }
      } else {
        canvas.drawPath(path, line);
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
