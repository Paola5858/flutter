import 'package:flutter/material.dart';

class ColorTokens {
  static const primary = Color(0xFF01696F); // teal nexus senai
  static const accent = Color(0xFF00A896);
  static const error = Color(0xFFD62828);
  static const background = Color(0xFFF7F9F9);
  static const surface = Color(0xFFFFFFFF);
}

class ColorTokenSet extends ThemeExtension<ColorTokenSet> {
  final Color primary;
  final Color accent;
  final Color error;
  final Color background;
  final Color surface;
  final Color textPrimary;

  const ColorTokenSet({
    required this.primary,
    required this.accent,
    required this.error,
    required this.background,
    required this.surface,
    required this.textPrimary,
  });

  @override
  ThemeExtension<ColorTokenSet> copyWith({
    Color? primary,
    Color? accent,
    Color? error,
    Color? background,
    Color? surface,
    Color? textPrimary,
  }) {
    return ColorTokenSet(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
    );
  }

  @override
  ThemeExtension<ColorTokenSet> lerp(
    ThemeExtension<ColorTokenSet>? other,
    double t,
  ) {
    if (other is! ColorTokenSet) return this;
    return ColorTokenSet(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      error: Color.lerp(error, other.error, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
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
