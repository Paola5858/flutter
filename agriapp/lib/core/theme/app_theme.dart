import 'package:flutter/material.dart';
import 'tokens.dart';

extension AppTheme on ThemeData {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorTokens.primary,
        brightness: Brightness.light,
      ).copyWith(surface: ColorTokens.surface),
      extensions: <ThemeExtension<dynamic>>[
        ColorTokenSet(
          primary: ColorTokens.primary,
          accent: ColorTokens.accent,
          error: ColorTokens.error,
          background: ColorTokens.background,
          surface: ColorTokens.surface,
          textPrimary: Colors.black,
        ),
      ],
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorTokens.primary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, 44), // touch 44px WCAG
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorTokens.accent,
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
      ),
      extensions: <ThemeExtension<dynamic>>[
        const ColorTokenSet(
          primary: ColorTokens.accent,
          accent: ColorTokens.primary,
          error: ColorTokens.error,
          background: Color(0xFF121212),
          surface: Color(0xFF1E1E1E),
          textPrimary: Color(0xFFFFFFFF),
        ),
      ],
    );
  }
}
