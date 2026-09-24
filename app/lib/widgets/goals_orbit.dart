/// The goals at a glance (Strategy §10): up to four goals as coloured rings
/// set round a centre that says how far along all of them are together,
/// with a soft glow and a scatter of dots in each goal's colour.
///
/// It is progress, never a score: every figure is what is saved against
/// what was set, and nothing is graded.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/parts.dart';
import '../design/theme.dart';
import '../domain/goal.dart';
import '../l10n/app_localizations.dart';

/// A colour for each goal, in the order they are shown, so a goal keeps its
/// colour from the rings to its tile.
const goalPalette = <Color>[
  Color(0xFF1FB8E0), // cyan
  Color(0xFF2FBF5B), // green
  Color(0xFFD35BEF), // violet
  Color(0xFFF2545B), // coral
  Color(0xFFF5A524), // amber
  Color(0xFF5B63F5), // indigo
];

Color goalColor(int index) => goalPalette[index % goalPalette.length];

/// Whole percent, rounded down so a goal never shows 100 before it is met.
int goalPercent(Goal g) =>
    g.isComplete ? 100 : (g.progress * 100).floor().clamp(0, 99);

class GoalsOrbit extends StatelessWidget {
  const GoalsOrbit({
    required this.goals,
    required this.overall,
    required this.onOpen,
    super.key,
  });

  /// At most four; each with the index of its colour.
  final List<({Goal goal, int color})> goals;

  /// All goals together, 0 to 1.
  final double overall;
  final ValueChanged<Goal> onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final ink = dark ? const Color(0xFFB4B4BC) : const Color(0xFF6E6E76);
    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        // The rings sit on a circle of radius r; the names run round a
        // circle 1.72 r out, as in the reference, so the whole thing is
        // about 3.6 r across.
        final r = math.min(w / 3.7, 100.0);
        final height = r * 3.7;
        final c = Offset(w / 2, height / 2);
        final ring = r * 0.62;
        final n = goals.length;
        final angles = [
          for (var i = 0; i < n; i++) -math.pi / 2 + i * 2 * math.pi / n,
        ];
        Offset at(double a, double radius) =>
            c + Offset(math.cos(a), math.sin(a)) * radius;
        final labelStyle =
            (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
          fontSize: 13,
          letterSpacing: 2.2,
          fontWeight: FontWeight.w500,
          color: ink,
        );

        return SizedBox(
          key: const Key('goals-orbit'),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _OrbitPainter(
                    centre: c,
                    radius: r,
                    angles: angles,
                    colors: [for (final g in goals) goalColor(g.color)],
                    names: [for (final g in goals) g.goal.name.toUpperCase()],
                    labelStyle: labelStyle,
                    dark: dark,
                  ),
                ),
              ),
              // The centre: all goals together.
              Positioned(
                left: c.dx - r * 0.72,
                top: c.dy - r * 0.5,
                width: r * 1.44,
                height: r,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(overall * 100).floor().clamp(0, 100)}%',
                        key: const Key('goals-overall'),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 46,
                          height: 1.0,
                          fontWeight: FontWeight.w700,
                          fontFeatures: moneyFeatures,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.goalsOverall,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              for (var i = 0; i < n; i++)
                Positioned(
                  left: at(angles[i], r).dx - ring / 2,
                  top: at(angles[i], r).dy - ring / 2,
                  width: ring,
                  height: ring,
                  child: GestureDetector(
                    key: Key('goals-orbit-${goals[i].goal.id}'),
                    onTap: () => onOpen(goals[i].goal),
                    child: _Ring(
                      goal: goals[i].goal,
                      color: goalColor(goals[i].color),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.goal, required this.color});

  final Goal goal;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _RingPainter(
          value: goal.progress,
          color: color,
          fill: cardColor(context),
        ),
        child: Center(
          child: Text(
            '${goalPercent(goal)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFeatures: moneyFeatures,
                ),
          ),
        ),
      );
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.color, required this.fill});

  final double value;
  final Color color;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 2;
    canvas
      ..drawCircle(c, r, Paint()..color = fill)
      ..drawCircle(c, r - 2, Paint()..color = color.withValues(alpha: 0.07))
      ..drawCircle(
        c,
        r,
        Paint()
          ..color = color.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.6,
      )
      ..drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        2 * math.pi * value.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.6
          ..strokeCap = StrokeCap.round,
      );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color;
}

