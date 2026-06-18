import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const ink = Color(0xFF211A17);
  static const cream = Color(0xFFF3ECDF);
  static const amber = Color(0xFFE08A2D);
  static const moss = Color(0xFF6B7A4F);
  static const rust = Color(0xFFB23A2E);

  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: ink,
        colorScheme: ColorScheme.dark(
          primary: amber,
          surface: cream,
          error: rust,
        ),
        useMaterial3: true,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.bricolageGrotesque(
            textStyle: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              color: cream,
            ),
          ),
          displayMedium: GoogleFonts.bricolageGrotesque(
            textStyle: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
              color: cream,
            ),
          ),
          displaySmall: GoogleFonts.bricolageGrotesque(
            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
              color: cream,
            ),
          ),
          titleLarge: GoogleFonts.bricolageGrotesque(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: cream,
            ),
          ),
          titleMedium: GoogleFonts.bricolageGrotesque(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: cream,
            ),
          ),
          bodyLarge: GoogleFonts.hankenGrotesk(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cream,
            ),
          ),
          bodyMedium: GoogleFonts.hankenGrotesk(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cream,
            ),
          ),
          bodySmall: GoogleFonts.hankenGrotesk(
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cream,
            ),
          ),
          labelLarge: GoogleFonts.spaceMono(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          labelMedium: GoogleFonts.spaceMono(
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          labelSmall: GoogleFonts.spaceMono(
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: cream,
          elevation: 0,
        ),
      );
}
