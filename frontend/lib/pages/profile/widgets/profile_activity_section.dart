import 'package:flutter/material.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/profile/widgets/profile_box.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileActivitySection extends StatelessWidget {
  const ProfileActivitySection({
    super.key,
    required this.activities,
  });

  final List<PlayerActivity> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            'آخرین فعالیت‌ها',
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: ProfileBox.decoration(),
          child: activities.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'هنوز فعالیتی ثبت نشده است',
                    textAlign: TextAlign.center,
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < activities.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.primaryGold.withValues(alpha: 0.25),
                        ),
                      _ActivityRow(activity: activities[i]),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final PlayerActivity activity;

  IconData get _icon {
    switch (activity.activityType) {
      case 'poll':
        return Icons.description_outlined;
      case 'vote':
        return Icons.how_to_vote_outlined;
      default:
        return Icons.sports_esports_outlined;
    }
  }

  String get _buttonLabel {
    switch (activity.activityType) {
      case 'poll':
        return 'تمام نظرسنجی‌های تکمیل شده';
      case 'vote':
        return 'تمام آراء ثبت‌شده';
      default:
        return 'تمام کوییزهای تکمیل شده';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.secondaryPurple,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, size: 17, color: AppColors.textLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.displayTitle,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textLight,
                  ),
                ),
                if (activity.stars != null && activity.stars! > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      activity.stars!,
                      (_) => const Padding(
                        padding: EdgeInsetsDirectional.only(end: 2),
                        child: Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          _GradientActionButton(label: _buttonLabel),
        ],
      ),
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: 148,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: ProfileBox.gradientButtonDecoration,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }
}
