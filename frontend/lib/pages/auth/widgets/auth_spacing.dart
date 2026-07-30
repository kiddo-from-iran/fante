import 'package:flutter/material.dart';

class AuthSpacing {
  AuthSpacing._();

  static const primaryButtonGap = 26.0;
  static const beforePrimaryButton = 32.0;
  static const beforeDivider = 44.0;
  static const afterDivider = 34.0;
  static const socialButtonGap = 22.0;
  static const beforeFooter = 40.0;
  static const afterTitle = 36.0;
}

class AuthLayout {
  AuthLayout._();

  static const maxCardWidth = 360.0;
  static const cardPaddingHorizontal = 28.0;
  static const cardPaddingVertical = 40.0;
  static const cardBorderRadius = 16.0;
  static const buttonHeight = 48.0;
  static const buttonBorderRadius = 8.0;
  static const otpBoxSize = 46.0;
}

class AuthGaps {
  AuthGaps._();

  static const primaryButtonGap = SizedBox(height: AuthSpacing.primaryButtonGap);
  static const beforePrimaryButton = SizedBox(height: AuthSpacing.beforePrimaryButton);
  static const beforeDivider = SizedBox(height: AuthSpacing.beforeDivider);
  static const afterDivider = SizedBox(height: AuthSpacing.afterDivider);
  static const socialButtonGap = SizedBox(height: AuthSpacing.socialButtonGap);
  static const beforeFooter = SizedBox(height: AuthSpacing.beforeFooter);
  static const afterTitle = SizedBox(height: AuthSpacing.afterTitle);
}
