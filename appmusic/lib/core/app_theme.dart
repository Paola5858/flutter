import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta obrigatória
  static const Color ink = Color(0xFF121212);
  static const Color cream = Color(0xFFF4F4F0);
  static const Color amber = Color(0xFFE08A2D);
  static const Color graphite = Color(0xFF333333);

  // Cores auxiliares já usadas no app atual (estados)
  static const Color moss = Color(0xFF6B7A4F);
  static const Color rust = Color(0xFFB23A2E);

  static TextTheme textTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        textStyle: const TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          height: 1.0,
          color: ink,
        ),
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        textStyle: const TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
          height: 1.05,
          color: ink,
        ),
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        textStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          height: 1.1,
          color: cream,
        ),
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
          height: 1.15,
          color: cream,
        ),
      ),
      titleLarge: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
          height: 1.2,
          color: cream,
        ),
      ),
      titleMedium: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.15,
          height: 1.25,
          color: cream,
        ),
      ),
      bodyLarge: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          height: 1.4,
          color: cream,
        ),
      ),
      bodyMedium: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.05,
          height: 1.45,
          color: cream,
        ),
      ),
      bodySmall: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
          height: 1.35,
          color: cream,
        ),
      ),
      labelLarge: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
          height: 1.2,
          color: ink,
        ),
      ),
      labelMedium: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
          height: 1.2,
          color: cream,
        ),
      ),
      labelSmall: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.25,
          height: 1.2,
          color: cream,
        ),
      ),
    );
  }

  static ThemeData get theme {
    final inputTheme = InputDecorationTheme(
      isDense: true,
      filled: false,
      contentPadding: EdgeInsets.zero,
      labelStyle: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          color: cream,
        ),
      ),
      hintStyle: GoogleFonts.spaceGrotesk(
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: cream.withOpacity(0.65),
          letterSpacing: 0.1,
        ),
      ),
      errorStyle: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: graphite, width: 1),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: amber, width: 1.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: rust, width: 1.5),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: rust, width: 1.5),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ink,
      colorScheme: ColorScheme.dark(
        primary: amber,
        surface: ink,
        background: ink,
        onPrimary: ink,
        onSurface: cream,
        error: rust,
      ),
      dividerColor: graphite,
      textTheme: textTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: ink,
        foregroundColor: cream,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: inputTheme,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cream,
          side: const BorderSide(color: graphite, width: 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: amber,
          foregroundColor: ink,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: amber,
        foregroundColor: ink,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: graphite,
        contentTextStyle: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            color: cream,
          ),
        ),
      ),
    );
  }
}
