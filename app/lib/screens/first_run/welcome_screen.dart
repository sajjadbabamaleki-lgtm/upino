/// The first thing anyone sees: a month with Upino. A timeline of four
/// moments runs across the top; each page shows the real screen that goes
/// with its moment, so the app introduces itself with itself.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../design/icon.dart';
import '../../design/parts.dart';
import '../../design/theme.dart';
import '../../engine/clock.dart';
import '../../engine/money.dart';
import '../../l10n/dates.dart';
import '../../state/app_state.dart';
import 'fr_parts.dart';

const _ease = Cubic(0.23, 1, 0.32, 1);

/// The end of the demo month the welcome pages show.
const _demoEnd = LocalDate(2026, 10, 30);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({required this.state, super.key});
  final AppState state;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pages = PageController();
  int _page = 0;

  static const _count = 4;

  static List<(String, String, String)> _moments(BuildContext c) => [
        (c.l.frDay(1), c.l.frMoment1Title, c.l.frMoment1Body),
        (c.l.frDay(12), c.l.frMoment2Title, c.l.frMoment2Body),
        (c.l.frDay(18), c.l.frMoment3Title, c.l.frMoment3Body),
        (c.l.frDay(30), c.l.frMoment4Title, c.l.frMoment4Body),
      ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  String _m(double major) => Money((major * 100).round(), widget.state.currency).display();

  @override
  Widget build(BuildContext context) {
    final last = _page == _count - 1;
    return Scaffold(
      backgroundColor: pageOf(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: AnimatedBuilder(
                animation: _pages,
                builder: (context, _) => _Timeline(
                  labels: [for (final m in _moments(context)) m.$1],
                  at: _pages.hasClients && _pages.position.haveDimensions ? _pages.page ?? 0 : 0,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: _count,
                onPageChanged: (i) {
                  HapticFeedback.selectionClick();
                  setState(() => _page = i);
                },
                itemBuilder: (context, i) {
                  final active = i == _page;
                  final visual = switch (i) {
                    0 => _Payday(key: ValueKey('p0$active'), m: _m),
                    1 => _Spend(key: ValueKey('p1$active'), m: _m, active: active),
                    2 => _Ask(key: ValueKey('p2$active'), m: _m),
                    _ => _Close(key: ValueKey('p3$active')),
                  };
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Center(child: visual)),
                        const SizedBox(height: 18),
                        Text(
                          _moments(context)[i].$2,
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.08,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1.1,
                            color: inkOf(context),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(_moments(context)[i].$3,
                            style: TextStyle(fontSize: 15, height: 1.45, color: subOf(context)),),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
              child: FlowButton(
                buttonKey: const Key('welcome-next'),
                label: last ? context.l.frGetStarted : context.l.frContinue,
                style: FlowButtonStyle.light,
                onTap: () {
                  if (last) {
                    widget.state.markWelcomeSeen();
                  } else {
                    _pages.nextPage(duration: const Duration(milliseconds: 620), curve: const Cubic(0.77, 0, 0.175, 1));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Four moments on a line; the line fills with the swipe.
class _Timeline extends StatelessWidget {
  const _Timeline({required this.labels, required this.at});
  final List<String> labels;
  final double at;

  @override
  Widget build(BuildContext context) {
    final n = labels.length;
    return SizedBox(
      height: 42,
      child: LayoutBuilder(builder: (context, box) {
        final w = box.maxWidth;
        double x(int i) => 7 + (w - 14) * i / (n - 1);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 7,
              right: 7,
              top: 6,
              child: Container(height: 2, color: sunkenColor(context)),
            ),
            Positioned(
              left: 7,
              top: 6,
              width: (w - 14) * (at / (n - 1)).clamp(0.0, 1.0),
              child: Container(height: 2, color: inkOf(context)),
            ),
            for (var i = 0; i < n; i++) ...[
              Positioned(
                left: x(i) - 7,
                top: 0,
                child: _Dot(on: at >= i - 0.5, now: (at - i).abs() < 0.5, last: i == n - 1),
              ),
              Positioned(
                left: (x(i) - 30).clamp(0.0, w - 60),
                width: 60,
                top: 22,
                child: Text(
                  labels[i].toUpperCase(),
                  textAlign: i == 0 ? TextAlign.left : i == n - 1 ? TextAlign.right : TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: (at - i).abs() < 0.5 ? inkOf(context) : tertOf(context),
                  ),
                ),
              ),
            ],
          ],
        );
      },),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.on, required this.now, required this.last});
  final bool on;
  final bool now;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final c = now ? (last || !on ? lime : lime) : (on ? inkOf(context) : sunkenColor(context));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: _ease,
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c,
        boxShadow: now ? [BoxShadow(color: lime.withValues(alpha: 0.35), blurRadius: 0, spreadRadius: 5)] : null,
      ),
    );
  }
}

/// The blue hero card, as Home shows it.
class _Hero extends StatelessWidget {
  const _Hero({required this.amount, required this.until, this.button = true});
  final String amount;
  final String until;
  final bool button;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          color: const Color(0xFF2F3AE8),
          child: Stack(
            children: [
              const Positioned.fill(child: GridField()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l.heroSafeToSpend,
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 13.5, fontWeight: FontWeight.w500),),
                  const SizedBox(height: 6),
                  Text(amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -2,
                        fontFeatures: moneyFeatures,
                      ),),
                  Text(until, style: const TextStyle(color: Color(0xBFFFFFFF), fontSize: 12.5)),
                  if (button) ...[
                    const SizedBox(height: 14),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(99)),
                      child: Text(context.l.heroRecordSpend,
                          style: TextStyle(color: Color(0xFF2F3AE8), fontWeight: FontWeight.w600, fontSize: 13.5),),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.amount);
  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(fontSize: 13.5, color: inkOf(context)))),
            Text(amount, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: inkOf(context), fontFeatures: moneyFeatures)),
            const SizedBox(width: 8),
            UpinoIcon('check', size: 16, color: isDark(context) ? lime : const Color(0xFF4F7A00)),
          ],
        ),
      );
}

