import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/profile/widgets/profile_panel.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileBadgesPanel extends StatelessWidget {
  const ProfileBadgesPanel({super.key});

  static const _badges = [
    ('نظرسنجی حرفه‌ای', DashboardAssets.badgeBronze, Color(0xFFCD7F32)),
    ('تست‌ساز', DashboardAssets.badgeBronze, Color(0xFFB84A3A)),
    ('مخترع', DashboardAssets.badgeSilver, Color(0xFF1C6B7A)),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfilePanel(
      title: 'آخرین نشان‌ها',
      child: Row(
        children: _badges
            .map(
              (badge) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: badge.$3.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryGold.withValues(alpha: 0.5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(badge.$2, width: 30, height: 30),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge.$1,
                        textAlign: TextAlign.center,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
