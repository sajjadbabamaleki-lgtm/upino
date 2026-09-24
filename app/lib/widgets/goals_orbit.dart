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

  static const _height = 320.0;
  static const _ring = 66.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    return SizedBox(
      key: const Key('goals-orbit'),
      height: _height,
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth;
          final c = Offset(w / 2, _height / 2);
          final r = math.min(w, _height) / 2 - 62;
          final n = goals.length;
          // Round from the top, evenly.
          final angles = [
            for (var i = 0; i < n; i++) -math.pi / 2 + i * 2 * math.pi / n,
          ];
          Offset at(double a, double radius) =>
              c + Offset(math.cos(a), math.sin(a)) * radius;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _OrbitPainter(
                    centre: c,
                    radius: r,
                    angles: angles,
                    colors: [for (final g in goals) goalColor(g.color)],
                    dark: dark,
                  ),
                ),
              ),
              // The centre: all goals together.
              Positioned(
                left: c.dx - 70,
                top: c.dy - 45,
                width: 140,
                height: 90,
                // Shrunk to fit, never spilling into the rings.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(overall * 100).floor().clamp(0, 100)}%',
                        key: const Key('goals-overall'),
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontSize: 42,
                          height: 1.0,
                          fontFeatures: moneyFeatures,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.goalsOverall,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              for (var i = 0; i < n; i++) ...[
                // Each goal's ring.
                Positioned(
                  left: at(angles[i], r).dx - _ring / 2,
                  top: at(angles[i], r).dy - _ring / 2,
                  width: _ring,
                  height: _ring,
                  child: GestureDetector(
                    key: Key('goals-orbit-${goals[i].goal.id}'),
                    onTap: () => onOpen(goals[i].goal),
                    child: _Ring(
                      goal: goals[i].goal,
                      color: goalColor(goals[i].color),
                    ),
                  ),
                ),
                // Its name outside the ring: level above and below, turned
                // along the side at left and right so a word keeps its
                // shape (a script that joins its letters cannot be bent
                // round a curve one letter at a time).
                _Label(
                  text: goals[i].goal.name,
                  at: at(angles[i], r + _ring / 2 + 16),
                  angle: angles[i],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text, required this.at, required this.angle});

  final String text;
  final Offset at;
  final double angle;

  @override
  Widget build(BuildContext context) {
    final side = math.cos(angle).abs() > 0.7;
    final style = Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w600,
        );
    const w = 120.0, h = 18.0;
    final label = Text(
      text.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: style,
    );
    return Positioned(
      left: at.dx - w / 2,
      top: at.dy - h / 2,
      width: w,
      height: h,
      child: side
          ? Transform.rotate(
              angle: math.cos(angle) > 0 ? math.pi / 2 : -math.pi / 2,
              child: label,
            )
          : label,
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
                  fontSize: 18,
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
    final r = size.width / 2 - 3;
    canvas
      ..drawCircle(c, r + 2, Paint()..color = fill)
      ..drawCircle(c, r - 3, Paint()..color = color.withValues(alpha: 0.08))
      ..drawCircle(
        c,
        r,
        Paint()
          ..color = color.withValues(alpha: 0.16)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.5,
      )
      ..drawArc(
        Rect.fromCircle(center: c, radius: r),
        -math.pi / 2,
        2 * math.pi * value.clamp(0.0, 1.0),
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.5
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
    required this.dark,
  });

  final Offset centre;
  final double radius;
  final List<double> angles;
  final List<Color> colors;
  final bool dark;

  Offset _at(double a, double r) =>
      centre + Offset(math.cos(a), math.sin(a)) * r;

  @override
  void paint(Canvas canvas, Size size) {
    // A soft glow in each goal's colour, behind everything.
    for (var i = 0; i < angles.length; i++) {
      final p = _at(angles[i], radius * 0.55);
      canvas.drawCircle(
        p,
        radius * 1.05,
        Paint()
          ..shader = RadialGradient(
            colors: [
              colors[i].withValues(alpha: dark ? 0.16 : 0.13),
              colors[i].withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: p, radius: radius * 1.05)),
      );
    }

    final grey = (dark ? Colors.white : Colors.black)
        .withValues(alpha: dark ? 0.12 : 0.07);

    // Dots trailing away from each ring in its colour, and grey ones in
    // between, as in a constellation.
    for (var i = 0; i < angles.length; i++) {
      final a = angles[i];
      final col = colors[i];
      for (final (off, size, alpha) in const [
        (0.44, 7.5, 0.85),
        (0.62, 4.5, 0.45),
        (0.76, 2.5, 0.28),
      ]) {
        for (final sign in const [-1, 1]) {
          canvas.drawCircle(
            _at(a + sign * off, radius),
            size,
            Paint()..color = col.withValues(alpha: alpha),
          );
        }
      }
      for (final sign in const [-1, 1]) {
        canvas
          ..drawCircle(
            _at(a + sign * 0.78, radius * 0.66),
            11,
            Paint()..color = grey,
          )
          ..drawCircle(
            _at(a + sign * 1.0, radius * 1.02),
            6,
            Paint()..color = grey,
          );
      }
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.angles.length != angles.length ||
      old.radius != radius ||
      old.dark != dark;
}
