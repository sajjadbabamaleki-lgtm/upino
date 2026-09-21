import 'package:flutter/material.dart';

import 'design/theme.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';

void main() => runApp(UpinoApp(state: AppState()));

class UpinoApp extends StatelessWidget {
  const UpinoApp({required this.state, this.fontFamily, super.key});

  final AppState state;

  /// Set only by the screenshot harness, which loads its own face.
  final String? fontFamily;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Upino',
        debugShowCheckedModeBanner: false,
        theme: _themed(Brightness.light),
        darkTheme: _themed(Brightness.dark),
        home: AnimatedBuilder(
          animation: state,
          builder: (context, _) => state.isOnboarded
              ? HomeScreen(state: state)
              : OnboardingScreen(state: state),
        ),
      );

  ThemeData _themed(Brightness brightness) =>
      buildTheme(brightness: brightness, fontFamily: fontFamily);
}
