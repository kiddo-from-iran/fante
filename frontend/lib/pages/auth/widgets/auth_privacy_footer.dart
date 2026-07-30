import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class AuthPrivacyFooter extends StatelessWidget {
  const AuthPrivacyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'امنیت و حفظ حریم خصوصی شما، اولویت ماست.',
      textAlign: TextAlign.center,
      style: AppTextTheme.getTextStyle(
        fontSize: 12,
        color: AppColors.textMuted,
        height: 1.6,
      ),
    );
  }
}