class _Payday extends StatelessWidget {
  const _Payday({required this.m, super.key});
  final String Function(double) m;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Arrive(
            dy: -16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: lime, borderRadius: BorderRadius.circular(99)),
              child: Text(context.l.frPayArrived('+${m(2000)}'),
                  style: const TextStyle(color: Color(0xFF0F1012), fontWeight: FontWeight.w700, fontSize: 13),),
            ),
          ),
          const SizedBox(height: 12),
          Arrive(delay: const Duration(milliseconds: 180), child: _Hero(amount: m(644), until: context.l.heroUntil(formatDate(context, _demoEnd)))),
          const SizedBox(height: 10),
          Arrive(
            delay: const Duration(milliseconds: 360),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              decoration: BoxDecoration(color: cardColor(context), borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l.homeSetAsideFirst.toUpperCase(),
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, letterSpacing: 1, color: tertOf(context)),),
                  const SizedBox(height: 4),
                  _Line(context.l.frObRent, m(1200)),
                  _Line(context.l.frEssGroceries, m(400)),
                ],
              ),
            ),
          ),
        ],
      );
}

class _Spend extends StatelessWidget {
  const _Spend({required this.m, required this.active, super.key});
  final String Function(double) m;
  final bool active;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 516.4, end: active ? 512.2 : 516.4),
            duration: const Duration(milliseconds: 900),
            curve: _ease,
            builder: (context, v, _) => _Hero(amount: m(v), until: context.l.heroUntil(formatDate(context, _demoEnd)), button: false),
          ),
          const SizedBox(height: 12),
          Arrive(
            delay: const Duration(milliseconds: 250),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
              decoration: BoxDecoration(color: cardColor(context), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const IconTile('su-cart', size: 38),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l.frCoffee, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5, color: inkOf(context))),
                        Text(context.l.frRecordedNow, style: TextStyle(fontSize: 12.5, color: tertOf(context))),
                      ],
                    ),
                  ),
                  Text('\u2212${m(4.2)}',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: inkOf(context), fontFeatures: moneyFeatures),),
                ],
              ),
            ),
          ),
        ],
      );
}

class _Ask extends StatelessWidget {
  const _Ask({required this.m, super.key});
  final String Function(double) m;

