import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/widgets/auth_spacing.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

enum AuthSocialProvider { google, apple }

class AuthAssets {
  AuthAssets._();

  static const googleIcon = 'assets/icons/Google icon.png';
  static const appleIcon = 'assets/icons/Apple icon.png';
}

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.provider,
    this.onPressed,
  });

  final AuthSocialProvider provider;
  final VoidCallback? onPressed;

  String get _label =>
      provider == AuthSocialProvider.google ? 'گوگل' : 'اپل';

  String get _iconAsset => provider == AuthSocialProvider.google
      ? AuthAssets.googleIcon
      : AuthAssets.appleIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AuthLayout.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.socialButtonBackground,
          foregroundColor: AppColors.socialButtonText,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthLayout.buttonBorderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _iconAsset,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Text(
              _label,
              style: AppTextTheme.getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.socialButtonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
