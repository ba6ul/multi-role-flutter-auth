import 'package:flutter/material.dart';
/*
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
*/

class HColors {
  // -- App Theme Colors
  // Using your preferred trio as the foundation
  static const Color primary = Color(0xFF212842);      // Midnight Indigo
  static const Color secondary = Color(0xFFF0E7D5);    // Vanilla Cream
  static const Color accent = Color(0xFFC5A358);       // Muted Gold

  // -- Icon Colors
  // Indigo for light mode visibility; Cream/Gold usually handled by theme logic
  static const Color iconPrimary = Color(0xFF212842);

  // -- Text Colors
  static const Color textPrimary = Color(0xFF1A1F33);  // Deepest Indigo (Near Black)
  static const Color textSecondary = Color(0xFF6B7280); // Muted Grey-Blue
  static const Color textWhite = Colors.white;

  // -- Background Colors
  static const Color light = Color(0xFFFDFBFA);        // Soft Pearl White
  static const Color dark = Color(0xFF0F1424);         // Deep Midnight Black
  static const Color primaryBackground = Color(0xFFF9F6F0); // Vanilla Tint

  // -- Background Container Colors
  // These are designed to be swapped based on brightness logic in your UI
  static const Color lightContainer = Color(0xFFF0E7D5); // Vanilla Cream
  static Color darkContainer = const Color(0xFFFFFFFF).withOpacity(0.1);

  // -- Button Colors
  static const Color buttonPrimary = Color(0xFF212842); // Indigo Button
  static const Color buttonSecondary = Color(0xFFC5A358); // Gold Button
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // -- Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE5E7EB);

  // -- Error and Validation Colors
  // Adjusted to sit well against both Indigo and Vanilla backgrounds
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // -- Neutral Shades
  static const Color black = Color(0xFF121212);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFD9D9D9);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}


