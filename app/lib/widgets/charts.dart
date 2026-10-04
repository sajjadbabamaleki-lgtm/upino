/// The app's other charts (Strategy §8), each answering one question:
///
/// * [SegmentGauge] — how far along is this? A half ring of segments.
/// * [SignedBars] — what came in and what went out, week by week?
/// * [Lollipops] — what falls due, when, and how big is each?
/// * [AreaLine] — how has the balance moved?
///
/// Like the column chart, each draws what it is given and works nothing
/// out. Time runs left to right in every language.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color _ink(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFF2F2F4)
        : const Color(0xFF17171A);

// --- gauge -------------------------------------------------------------------

/// A half ring of rounded segments, lit up to [value] (0 to 1), with
/// whatever the caller puts in the middle.
class SegmentGauge extends StatelessWidget {
  const SegmentGauge({
    required this.value,
    required this.color,
    required this.center,
    this.segments = 22,
    this.size = 220,
    super.key,
  });

  final double value;
  final Color color;
  final Widget center;
  final int segments;
  final double size;

  @override
  Widget build(BuildContext context) {
    final track = _ink(context).withValues(
      alpha: Theme.of(context).brightness == Brightness.dark ? 0.14 : 0.08,
    );
    return SizedBox(
      width: size,
      height: size * 0.62,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GaugePainter(
                value: value.clamp(0.0, 1.0),
                color: color,
                track: track,
                segments: segments,
              ),
            ),
          ),
          // Inside the ring's opening, shrunk rather than run into it.
          Padding(
            padding: EdgeInsets.only(bottom: size * 0.02),
            child: SizedBox(
              width: size * 0.56,
              height: size * 0.34,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomCenter,
                child: center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.value,
    required this.color,
    required this.track,
    required this.segments,
  });

  final double value;
  final Color color;
  final Color track;
  final int segments;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height * 0.94);
    final outer = size.width / 2;
    final inner = outer * 0.70;
    final lit = (value * segments).round();
    // From the left end round to the right, with a small gap between.
    final step = math.pi / segments;
    final thick = (outer - inner);
    for (var i = 0; i < segments; i++) {
      final a = math.pi + step * (i + 0.5);
      final dir = Offset(math.cos(a), math.sin(a));
      final mid = c + dir * ((outer + inner) / 2);
      canvas.save();
      canvas.translate(mid.dx, mid.dy);
      canvas.rotate(a);
      final w = outer * step * 0.62;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: thick, height: w),
          Radius.circular(w / 2.2),
        ),
        Paint()..color = i < lit ? color : track,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.color != color || old.track != track;
}

// --- in and out ----------------------------------------------------------------

/// Columns above a zero line for money in and below it for money out, one
/// pair a period, the chosen pair in colour.
class SignedBars extends StatelessWidget {
  const SignedBars({
    required this.ins,
    required this.outs,
    required this.selected,
    required this.onSelect,
    required this.inColor,
    required this.outColor,
    this.labels,
    this.height = 150,
    super.key,
  });

