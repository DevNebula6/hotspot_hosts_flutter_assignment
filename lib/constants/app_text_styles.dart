import 'package:flutter/material.dart';

class AppTextStyles {
  // Font Family
  static const String fontFamily = 'Space Grotesk';

  // Heading 1 - Bold
  static const TextStyle h1Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 36 / 28, // line-height / font-size
    fontWeight: FontWeight.w700, // 400 weight
    letterSpacing: -0.02 * 28, // -2% of font size
  );

  // Heading 1 - Regular
  static const TextStyle h1Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w400, // 300 weight
    letterSpacing: -0.03 * 28, // -3% of font size
  );

  // Heading 2 - Bold
  static const TextStyle h2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 24,
  );

  // Heading 2 - Regular
  static const TextStyle h2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.02 * 24,
  );

  // Heading 3 - Bold
  static const TextStyle h3Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.01 * 20,
  );

  // Heading 3 - Regular
  static const TextStyle h3Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.01 * 20,
  );

  // Body/B - Bold
  static const TextStyle bodyBBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // Body/B - Regular
  static const TextStyle bodyBRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Body/R2 - Bold
  static const TextStyle bodyR2Bold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // Body/R2 - Regular
  static const TextStyle bodyR2Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Button/BT - Bold
  static const TextStyle buttonBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Button/BT - Regular
  static const TextStyle buttonRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Subtext
  static const TextStyle subtext = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );
}
