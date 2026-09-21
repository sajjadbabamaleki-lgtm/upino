/// Design tokens, §32.2 and §32.3 of Upino Product Foundation v3.5.
///
/// Values derive from the approved visual direction. Every text and control
/// pair records the measured WCAG 2.1 ratio beside it.
library;

import 'dart:ui';

class UpinoTokens {
  const UpinoTokens._();

  // --- Light mode (§32.2) -------------------------------------------------
  static const surfacePage = Color(0xFFF0F0F0);
  static const surfaceCard = Color(0xFFFFFFFF);
  static const surfaceSunken = Color(0xFFF4F4F5);
  static const surfaceRaised = Color(0xFFFFFFFF);

  /// Funding-gap hero (state S3). Never the celebratory gradient.
  static const surfaceInverse = Color(0xFF1E1E22);

  static const borderSubtle = Color(0xFFE8E8EA);

  static const textPrimary = Color(0xFF17171A); // 16.7:1 on card
  static const textSecondary = Color(0xFF55555C); // 7.4:1 on card
  static const textTertiary = Color(0xFF6E6E76); // 5.0:1 on card
  static const textOnInverse = Color(0xFFF8F8F8);

  static const actionPrimary = Color(0xFF2F3AE8); // white label 7.5:1
  static const actionPrimaryPressed = Color(0xFF2229B8);
  static const actionTint = Color(0xFFEFF1FE); // active nav pill
  static const actionOnTint = Color(0xFF262A78); // label on the tint, 9.4:1
  static const navIdle = Color(0xFF939399); // idle nav glyph, 3.06:1 on white

  /// The gradient is reserved for hero states S1 and S2 (§32.6).
  static const gradientStart = Color(0xFF2F3AE8);
  static const gradientEnd = Color(0xFF5B62F7);

  /// Transient confirmation only — never the Safe-to-Spend figure (§32.7).
  static const accentConfirm = Color(0xFFCDF95F); // with textPrimary 12.5:1
  static const accentConfirmSurface = Color(0xFFEFFBCF);

  static const critical = Color(0xFFCC2E26); // white 5.27:1 · on card 5.2:1

  /// critical measures 2.8:1 on the inverse surface, so S3 uses this instead.
  static const criticalOnInverse = Color(0xFFFF8A80); // 6.5:1 on inverse
  static const criticalSurface = Color(0xFFFCE9E7);

  // --- Dark mode (§32.3) --------------------------------------------------
  static const darkSurfacePage = Color(0xFF111114);
  static const darkSurfaceCard = Color(0xFF1C1C21);
  static const darkSurfaceSunken = Color(0xFF232329);
  static const darkSurfaceRaised = Color(0xFF26262D);
  static const darkBorderSubtle = Color(0xFF2E2E36);

  static const darkTextPrimary = Color(0xFFF2F2F4); // 15.2:1
  static const darkTextSecondary = Color(0xFFB4B4BC); // 8.3:1
  static const darkTextTertiary = Color(0xFF8A8A94); // 5.0:1

  static const darkActionPrimary = Color(0xFF5B63F5); // white label 4.62:1
  static const darkActionTint = Color(0xFF26294A);
  static const darkGradientStart = Color(0xFF3A43F0);
  static const darkGradientEnd = Color(0xFF6B72FF);

  /// A filled critical surface in dark mode takes a near-black label; white
  /// on this colour measures 2.79:1 and is prohibited.
  static const darkCritical = Color(0xFFFF6B63);
  static const darkCriticalLabel = Color(0xFF101012);
  static const darkCriticalSurface = Color(0xFF3A1F1D);

  // --- Shape, spacing, elevation -----------------------------------------
  static const radiusHero = 30.0;
  static const radiusCard = 26.0;
  static const radiusInner = 20.0;
  static const radiusPill = 999.0;
  static const gutter = 18.0;
  static const cardPadding = 20.0;

  /// The metadata separator. The multiplication sign is prohibited on any
  /// line that also carries a monetary amount (§32.8).
  static const separator = ' · ';
}
