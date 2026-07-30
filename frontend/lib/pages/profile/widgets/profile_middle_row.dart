import 'package:flutter/material.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/profile/widgets/profile_activity_chart.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileMiddleRow extends StatelessWidget {
  const ProfileMiddleRow({super.key, required this.profile});

  final PlayerProfile profile;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        final latestActivity = DashboardCard(
          title: 'آخرین فعالیت',
          actionLabel: 'مشاهده همه',
          onAction: () {},
          child: _ActivityList(
            items: profile.recentActivities.isEmpty
                ? List.generate(
                    5,
                    (_) => const _ActivityListItem(
                      title: 'کوئیز جدید منتشر کردید',
                    ),
                  )
                : profile.recentActivities
                    .map(
                      (a) => _ActivityListItem(
                        title: a.displayTitle,
                      ),
                    )
                    .toList(),
          ),
        );

        const unfinished = DashboardCard(
          title: 'فعالیت‌های ناتمام',
          actionLabel: 'مشاهده همه',
          onAction: _noop,
          child: _ActivityList(
            items: [
              _ActivityListItem(
                title: 'دنیای انیمه',
                subtitle: '45 شرکت‌کننده',
              ),
              _ActivityListItem(
                title: 'دنیای انیمه',
                subtitle: '45 شرکت‌کننده',
              ),
              _ActivityListItem(
                title: 'دنیای انیمه',
                subtitle: '45 شرکت‌کننده',
              ),
            ],
          ),
        );

        final chart = DashboardCard(
          title: 'آمار فعالیت‌های شما',
          child: const ProfileActivityChart(),
        );

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              chart,
              const SizedBox(height: 16),
              unfinished,
              const SizedBox(height: 16),
              latestActivity,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: latestActivity),
            const SizedBox(width: 16),
            Expanded(child: unfinished),
            const SizedBox(width: 16),
            Expanded(flex: 2, child: chart),
          ],
        );
      },
    );
  }
}

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.items});

  final List<_ActivityListItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.title,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle!,
                            style: AppTextTheme.getTextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ActivityListItem {
  const _ActivityListItem({required this.title, this.subtitle});

  final String title;
  final String? subtitle;
}
