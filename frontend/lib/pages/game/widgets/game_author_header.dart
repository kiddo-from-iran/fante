import 'package:flutter/material.dart';
import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/pages/game/utils/game_picture_helper.dart';
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

/// Game-info card matching the overview mock: cover, title, quote, meta, actions.
class GameSidebar extends StatelessWidget {
  const GameSidebar({
    super.key,
    required this.data,
  });

  final GameSidebarData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE6121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.65)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: GamePictureHelper.image(picture: data.thumbnail),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  data.secondaryTitle,
                  textAlign: TextAlign.right,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '«${data.description}»',
                  textAlign: TextAlign.right,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${data.timeAgo} - ${data.participants} شرکت کننده',
                  textAlign: TextAlign.right,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 18),
                const _SidebarAction(
                  icon: Icons.add,
                  label: 'افزودن به کتابخانه',
                ),
                const _SidebarAction(
                  icon: Icons.chat_bubble_outline,
                  label: 'بحث و گفتگو',
                ),
                const _SidebarAction(
                  icon: Icons.person_outline,
                  label: 'دنبال کردن طراح',
                ),
                const _SidebarAction(
                  icon: Icons.link,
                  label: 'اشتراک‌گذاری',
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    GameAssets.socialMedia,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textLight),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
