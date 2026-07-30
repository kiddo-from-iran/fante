import 'package:flutter/material.dart';

/// Fante Quiz design system colors.
class AppColors {
  AppColors._();

  // --- Design tokens (exact palette) ---
  static const textBlack = Color(0xFF000000);
  static const backgroundSecondSection = Color(0xFF121212);
  static const hoverButton = Color(0xFF2D2D2D);
  static const textMuted = Color(0xFFA0A0A0);
  static const textLight = Color(0xFFFFFFFF);
  static const secondaryPurple = Color(0xFF420B41);
  static const surfaceCard = Color(0xFF1E1E1E);
  static const surfaceCardOverlay = Color(0xB31E1E1E);
  static const backgroundDark = Color(0xFF000000);
  static const primaryGold = Color(0xFFF5AA57);

  // --- Semantic aliases used across the app ---
  static const primaryOrange = primaryGold;
  static const primaryOrangeDark = Color(0xFFE09A4A);

  static const textPrimary = textLight;
  static const textSecondary = textMuted;
  static const textDark = textBlack;

  static const headerBackground = backgroundSecondSection;
  static const scaffoldBackground = backgroundDark;
  static const cardBackground = surfaceCardOverlay;
  static const cardBorder = Color(0x33FFFFFF);

  static const inputBackground = textLight;
  static const inputHint = textMuted;
  static const inputIcon = textMuted;

  static const socialButtonBackground = textLight;
  static const socialButtonText = textBlack;

  static const dividerColor = hoverButton;
  static const dividerText = textMuted;

  static const navLinkColor = textLight;
  static const navLinkHover = primaryGold;

  static const buttonHover = hoverButton;

  static const successColor = Color(0xFF10B981);
  static const errorColor = Color(0xFFEF4444);
}

/// Legacy light theme tokens kept for existing pages.
class LightThemeColors {
  static const primaryColor = AppColors.primaryGold;
  static const primaryDark = AppColors.primaryOrangeDark;
  static const primaryLight = Color(0xFFF7C48A);

  static const surfaceColor = Colors.white;
  static const surfaceLight = Color(0xFFF8F9FA);
  static const onSurfaceColor = Colors.white;

  static const primaryTextColor = AppColors.textBlack;
  static const secondaryTextColor = AppColors.textMuted;
  static const textLight = AppColors.textMuted;

  static const accentColor = AppColors.primaryGold;
  static const successColor = AppColors.successColor;
  static const errorColor = AppColors.errorColor;
}

/// Legacy dark theme tokens kept for existing pages.
class DarkThemeColors {
  static const primaryColor = AppColors.backgroundSecondSection;
  static const surfaceColor = AppColors.backgroundDark;
  static const onSurfaceColor = AppColors.surfaceCard;
  static const activeStatus = Color.fromARGB(255, 96, 224, 67);
  static const suspendStatus = Color.fromARGB(255, 233, 152, 71);
  static const inProgressStatus = Color.fromARGB(255, 144, 123, 241);
  static const busColor = Color.fromARGB(255, 90, 180, 220);
  static const messageBoxColor = AppColors.secondaryPurple;
  static const notifBoxColor = Color(0xFF1C6B7A);
  static const notifIconColor = Color(0xFFB3DEE6);
  static const investorBoxColor = Color(0xFF6C59C0);
  static const messageIconColor = Color(0xFFE1BEE7);
  static const primaryTextColor = AppColors.textLight;
  static const secondaryTextColor = AppColors.textMuted;
  static const greyTextColor = AppColors.textMuted;
  static const deactiveButton = AppColors.hoverButton;
  static const showColumnsColor = Color(0xFF2A3B4C);
  static const elevatedButtonColorOne = AppColors.hoverButton;
  static const amountInReal = Color(0xFF455A64);
  static const amountInRealOverlay = Color.fromARGB(255, 60, 70, 80);
  static const elevatedButtonOverlayColorOne = Color.fromARGB(172, 80, 80, 80);
  static const infoBoxBackgroundColor = AppColors.hoverButton;
}
