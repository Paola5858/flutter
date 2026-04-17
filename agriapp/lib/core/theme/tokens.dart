import 'package:flutter/material.dart';

// leviatã rule: hsl semantic tokens, nada de hex hardcoded espalhado.
class ColorTokens extends ThemeExtension<ColorTokens> {
  final Color primary;
  final Color surface;
  final Color error;
  final Color textPrimary;

  const ColorTokens({
    required this.primary,
    required this.surface,
    required this.error,
    required this.textPrimary,
  });

  factory ColorTokens.light() => const ColorTokens(
    primary: Color(0xFF01696F), // teal senai araçatuba vibe
    surface: Color(0xFFFAFAFA),
    error: Color(0xFFB00020),
    textPrimary: Color(0xFF121212),
  );

  factory ColorTokens.dark() => const ColorTokens(
    primary: Color(0xFF4DB6AC),
    surface: Color(0xFF121212),
    error: Color(0xFFCF6679),
    textPrimary: Color(0xFFE0E0E0),
  );

  @override
  ThemeExtension<ColorTokens> copyWith({
    Color? primary,
    Color? surface,
    Color? error,
    Color? textPrimary,
  }) {
    return ColorTokens(
      primary: primary ?? this.primary,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
    );
  }

  @override
  ThemeExtension<ColorTokens> lerp(
    ThemeExtension<ColorTokens>? other,
    double t,
  ) {
    if (other is! ColorTokens) return this;
    return ColorTokens(
      primary: Color.lerp(primary, other.primary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
    );
  }
}

class SpacingTokens {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class TypographyTokens {
  static const headlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );
  static const bodyLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
}
