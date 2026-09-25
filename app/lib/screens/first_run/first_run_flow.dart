/// Everything before the plan exists: welcome, sign-in, then setup. Which
/// one shows is read from saved state, so closing the app mid-way reopens
/// at the same place.
library;

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';


import '../../state/app_state.dart';
import '../language_screen.dart';
import 'fr_parts.dart';
import 'setup_flow.dart';
import 'welcome_screen.dart';

class FirstRunFlow extends StatelessWidget {
  const FirstRunFlow({required this.state, super.key});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final (key, child) = !state.languageChosen
        ? ('language', LanguageStart(state: state) as Widget)
        : !state.welcomeSeen
            ? ('welcome', WelcomeScreen(state: state) as Widget)
            : state.signInProvider == null
                ? ('signin', SignInScreen(state: state))
                : ('setup', SetupFlow(state: state));
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: const Cubic(0.23, 1, 0.32, 1),
      transitionBuilder: (c, a) => FadeTransition(
        opacity: a,
        child: ScaleTransition(
            scale: Tween(begin: 0.98, end: 1.0).animate(a), child: c,),
      ),
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
  }
}

/// The very first screen: the phone's own language, large, with the other
/// nine a tap away. Most people only confirm.
class LanguageStart extends StatefulWidget {
  const LanguageStart({required this.state, super.key});
  final AppState state;

  @override
  State<LanguageStart> createState() => _LanguageStartState();
}

class _LanguageStartState extends State<LanguageStart> {
  static String get _device => PlatformDispatcher.instance.locale.languageCode;

  /// True when the phone's own language is one the app speaks.
  bool get _fromPhone => languageNames.containsKey(_device);

  late final String _phone = _fromPhone ? _device : 'en';

  /// The chosen language sits in the card; the rest fill the grid. A tap
  /// swaps a tile with the card, so nothing ever disappears.
  late String _hero = widget.state.languageCode ?? _phone;
  late final List<String> _grid = [
    for (final c in languageNames.keys) if (c != _hero) c,
  ];

  void _swap(int i) => setState(() {
        final was = _hero;
        _hero = _grid[i];
        _grid[i] = was;
      });

  void _go() {
    widget.state
      ..setLanguageCode(_hero == _phone ? null : _hero)
      ..markLanguageChosen();
  }

  @override
  Widget build(BuildContext context) {
    final name = languageNames[_hero]!;
    final label = _hero != _phone ? 'SELECTED' : _fromPhone ? 'FROM YOUR PHONE' : 'SUGGESTED';
    final line = [
      if (name.english != name.native) name.english,
      if (_hero == _phone) _fromPhone ? 'The language on your phone' : 'Yours isn’t here yet',
    ].join(' · ');
    return Scaffold(
      backgroundColor: pageOf(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Arrive(
                child: Text(
                  'Let’s speak\nyour language.',
                  maxLines: 2,
                  style: TextStyle(fontSize: 30, height: 1.1, fontWeight: FontWeight.w600,
                      letterSpacing: -0.7, color: inkOf(context),),
                ),
              ),
              const SizedBox(height: 22),
              Arrive(
                delay: const Duration(milliseconds: 80),
                child: Container(
                  width: double.infinity,
                  height: 176,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2F3AE8), Color(0xFF1D25A8)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      HeroGlyph('Aa', color: Colors.white.withValues(alpha: 0.08)),
                      Padding(
                        padding: const EdgeInsets.all(22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 240),
                              child: Text(label, key: ValueKey(label), style: const TextStyle(fontSize: 10.5,
                                  fontWeight: FontWeight.w600, letterSpacing: 1.3, color: Color(0xB3FFFFFF),),),
                            ),
                            const Spacer(),
                            SwapSlot(
                              id: _hero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name.native, style: const TextStyle(fontSize: 38,
                                      fontWeight: FontWeight.w600, letterSpacing: -1, color: Colors.white,),),
                                  Text(line.isEmpty ? _hero.toUpperCase() : line,
                                      style: const TextStyle(fontSize: 13, color: Color(0xBFFFFFFF)),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('OR CHOOSE', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600,
                  letterSpacing: 1.3, color: tertOf(context),),),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.75,
                children: [
                  for (var i = 0; i < _grid.length; i++)
                    Arrive(
                      delay: Duration(milliseconds: 140 + 30 * i),
                      child: SwapSlot(
                        id: _grid[i],
                        fromBelow: false,
                        child: pickTile(
                          context,
                          key: Key('lang-${_grid[i]}'),
                          title: languageNames[_grid[i]]!.native,
                          sub: _grid[i].toUpperCase(),
                          onTap: () => _swap(i),
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              FlowButton(
                buttonKey: const Key('language-continue'),
                label: 'Continue in ${name.native}',
                style: FlowButtonStyle.light,
                onTap: _go,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
