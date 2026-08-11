import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/data/dashboard_controller.dart';
import 'package:frontend/pages/dashboard/data/dashboard_models.dart';
import 'package:frontend/pages/dashboard/data/dashboard_time.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/utils/jalali_date.dart';

class DashboardBadgesPage extends StatelessWidget {
  const DashboardBadgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.dashboard,
      child: AnimatedBuilder(
        animation: dashboardController,
        builder: (context, _) {
          final badges = dashboardController.badges;
          return DashboardCard(
            title: 'نشان‌ها',
            child: badges.isEmpty
                ? Text(
                    'هنوز نشانی کسب نکرده‌اید.',
                    style: AppTextTheme.getTextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  )
                : Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final b in badges) _BadgeTile(badge: b),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});
  final DashboardBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Image.asset(badge.assetPath, height: 72, fit: BoxFit.contain),
          const SizedBox(height: 10),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            JalaliDate.format(badge.earnedAt),
            style: AppTextTheme.getTextStyle(
              fontSize: 10,
              color: AppColors.primaryGold,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardAnnouncementsPage extends StatelessWidget {
  const DashboardAnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.dashboard,
      child: AnimatedBuilder(
        animation: dashboardController,
        builder: (context, _) {
          final items = dashboardController.announcements;
          return DashboardCard(
            title: 'اعلانات',
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    const Divider(color: AppColors.cardBorder, height: 1),
                  InkWell(
                    onTap: () => _showDetail(context, items[i]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          if (items[i].isPinned)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.push_pin_rounded,
                                size: 16,
                                color: AppColors.primaryGold,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              items[i].title,
                              style: AppTextTheme.getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                          Text(
                            JalaliDate.format(items[i].publishedAt),
                            style: AppTextTheme.getTextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, DashboardAnnouncement item) {
    showDialog<void>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            item.title,
            style: AppTextTheme.getTextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            item.body,
            style: AppTextTheme.getTextStyle(
              color: AppColors.textMuted,
              height: 1.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'بستن',
                style: AppTextTheme.getTextStyle(color: AppColors.primaryGold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardReviewsPage extends StatelessWidget {
  const DashboardReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.dashboard,
      child: AnimatedBuilder(
        animation: dashboardController,
        builder: (context, _) {
          final ratings = dashboardController.ratings;
          final reviews = ratings?.latest ?? dashboardController.reviews;
          return DashboardCard(
            title: 'نظرات و امتیازات',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (ratings != null) ...[
                  Text(
                    'میانگین ${ratings.average.toStringAsFixed(1)} از ${ratings.totalCount} نظر',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                for (var i = 0; i < reviews.length; i++) ...[
                  if (i > 0)
                    const Divider(color: AppColors.cardBorder, height: 24),
                  _ReviewTile(review: reviews[i]),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});
  final DashboardReview review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(review.avatarAsset),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.authorName,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  Text(
                    DashboardTime.relative(review.createdAt),
                    style: AppTextTheme.getTextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                review.gameTitle,
                style: AppTextTheme.getTextStyle(
                  fontSize: 11,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: i < review.stars
                        ? AppColors.primaryGold
                        : AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                review.comment,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DashboardActivityPage extends StatelessWidget {
  const DashboardActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.dashboard,
      child: AnimatedBuilder(
        animation: dashboardController,
        builder: (context, _) {
          final items = dashboardController.recentActivities;
          return DashboardCard(
            title: 'آخرین فعالیت‌ها',
            child: items.isEmpty
                ? Text(
                    'فعلاً فعالیتی ثبت نشده است.',
                    style: AppTextTheme.getTextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0)
                          const Divider(color: AppColors.cardBorder, height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  items[i].displayTitle,
                                  style: AppTextTheme.getTextStyle(
                                    fontSize: 13,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ),
                              Text(
                                DashboardTime.relative(items[i].completedAt),
                                style: AppTextTheme.getTextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class DashboardNotificationsPage extends StatelessWidget {
  const DashboardNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.dashboard,
      child: AnimatedBuilder(
        animation: dashboardController,
        builder: (context, _) {
          final items = dashboardController.notifications;
          return DashboardCard(
            title: 'اعلان‌ها',
            actionLabel: items.any((n) => !n.isRead) ? 'خواندن همه' : null,
            onAction: items.any((n) => !n.isRead)
                ? () => dashboardController.markAllNotificationsRead()
                : null,
            child: items.isEmpty
                ? Text(
                    'اعلانی وجود ندارد.',
                    style: AppTextTheme.getTextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0)
                          const Divider(color: AppColors.cardBorder, height: 1),
                        InkWell(
                          onTap: () async {
                            await dashboardController
                                .markNotificationRead(items[i].id);
                            final route = items[i].linkRoute;
                            if (route != null && context.mounted) {
                              Navigator.of(context).pushNamed(route);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  items[i].isRead
                                      ? Icons.notifications_none_rounded
                                      : Icons.notifications_active_rounded,
                                  size: 20,
                                  color: items[i].isRead
                                      ? AppColors.textMuted
                                      : AppColors.primaryGold,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        items[i].title,
                                        style: AppTextTheme.getTextStyle(
                                          fontSize: 13,
                                          fontWeight: items[i].isRead
                                              ? FontWeight.w500
                                              : FontWeight.bold,
                                          color: AppColors.textLight,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        items[i].body,
                                        style: AppTextTheme.getTextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DashboardTime.relative(items[i].createdAt),
                                  style: AppTextTheme.getTextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}
