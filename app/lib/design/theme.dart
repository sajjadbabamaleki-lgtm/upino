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

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    // Set here rather than on textTheme alone, so component styles such as
    // button labels inherit it too.
    fontFamily: fontFamily,
    scaffoldBackgroundColor: page,
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
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UpinoTokens.radiusCard),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 52,
        height: 1.05,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: textPrimary,
        fontFeatures: moneyFeatures,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 15, height: 1.4, color: textPrimary),
      bodySmall: TextStyle(fontSize: 13, height: 1.35, color: textSecondary),
      labelLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UpinoTokens.radiusPill),
        ),
        // The family is repeated here because an explicit component textStyle
        // wins over ThemeData.fontFamily and would otherwise fall back.
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
      ),
    ),
  );
}
