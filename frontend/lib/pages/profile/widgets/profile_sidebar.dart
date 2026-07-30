import 'package:flutter/material.dart';
import 'package:frontend/common/user_avatar.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileSidebar extends StatelessWidget {
  const ProfileSidebar({super.key, required this.profile});

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final user = profile.user;
    final level = profile.stats.level;

    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.surfaceCard,
              backgroundImage: UserAvatarHelper.avatarImage(user),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            UserAvatarHelper.displayName(user),
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level.levelTitle != null
                ? 'سطح ${level.level} — ${level.levelTitle}'
                : 'سطح ${level.level}',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: level.xpProgress,
              minHeight: 8,
              backgroundColor: AppColors.backgroundDark,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
            ),
          ),
          const SizedBox(height: 16),
          _infoLine(Icons.alternate_email_rounded, _handle(user)),
          _infoLine(Icons.location_on_outlined, 'ایران - تهران'),
          _infoLine(Icons.link_rounded, 'fantequiz.ir/${_slug(user)}'),
          _infoLine(
            Icons.calendar_today_outlined,
            'عضو از ${_memberSince(user.createdAt)}',
          ),
        ],
      ),
    );
  }

  String _handle(user) {
    final email = user.email;
    if (email != null && email.contains('@')) {
      return '@${email.split('@').first}';
    }
    final phone = user.phoneNumber;
    if (phone != null && phone.isNotEmpty) {
      final digits = phone.replaceAll(RegExp(r'\D'), '');
      return '@${digits.length > 6 ? digits.substring(0, 6) : digits}';
    }
    return '@user${user.id}';
  }

  String _slug(user) {
    final name = user.fullName?.trim();
    if (name != null && name.isNotEmpty) {
      return name.split(' ').first.toLowerCase();
    }
    return 'user${user.id}';
  }

  String _memberSince(DateTime? createdAt) {
    if (createdAt == null) return '—';
    final y = createdAt.year;
    final m = createdAt.month.toString().padLeft(2, '0');
    final d = createdAt.day.toString().padLeft(2, '0');
    return '$y/$m/$d';
  }

  Widget _infoLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.left,
              style: AppTextTheme.getTextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
