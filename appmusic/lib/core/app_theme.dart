import 'package:flutter/material.dart';

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
        fontFamily: 'Hanken Grotesk',
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: cream,
          elevation: 0,
        ),
      );
}
