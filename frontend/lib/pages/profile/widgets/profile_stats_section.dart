import 'package:flutter/material.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/profile/widgets/profile_box.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key, required this.profile});

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final stats = profile.stats;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 132,
            child: Container(
              decoration: ProfileBox.decoration(),
              child: Column(
                children: [
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.emoji_events,
                      iconColor: AppColors.primaryGold,
                      label: 'دریافت جایزه',
                      onTap: () {},
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.primaryGold.withValues(alpha: 0.25),
                  ),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.settings,
                      iconColor: const Color(0xFF9B59B6),
                      label: 'تنظیمات',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              decoration: ProfileBox.decoration(),
              child: Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'امتیاز کل',
                      value: '${_formatNumber(stats.totalPoints)} XP',
                      valueColor: AppColors.primaryGold,
                    ),
                  ),
                  const _StatDivider(),
                  Expanded(
                    child: _StatItem(
                      label: 'کوییزهای کامل شده',
                      value: '${stats.quizzesCompleted}',
                      badgeColor: const Color(0xFFCD7F32),
                    ),
                  ),
                  const _StatDivider(),
                  Expanded(
                    child: _StatItem(
                      label: 'نظرسنجی / آراء',
                      value: '${stats.pollsCompleted} / ${stats.votesCompleted}',
                      badgeColor: const Color(0xFF1C6B7A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatNumber(int value) {
  return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: AppColors.primaryGold.withValues(alpha: 0.25),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textLight,
    this.badgeColor,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (badgeColor != null) ...[
              Container(
                width: 16,
                height: 16,
                margin: const EdgeInsetsDirectional.only(end: 5),
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ProfileBox.borderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextTheme.getTextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                  height: 1.3,
                ),
              ),
            ),
            Icon(icon, color: iconColor, size: 22),
          ],
        ),
      ),
    );
  }
}