  @override
  Widget build(BuildContext context) {
    Widget bubble(String text, {required bool mine, TextSpan? rich}) => Align(
          alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 270),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: mine ? const Color(0xFF2F3AE8) : cardColor(context),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(mine ? 20 : 6),
                bottomRight: Radius.circular(mine ? 6 : 20),
              ),
            ),
            child: Text.rich(
              rich ?? TextSpan(text: text),
              style: TextStyle(fontSize: 14, height: 1.4, color: mine ? Colors.white : inkOf(context)),
            ),
          ),
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Arrive(child: bubble(context.l.frAskJacket(m(120)), mine: true)),
        const SizedBox(height: 10),
        Arrive(
          delay: const Duration(milliseconds: 700),
          child: bubble('', mine: false, rich: TextSpan(children: [
            // The amount is set in bold wherever the language puts it.
            for (final (i, part) in context.l.frAskAnswer('\u0000', formatDate(context, _demoEnd)).split('\u0000').indexed) ...[
              if (i > 0)
                TextSpan(text: m(392), style: TextStyle(fontWeight: FontWeight.w700, color: isDark(context) ? lime : const Color(0xFF4F7A00))),
              TextSpan(text: part),
            ],
          ],),),
        ),
        const SizedBox(height: 12),
        Arrive(
          delay: const Duration(milliseconds: 1000),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cardColor(context), borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l.frIfBuyNow.toUpperCase(), style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, letterSpacing: 1, color: tertOf(context))),
                const SizedBox(height: 4),
                Text(context.l.frLeft(m(392)), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: inkOf(context))),
                const SizedBox(height: 10),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 0.62),
                  duration: const Duration(milliseconds: 900),
                  curve: _ease,
                  builder: (context, v, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: v,
                      minHeight: 6,
                      backgroundColor: sunkenColor(context),
                      color: const Color(0xFF2F3AE8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Close extends StatelessWidget {
  const _Close({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 210,
            width: 240,
            child: Stack(
              children: [
                Positioned.fill(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1400),
                    curve: _ease,
                    builder: (context, t, _) => CustomPaint(painter: _Rings(t: t, dark: isDark(context), sub: context.l.frOfAllGoals)),
                  ),
                ),
                for (var i = 0; i < 4; i++)
                  Positioned(
                    left: 120 + math.cos(-math.pi / 2 + i * math.pi / 2) * 72 - 10,
                    top: 105 + math.sin(-math.pi / 2 + i * math.pi / 2) * 72 - 10,
                    child: UpinoIcon(
                      const ['goal-trip', 'goal-laptop', 'goal-emergency', 'goal-car'][i],
                      size: 20,
                      color: _Rings._cols[i],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Arrive(
            delay: const Duration(milliseconds: 600),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(color: cardColor(context), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  UpinoIcon('trendingUp', size: 18, color: isDark(context) ? lime : const Color(0xFF4F7A00)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(context.l.frMonthClosed,
                        style: TextStyle(fontSize: 13.5, color: inkOf(context)),),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class _Rings extends CustomPainter {
  _Rings({required this.t, required this.dark, required this.sub});
  final String sub;
  final double t;
  final bool dark;

  static const _cols = [Color(0xFF2F3AE8), Color(0xFFEB6834), Color(0xFF1BAF7A), Color(0xFFEDA100)];
  static const _pct = [0.36, 0.43, 0.66, 0.19];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    const R = 72.0, r = 25.0;
    for (var i = 0; i < 4; i++) {
      final a = -math.pi / 2 + i * math.pi / 2;
      final p = c + Offset(math.cos(a), math.sin(a)) * R;
      canvas.drawCircle(p, r, Paint()..color = dark ? const Color(0xFF141418) : Colors.white);
      canvas.drawCircle(p, r, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..color = _cols[i].withValues(alpha: 0.18),);
      canvas.drawArc(Rect.fromCircle(center: p, radius: r), -math.pi / 2, 2 * math.pi * _pct[i] * t, false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.5
            ..strokeCap = StrokeCap.round
            ..color = _cols[i],);
    }
    final tp = TextPainter(
      text: TextSpan(
        text: '${(41 * t).round()}%',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: dark ? Colors.white : const Color(0xFF17171A), fontFamily: 'Geist'),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2 + 6));
    final label = TextPainter(
      text: TextSpan(text: sub, style: TextStyle(fontSize: 10.5, color: dark ? const Color(0xFF9A9AA3) : const Color(0xFF55555C), fontFamily: 'Geist')),
      textDirection: TextDirection.ltr,
    )..layout();
    label.paint(canvas, c + Offset(-label.width / 2, 12));
  }

  @override
  bool shouldRepaint(_Rings old) => old.t != t;
}

/// One screen for signing in and signing up: the person does not have to
/// know which they are doing.
class SignInScreen extends StatelessWidget {
  const SignInScreen({required this.state, super.key});
  final AppState state;

  static const _apple =
      '<svg viewBox="0 0 24 24"><path fill="#0F1012" d="M16.4 12.6c0-2.6 2.1-3.8 2.2-3.9-1.2-1.8-3.1-2-3.7-2-1.6-.2-3.1.9-3.9.9-.8 0-2-.9-3.4-.9-1.7 0-3.3 1-4.2 2.6-1.8 3.1-.5 7.7 1.3 10.2.8 1.2 1.8 2.6 3.1 2.6 1.2-.1 1.7-.8 3.2-.8s1.9.8 3.2.8c1.3 0 2.2-1.3 3-2.5.9-1.4 1.3-2.8 1.3-2.8s-2.6-1-2.1-4.2zM13.9 5c.7-.8 1.1-1.9 1-3-1 0-2.1.7-2.8 1.5-.6.7-1.2 1.8-1 2.9 1.1.1 2.1-.6 2.8-1.4z"/></svg>';
  static const _google =
      '<svg viewBox="0 0 24 24"><path fill="#4285F4" d="M22.5 12.2c0-.8-.1-1.5-.2-2.2H12v4.2h5.9a5 5 0 0 1-2.2 3.3v2.7h3.5c2.1-1.9 3.3-4.7 3.3-8z"/><path fill="#34A853" d="M12 23c3 0 5.5-1 7.3-2.7l-3.5-2.7c-1 .7-2.3 1.1-3.8 1.1-2.9 0-5.4-2-6.3-4.6H2.1v2.8A11 11 0 0 0 12 23z"/><path fill="#FBBC05" d="M5.7 14.1a6.6 6.6 0 0 1 0-4.2V7.1H2.1a11 11 0 0 0 0 9.8z"/><path fill="#EA4335" d="M12 5.4c1.6 0 3.1.6 4.2 1.7l3.2-3.2A11 11 0 0 0 2.1 7.1l3.6 2.8C6.6 7.3 9.1 5.4 12 5.4z"/></svg>';

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    String m(int major) => Money(major * 100, state.currency).display();
    return Scaffold(
      backgroundColor: pageOf(context),
      body: Stack(
        children: [
          // The app's own charts, one every two seconds, faint behind.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: _ChartCycle(dark: dark, source: m(3000)),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    pageOf(context).withValues(alpha: 0),
                    pageOf(context),
                  ],
                  stops: const [0.2, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Arrive(child: Mark(size: 52)),
                  const SizedBox(height: 20),
                  Arrive(
                    delay: const Duration(milliseconds: 60),
                    child: Text(
                      context.l.frWelcome,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.1,
                        color: inkOf(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Arrive(
                    delay: const Duration(milliseconds: 120),
                    child: Text(
                      context.l.frWelcomeSub,
                      style: TextStyle(fontSize: 15, color: subOf(context)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Arrive(
                    delay: const Duration(milliseconds: 180),
                    child: _Provider(
                      key: const Key('signin-apple'),
                      label: context.l.frWithApple,
                      logo: _apple,
                      filled: true,
                      onTap: () => state.signIn('apple'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Arrive(
                    delay: const Duration(milliseconds: 230),
                    child: _Provider(
                      key: const Key('signin-google'),
                      label: context.l.frWithGoogle,
                      logo: _google,
                      onTap: () => state.signIn('google'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Arrive(
                    delay: const Duration(milliseconds: 280),
                    child: _Provider(
                      key: const Key('signin-email'),
                      label: context.l.frWithEmail,
                      icon: 'su-mail',
                      onTap: () => _EmailSheet.show(context, state),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: Text(
                      '${context.l.frOnDevice}\n${context.l.frTermsPrivacy}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12, height: 1.5, color: tertOf(context),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Provider extends StatelessWidget {
  const _Provider({
    required this.label,
    required this.onTap,
    this.logo,
    this.icon,
    this.filled = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final String? logo;
  final String? icon;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final bg = filled
        ? (dark ? const Color(0xFFF3F3F5) : const Color(0xFF0F1012))
        : cardColor(context);
    final fg = filled
        ? (dark ? const Color(0xFF0F1012) : Colors.white)
        : inkOf(context);
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(28)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (logo != null)
              SvgPicture.string(
                logo!,
                width: 18,
                height: 18,
                colorFilter: filled && !dark
                    ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                    : null,
              ),
            if (icon != null) UpinoIcon(icon!, size: 19, color: fg),
            const SizedBox(width: 10),
            Text(label,
                style: TextStyle(
                    color: fg, fontSize: 15.5, fontWeight: FontWeight.w600,),),
          ],
        ),
      ),
    );
  }
}

/// Email in, a six-digit code back. Not yet connected to an account
/// service; any six digits continue.
class _EmailSheet extends StatefulWidget {
  const _EmailSheet({required this.state});
  final AppState state;

  static Future<void> show(BuildContext context, AppState state) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _EmailSheet(state: state),
      );

  @override
  State<_EmailSheet> createState() => _EmailSheetState();
}

class _EmailSheetState extends State<_EmailSheet> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  bool _sent = false;

  bool get _emailOk =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_email.text.trim());

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final field = InputDecoration(
      filled: true,
      fillColor: sunkenColor(context),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none,),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
        decoration: BoxDecoration(
          color: cardColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: const Cubic(0.23, 1, 0.32, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: borderColor(context),
                        borderRadius: BorderRadius.circular(4),),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  _sent ? context.l.frCheckEmail : context.l.frWithEmail,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -.6,
                      color: inkOf(context),),
                ),
                const SizedBox(height: 6),
                Text(
                  _sent
                      ? context.l.frCodeSent(_email.text.trim())
                      : context.l.frCodeWhy,
                  style: TextStyle(fontSize: 14, color: subOf(context)),
                ),
                const SizedBox(height: 18),
                if (!_sent)
                  TextField(
                    key: const Key('signin-email-field'),
                    controller: _email,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() {}),
                    decoration: field.copyWith(hintText: 'you@example.com'),
                  )
                else
                  TextField(
                    key: const Key('signin-code-field'),
                    controller: _code,
                    autofocus: true,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                        fontSize: 26,
                        letterSpacing: 12,
                        fontWeight: FontWeight.w600,),
                    decoration:
                        field.copyWith(counterText: '', hintText: '······'),
                  ),
                const SizedBox(height: 16),
                FlowButton(
                  label: _sent ? context.l.frContinue : context.l.frSendCode,
                  onTap: !_sent
                      ? (_emailOk ? () => setState(() => _sent = true) : null)
                      : (_code.text.length == 6
                          ? () {
                              Navigator.of(context).pop();
                              widget.state.signIn('email');
                            }
                          : null),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// Upino's charts taking turns behind the sign-in: each draws itself in,
/// holds, and fades as the next arrives.
class _ChartCycle extends StatefulWidget {
  const _ChartCycle({required this.dark, required this.source});
  final bool dark;
  final String source;

  @override
  State<_ChartCycle> createState() => _ChartCycleState();
}

class _ChartCycleState extends State<_ChartCycle> {
  int _i = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => setState(() => _i++));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  CustomPainter _painter(int k, double t) => switch (k % 5) {
        0 => _Balance(t: t, dark: widget.dark),
        1 => _Rings(t: t, dark: widget.dark, sub: context.l.frOfAllGoals),
        2 => _Bars(t: t, dark: widget.dark),
        3 => _Gauge(t: t, dark: widget.dark),
        _ => WaterfallPainter(
            t: 1 + 3 * t,
            dark: widget.dark,
            source: widget.source,
            tiers: const [Tier('', 0.4), Tier('', 0.14), Tier('', 0.07)],
            pool: '',
            poolLabel: '',
          ),
      };

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: 0.42,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          layoutBuilder: (current, previous) => Stack(fit: StackFit.expand, children: [...previous, if (current != null) current]),
          child: TweenAnimationBuilder<double>(
            key: ValueKey(_i),
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1500),
            curve: const Cubic(0.23, 1, 0.32, 1),
            builder: (context, t, _) => Padding(
              padding: const EdgeInsets.fromLTRB(40, 70, 40, 0),
              child: CustomPaint(painter: _painter(_i, t)),
            ),
          ),
        ),
      );
}

const _blue = Color(0xFF2F3AE8);

/// The balance timeline: past solid, projection dashed, today in lime.
class _Balance extends CustomPainter {
  _Balance({required this.t, required this.dark});
  final double t;
  final bool dark;

  static const _v = [0.52, 0.48, 0.55, 0.5, 0.42, 0.46, 0.38, 0.62, 0.58, 0.6, 0.53, 0.49, 0.44, 0.7, 0.66, 0.68, 0.61, 0.57, 0.63, 0.78];

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height * 0.8;
    final pts = [
      for (var i = 0; i < _v.length; i++)
        Offset(size.width * i / (_v.length - 1), h - _v[i] * h * 0.9),
    ];
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final a = pts[i - 1], b = pts[i];
      final mx = (a.dx + b.dx) / 2;
      path.cubicTo(mx, a.dy, mx, b.dy, b.dx, b.dy);
    }
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * t, size.height));
    final area = Path.from(path)
      ..lineTo(size.width, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(area, Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [_blue.withValues(alpha: 0.5), _blue.withValues(alpha: 0)],).createShader(Offset.zero & size),);
    canvas.drawPath(path, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = _blue,);
    canvas.restore();
    final today = pts[13];
    if (t > 0.66) {
      canvas.drawLine(Offset(today.dx, 0), Offset(today.dx, h), Paint()
        ..strokeWidth = 1
        ..color = (dark ? Colors.white : Colors.black).withValues(alpha: 0.15),);
      canvas.drawCircle(today, 7 * ((t - 0.66) / 0.34), Paint()..color = lime);
    }
  }

  @override
  bool shouldRepaint(_Balance old) => old.t != t;
}

/// Spending by week, one week in lime.
class _Bars extends CustomPainter {
  _Bars({required this.t, required this.dark});
  final double t;
  final bool dark;

  static const _v = [0.42, 0.6, 0.35, 0.8, 0.52, 0.66, 0.3, 0.9, 0.48];

  @override
  void paint(Canvas canvas, Size size) {
    final n = _v.length;
    const gap = 10.0;
    final w = (size.width - gap * (n - 1)) / n;
    final base = size.height * 0.82;
    for (var i = 0; i < n; i++) {
      final k = ((t * 1.6) - i * 0.07).clamp(0.0, 1.0);
      final bh = _v[i] * base * 0.9 * Curves.easeOutCubic.transform(k);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(i * (w + gap), base - bh, w, bh), const Radius.circular(10)),
        Paint()..color = i == 7 ? lime : _blue.withValues(alpha: 0.35 + 0.5 * _v[i]),
      );
    }
  }

  @override
  bool shouldRepaint(_Bars old) => old.t != t;
}

/// The pay gauge: what's gone, what's set aside, what's free.
class _Gauge extends CustomPainter {
  _Gauge({required this.t, required this.dark});
  final double t;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final r = math.min(size.width / 2, size.height * 0.8) - 14;
    final c = Offset(size.width / 2, size.height * 0.8);
    final rect = Rect.fromCircle(center: c, radius: r);
    Paint p(Color col) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round
      ..color = col;
    canvas.drawArc(rect, math.pi, math.pi, false, p((dark ? Colors.white : Colors.black).withValues(alpha: 0.06)));
    final parts = [(0.38, _blue), (0.24, _blue.withValues(alpha: 0.5)), (0.3, lime)];
    var start = math.pi;
    for (final (f, col) in parts) {
      final sweep = math.pi * f * t;
      canvas.drawArc(rect, start, math.max(0.001, sweep - 0.06), false, p(col));
      start += math.pi * f * t;
    }
  }

  @override
  bool shouldRepaint(_Gauge old) => old.t != t;
}
