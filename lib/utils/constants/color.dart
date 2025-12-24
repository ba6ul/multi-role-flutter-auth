import 'package:flutter/material.dart';

class HColors {
  // -- Brand Colors
  static const Color primary = Color(0xFF212842);      // Midnight Indigo
  static const Color secondary = Color(0xFFF0E7D5);    // Vanilla Cream
  static const Color accent = Color(0xFFC5A358);       // Muted Gold
  
  // -- Background Colors
  static const Color lightBackground = Color(0xFFFDFBF7); // Off-white cream
  static const Color darkBackground = Color(0xFF10141D);  // Deeper Navy for Dark Mode
  
  // -- Primary & Secondary Background (Used for sections/hero)
  static const Color primaryBackground = Color(0xFFF0E7D5);   // Vanilla Cream
  static const Color secondaryBackground = Color(0xFF212842); // Midnight Indigo

  // -- Text Colors
  static const Color textPrimary = Color(0xFF212842);    // Midnight Indigo (High contrast on cream)
  static const Color textSecondary = Color(0xFF5D6C89);  // Slate Blue (Softer)
  static const Color textWhite = Colors.white;
  
  // Dark Mode Text
  static const Color textDarkPrimary = Color(0xFFF0E7D5);   // Vanilla Cream
  static const Color textDarkSecondary = Color(0xFF9CA3AF); // Muted Gray

  // -- Container & Card Colors
  static const Color lightContainer = Color(0xFFF7F2E9); // Slightly darker cream 
  static const Color darkContainer = Color(0xFF1B2235);  // Mid-tone Navy
  static const Color cardBackgroundColor = Color(0xFFFFFFFF);

  // -- Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFF5D6C89);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // -- Border Colors
  static const Color borderPrimary = primary;
  static const Color borderSecondary = Color(0xFFE5DCC3);
  
  // -- Icon Colors
  static const Color iconPrimaryLight = Color(0xFF212842);
  static const Color iconSecondaryLight = Color(0xFFC5A358);
  static const Color iconPrimaryDark = Color(0xFFF0E7D5);

  // -- ON-BOARDING COLORS (Harmonized with palette)
  static const Color onBoardingPage1Color = Color(0xFFFDFBF7);
  static const Color onBoardingPage2Color = Color(0xFFE8E1D1);
  static const Color onBoardingPage3Color = Color(0xFFDCD4C0);

  // -- System Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // -- Neutral Shades
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color white = Color(0xFFFFFFFF);
}