import 'package:flutter/material.dart';
import 'package:frontend/common/user_avatar.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/profile/widgets/profile_box.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileRankingSection extends StatelessWidget {
  const ProfileRankingSection({
    super.key,
    required this.profile,
  });

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final user = profile.user;
    final ranking = profile.ranking;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            'رتبه‌بندی نهایی شما براساس امتیاز کل',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: ProfileBox.decoration(),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.secondaryPurple,
                backgroundImage: UserAvatarHelper.avatarImage(user),
                child: user.profilePicture == null
                    ? const Icon(
                        Icons.person,
                        size: 16,
                        color: AppColors.textLight,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Text(
                UserAvatarHelper.displayName(user),
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                ),
              ),
              const Spacer(),
              Text(
                ranking.label,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