  final List<double> ins;
  final List<double> outs;
  final int selected;
  final ValueChanged<int> onSelect;
  final Color inColor;
  final Color outColor;
  final List<String>? labels;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ink = _ink(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, box) {
          void pick(Offset p) {
            final n = ins.length;
            if (n == 0) return;
            final i = (p.dx / box.maxWidth * n).floor().clamp(0, n - 1);
            if (i != selected) onSelect(i);
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => pick(d.localPosition),
            onHorizontalDragUpdate: (d) => pick(d.localPosition),
            child: CustomPaint(
              size: Size(box.maxWidth, height),
              painter: _SignedPainter(
                ins: ins,
                outs: outs,
                selected: selected,
                inColor: inColor,
                outColor: outColor,
                ink: ink,
                labels: labels,
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
    );
  }
}

class _SignedPainter extends CustomPainter {
  _SignedPainter({
    required this.ins,
    required this.outs,
    required this.selected,
    required this.inColor,
    required this.outColor,
    required this.ink,
    required this.labels,
    required this.labelStyle,
  });

  final List<double> ins;
  final List<double> outs;
  final int selected;
  final Color inColor;
  final Color outColor;
  final Color ink;
  final List<String>? labels;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final n = ins.length;
    if (n == 0) return;
    final band = labels == null ? 0.0 : 20.0;
    final plot = size.height - band;
    var hiIn = 0.0, hiOut = 0.0;
    for (var i = 0; i < n; i++) {
      hiIn = math.max(hiIn, ins[i]);
      hiOut = math.max(hiOut, outs[i]);
    }
    final total = hiIn + hiOut;
    final zero = total == 0 ? plot / 2 : plot * (hiIn / total).clamp(0.2, 0.8);
    double up(double v) => hiIn == 0 ? 0 : v / hiIn * (zero - 4);
    double down(double v) => hiOut == 0 ? 0 : v / hiOut * (plot - zero - 4);

    final slot = size.width / n;
    final w = (slot * 0.56).clamp(4.0, 22.0);
    final r = Radius.circular(w / 2 > 7 ? 7 : w / 2);

    for (var i = 0; i < n; i++) {
      final cx = slot * i + slot / 2;
      final chosen = i == selected;
      final a = up(ins[i]);
      final b = down(outs[i]);
      if (a > 0) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(cx - w / 2, zero - 1 - a, cx + w / 2, zero - 1),
            topLeft: r,
            topRight: r,
            bottomLeft: const Radius.circular(2),
            bottomRight: const Radius.circular(2),
          ),
          Paint()..color = chosen ? inColor : inColor.withValues(alpha: 0.28),
        );
      }
      if (b > 0) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTRB(cx - w / 2, zero + 1, cx + w / 2, zero + 1 + b),
            bottomLeft: r,
            bottomRight: r,
            topLeft: const Radius.circular(2),
            topRight: const Radius.circular(2),
          ),
          Paint()..color = chosen ? outColor : outColor.withValues(alpha: 0.28),
        );
      }
    }
    canvas.drawLine(
      Offset(0, zero),
      Offset(size.width, zero),
      Paint()
        ..color = ink.withValues(alpha: 0.25)
        ..strokeWidth = 1,
    );

    final ls = labels;
    if (ls != null) {
      for (var i = 0; i < n && i < ls.length; i++) {
        final chosen = i == selected;
        final tp = TextPainter(
          text: TextSpan(
            text: ls[i],
            style: chosen
                ? labelStyle.copyWith(
                    color: ink,
                    fontWeight: FontWeight.w700,
                  )
                : labelStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(slot * i + slot / 2 - tp.width / 2, plot + 5),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SignedPainter old) =>
      old.selected != selected || old.ins != ins || old.outs != outs;
}

// --- lollipops -----------------------------------------------------------------

class Lollipop {
  const Lollipop({required this.at, required this.value, required this.color});

  /// Where along the axis, 0 to 1.
  final double at;
  final double value;
  final Color color;
}

/// A thin stick up to a dot for each item, placed along a span of time: a
/// bill at its date, as tall as it costs.
class Lollipops extends StatelessWidget {
  const Lollipops({
    required this.items,
    this.selected,
    this.onSelect,
    this.height = 110,
    super.key,
  });

  final List<Lollipop> items;
  final int? selected;
  final ValueChanged<int>? onSelect;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ink = _ink(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, box) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) {
            final select = onSelect;
            if (select == null || items.isEmpty) return;
            final t = d.localPosition.dx / box.maxWidth;
            var best = 0;
            for (var i = 1; i < items.length; i++) {
              if ((items[i].at - t).abs() < (items[best].at - t).abs()) {
                best = i;
              }
            }
            HapticFeedback.selectionClick();
            select(best);
          },
          child: CustomPaint(
            size: Size(box.maxWidth, height),
            painter: _LollipopPainter(
              items: items,
              selected: selected,
              ink: ink,
            ),
          ),
        ),
      ),
    );
  }
}

class _LollipopPainter extends CustomPainter {
  _LollipopPainter({
    required this.items,
    required this.selected,
    required this.ink,
  });

  final List<Lollipop> items;
  final int? selected;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    final floor = size.height - 4;
    var hi = 0.0;
    for (final i in items) {
      hi = math.max(hi, i.value);
    }
    if (hi <= 0) hi = 1;
    final pad = 8.0;
    final span = size.width - pad * 2;

    for (var y = 0.25; y < 1.0; y += 0.25) {
      final yy = floor - (floor - 12) * y;
      canvas.drawLine(
        Offset(0, yy),
        Offset(size.width, yy),
        Paint()
          ..color = ink.withValues(alpha: 0.05)
          ..strokeWidth = 1,
      );
    }
    canvas.drawLine(
      Offset(0, floor),
      Offset(size.width, floor),
      Paint()
        ..color = ink.withValues(alpha: 0.1)
        ..strokeWidth = 1,
    );

