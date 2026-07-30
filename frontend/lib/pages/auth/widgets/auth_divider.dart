import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.textLight,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'یا ادامه با:',
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.textLight,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
