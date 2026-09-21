/// Design tokens, §32.2 and §32.3 of Upino Product Foundation v3.5.
///
/// Every text and control pair below was verified against WCAG 2.1 contrast
/// minimums; the measured ratio is recorded beside each token so the values
/// can be re-checked rather than trusted.
library;

import 'dart:ui';

class UpinoTokens {
  const UpinoTokens._();

  // --- Light mode (§32.2) -------------------------------------------------
  static const surfacePage = Color(0xFFF0F0F0);
  static const surfaceCard = Color(0xFFF8F8F8);
  static const surfaceRaised = Color(0xFFFFFFFF);

  /// Funding-gap hero (state S3). Never the celebratory gradient.
  static const surfaceInverse = Color(0xFF282828);

  /// Decorative separator only; never carries state.
  static const borderSubtle = Color(0xFFE4E4E6);

  static const textPrimary = Color(0xFF282828); // 13.88:1 on card
  static const textSecondary = Color(0xFF555358); // 7.15:1 on card
  static const textTertiary = Color(0xFF6E6E76); // 4.76:1 on card
  static const textOnInverse = Color(0xFFF8F8F8); // 13.88:1 on inverse

  static const actionPrimary = Color(0xFF3038E8); // white label 7.35:1
  static const actionPrimaryPressed = Color(0xFF2229B8); // white label 10.11:1

  /// The gradient is reserved for hero states S1 and S2 (§32.6).
  static const gradientStart = Color(0xFF3038E8);
  static const gradientEnd = Color(0xFF5858F8);

  /// Transient confirmation only — never the Safe-to-Spend figure (§32.7).
  static const accentConfirm = Color(0xFFC8F868); // with textPrimary 11.99:1
  static const accentConfirmSurface = Color(0xFFF0F8D8); // 13.43:1

  static const critical = Color(0xFFCC2E26); // white 5.27:1 · on card 4.96:1

  /// critical measures only 2.80:1 on surfaceInverse, so the S3 hero uses
  /// this lighter value instead. That is why two critical tokens exist.
  static const criticalOnInverse = Color(0xFFFF8A80); // 6.46:1 on inverse
  static const criticalSurface = Color(0xFFFBE4E2); // with textPrimary 12.14:1

  // --- Dark mode (§32.3) --------------------------------------------------
  static const darkSurfacePage = Color(0xFF121214);
  static const darkSurfaceCard = Color(0xFF1C1C20);
  static const darkSurfaceRaised = Color(0xFF24242A);
  static const darkBorderSubtle = Color(0xFF2E2E36);

  static const darkTextPrimary = Color(0xFFF2F2F4); // 15.19:1 on card
  static const darkTextSecondary = Color(0xFFB4B4BC); // 8.25:1
  static const darkTextTertiary = Color(0xFF8A8A94); // 4.97:1

  static const darkActionPrimary = Color(0xFF5B63F5); // white label 4.62:1
  static const darkGradientStart = Color(0xFF4048F0);
  static const darkGradientEnd = Color(0xFF6B72FF);

  /// A filled critical surface in dark mode takes a near-black label; white
  /// on this colour measures 2.79:1 and is prohibited.
  static const darkCritical = Color(0xFFFF6B63); // as text 6.09:1
  static const darkCriticalLabel = Color(0xFF101012); // on critical 6.82:1
  static const darkCriticalSurface = Color(0xFF3A1F1D);

  // --- Shape and spacing --------------------------------------------------
  static const radiusCard = 24.0;
  static const radiusPill = 999.0;
  static const gutter = 16.0;
  static const cardPadding = 20.0;

  /// The metadata separator. The multiplication sign is prohibited on any
  /// line that also carries a monetary amount (§32.8).
  static const separator = ' · ';
}
