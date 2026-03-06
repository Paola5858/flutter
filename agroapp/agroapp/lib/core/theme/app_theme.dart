import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// ThemeData centralizado para o app AgroControl
/// Suporta light e dark mode com ThemeMode.system
class AppTheme {
  // Construtor privado para evitar instanciação
  AppTheme._();

  /// ThemeData para modo claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.verdeOliva,
      scaffoldBackgroundColor: AppColors.fundoClaro,
      colorScheme: const ColorScheme.light(
        primary: AppColors.verdeOliva,
        secondary: AppColors.douradoTrigo,
        surface: AppColors.fundoClaro,
        onPrimary: Colors.white,
        onSecondary: AppColors.fundoEscuro,
        onSurface: AppColors.fundoEscuro,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.verdeOliva,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        // Títulos usando Cormorant Garamond bold
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.fundoEscuro,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.fundoEscuro,
        ),
        // Labels e botões usando Montserrat
        labelLarge: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.fundoEscuro,
        ),
        labelMedium: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.fundoEscuro,
        ),
        // Corpo usando Lora
        bodyLarge: GoogleFonts.lora(
          fontSize: 16,
          color: AppColors.fundoEscuro,
        ),
        bodyMedium: GoogleFonts.lora(
          fontSize: 14,
          color: AppColors.fundoEscuro,
        ),
        // Valores numéricos grandes usando Montserrat bold
        displayLarge: GoogleFonts.montserrat(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: AppColors.fundoEscuro,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.fundoEscuro,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeOliva,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// ThemeData para modo escuro
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.verdeOliva,
      scaffoldBackgroundColor: AppColors.fundoEscuro,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.verdeOliva,
        secondary: AppColors.douradoTrigo,
        surface: AppColors.fundoEscuro,
        onPrimary: Colors.white,
        onSecondary: AppColors.cremeSol,
        onSurface: AppColors.cremeSol,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.verdeOliva,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cormorantGaramond(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.cormorantGaramond(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.cremeSol,
        ),
        headlineMedium: GoogleFonts.cormorantGaramond(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.cremeSol,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.cremeSol,
        ),
        labelMedium: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppColors.cremeSol,
        ),
        bodyLarge: GoogleFonts.lora(
          fontSize: 16,
          color: AppColors.cremeSol,
        ),
        bodyMedium: GoogleFonts.lora(
          fontSize: 14,
          color: AppColors.cremeSol,
        ),
        displayLarge: GoogleFonts.montserrat(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: AppColors.cremeSol,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.cremeSol,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdeOliva,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A2420),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
