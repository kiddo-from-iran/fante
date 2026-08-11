import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/data/dashboard_controller.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class DashboardTopBar extends StatefulWidget {
  const DashboardTopBar({super.key});

  @override
  State<DashboardTopBar> createState() => _DashboardTopBarState();
}

class _DashboardTopBarState extends State<DashboardTopBar> {
  @override
  void initState() {
    super.initState();
    if (dashboardController.notifications.isEmpty &&
        !dashboardController.loading) {
      dashboardController.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force LTR so search / settings / notifications sit on the visual left.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 67,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: AppColors.backgroundDark,
        child: Row(
          children: [
            SizedBox(
              width: 315,
              height: 39,
              child: TextField(
                style: AppTextTheme.getTextStyle(
                  color: AppColors.textLight,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: AppTextTheme.getTextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 19,
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceCard,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _TopBarIcon(
              icon: Icons.settings_outlined,
              onTap: () =>
                  Navigator.of(context).pushNamed(DashboardRoutes.settings),
            ),
            const SizedBox(width: 6),
            AnimatedBuilder(
              animation: dashboardController,
              builder: (context, _) {
                final unread = dashboardController.unreadNotificationCount;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _TopBarIcon(
                      icon: Icons.notifications_none_rounded,
                      onTap: () => Navigator.of(context)
                          .pushNamed(DashboardRoutes.notifications),
                    ),
                    if (unread > 0)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            unread > 9 ? '9+' : '$unread',
                            style: AppTextTheme.getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const Spacer(),
          ],
        ),
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
      iconSize: 23,
      color: AppColors.textLight,
      splashRadius: 21,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 43, minHeight: 43),
      icon: Icon(icon),
    );
  }
}
