import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_learning/theme/app_colors.dart';

class AppTheme {
  // Cupertino Theme
  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      barBackgroundColor: AppColors.surface,
      textTheme: CupertinoTextThemeData(primaryColor: AppColors.textPrimary),
    );
  }

  // Material Theme
  static ThemeData get materialTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.textOrange,
      ),
      // Use Cairo font family from Google Fonts
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.cairo(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: GoogleFonts.cairo(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodySmall: GoogleFonts.cairo(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      // Input decoration theme with Cairo font
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        hintStyle: GoogleFonts.cairo(
          fontSize: 16,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.normal,
        ),
        labelStyle: GoogleFonts.cairo(
          fontSize: 16,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.normal,
        ),
        floatingLabelStyle: GoogleFonts.cairo(
          fontSize: 14,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.textOrange, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  // Common text styles using Cairo from Google Fonts
  static TextStyle get titleLarge => GoogleFonts.cairo(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get headline => GoogleFonts.cairo(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => GoogleFonts.cairo(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.cairo(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get caption => GoogleFonts.cairo(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Common decorations
  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static InputDecoration get inputDecoration {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.inputBackground,
      // Add Cairo font for placeholder text
      hintStyle: GoogleFonts.cairo(
        fontSize: 16,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.normal,
      ),
      // Add Cairo font for label text
      labelStyle: GoogleFonts.cairo(
        fontSize: 16,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.normal,
      ),
      // Add Cairo font for floating label
      floatingLabelStyle: GoogleFonts.cairo(
        fontSize: 14,
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.textOrange, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // Additional input decoration method for customizable placeholders
  static InputDecoration getInputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.inputBackground,
      // Cairo font for hint text
      hintStyle: GoogleFonts.cairo(
        fontSize: 16,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.normal,
      ),
      // Cairo font for label text
      labelStyle: GoogleFonts.cairo(
        fontSize: 16,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.normal,
      ),
      // Cairo font for floating label
      floatingLabelStyle: GoogleFonts.cairo(
        fontSize: 14,
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.textOrange, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.textOrange, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
