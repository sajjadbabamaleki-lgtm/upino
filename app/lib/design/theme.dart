/// Flutter theme assembled from the §32 tokens.
library;

import 'package:flutter/material.dart';

import 'tokens.dart';

/// Monetary figures use lining tabular numerals. Safe-to-Spend recalculates on
/// every trigger in §14, and proportional figures change width between
/// recalculations, which reads as instability in the one number the product
/// asks the user to trust (§32.8).
const moneyFeatures = <FontFeature>[
  FontFeature.tabularFigures(),
  FontFeature.liningFigures(),
];

ThemeData buildTheme({required Brightness brightness, String? fontFamily}) {
  final dark = brightness == Brightness.dark;

  final page = dark ? UpinoTokens.darkSurfacePage : UpinoTokens.surfacePage;
  final card = dark ? UpinoTokens.darkSurfaceCard : UpinoTokens.surfaceCard;
  final raised = dark ? UpinoTokens.darkSurfaceRaised : UpinoTokens.surfaceRaised;
  final primary = dark ? UpinoTokens.darkActionPrimary : UpinoTokens.actionPrimary;
  final textPrimary = dark ? UpinoTokens.darkTextPrimary : UpinoTokens.textPrimary;
  final textSecondary =
      dark ? UpinoTokens.darkTextSecondary : UpinoTokens.textSecondary;
  final critical = dark ? UpinoTokens.darkCritical : UpinoTokens.critical;

  TextStyle heading(double size, {double spacing = -0.8}) => TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: spacing,
        height: 1.15,
        color: textPrimary,
        fontFamily: fontFamily,
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: page,
    // Set here rather than on textTheme alone, so component styles such as
    // button labels inherit it too.
    fontFamily: fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: UpinoTokens.actionPrimary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      surface: card,
      surfaceContainerHighest: raised,
      error: critical,
      onSurface: textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: heading(50, spacing: -2).copyWith(fontFeatures: moneyFeatures),
      displayMedium: heading(38, spacing: -1.4).copyWith(fontFeatures: moneyFeatures),
      headlineLarge: heading(30, spacing: -1),
      headlineMedium: heading(25),
      headlineSmall: heading(22, spacing: -0.5).copyWith(fontFeatures: moneyFeatures),
      titleLarge: heading(19, spacing: -0.4),
      titleMedium: TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: textPrimary,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.5,
        height: 1.4,
        color: textPrimary,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        height: 1.35,
        color: textSecondary,
        fontFamily: fontFamily,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor:
            dark ? UpinoTokens.darkSurfaceSunken : UpinoTokens.surfaceSunken,
        disabledForegroundColor: UpinoTokens.textTertiary,
        minimumSize: const Size.fromHeight(56),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        // The family is repeated here because an explicit component textStyle
        // wins over ThemeData.fontFamily and would otherwise fall back.
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: fontFamily,
        ),
      ),
    ),
  );
}
