/// Design tokens, §32.2 and §32.3 of Upino Product Foundation v3.5.
///
/// Values derive from the approved visual direction. Every text and control
/// pair records the measured WCAG 2.1 ratio beside it.
library;

import 'dart:ui';

class UpinoTokens {
  const UpinoTokens._();

  // --- Light mode (§32.2) -------------------------------------------------
  static const surfacePage = Color(0xFFF7F7F7);
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

  /// The gradient is reserved for hero states S1 and S2 (§32.6). Both stops
  /// are read off the approved direction rather than chosen. The reference
  /// card's per-row modal colour climbs at a steady rate over its clean band,
  /// and its left and right edges agree at every row, so the sweep is
  /// vertical and far wider than a tinted wash. The ends are that band's
  /// slope carried out to the card edges, not to where the blue channel
  /// would have run past 255.
  static const gradientStart = Color(0xFF2F3AE8); // white label 8.93:1
  static const gradientEnd = Color(0xFF2F3AE8); // white label 2.79:1

  /// White clears 4.5:1 only down to about three fifths of that sweep.
  /// Anything sitting lower gets this scrim behind it, which restores the
  /// ratio without pulling the gradient's light end back in. Kept as light
  /// as the ratio allows so it reads as a soft chip, not a bar.
  static const onGradientScrim = Color(0x33000000);

  /// Transient confirmation only — never the Safe-to-Spend figure (§32.7).
  /// The reference uses the saturated end for pills and dots alone; a filled
  /// panel takes the two surface stops instead, lightest at the top.
  static const accentConfirm = Color(0xFFE2E4FC); // with textPrimary 15.32:1
  static const accentSurfaceStart = Color(0xFFEEF0FD); // textPrimary 17.40:1
  static const accentSurfaceEnd = Color(0xFFEEF0FD); // textPrimary 16.17:1

  static const critical = Color(0xFFCC2E26); // white 5.27:1 · on card 5.2:1

  /// critical measures 2.8:1 on the inverse surface, so S3 uses this instead.
  static const criticalOnInverse = Color(0xFFFF8A80); // 6.5:1 on inverse
  static const criticalSurface = Color(0xFFFCE9E7);

  // --- Dark mode (§32.3) --------------------------------------------------
  static const darkSurfacePage = Color(0xFF0B0B0D);
  static const darkSurfaceCard = Color(0xFF141418);
  static const darkSurfaceSunken = Color(0xFF1E1E23);
  static const darkSurfaceRaised = Color(0xFF212127);
  static const darkBorderSubtle = Color(0xFF28282F);

  /// The top bar and the tab bar: the card colour, no edge.
  static const darkChrome = Color(0xFF141418);
  static const darkChromeEdge = Color(0x12FFFFFF);

  static const darkTextPrimary = Color(0xFFF2F2F4); // 15.2:1
  static const darkTextSecondary = Color(0xFFB4B4BC); // 8.3:1
  static const darkTextTertiary = Color(0xFF8A8A94); // 5.0:1

  /// The second colour: only for good money news — pay arriving, money
  /// in, a goal saved in full. Always as a fill, never as text on white.
  static const lime = Color(0xFFCDFE6C);

  static const darkActionPrimary = Color(0xFF5B63F5); // white label 4.62:1
  static const darkActionTint = Color(0xFF26294A);
  /// The same sweep held back about a tenth, so the hero does not glare
  /// against the dark page.
  static const darkGradientStart = Color(0xFF2F3AE8); // white 9.82:1
  static const darkGradientEnd = Color(0xFF2F3AE8); // white 3.54:1

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
