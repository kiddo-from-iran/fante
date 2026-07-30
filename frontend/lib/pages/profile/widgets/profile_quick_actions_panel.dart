import 'package:flutter/material.dart';
import 'package:frontend/pages/profile/widgets/profile_panel.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileQuickActionsPanel extends StatelessWidget {
  const ProfileQuickActionsPanel({super.key});

  static const _actions = [
    'ساخت کوئیز جدید',
    'ساخت نظرسنجی جدید',
    'ساخت تست جدید',
    'ایجاد تیکت جدید',
  ];

  @override
  Widget build(BuildContext context) {
    return ProfilePanel(
      title: 'فعالیت سریع',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _actions.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(child: _actionButton(_actions[i])),
                  const SizedBox(width: 12),
                  Expanded(
                    child: i + 1 < _actions.length
                        ? _actionButton(_actions[i + 1])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButton(String label) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.textBlack,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}
