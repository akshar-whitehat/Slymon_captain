import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF0052CC); // Royal Blue
  static const Color secondaryColor = Color(0xFFFFFFFF); // Pure White
  static const Color accentColor = Color(0xFFE6F0FF); // Light Blue
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFFFFFFF); // Pure White
  static const Color lightBackgroundColor = Color(0xFFF7FAFF); // Very Light Blue
  static const Color cardColor = Colors.white;
  
  // Text Colors
  static const Color textColor = Color(0xFF14284B); // Deep Navy
  static const Color lightTextColor = Color(0xFF5E6C84); // Slate Gray
  
  // Status Colors
  static const Color successColor = Color(0xFF00875A); // Green
  static const Color errorColor = Color(0xFFDE350B); // Red
  static const Color warningColor = Color(0xFFFF991F); // Orange
  static const Color infoColor = Color(0xFF0065FF); // Blue
  
  // Dimensions
  static const double borderRadius = 12.0;
  static const double spacing = 24.0;
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'SF Pro Display',
    letterSpacing: -0.5,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: 'SF Pro Display',
    letterSpacing: -0.3,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
    fontFamily: 'Inter',
    letterSpacing: -0.2,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: lightTextColor,
    fontFamily: 'Inter',
    letterSpacing: -0.1,
  );
  
  // Input Decoration
  static InputDecoration inputDecoration({
    required String hint,
    IconData? prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: captionStyle,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: lightTextColor) : null,
      suffix: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: spacing, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: lightTextColor.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
    );
  }
  
  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ],
  );
  
  // Button Styles
  static ButtonStyle primaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 16, horizontal: spacing),
    ),
    elevation: MaterialStateProperty.all<double>(1),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
  
  static ButtonStyle secondaryButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(accentColor),
    foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
    padding: MaterialStateProperty.all<EdgeInsets>(
      const EdgeInsets.symmetric(vertical: 16, horizontal: spacing),
    ),
    elevation: MaterialStateProperty.all<double>(0),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: const BorderSide(color: primaryColor, width: 1),
      ),
    ),
  );
}
