import 'package:flutter/material.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_border_radius.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.base,
      fontFamily: AppTextStyles.fontFamily,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.surface,
        error: AppColors.negative,
      ),
      
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1Bold,
        displayMedium: AppTextStyles.h2Bold,
        displaySmall: AppTextStyles.h3Bold,
        headlineMedium: AppTextStyles.h1Regular,
        headlineSmall: AppTextStyles.h2Regular,
        titleLarge: AppTextStyles.h3Regular,
        bodyLarge: AppTextStyles.bodyBBold,
        bodyMedium: AppTextStyles.bodyBRegular,
        bodySmall: AppTextStyles.bodyR2Regular,
        labelLarge: AppTextStyles.buttonBold,
        labelSmall: AppTextStyles.subtext,
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          side: BorderSide(color: AppColors.border1, width: 1),
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: AppColors.border1,
        thickness: 1,
      ),
    );
  }
}
