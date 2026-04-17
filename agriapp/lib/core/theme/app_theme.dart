import 'package:flutter/material.dart';
import 'tokens.dart';

extension AppTheme on ThemeData {
  static ThemeData light() {
    final colorTokens = ColorTokens.light();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorTokens.primary,
        brightness: Brightness.light,
      ).copyWith(surface: colorTokens.surface),
      extensions: <ThemeExtension<dynamic>>[colorTokens],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorTokens.primary,
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
    final colorTokens = ColorTokens.dark();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorTokens.primary,
        brightness: Brightness.dark,
      ).copyWith(surface: colorTokens.surface),
      extensions: <ThemeExtension<dynamic>>[colorTokens],
    );
  }
}
