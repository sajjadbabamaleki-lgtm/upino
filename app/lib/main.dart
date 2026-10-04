import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'l10n/app_localizations.dart';

import 'data/plan_store.dart';
import 'device/device_bridge.dart';
import 'design/motion.dart';
import 'design/theme.dart';
import 'design/tokens.dart';
import 'screens/home_screen.dart';
import 'screens/first_run/first_run_flow.dart';
import 'screens/first_run/reveal_screen.dart';
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
  runApp(UpinoApp(state: state));
  await state.restore();
  // After the plan is back, so the widget and the reminder describe the
  // real plan and not an empty one.
  await DeviceBridge.start(state);
}

class UpinoApp extends StatelessWidget {
  const UpinoApp({required this.state, this.fontFamily, this.singleFormSetup = false, super.key});

  final AppState state;

  /// The one-screen setup form instead of the guided first run. Kept for
  /// the tests that drive the engine through setup; people never see it.
  @visibleForTesting
  final bool singleFormSetup;

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
        scrollBehavior: const UpinoScrollBehavior(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // A phone in a language the app does not speak gets English, not
        // whichever language happens to sort first (Arabic, right to left).
        localeResolutionCallback: (device, supported) {
          if (device != null) {
            for (final l in supported) {
              if (l.languageCode == device.languageCode) return l;
            }
          }
          return const Locale('en');
        },
        // Null follows the phone; Flutter then resolves to the closest
        // supported language, falling back to English. Arabic and Persian
        // flip the whole layout, which Directionality handles from the
        // locale alone — no screen asks which way it is running.
        locale: state.languageCode == null ? null : Locale(state.languageCode!),
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
                ? (state.revealPending
                    ? RevealScreen(state: state)
                    : HomeScreen(state: state))
                : singleFormSetup
                    ? OnboardingScreen(state: state)
                    : FirstRunFlow(state: state),
      );

  ThemeData _themed(Brightness brightness) =>
      buildTheme(brightness: brightness, fontFamily: fontFamily ?? 'Geist');

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
