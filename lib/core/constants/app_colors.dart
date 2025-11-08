import 'package:flutter/material.dart';

class AppColors {
  // Text Colors
  static const Color text1 = Color(0xFFFFFFFF); // 100% white
  static const Color text2 = Color(0xB8FFFFFF); // 72% white
  static const Color text3 = Color(0x7AFFFFFF); // 48% white
  static const Color text4 = Color(0x3DFFFFFF); // 24% white
  static const Color text5 = Color(0x3DFFFFFF); // 24% white

  // Convenient aliases for text colors
  static const Color textPrimary = text1;
  static const Color textSecondary = text2;
  static const Color textTertiary = text3;

  // Base Colors
  static const Color base = Color(0xFF101010); // 100%
  static const Color base2Dark = Color(0xFF151515); // 100%
  
  // Surface Colors
  static const Color surface = Color(0xFF1C1C1C); // Base surface
  static const Color surfaceWhite1 = Color(0x05FFFFFF); // 2% white
  static const Color surfaceWhite2 = Color(0x0DFFFFFF); // 5% white
  static const Color surfaceBlack1 = Color(0xE6101010); // 90% black
  static const Color surfaceBlack2 = Color(0xB3101010); // 70% black
  static const Color surfaceBlack3 = Color(0x80101010); // 50% black

  // Accent Colors
  static const Color primaryAccent = Color(0xFF9196FF); // 100%
  static const Color secondaryAccent = Color(0xFF5961FF); // 100%
  static const Color positive = Color(0xFFEFE6DB); // 100%
  static const Color negative = Color(0xFFC22743); // 100%

  // Border Colors
  static const Color border = Color(0xFF2A2A2A); // Gradient base
  static const Color border1 = Color(0x14FFFFFF); // 8% white
  static const Color border2 = Color(0x29FFFFFF); // 16% white
  static const Color border3 = Color(0x3DFFFFFF); // 24% white

  // Effects
  static const Color bgBlur12 = Colors.transparent; // Bg-blur 12
  static const Color bgBlur40 = Colors.transparent; // Bg-blur 40
  static const Color bgBlur80 = Colors.transparent; // Bg-blur 80
}