class _OrbitPainter extends CustomPainter {
  _OrbitPainter({
    required this.centre,
    required this.radius,
    required this.angles,
    required this.colors,
    required this.names,
    required this.labelStyle,
    required this.dark,
  });

  final Offset centre;
  final double radius;
  final List<double> angles;
  final List<Color> colors;
  final List<String> names;
  final TextStyle labelStyle;
  final bool dark;

  static const _deg = math.pi / 180;

  Offset _at(double a, double r) =>
      centre + Offset(math.cos(a), math.sin(a)) * r;

  @override
  void paint(Canvas canvas, Size size) {
    final r = radius;

    // A soft glow of each goal's colour round its ring.
    for (var i = 0; i < angles.length; i++) {
      final p = _at(angles[i], r * 0.9);
      final rect = Rect.fromCircle(center: p, radius: r * 1.2);
      canvas.drawCircle(
        p,
        r * 1.2,
        Paint()
          ..shader = RadialGradient(
            colors: [
              colors[i].withValues(alpha: dark ? 0.14 : 0.11),
              colors[i].withValues(alpha: 0.0),
            ],
          ).createShader(rect),
      );
    }

    final grey = (dark ? Colors.white : Colors.black)
        .withValues(alpha: dark ? 0.13 : 0.075);
    final greyLight = (dark ? Colors.white : Colors.black)
        .withValues(alpha: dark ? 0.08 : 0.05);

    // Grey dots on the diagonals between rings: a large one near in, a small
    // one further out.
    for (var k = 0; k < 4; k++) {
      final a = (-135 + k * 90) * _deg;
      canvas
        ..drawCircle(_at(a, r * 0.98), r * 0.15, Paint()..color = grey)
        ..drawCircle(_at(a, r * 1.4), r * 0.065, Paint()..color = greyLight);
    }

    // Two dots in each goal's colour either side of its ring, and a tiny one
    // further out.
    for (var i = 0; i < angles.length; i++) {
      final a = angles[i];
      final col = colors[i];
      for (final s in const [-1, 1]) {
        canvas
          ..drawCircle(
            _at(a + s * 27 * _deg, r * 1.19),
            r * 0.085,
            Paint()..color = col.withValues(alpha: 0.75),
          )
          ..drawCircle(
            _at(a + s * 31 * _deg, r * 1.42),
            r * 0.03,
            Paint()..color = col.withValues(alpha: 0.45),
          );
      }
    }

    // Names round the outside.
    for (var i = 0; i < angles.length; i++) {
      _label(canvas, names[i], angles[i], r * 1.72);
    }
  }

  /// Arabic-script letters join, so a word in one of those scripts cannot
  /// be bent round a curve one letter at a time without falling apart.
  static final _joining = RegExp(r'[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]');

  void _label(Canvas canvas, String text, double angle, double rl) {
    final bottom = math.sin(angle) > 0.5;
    if (_joining.hasMatch(text)) {
      // Straight: level at top and bottom, turned along the side at left
      // and right, so the word keeps its shape.
      final tp = TextPainter(
        text:
            TextSpan(text: text, style: labelStyle.copyWith(letterSpacing: 0)),
        textDirection: TextDirection.rtl,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: rl * 1.2);
      final p = _at(angle, rl);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      final side = math.cos(angle).abs() > 0.7;
      if (side) canvas.rotate(math.cos(angle) > 0 ? math.pi / 2 : -math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
      return;
    }

    // Letter by letter along the arc, reading left to right at the top and
    // bottom, upward on the left and downward on the right.
    final letters = [
      for (final ch in text.characters)
        TextPainter(
          text: TextSpan(text: ch, style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout(),
    ];
    final total = letters.fold<double>(0, (w, t) => w + t.width);
    // Never more than a third of the way round.
    final span = math.min(total / rl, 2 * math.pi / 3);
    final scale = span * rl / total;
    var a = bottom ? angle + span / 2 : angle - span / 2;
    for (final t in letters) {
      final step = t.width * scale / rl;
      final mid = bottom ? a - step / 2 : a + step / 2;
      final p = _at(mid, rl);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(bottom ? mid - math.pi / 2 : mid + math.pi / 2);
      t.paint(canvas, Offset(-t.width / 2, -t.height / 2));
      canvas.restore();
      a = bottom ? a - step : a + step;
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.angles.length != angles.length ||
      old.radius != radius ||
      old.dark != dark ||
      old.names.join() != names.join();
}
