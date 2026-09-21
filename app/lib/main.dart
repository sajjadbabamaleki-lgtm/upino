import 'package:flutter/material.dart';

import 'design/theme.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'state/app_state.dart';

void main() => runApp(UpinoApp(state: AppState()));

class UpinoApp extends StatelessWidget {
  const UpinoApp({required this.state, super.key});

  final AppState state;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Upino',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(brightness: Brightness.light),
        darkTheme: buildTheme(brightness: Brightness.dark),
        home: AnimatedBuilder(
          animation: state,
          builder: (context, _) => state.isOnboarded
              ? HomeScreen(state: state)
              : OnboardingScreen(state: state),
        ),
      );
}
