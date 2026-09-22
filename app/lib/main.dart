import 'dart:async';

import 'package:flutter/material.dart';

import 'data/plan_store.dart';
import 'design/theme.dart';
import 'design/tokens.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // Waiting one frame beats showing an empty plan and replacing it.
        home: !state.isRestored
            ? const _RestoringScreen()
            : state.isOnboarded
                ? HomeScreen(state: state)
                : OnboardingScreen(state: state),
      );

  ThemeData _themed(Brightness brightness) =>
      buildTheme(brightness: brightness, fontFamily: fontFamily);
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
