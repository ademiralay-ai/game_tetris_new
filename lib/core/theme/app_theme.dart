import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonCyan,
        secondary: AppColors.neonMagenta,
        surface: AppColors.darkCard,
        error: AppColors.neonRed,
      ),
      textTheme: GoogleFonts.orbitronTextTheme(
        ThemeData.dark().textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(
          color: AppColors.neonCyan,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: AppColors.neonCyan),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.neonCyan,
          side: const BorderSide(color: AppColors.neonCyan, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          textStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          side: const BorderSide(color: AppColors.neonCyan, width: 1),
        ),
        elevation: 8,
      ),
      iconTheme: const IconThemeData(color: AppColors.neonCyan),
      useMaterial3: true,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF0F0FF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5500CC),
        secondary: Color(0xFFCC0088),
        surface: Color(0xFFE8E8FF),
        error: Color(0xFFCC0033),
      ),
      textTheme: GoogleFonts.orbitronTextTheme(
        ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF1A1A3E),
          displayColor: const Color(0xFF1A1A3E),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFE8E8FF),
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(
          color: const Color(0xFF5500CC),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: Color(0xFF5500CC)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF5500CC),
          side: const BorderSide(color: Color(0xFF5500CC), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          textStyle: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFFE8E8FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          side: const BorderSide(color: Color(0xFF5500CC), width: 1),
        ),
        elevation: 4,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF5500CC)),
      useMaterial3: true,
    );
  }
}
