import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Official Design System Brand Palette
  static const Color primary = Color(0xFFF97316); // #F97316 Primary (Brand)
  static const Color brandBright = Color(0xFFFB923C); // #FB923C Brand Bright
  static const Color brandDim = Color(0xFFC2410C); // #C2410C Brand Dim

  // Secondary Accents & Badges
  static const Color pdfRed = Color(0xFFEF4444); // #EF4444 PDF Badge / Error
  static const Color success = Color(0xFF22C55E); // #22C55E Success
  static const Color docxBlue = Color(0xFF3B82F6); // DOCX / Links
  static const Color splitPurple = Color(0xFF8B5CF6); // Split Tool Purple
  static const Color compressGreen = Color(0xFF10B981); // Compress Green
  static const Color premiumGold = Color(0xFFF59E0B); // Amber / Gold Crown
  static const Color folderYellow = Color(0xFFFBBF24); // Folders Yellow

  // Neutral tones - Light (Orange Cream Theme)
  static const Color backgroundLight = Color(0xFFFFF7ED); // #FFF7ED Background Cream
  static const Color surfaceLight = Color(0xFFFFFFFF); // #FFFFFF Surface
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFFED7AA); // Soft peach border
  static const Color borderLightMuted = Color(0xFFE2E8F0); // Neutral subtle border

  static const Color textPrimaryLight = Color(0xFF0F172A); // #0F172A Text Primary
  static const Color textSecondaryLight = Color(0xFF475569); // #475569 Text Secondary
  static const Color textMutedLight = Color(0xFF94A3B8);

  // Neutral tones - Dark
  static const Color backgroundDark = Color(0xFF120E0A); // Warm deep dark
  static const Color surfaceDark = Color(0xFF1C1712);
  static const Color cardDark = Color(0xFF261F18);
  static const Color borderDark = Color(0xFF382D24);
  static const Color textPrimaryDark = Color(0xFFFFF7ED);
  static const Color textSecondaryDark = Color(0xFFD6C7B9);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFFF1E6), Color(0xFFFFEDD5), Color(0xFFFED7AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGoldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient softOrangeGradient = LinearGradient(
    colors: [Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
