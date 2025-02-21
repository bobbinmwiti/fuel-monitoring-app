// lib/core/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final double? width;
  final double height;

  const CustomButton({
    super.key,  // Changed from 'key' to 'super.key'
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getForegroundColor(),
          elevation: isOutlined ? 0 : 2,
          side: isOutlined 
              ? const BorderSide(color: AppColors.primary) 
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? AppColors.primary : Colors.white,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: isOutlined ? AppColors.primary : Colors.white,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTextStyles.buttonText.copyWith(
            color: isOutlined ? AppColors.primary : Colors.white,
          ),
        ),
      ],
    );
  }

  Color _getBackgroundColor() {
    if (isLoading) {
      return isOutlined 
          ? Colors.transparent 
          : (backgroundColor ?? AppColors.primary).withValues(
              red: (backgroundColor ?? AppColors.primary).r,
              green: (backgroundColor ?? AppColors.primary).g,
              blue: (backgroundColor ?? AppColors.primary).b,
              alpha: 0.7 * 255.0
            );
    }
    if (isOutlined) {
      return Colors.transparent;
    }
    return backgroundColor ?? AppColors.primary;
  }

  Color _getForegroundColor() {
    return isOutlined ? AppColors.primary : Colors.white;
  }
}