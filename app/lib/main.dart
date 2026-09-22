import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/plan_store.dart';
import 'design/theme.dart';
import 'design/tokens.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Draw the page colour the full height of the display, behind the clock and
  // the battery at the top and behind the gesture bar at the bottom. Every
  // screen already wraps its content in a SafeArea, so only the background
  // moves up; nothing lands under the status icons.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final state = AppState(store: await FilePlanStore.inAppDirectory());
  unawaited(state.restore());
  runApp(UpinoApp(state: state));
}

class UpinoApp extends StatelessWidget {
  const UpinoApp({required this.state, this.fontFamily, super.key});

  final AppState state;

  /// Set only by the screenshot harness, which loads its own face.
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: state,
        builder: (context, _) => _app(context),
      );

  Widget _app(BuildContext context) => MaterialApp(
        title: 'Upino',
        debugShowCheckedModeBanner: false,
        theme: _themed(Brightness.light),
        darkTheme: _themed(Brightness.dark),
        themeMode: switch (state.themeChoice) {
          ThemeChoice.system => ThemeMode.system,
          ThemeChoice.light => ThemeMode.light,
          ThemeChoice.dark => ThemeMode.dark,
        },
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: _overlayStyle(Theme.of(context).brightness),
          child: child ?? const SizedBox.shrink(),
        ),
        // Waiting one frame beats showing an empty plan and replacing it.
        home: !state.isRestored
            ? const _RestoringScreen()
            : state.isOnboarded
                ? HomeScreen(state: state)
                : OnboardingScreen(state: state),
      );

  ThemeData _themed(Brightness brightness) =>
      buildTheme(brightness: brightness, fontFamily: fontFamily);

  /// Transparent bars, with the glyphs inside them set to whichever of black
  /// or white reads against the page underneath. Android and iOS name that
  /// choice with opposite conventions, hence the two fields.
  static SystemUiOverlayStyle _overlayStyle(Brightness brightness) {
    final light = brightness == Brightness.light;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: light ? Brightness.dark : Brightness.light,
      statusBarBrightness: light ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          light ? Brightness.dark : Brightness.light,
      // Without this Android paints its own translucent scrim over the
      // navigation bar, which shows as a band in a different shade.
      systemNavigationBarContrastEnforced: false,
    );
  }
}

class _RestoringScreen extends StatelessWidget {
  const _RestoringScreen();

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: UpinoTokens.actionPrimary,
            ),
          ),
        ),
      );
}
