import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/common/user_avatar.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/auth/auth_routes.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/catalog/catalog_routes.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/home/home_routes.dart';
import 'package:frontend/pages/info/info_routes.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/brand_logo.dart';

class FanteNavBar extends StatelessWidget {
  const FanteNavBar({
    super.key,
    this.showAuthActions = true,
  });

  final bool showAuthActions;

  static const _links = <({String label, String? route, Object? args})>[
    (label: 'تماس با ما', route: InfoRoutes.contact, args: null),
    (label: 'قوانین ما', route: InfoRoutes.terms, args: null),
    (label: 'درباره ما', route: InfoRoutes.about, args: null),
    (label: 'مطالب', route: null, args: null),
    (label: 'رنکینگ', route: null, args: null),
    (label: 'نظرسنجی‌ها', route: null, args: null),
    (label: 'کوییزها', route: CatalogRoutes.quizzes, args: null),
    (label: 'تست‌ها', route: CatalogRoutes.category, args: 'test'),
    (label: 'دسته‌بندی', route: CatalogRoutes.category, args: null),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 84,
        color: AppColors.headerBackground,
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Row(
          children: [
            const BrandLogo(height: 68),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _links
                        .map((link) => _NavLink(
                              label: link.label,
                              onPressed: link.route == null
                                  ? null
                                  : () => _onLinkPressed(context, link),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
            if (showAuthActions)
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return _AuthenticatedNavActions(user: state.authInfo.user);
                  }
                  return _LoginButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AuthRoutes.landing);
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _onLinkPressed(
    BuildContext context,
    ({String label, String? route, Object? args}) link,
  ) {
    if (link.route == HomeRoutes.home) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeRoutes.home,
        (route) => false,
      );
      return;
    }
    Navigator.of(context).pushNamed(
      link.route!,
      arguments: link.args,
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final targetColor = !enabled
        ? AppColors.textMuted
        : _hovered
            ? AppColors.primaryGold
            : AppColors.textLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
        onExit: enabled ? (_) => setState(() => _hovered = false) : null,
        child: GestureDetector(
          onTap: widget.onPressed,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: targetColor,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.textBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'ورود / ثبت‌نام',
          style: AppTextTheme.getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}

class _AuthenticatedNavActions extends StatelessWidget {
  const _AuthenticatedNavActions({this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: UserAvatarHelper.displayName(user),
      offset: const Offset(0, 44),
      color: AppColors.surfaceCard,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primaryGold.withValues(alpha: 0.55),
          width: 1.5,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'dashboard',
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: _ProfileMenuRow(
            icon: Icons.grid_view_rounded,
            label: 'داشبورد',
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: _ProfileMenuRow(
            icon: Icons.logout_rounded,
            label: 'خروج',
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'dashboard') {
          Navigator.of(context).pushNamed(DashboardRoutes.dashboard);
        } else if (value == 'logout') {
          context.read<AuthBloc>().add(const AuthLogoutRequested());
        }
      },
      child: CircleAvatar(
        radius: 19,
        backgroundColor: AppColors.surfaceCard,
        backgroundImage: UserAvatarHelper.avatarImage(user),
      ),
    );
  }
}

class _ProfileMenuRow extends StatelessWidget {
  const _ProfileMenuRow({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textLight),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textLight,
            ),
          ),
        ),
        const Icon(
          Icons.chevron_left_rounded,
          size: 18,
          color: AppColors.textMuted,
        ),
      ],
    );
  }
}
