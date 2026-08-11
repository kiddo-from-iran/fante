import 'package:flutter/material.dart';
import 'package:frontend/common/user_avatar.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/data/dashboard_controller.dart';
import 'package:frontend/pages/dashboard/data/dashboard_models.dart';
import 'package:frontend/pages/dashboard/data/dashboard_time.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/pages/dashboard/tickets/player_ticket.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/utils/game_picture_helper.dart';
import 'package:frontend/pages/profile/profile_routes.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/utils/jalali_date.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    dashboardController.load();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.dashboard,
      child: AnimatedBuilder(
        animation: dashboardController,
        builder: (context, _) {
          if (dashboardController.loading &&
              dashboardController.profile == null &&
              dashboardController.badges.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryGold),
              ),
            );
          }

          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ActivitySummaryCard(),
              SizedBox(height: 16),
              _TopListsRow(),
              SizedBox(height: 16),
              _BottomRow(),
            ],
          );
        },
      ),
    );
  }
}

class _BottomRow extends StatelessWidget {
  const _BottomRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _RatingsCard(),
              SizedBox(height: 16),
              _RecentTicketsCard(),
              SizedBox(height: 16),
              _AnnouncementsCard(),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _RatingsCard()),
            SizedBox(width: 16),
            Expanded(flex: 4, child: _RecentTicketsCard()),
            SizedBox(width: 16),
            Expanded(flex: 3, child: _AnnouncementsCard()),
          ],
        );
      },
    );
  }
}

