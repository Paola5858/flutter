import 'package:flutter/material.dart';
import 'tokens.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: ColorTokens.primary,
      extensions: <ThemeExtension<dynamic>>[
        const ColorTokenSet(
          primary: ColorTokens.primary,
          accent: ColorTokens.accent,
          background: ColorTokens.background,
          surface: ColorTokens.surface,
          error: ColorTokens.error,
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorTokens.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: ColorTokens.accent,
      extensions: <ThemeExtension<dynamic>>[
        const ColorTokenSet(
          primary: ColorTokens.accent,
          accent: ColorTokens.primary,
          background: ColorTokens.darkBackground,
          surface: Color(0xFF1E1E1E),
          error: ColorTokens.error,
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        centerTitle: true,
      ),
    );
  }
}