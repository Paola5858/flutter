import 'package:flutter/material.dart';

class ColorTokenSet extends ThemeExtension<ColorTokenSet> {
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color error;
  final Color textPrimary;

  const ColorTokenSet({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.error,
    required this.textPrimary,
  });

  @override
  ThemeExtension<ColorTokenSet> copyWith({
    Color? primary,
    Color? accent,
    Color? background,
    Color? surface,
    Color? error,
    Color? textPrimary,
  }) {
    return ColorTokenSet(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      textPrimary: textPrimary ?? this.textPrimary,
    );
  }

  @override
  ThemeExtension<ColorTokenSet> lerp(ThemeExtension<ColorTokenSet>? other, double t) {
    if (other is! ColorTokenSet) return this;
    return ColorTokenSet(
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
    );
  }
}

class ColorTokens {
  // HSL Color Logic - Vibe Chic/Enterprise
  static Color primary = HSLColor.fromAHSL(1.0, 182.0, 0.98, 0.22).toColor();
  static Color accent = HSLColor.fromAHSL(1.0, 174.0, 1.0, 0.33).toColor();
  static Color error = HSLColor.fromAHSL(1.0, 348.0, 0.83, 0.47).toColor();
  static Color background = HSLColor.fromAHSL(1.0, 180.0, 0.12, 0.97).toColor();
  static Color surface = const Color(0xFFFFFFFF);
  static Color textPrimary = HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.10).toColor();
  static Color darkBackground = const Color(0xFF121212);

  static const primaryHex = Color(0xFF01696F); // Legacy fallback
  static const accentHex = Color(0xFF00A896);
  static const errorHex = Color(0xFFD62828);
}