import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF070707);
  static const Color surface = Color(0xFF111111);
  static const Color surfaceLight = Color(0xFF1A1A1A);
  static const Color border = Color(0xFF242424);
  static const Color accent = Colors.white;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        surface: surface,
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.pirataOne(
          fontSize: 54,
          color: Colors.white,
          letterSpacing: 2,
        ),
        headlineMedium: GoogleFonts.pirataOne(
          fontSize: 32,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}