class _ActivitySummaryCard extends StatelessWidget {
  const _ActivitySummaryCard();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          if (!isWide) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileMini(),
                SizedBox(height: 16),
                _StatsPanel(),
                SizedBox(height: 16),
                _LatestBadgesPanel(),
                SizedBox(height: 16),
                _QuickActionsPanel(),
              ],
            );
          }

          return const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileMini(),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StatsPanel(),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _LatestBadgesPanel()),
                        SizedBox(width: 16),
                        Expanded(flex: 4, child: _QuickActionsPanel()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InnerPanel extends StatelessWidget {
  const _InnerPanel({
    this.title,
    this.centerTitle = false,
    this.onTitleTap,
    required this.child,
  });

  final String? title;
  final bool centerTitle;
  final VoidCallback? onTitleTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            InkWell(
              onTap: onTitleTap,
              child: Text(
                title!,
                textAlign: centerTitle ? TextAlign.center : TextAlign.right,
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textLight,
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel();

  @override
  Widget build(BuildContext context) {
    final c = dashboardController;
    final stats = c.profile?.stats;
    final badgeCount = c.badges.length;
    final quizCreated = c.publishedCount(GameKind.quiz);
    final pollCreated = c.publishedCount(GameKind.poll);
    final testCreated = c.publishedCount(GameKind.personality);

    final cards = [
      _StatCardData(
        topLine: 'نشان ها = $badgeCount',
        bottomLine: 'امتیاز کل = ${stats?.totalPoints ?? 0}',
      ),
      _StatCardData(
        topLine: 'تست های شرکت کرده = ${stats?.pollsCompleted ?? 0}',
        bottomLine: 'تست های ساخته شده = $testCreated',
      ),
      _StatCardData(
        topLine: 'کوئیز های شرکت کرده = ${stats?.quizzesCompleted ?? 0}',
        bottomLine:
            'کوئیز های ساخته شده = ${stats?.quizzesCreated ?? quizCreated}',
      ),
      _StatCardData(
        topLine: 'نظرسنجی‌های شرکت کرده = ${stats?.votesCompleted ?? 0}',
        bottomLine: 'نظرسنجی‌های ساخته شده = $pollCreated',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cards
                .map(
                  (stat) => SizedBox(
                    width: constraints.maxWidth < 360
                        ? double.infinity
                        : (constraints.maxWidth - 12) / 2,
                    child: _StatBox(data: stat),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: _StatBox(data: cards[i])),
            ],
          ],
        );
      },
    );
  }
}

class _StatCardData {
  const _StatCardData({required this.topLine, required this.bottomLine});
  final String topLine;
  final String bottomLine;
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.data});
  final _StatCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Text(
            data.topLine,
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textLight,
              height: 1.4,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              color: AppColors.hoverButton,
              height: 1,
              thickness: 1,
            ),
          ),
          Text(
            data.bottomLine,
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textLight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMini extends StatelessWidget {
  const _ProfileMini();

  @override
  Widget build(BuildContext context) {
    final profile = dashboardController.profile;
    final user = profile?.user;
    final level = profile?.stats.level;
    final name = UserAvatarHelper.displayName(user);
    final handle = _handleFor(user?.email, user?.phoneNumber, user?.id);
    final memberSince = user?.createdAt != null
        ? JalaliDate.format(user!.createdAt!)
        : '—';

    return SizedBox(
      width: 220,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pushNamed(ProfileRoutes.profile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.surfaceCard,
                backgroundImage: UserAvatarHelper.avatarImage(user),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              name,
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              level == null
                  ? 'سطح —'
                  : (level.levelTitle?.isNotEmpty ?? false)
                      ? 'سطح ${level.level} · ${level.levelTitle}'
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
                value: level?.xpProgress.clamp(0.0, 1.0) ?? 0,
                minHeight: 8,
                backgroundColor: AppColors.backgroundDark,
                valueColor:
                    const AlwaysStoppedAnimation(AppColors.primaryGold),
              ),
            ),
            if (level != null) ...[
              const SizedBox(height: 6),
              Text(
                level.xpLabel,
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 16),
            _infoLine(Icons.alternate_email_rounded, handle),
            _infoLine(Icons.calendar_today_outlined, 'عضو از $memberSince'),
            _infoLine(Icons.link_rounded, 'fantequiz.ir/profile'),
          ],
        ),
      ),
    );
  }

  String _handleFor(String? email, String? phone, int? id) {
    if (email != null && email.contains('@')) {
      return '@${email.split('@').first}';
    }
    if (phone != null && phone.isNotEmpty) return phone;
    if (id != null) return '@user$id';
    return '@player';
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

class _LatestBadgesPanel extends StatelessWidget {
  const _LatestBadgesPanel();

  @override
  Widget build(BuildContext context) {
    final badges = dashboardController.badges.take(3).toList();
    return _InnerPanel(
      title: 'آخرین نشان ها',
      centerTitle: true,
      onTitleTap: () =>
          Navigator.of(context).pushNamed(DashboardRoutes.badges),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(DashboardRoutes.badges),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primaryGold.withValues(alpha: 0.45),
            ),
          ),
          child: badges.isEmpty
              ? Text(
                  'هنوز نشانی ندارید',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                )
              : Row(
                  children: [
                    for (var i = 0; i < badges.length; i++) ...[
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              badges[i].assetPath,
                              height: 88,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              badges[i].title,
                              textAlign: TextAlign.center,
                              style: AppTextTheme.getTextStyle(
                                fontSize: 13,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < badges.length - 1)
                        Container(
                          width: 1,
                          height: 110,
                          color: AppColors.hoverButton,
                        ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel();

  @override
  Widget build(BuildContext context) {
    final actions = <(String, VoidCallback)>[
      (
        'ساخت کوییز جدید',
        () => Navigator.of(context).pushNamed(
              DashboardRoutes.gameCreate,
              arguments: GameKind.quiz,
            ),
      ),
      (
        'ساخت نظرسنجی جدید',
        () => Navigator.of(context).pushNamed(
              DashboardRoutes.gameCreate,
              arguments: GameKind.poll,
            ),
      ),
      (
        'ساخت تست جدید',
        () => Navigator.of(context).pushNamed(
              DashboardRoutes.gameCreate,
              arguments: GameKind.personality,
            ),
      ),
      (
        'ایجاد تیکت جدید',
        () => Navigator.of(context).pushNamed(DashboardRoutes.ticketCreate),
      ),
    ];

    return _InnerPanel(
      title: 'فعالیت سریع',
      centerTitle: true,
      child: Column(
        children: [
          for (var i = 0; i < actions.length; i += 2)
            Padding(
              padding: EdgeInsets.only(
                bottom: i + 2 < actions.length ? 20 : 0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _actionButton(actions[i].$1, actions[i].$2),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: i + 1 < actions.length
                        ? _actionButton(actions[i + 1].$1, actions[i + 1].$2)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.textBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}

class _TopListsRow extends StatelessWidget {
  const _TopListsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ActivityStatsCard(),
              SizedBox(height: 16),
              _IncompleteActivitiesCard(),
              SizedBox(height: 16),
              _LatestActivityCard(),
            ],
          );
        }

        return const IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: _ActivityStatsCard()),
              SizedBox(width: 16),
              Expanded(flex: 1, child: _IncompleteActivitiesCard()),
              SizedBox(width: 16),
              Expanded(flex: 1, child: _LatestActivityCard()),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityStatsCard extends StatelessWidget {
  const _ActivityStatsCard();

  @override
  Widget build(BuildContext context) {
    final series = dashboardController.activitySeries;
    final points =
        series.isEmpty ? const [0.3, 0.5, 0.4, 0.6] : series.map((e) => e.value).toList();
    final labels = series.isEmpty
        ? const ['01', '02', '03', '04']
        : series.map((e) => e.label).toList();

    return DashboardCard(
      title: 'آمار فعالیت های شما',
      child: Container(
        height: 220,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: CustomPaint(
                painter: _ActivityLineChartPainter(points: points),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < labels.length; i++)
                    if (i == 0 ||
                        i == labels.length - 1 ||
                        i % ((labels.length / 6).ceil().clamp(1, 6)) == 0)
                      Text(
                        labels[i],
                        style: AppTextTheme.getTextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      )
                    else
                      const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityLineChartPainter extends CustomPainter {
  _ActivityLineChartPainter({required this.points});

  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || size.width <= 0 || size.height <= 0) return;

    final gridPaint = Paint()
      ..color = AppColors.textMuted.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    const gridCount = 4;
    for (var i = 0; i <= gridCount; i++) {
      final y = size.height * i / gridCount;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1
          ? size.width / 2
          : size.width * i / (points.length - 1);
      final y = size.height * (1 - points[i].clamp(0.0, 1.0));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = AppColors.textLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ActivityLineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _IncompleteActivitiesCard extends StatelessWidget {
  const _IncompleteActivitiesCard();

  @override
  Widget build(BuildContext context) {
    final drafts = dashboardController.incompleteGames;

    return DashboardCard(
      title: 'فعالیت های ناتمام',
      actionLabel: 'مشاهده همه',
      onAction: () {
        Navigator.of(context).pushNamed(
          DashboardRoutes.games,
          arguments: const {'draftsOnly': true},
        );
      },
      child: drafts.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'پیش‌نویس ناتمامی ندارید.',
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < drafts.length; i++) ...[
                  if (i > 0)
                    const Divider(color: AppColors.cardBorder, height: 1),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        DashboardRoutes.gameEdit,
                        arguments: drafts[i].id,
                      ).then((_) => dashboardController.refreshLocalSlices());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  drafts[i].title.trim().isEmpty
                                      ? 'بدون عنوان'
                                      : drafts[i].title,
                                  style: AppTextTheme.getTextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  drafts[i].kindLabel,
                                  style: AppTextTheme.getTextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Image(
                                image: GamePictureHelper.providerFor(
                                  drafts[i].imagePath ?? DashboardAssets.thumb1,
                                ),
                                fit: BoxFit.cover,
                              ),
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
  }
}

class _LatestActivityCard extends StatelessWidget {
  const _LatestActivityCard();

  @override
  Widget build(BuildContext context) {
    final items = dashboardController.recentActivities.take(5).toList();

    return DashboardCard(
      title: 'آخرین فعالیت',
      actionLabel: 'مشاهده همه',
      onAction: () =>
          Navigator.of(context).pushNamed(DashboardRoutes.activity),
      child: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'فعلاً فعالیتی نیست.',
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0)
                    const Divider(color: AppColors.cardBorder, height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            items[i].displayTitle,
                            style: AppTextTheme.getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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
  }
}

class _RecentTicketsCard extends StatelessWidget {
  const _RecentTicketsCard();

  @override
  Widget build(BuildContext context) {
    final tickets = dashboardController.recentTickets;

    return DashboardCard(
      title: 'تیکت های اخیر',
      actionLabel: 'مشاهده همه',
      onAction: () {
        Navigator.of(context).pushReplacementNamed(DashboardRoutes.tickets);
      },
      child: Column(
        children: [
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 110),
              _headerCell('اولویت', flex: 2),
              _headerCell('موضوع', flex: 4),
              _headerCell('آخرین بروزرسانی', flex: 3),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.cardBorder, height: 1),
          if (tickets.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'تیکتی ثبت نشده است.',
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            )
          else
            for (var i = 0; i < tickets.length; i++) ...[
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    DashboardRoutes.ticketEdit,
                    arguments: tickets[i].id,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: _StatusChip(
                          label: tickets[i].status.label,
                          color: tickets[i].status.color,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          tickets[i].priority.label,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          tickets[i].subject,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          DashboardTime.relative(tickets[i].updatedAt),
                          style: AppTextTheme.getTextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < tickets.length - 1)
                const Divider(color: AppColors.cardBorder, height: 1),
            ],
        ],
      ),
    );
  }

  Widget _headerCell(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: AppTextTheme.getTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: AppTextTheme.getTextStyle(
            fontSize: 11,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }
}

class _AnnouncementsCard extends StatelessWidget {
  const _AnnouncementsCard();

  @override
  Widget build(BuildContext context) {
    final items = dashboardController.announcements.take(9).toList();

    return DashboardCard(
      title: 'اعلانات',
      actionLabel: 'مشاهده همه',
      onAction: () =>
          Navigator.of(context).pushNamed(DashboardRoutes.announcements),
      child: Column(
        children: [
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 8),
          for (final item in items)
            InkWell(
              onTap: () =>
                  Navigator.of(context).pushNamed(DashboardRoutes.announcements),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      JalaliDate.format(item.publishedAt),
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RatingsCard extends StatelessWidget {
  const _RatingsCard();

  @override
  Widget build(BuildContext context) {
    final ratings = dashboardController.ratings;
    final bars = ratings?.starShares ?? const [0.0, 0.0, 0.0, 0.0, 0.0];
    final latest = ratings?.latest.isNotEmpty == true
        ? ratings!.latest.first
        : null;

    return DashboardCard(
      title: 'نظرات و امتیازات دریافتی',
      actionLabel: 'مشاهده همه',
      onAction: () =>
          Navigator.of(context).pushNamed(DashboardRoutes.reviews),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < 5; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text(
                              '${5 - i} ستاره',
                              style: AppTextTheme.getTextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: i < bars.length ? bars[i] : 0,
                                  minHeight: 8,
                                  backgroundColor: AppColors.backgroundDark,
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.primaryGold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    (ratings?.average ?? 0).toStringAsFixed(1),
                    style: AppTextTheme.getTextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      5,
                      (_) => const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.primaryGold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ratings?.totalCount ?? 0} نظر',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 12),
          if (latest != null) _ReviewRow(review: latest),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.review});

  final DashboardReview review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(review.avatarAsset),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.authorName,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                review.comment,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.getTextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
