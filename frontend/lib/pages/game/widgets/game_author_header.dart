import 'package:flutter/material.dart';
import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/pages/game/widgets/game_glass_card.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class GameAuthorHeader extends StatelessWidget {
  const GameAuthorHeader({
    super.key,
    required this.title,
    required this.designerName,
    this.designerAvatar,
  });

  final String title;
  final String designerName;
  final String? designerAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGold,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage(
                designerAvatar ?? GameAssets.designerAvatar,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'طراح: $designerName',
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class GameSidebar extends StatelessWidget {
  const GameSidebar({
    super.key,
    required this.data,
  });

  final GameSidebarData data;

  @override
  Widget build(BuildContext context) {
    return GameGlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.description,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  data.thumbnail,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${data.timeAgo} · ${data.participants} شرکت‌کننده',
            style: AppTextTheme.getTextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            data.secondaryTitle,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 14),
          const _SidebarAction(icon: Icons.add, label: 'افزودن به کتابخانه'),
          const _SidebarAction(icon: Icons.chat_bubble_outline, label: 'بحث و گفتگو'),
          const _SidebarAction(icon: Icons.person_outline, label: 'دنبال کردن طراح'),
          const _SidebarAction(icon: Icons.link, label: 'اشتراک‌گذاری'),
          const SizedBox(height: 16),
          Image.asset(
            GameAssets.socialMedia,
            height: 24,
            fit: BoxFit.contain,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}

class _SidebarAction extends StatelessWidget {
  const _SidebarAction({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textLight),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
