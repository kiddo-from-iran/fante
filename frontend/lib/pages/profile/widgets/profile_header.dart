import 'package:flutter/material.dart';
import 'package:frontend/common/user_avatar.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/profile/widgets/profile_scaffold.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
  });

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final user = profile.user;
    final level = profile.stats.level;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(
          offset: Offset(0, -ProfileLayout.avatarRadius),
          child: CircleAvatar(
            radius: ProfileLayout.avatarRadius,
            backgroundColor: AppColors.surfaceCard,
            backgroundImage: UserAvatarHelper.avatarImage(user),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -10),
          child: Text(
            UserAvatarHelper.displayName(user),
            style: AppTextTheme.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
        ),
        if (user.phoneNumber != null) ...[
          const SizedBox(height: 4),
          Text(
            user.phoneNumber!,
            textDirection: TextDirection.ltr,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          level.levelTitle != null
              ? 'سطح ${level.level} — ${level.levelTitle}'
              : 'سطح ${level.level}',
          style: AppTextTheme.getTextStyle(
            fontSize: 13,
            color: AppColors.primaryGold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${level.xpLabel} XP',
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        _XpProgressBar(progress: level.xpProgress),
      ],
    );
  }
}

class _XpProgressBar extends StatelessWidget {
  const _XpProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ProfileLayout.xpBarWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 8,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.backgroundDark,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
          ),
        ),
      ),
    );
  }
}