    for (var k = 0; k < items.length; k++) {
      final i = items[k];
      final x = pad + span * i.at.clamp(0.0, 1.0);
      final top = floor - (floor - 12) * (i.value / hi).clamp(0.08, 1.0);
      final chosen = k == selected;
      canvas.drawLine(
        Offset(x, floor),
        Offset(x, top),
        Paint()
          ..color = i.color.withValues(alpha: chosen ? 0.9 : 0.4)
          ..strokeWidth = chosen ? 2.4 : 1.8
          ..strokeCap = StrokeCap.round,
      );
      if (chosen) {
        canvas.drawCircle(
          Offset(x, top),
          8,
          Paint()..color = i.color.withValues(alpha: 0.18),
        );
      }
      canvas.drawCircle(
          Offset(x, top), chosen ? 5 : 4, Paint()..color = i.color,);
    }
  }

  @override
  bool shouldRepaint(_LollipopPainter old) =>
      old.items != items || old.selected != selected;
}

// --- area line -----------------------------------------------------------------

/// A smooth line with a soft area under it, a dot on the chosen point. For
/// a record over time, such as the balance.
class AreaLine extends StatelessWidget {
  const AreaLine({
    required this.values,
    required this.selected,
    required this.onSelect,
    required this.color,
    this.height = 150,
    super.key,
  });

  final List<double> values;
  final int selected;
  final ValueChanged<int> onSelect;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ink = _ink(context);
    final card = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1C1C21)
        : Colors.white;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, box) {
          void pick(Offset p) {
            final n = values.length;
            if (n <= 1) return;
            final i = (p.dx / box.maxWidth * (n - 1)).round().clamp(0, n - 1);
            if (i != selected) onSelect(i);
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => pick(d.localPosition),
            onHorizontalDragStart: (d) => pick(d.localPosition),
            onHorizontalDragUpdate: (d) => pick(d.localPosition),
            child: CustomPaint(
              size: Size(box.maxWidth, height),
              painter: _AreaPainter(
                values: values,
                selected: selected,
                color: color,
                ink: ink,
                card: card,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  _AreaPainter({
    required this.values,
    required this.selected,
    required this.color,
    required this.ink,
    required this.card,
  });

  final List<double> values;
  final int selected;
  final Color color;
  final Color ink;
  final Color card;

  /// A smooth path that never overshoots its points (monotone cubic).
  static Path _smooth(List<Offset> p) {
    final path = Path()..moveTo(p.first.dx, p.first.dy);
    final n = p.length;
    if (n < 3) {
      for (final q in p.skip(1)) {
        path.lineTo(q.dx, q.dy);
      }
      return path;
    }
    final d = [
      for (var i = 0; i < n - 1; i++)
        (p[i + 1].dx - p[i].dx) == 0
            ? 0.0
            : (p[i + 1].dy - p[i].dy) / (p[i + 1].dx - p[i].dx),
    ];
    final m = List<double>.filled(n, 0)
      ..[0] = d[0]
      ..[n - 1] = d[n - 2];
    for (var i = 1; i < n - 1; i++) {
      m[i] = d[i - 1] * d[i] <= 0 ? 0 : (d[i - 1] + d[i]) / 2;
    }
    for (var i = 0; i < n - 1; i++) {
      if (d[i] == 0) {
        m[i] = 0;
        m[i + 1] = 0;
        continue;
      }
      final a = m[i] / d[i], b = m[i + 1] / d[i];
      final s = a * a + b * b;
      if (s > 9) {
        final t = 3 / math.sqrt(s);
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

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;
    var lo = values.reduce(math.min), hi = values.reduce(math.max);
    if (hi == lo) {
      hi += 1;
      lo -= 1;
    }
    final pad = (hi - lo) * 0.15;
    lo -= pad;
    hi += pad;
    const top = 10.0;
    final bottom = size.height - 6;
    Offset at(int i) => Offset(
          n == 1 ? size.width / 2 : size.width * i / (n - 1),
          top + (hi - values[i]) / (hi - lo) * (bottom - top),
        );
    final pts = [for (var i = 0; i < n; i++) at(i)];
    final line = _smooth(pts);
    final area = Path.from(line)
      ..lineTo(pts.last.dx, bottom)
      ..lineTo(pts.first.dx, bottom)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, top),
          Offset(0, bottom),
          [color.withValues(alpha: 0.22), color.withValues(alpha: 0.0)],
        ),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    final s = pts[selected.clamp(0, n - 1)];
    canvas
      ..drawLine(
        Offset(s.dx, top),
        Offset(s.dx, bottom),
        Paint()
          ..color = ink.withValues(alpha: 0.12)
          ..strokeWidth = 1,
      )
      ..drawCircle(s, 9, Paint()..color = color.withValues(alpha: 0.18))
      ..drawCircle(s, 5.5, Paint()..color = card)
      ..drawCircle(s, 3.8, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_AreaPainter old) =>
      old.values != values || old.selected != selected || old.color != color;
}
