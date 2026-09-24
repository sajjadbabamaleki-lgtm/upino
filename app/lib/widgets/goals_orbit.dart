/// The goals at a glance (Strategy §10): up to four goals as coloured rings
/// set round a centre that says how far along all of them are together,
/// with a soft glow and a scatter of dots in each goal's colour.
///
/// It arrives rather than appears: the glow and dots gather, the rings pop
/// in one after another, each arc sweeps to its goal's progress, the centre
/// counts up, and the names fade in last.
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

/// Where [t] is inside the stretch from [a] to [b], eased; 0 before, 1 after.
double _phase(double t, double a, double b,
    [Curve curve = Curves.easeOutCubic,]) {
  if (t <= a) return 0;
  if (t >= b) return 1;
  return curve.transform((t - a) / (b - a));
}

class GoalsOrbit extends StatefulWidget {
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

  /// The whole welcome, start to finish.
  static const welcome = Duration(milliseconds: 1700);

  @override
  State<GoalsOrbit> createState() => _GoalsOrbitState();
}

class _GoalsOrbitState extends State<GoalsOrbit>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: GoalsOrbit.welcome)..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Someone who has asked their phone to stop animating gets the rings as
    // they are, not a slower version of the same effect.
    if (MediaQuery.disableAnimationsOf(context)) return _frame(context, 1);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => _frame(context, _c.value),
    );
  }

  Widget _frame(BuildContext context, double t) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final dark = isDark(context);
    final ink = dark ? const Color(0xFFB4B4BC) : const Color(0xFF6E6E76);
    final goals = widget.goals;
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

        // The centre counts up to the whole.
        final shown =
            (widget.overall * 100 * _phase(t, 0.15, 0.9)).floor().clamp(0, 100);

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
                    t: t,
                  ),
                ),
              ),
              Positioned(
                left: c.dx - r * 0.72,
                top: c.dy - r * 0.5,
                width: r * 1.44,
                height: r,
                child: Opacity(
                  opacity: _phase(t, 0.05, 0.35),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$shown%',
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
              ),
              for (var i = 0; i < n; i++)
                Positioned(
                  left: at(angles[i], r).dx - ring / 2,
                  top: at(angles[i], r).dy - ring / 2,
                  width: ring,
                  height: ring,
                  child: GestureDetector(
                    key: Key('goals-orbit-${goals[i].goal.id}'),
                    onTap: () => widget.onOpen(goals[i].goal),
                    // Each ring pops in after the one before it, with a
                    // little overshoot, then its arc sweeps round.
                    child: Transform.scale(
                      scale: _phase(
                          t, 0.12 + 0.1 * i, 0.5 + 0.1 * i, Curves.easeOutBack,),
                      child: _Ring(
                        goal: goals[i].goal,
                        color: goalColor(goals[i].color),
                        sweep: _phase(t, 0.3 + 0.08 * i, 0.95),
                      ),
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
  const _Ring({required this.goal, required this.color, this.sweep = 1});

  final Goal goal;
  final Color color;

  /// How much of its progress the arc has swept to, 0 to 1.
  final double sweep;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _RingPainter(
          value: goal.progress * sweep,
          color: color,
          fill: cardColor(context),
        ),
        child: Center(
          child: Text(
            '${(goalPercent(goal) * sweep).round()}',
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
      );
    if (value > 0) {
      canvas.drawArc(
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
    required this.t,
  });

  final Offset centre;
  final double radius;
  final List<double> angles;
  final List<Color> colors;
  final List<String> names;
  final TextStyle labelStyle;
  final bool dark;

  /// Where the welcome is, 0 to 1.
  final double t;

  static const _deg = math.pi / 180;

  Offset _at(double a, double r) =>
      centre + Offset(math.cos(a), math.sin(a)) * r;

  @override
  void paint(Canvas canvas, Size size) {
    final r = radius;

    // A soft glow of each goal's colour round its ring, gathering first.
    final glow = _phase(t, 0, 0.45);
    for (var i = 0; i < angles.length; i++) {
      final p = _at(angles[i], r * 0.9);
      final rect = Rect.fromCircle(center: p, radius: r * 1.2);
      canvas.drawCircle(
        p,
        r * 1.2,
        Paint()
          ..shader = RadialGradient(
            colors: [
              colors[i].withValues(alpha: (dark ? 0.14 : 0.11) * glow),
              colors[i].withValues(alpha: 0.0),
            ],
          ).createShader(rect),
      );
    }

    // Grey dots on the diagonals between rings: a large one near in, a small
    // one further out. They drift out from the centre as they appear.
    final g = _phase(t, 0.05, 0.55);
    final base = dark ? Colors.white : Colors.black;
    for (var k = 0; k < 4; k++) {
      final a = (-135 + k * 90) * _deg;
      canvas
        ..drawCircle(
          _at(a, r * (0.6 + 0.38 * g)),
          r * 0.15 * g,
          Paint()..color = base.withValues(alpha: (dark ? 0.13 : 0.075) * g),
        )
        ..drawCircle(
          _at(a, r * (1.0 + 0.4 * g)),
          r * 0.065 * g,
          Paint()..color = base.withValues(alpha: (dark ? 0.08 : 0.05) * g),
        );
    }

    // Two dots in each goal's colour either side of its ring, and a tiny one
    // further out, popping in after their ring.
    for (var i = 0; i < angles.length; i++) {
      final a = angles[i];
      final col = colors[i];
      final d = _phase(t, 0.35 + 0.08 * i, 0.75 + 0.08 * i, Curves.easeOutBack);
      if (d <= 0) continue;
      for (final s in const [-1, 1]) {
        canvas
          ..drawCircle(
            _at(a + s * 27 * _deg, r * 1.19),
            r * 0.085 * d,
            Paint()..color = col.withValues(alpha: 0.75),
          )
          ..drawCircle(
            _at(a + s * 31 * _deg, r * 1.42),
            r * 0.03 * d,
            Paint()..color = col.withValues(alpha: 0.45),
          );
      }
    }

    // Names round the outside, last.
    final names = _phase(t, 0.55, 1.0);
    if (names > 0) {
      for (var i = 0; i < angles.length; i++) {
        _label(canvas, this.names[i], angles[i], r * 1.72, names);
      }
    }
  }

  /// Arabic-script letters join, so a word in one of those scripts cannot
  /// be bent round a curve one letter at a time without falling apart.
  static final _joining = RegExp(
    r'[؀-ۿݐ-ݿﭐ-﷿ﹰ-﻿]',
  );

  void _label(
    Canvas canvas,
    String text,
    double angle,
    double rl,
    double opacity,
  ) {
    final style = labelStyle.copyWith(
      color: labelStyle.color?.withValues(
        alpha: (labelStyle.color?.a ?? 1) * opacity,
      ),
    );
    final bottom = math.sin(angle) > 0.5;
    if (_joining.hasMatch(text)) {
      // Straight: level at top and bottom, turned along the side at left
      // and right, so the word keeps its shape.
      final tp = TextPainter(
        text: TextSpan(text: text, style: style.copyWith(letterSpacing: 0)),
        textDirection: TextDirection.rtl,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: rl * 1.2);
      final p = _at(angle, rl);
      canvas
        ..save()
        ..translate(p.dx, p.dy);
      if (math.cos(angle).abs() > 0.7) {
        canvas.rotate(math.cos(angle) > 0 ? math.pi / 2 : -math.pi / 2);
      }
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
      return;
    }

    // Letter by letter along the arc, reading left to right at the top and
    // bottom, upward on the left and downward on the right.
    final letters = [
      for (final ch in text.characters)
        TextPainter(
          text: TextSpan(text: ch, style: style),
          textDirection: TextDirection.ltr,
        )..layout(),
    ];
    final total = letters.fold<double>(0, (w, t) => w + t.width);
    if (total == 0) return;
    // Never more than a third of the way round.
    final span = math.min(total / rl, 2 * math.pi / 3);
    final scale = span * rl / total;
    var a = bottom ? angle + span / 2 : angle - span / 2;
    for (final tp in letters) {
      final step = tp.width * scale / rl;
      final mid = bottom ? a - step / 2 : a + step / 2;
      final p = _at(mid, rl);
      canvas
        ..save()
        ..translate(p.dx, p.dy)
        ..rotate(bottom ? mid - math.pi / 2 : mid + math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
      a = bottom ? a - step : a + step;
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) =>
      old.t != t ||
      old.angles.length != angles.length ||
      old.radius != radius ||
      old.dark != dark ||
      old.names.join() != names.join();
}
