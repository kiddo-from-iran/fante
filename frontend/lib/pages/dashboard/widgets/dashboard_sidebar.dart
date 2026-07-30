import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/brand_logo.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    super.key,
    required this.active,
    required this.expanded,
    required this.onToggle,
  });

  final DashboardSection active;
  final bool expanded;
  final VoidCallback onToggle;

  static const expandedWidth = 236.0;
  static const collapsedWidth = 72.0;

  /// Dashboard side menu items (tests / settings / polls removed).
  static const _items = [
    DashboardNavItem(
      section: DashboardSection.dashboard,
      label: 'داشبورد',
      icon: Icons.grid_view_rounded,
      route: DashboardRoutes.dashboard,
    ),
    DashboardNavItem(
      section: DashboardSection.myQuizzes,
      label: 'بازی ها',
      icon: Icons.extension_outlined,
      route: DashboardRoutes.games,
    ),
    DashboardNavItem(
      section: DashboardSection.tickets,
      label: 'تیکت ها',
      icon: Icons.confirmation_number_outlined,
      route: DashboardRoutes.tickets,
    ),
    DashboardNavItem(
      section: DashboardSection.feedback,
      label: 'ثبت بازخورد',
      icon: Icons.rate_review_outlined,
    ),
    DashboardNavItem(
      section: DashboardSection.logout,
      label: 'خروج',
      icon: Icons.logout_rounded,
      isLogout: true,
    ),
  ];

  void _onTap(BuildContext context, DashboardNavItem item) {
    if (item.isLogout) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
      return;
    }
    if (item.route == null || item.section == active) return;
    Navigator.of(context).pushReplacementNamed(item.route!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      width: expanded ? expandedWidth : collapsedWidth,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 12,
            offset: const Offset(-4, 0),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: AppColors.primaryGold.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: expanded ? 8 : 12),
            child: Center(
              child: BrandLogo(height: expanded ? 48 : 32),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 12 : 8,
              vertical: 4,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: expanded ? 14 : 0,
                    vertical: 12,
                  ),
                  child: expanded
                      ? const Row(
                          children: [
                            Icon(
                              Icons.menu_rounded,
                              size: 20,
                              color: AppColors.textLight,
                            ),
                          ],
                        )
                      : const Center(
                          child: Icon(
                            Icons.menu_rounded,
                            size: 22,
                            color: AppColors.textLight,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: expanded ? 12 : 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _items
                    .map(
                      (item) => _SidebarTile(
                        item: item,
                        isActive: item.section == active,
                        expanded: expanded,
                        onTap: () => _onTap(context, item),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.expanded,
    required this.onTap,
  });

  final DashboardNavItem item;
  final bool isActive;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primaryGold : AppColors.textLight;

    final tile = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isActive
            ? AppColors.primaryGold.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: expanded ? 14 : 0,
              vertical: 12,
            ),
            child: expanded
                ? Row(
                    children: [
                      Icon(item.icon, size: 20, color: color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 14,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_left_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ],
                  )
                : Center(
                    child: Icon(item.icon, size: 22, color: color),
                  ),
          ),
        ),
      ),
    );

    if (expanded) return tile;
    return Tooltip(
      message: item.label,
      waitDuration: const Duration(milliseconds: 400),
      child: tile,
    );
  }
}
