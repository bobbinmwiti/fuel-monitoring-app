// lib/core/widgets/custom_card.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final bool hasShadow;
  final BorderRadius? borderRadius;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.height,
    this.width,
    this.hasShadow = true,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          border: border,
          boxShadow: hasShadow ? [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ] : null,
        ),
        child: child,
      ),
    );
  }

  // Factory constructor for header card
  factory CustomCard.header({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? height,
    double? width,
  }) {
    return CustomCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(20),
      onTap: onTap,
      height: height,
      width: width,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      hasShadow: false,
      borderRadius: BorderRadius.circular(16),
      child: child,
    );
  }

  // Factory constructor for outline card
  factory CustomCard.outline({
    Key? key,
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? height,
    double? width,
    Color? borderColor,
  }) {
    return CustomCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(16),
      onTap: onTap,
      height: height,
      width: width,
      hasShadow: false,
      border: Border.all(
        color: borderColor ?? AppColors.primary.withOpacity(0.2),
        width: 1,
      ),
      child: child,
    );
  }

  // Factory constructor for colored card
  factory CustomCard.colored({
    Key? key,
    required Widget child,
    required Color color,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
    double? height,
    double? width,
  }) {
    return CustomCard(
      key: key,
      padding: padding ?? const EdgeInsets.all(16),
      onTap: onTap,
      height: height,
      width: width,
      backgroundColor: color,
      hasShadow: false,
      child: child,
    );
  }
}