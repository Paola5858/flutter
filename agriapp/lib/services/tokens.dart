import 'package:flutter/material.dart';

class ColorTokenSet extends ThemeExtension<ColorTokenSet> {
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color error;

  const ColorTokenSet({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.error,
  });

  @override
  ThemeExtension<ColorTokenSet> copyWith({
    Color? primary,
    Color? accent,
    Color? background,
    Color? surface,
    Color? error,
  }) {
    return ColorTokenSet(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
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
    );
  }
}

class ColorTokens {
  static const primary = Color(0xFF01696F);
  static const accent = Color(0xFF00A896);
  static const error = Color(0xFFD62828);
  static const background = Color(0xFFF7F9F9);
  static const surface = Color(0xFFFFFFFF);
  static const darkBackground = Color(0xFF121212);
}