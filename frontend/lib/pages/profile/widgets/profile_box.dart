import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';

class ProfileBox {
  ProfileBox._();

  static const borderRadius = 12.0;

  static BoxDecoration decoration({Color? backgroundColor}) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.surfaceCard.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColors.primaryGold.withValues(alpha: 0.35),
      ),
    );
  }

  static BoxDecoration gradientButtonDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: const LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        AppColors.primaryGold,
        Color(0xFFF7C48A),
      ],
    ),
  );
}
