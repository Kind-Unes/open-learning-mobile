import 'package:flutter/material.dart';

class AppColors {
  // Primary blue from the logo
  static const Color primary = Color(0xFF5B9BD5);
  static const Color primaryDark = Color(0xFF4A8BC2);
  
  // Orange/yellow from the logo pages
  static const Color accent = Color(0xFFE6A445);
  
  // Neutral colors
  static const Color background = Color(0xFFF8FAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  
  // Text colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFA8A8A8);
  
  // UI elements
  static const Color border = Color(0xFFE8E8E8);
  static const Color grey = Color(0xFF8E8E93);
  
  // Buttons
  static const Color buttonPrimary = primary;
  static const Color buttonText = white;
  
  // Gradient using logo colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}