import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsetsDirectional.only(start: 24, end: 24),
      color: AppColors.backgroundDark,
      child: Row(
        children: [
          SizedBox(
            width: 220,
            height: 34,
            child: TextField(
              style: AppTextTheme.getTextStyle(
                color: AppColors.textLight,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextTheme.getTextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.surfaceCard,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _TopBarIcon(icon: Icons.settings_outlined, onTap: () {}),
          const SizedBox(width: 6),
          _TopBarIcon(icon: Icons.notifications_none_rounded, onTap: () {}),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TopBarIcon extends StatelessWidget {
  const _TopBarIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      iconSize: 18,
      color: AppColors.textMuted,
      splashRadius: 20,
      icon: Icon(icon),
    );
  }
}
