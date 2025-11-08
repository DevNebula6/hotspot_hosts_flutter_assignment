import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_border_radius.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_spacing.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';

/// Custom multi-line text field widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool showCharacterCount;
  final String? labelText;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 5,
    this.maxLength,
    this.onChanged,
    this.showCharacterCount = true,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTextStyles.bodyBBold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
        ],
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          style: AppTextStyles.bodyBRegular,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyBRegular.copyWith(
              color: AppColors.textTertiary,
            ),
            filled: true,
            fillColor: AppColors.surface,
            counterText: showCharacterCount && maxLength != null
                ? null
                : '', // Hide counter if not needed
            counterStyle: AppTextStyles.subtext.copyWith(
              color: AppColors.textTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: const BorderSide(color: AppColors.border1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: const BorderSide(color: AppColors.border1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2),
            ),
            contentPadding: EdgeInsets.all(AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
