import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4ECDC4);
  static const Color primaryLight = Color(0xFF5ED9D1);
  static const Color primaryDark = Color(0xFF44A08D);

  static const Color background = Color(0xFFF8FAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFF8FAFA);

  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFA8A8A8);
  static const Color textOrange = Color(0xFFFF9A56);

  static const Color border = Color(0xFFE8E8E8);

  static const Color buttonPrimary = Color(0xFF4ECDC4);
  static const Color buttonText = Color(0xFFFFFFFF);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF8E8E93);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
