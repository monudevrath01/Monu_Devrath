import 'package:flutter/material.dart';

class CyberTheme extends ThemeExtension<CyberTheme> {
  final Color backgroundColor;
  final Color cardBackgroundColor;
  final Color primaryGlow;
  final Color secondaryGlow;
  final Color accent;
  final Color textColor;
  final Color subtitleColor;
  final double glowIntensity;

  const CyberTheme({
    required this.backgroundColor,
    required this.cardBackgroundColor,
    required this.primaryGlow,
    required this.secondaryGlow,
    required this.accent,
    required this.textColor,
    required this.subtitleColor,
    required this.glowIntensity,
  });

  @override
  CyberTheme copyWith({
    Color? backgroundColor,
    Color? cardBackgroundColor,
    Color? primaryGlow,
    Color? secondaryGlow,
    Color? accent,
    Color? textColor,
    Color? subtitleColor,
    double? glowIntensity,
  }) {
    return CyberTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      primaryGlow: primaryGlow ?? this.primaryGlow,
      secondaryGlow: secondaryGlow ?? this.secondaryGlow,
      accent: accent ?? this.accent,
      textColor: textColor ?? this.textColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      glowIntensity: glowIntensity ?? this.glowIntensity,
    );
  }

  @override
  CyberTheme lerp(ThemeExtension<CyberTheme>? other, double t) {
    if (other is! CyberTheme) return this;
    return CyberTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      cardBackgroundColor: Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t)!,
      primaryGlow: Color.lerp(primaryGlow, other.primaryGlow, t)!,
      secondaryGlow: Color.lerp(secondaryGlow, other.secondaryGlow, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      glowIntensity: lerpDouble(glowIntensity, other.glowIntensity, t),
    );
  }

  static double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class AppTheme {
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff090014),
    extensions: const <ThemeExtension<dynamic>>[
      CyberTheme(
        backgroundColor: Color(0xff090014),
        cardBackgroundColor: Color(0xff140326),
        primaryGlow: Color(0xff8B5CF6),
        secondaryGlow: Color(0xffA855F7),
        accent: Color(0xffC084FC),
        textColor: Color(0xffFFFFFF),
        subtitleColor: Color(0xffB8A7D9),
        glowIntensity: 1.0,
      ),
    ],
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffFAFAFF),
    extensions: const <ThemeExtension<dynamic>>[
      CyberTheme(
        backgroundColor: Color(0xffFAFAFF),
        cardBackgroundColor: Color(0xffF0EBF8),
        primaryGlow: Color(0xffA78BFA),
        secondaryGlow: Color(0xffC084FC),
        accent: Color(0xff8B5CF6),
        textColor: Color(0xff1E1B4B),
        subtitleColor: Color(0xff6366F1),
        glowIntensity: 0.15,
      ),
    ],
  );
}

class ThemeController extends ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;

  ThemeData get currentTheme => _isDark ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
