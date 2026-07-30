import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardShell(
      active: DashboardSection.dashboard,
      child: _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
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

        // RTL: ratings (right) → tickets → announcements (left)
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

// ===========================================================================
// Activity summary
// ===========================================================================

class _ActivitySummaryCard extends StatelessWidget {
  const _ActivitySummaryCard();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          final rightSide = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _StatsPanel(),
              SizedBox(height: 16),
              _BadgesAndActionsRow(),
            ],
          );

          if (!isWide) {
            return Column(
              children: [
                const _ProfileMini(),
                const SizedBox(height: 16),
                rightSide,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: rightSide),
              const SizedBox(width: 20),
              const _ProfileMini(),
            ],
          );
        },
      ),
    );
  }
}

/// Bordered inner container used to group panels within the summary card.
class _InnerPanel extends StatelessWidget {
  const _InnerPanel({
    this.title,
    this.centerTitle = false,
    required this.child,
  });

  final String? title;
  final bool centerTitle;
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
            Text(
              title!,
              textAlign: centerTitle ? TextAlign.center : TextAlign.right,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
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

  static const _stats = [
    _StatCardData(
      topLine: 'نشان ها = 12',
      bottomLine: 'امتیاز کل = 15400',
    ),
    _StatCardData(
      topLine: 'تست های شرکت کرده = 53',
      bottomLine: 'تست های ساخته شده = 21',
    ),
    _StatCardData(
      topLine: 'کوئیز های شرکت کرده = 53',
      bottomLine: 'کوئیز های ساخته شده = 21',
    ),
    _StatCardData(
      topLine: 'نظرسنجی‌های شرکت کرده = 53',
      bottomLine: 'نظرسنجی‌های ساخته شده = 21',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _stats
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
            for (var i = 0; i < _stats.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: _StatBox(data: _stats[i])),
            ],
          ],
        );
      },
    );
  }
}

class _StatCardData {
  const _StatCardData({
    required this.topLine,
    required this.bottomLine,
  });

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
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.surfaceCard,
              backgroundImage: AssetImage(DashboardAssets.avatar),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'آرین کاوشگر',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'سطح 15',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.4,
              minHeight: 8,
              backgroundColor: AppColors.backgroundDark,
              valueColor: AlwaysStoppedAnimation(AppColors.primaryGold),
            ),
          ),
          const SizedBox(height: 16),
          _infoLine(Icons.alternate_email_rounded, '@arian'),
          _infoLine(Icons.location_on_outlined, 'ایران - تهران'),
          _infoLine(Icons.link_rounded, 'fantequiz.ir/arin'),
          _infoLine(Icons.calendar_today_outlined, 'عضو از 1405/06/24'),
        ],
      ),
    );
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

// ===========================================================================
// Latest badges + quick actions (inner panels of the summary card)
// ===========================================================================

class _BadgesAndActionsRow extends StatelessWidget {
  const _BadgesAndActionsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _QuickActionsPanel(),
              SizedBox(height: 16),
              _LatestBadgesPanel(),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(flex: 4, child: _QuickActionsPanel()),
            SizedBox(width: 16),
            Expanded(flex: 5, child: _LatestBadgesPanel()),
          ],
        );
      },
    );
  }
}

class _LatestBadgesPanel extends StatelessWidget {
  const _LatestBadgesPanel();

  static const _badges = [
    ('مخترع', DashboardAssets.badgeSilver),
    ('تست ساز', DashboardAssets.badgeBronze),
    ('نظرسنجی حرفه ای', DashboardAssets.badgeBronze),
  ];

  @override
  Widget build(BuildContext context) {
    return _InnerPanel(
      title: 'آخرین نشان ها',
      centerTitle: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryGold.withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            for (var i = 0; i < _badges.length; i++) ...[
              Expanded(
                child: Column(
                  children: [
                    Image.asset(
                      _badges[i].$2,
                      height: 88,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _badges[i].$1,
                      textAlign: TextAlign.center,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              if (i < _badges.length - 1)
                Container(
                  width: 1,
                  height: 110,
                  color: AppColors.hoverButton,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel();

  static const _actions = [
    'ساخت کوییز جدید',
    'ساخت نظرسنجی جدید',
    'ساخت تست جدید',
    'ایجاد تیکت جدید',
  ];

  @override
  Widget build(BuildContext context) {
    return _InnerPanel(
      title: 'فعالیت سریع',
      centerTitle: true,
      child: Column(
        children: [
          for (var i = 0; i < _actions.length; i += 2)
            Padding(
              padding: EdgeInsets.only(
                bottom: i + 2 < _actions.length ? 20 : 0,
              ),
              child: Row(
                children: [
                  Expanded(child: _actionButton(context, _actions[i])),
                  const SizedBox(width: 20),
                  Expanded(
                    child: i + 1 < _actions.length
                        ? _actionButton(context, _actions[i + 1])
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, String label) {
    final opensCreate = label.startsWith('ساخت');
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: opensCreate
            ? () => Navigator.of(context)
                .pushNamed(DashboardRoutes.gameCreate)
            : () {},
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

// ===========================================================================
// Activity row: stats chart + incomplete + latest
// ===========================================================================

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

        // RTL: first child sits on the right — chart (wide), incomplete, latest.
        // IntrinsicHeight needed: parent is a scroll view (unbounded height),
        // so CrossAxisAlignment.stretch alone would assert.
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

  static const _years = ['2017', '2018', '2019', '2020', '2021', '2022', '2023'];

  /// Demo values (0–1) matching the design's jagged line.
  static const _points = [0.42, 0.55, 0.48, 0.62, 0.38, 0.78, 0.52, 0.88, 0.45, 0.70, 0.58, 0.40];

  @override
  Widget build(BuildContext context) {
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
                painter: _ActivityLineChartPainter(points: _points),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _years
                    .map(
                      (y) => Text(
                        y,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                    .toList(),
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
      final x = size.width * i / (points.length - 1);
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
    return DashboardCard(
      title: 'فعالیت های ناتمام',
      actionLabel: 'مشاهده همه',
      onAction: () {},
      child: Column(
        children: List.generate(3, (index) {
          final isLast = index == 2;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'دنیای انیمه',
                            style: AppTextTheme.getTextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '45 شرکت کننده',
                            style: AppTextTheme.getTextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(color: AppColors.cardBorder, height: 1),
            ],
          );
        }),
      ),
    );
  }
}

class _LatestActivityCard extends StatelessWidget {
  const _LatestActivityCard();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'آخرین فعالیت',
      actionLabel: 'مشاهده همه',
      onAction: () {},
      child: Column(
        children: List.generate(5, (index) {
          final isLast = index == 4;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'کوییز جدید منتشر کردید',
                        style: AppTextTheme.getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(color: AppColors.cardBorder, height: 1),
            ],
          );
        }),
      ),
    );
  }
}

// ===========================================================================
// Recent tickets
// ===========================================================================

class _RecentTicketsCard extends StatelessWidget {
  const _RecentTicketsCard();

  static const _tickets = [
    _TicketRowData(
      status: 'پاسخ داده شده',
      statusColor: Color(0xFF2D7D46),
      priority: 'متوسط',
      subject: 'مشکل در انتشار کوییز',
      updatedAt: 'دو ساعت پیش',
    ),
    _TicketRowData(
      status: 'درحال بررسی',
      statusColor: Color(0xFFB8862B),
      priority: 'بالا',
      subject: 'درخواست قابلیت جدید',
      updatedAt: 'یک روز پیش',
    ),
    _TicketRowData(
      status: 'باز',
      statusColor: Color(0xFF2D4A7A),
      priority: 'پایین',
      subject: 'مشکل در نمایش نتایج',
      updatedAt: 'دو روز پیش',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          for (var i = 0; i < _tickets.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: _StatusChip(
                      label: _tickets[i].status,
                      color: _tickets[i].statusColor,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _tickets[i].priority,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      _tickets[i].subject,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      _tickets[i].updatedAt,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < _tickets.length - 1)
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

class _TicketRowData {
  const _TicketRowData({
    required this.status,
    required this.statusColor,
    required this.priority,
    required this.subject,
    required this.updatedAt,
  });

  final String status;
  final Color statusColor;
  final String priority;
  final String subject;
  final String updatedAt;
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

// ===========================================================================
// Announcements
// ===========================================================================

class _AnnouncementsCard extends StatelessWidget {
  const _AnnouncementsCard();

  static const _items = [
    ('آپدیت جدید بازی ها', '1405/02/23'),
    ('مراقب اطلاعاتتان باشید', '1405/02/23'),
    ('پروفایل شما به روز ...', '1405/02/23'),
    ('آپدیت جدید بازی ها', '1405/02/23'),
    ('مراقب اطلاعاتتان باشید', '1405/02/23'),
    ('پروفایل شما به روز ...', '1405/02/23'),
    ('آپدیت جدید بازی ها', '1405/02/23'),
    ('مراقب اطلاعاتتان باشید', '1405/02/23'),
    ('پروفایل شما به روز ...', '1405/02/23'),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'اعلانات',
      actionLabel: 'مشاهده همه',
      onAction: () {},
      child: Column(
        children: [
          const Divider(color: AppColors.cardBorder, height: 1),
          const SizedBox(height: 8),
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.$1,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.$2,
                    style: AppTextTheme.getTextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Ratings
// ===========================================================================

class _RatingsCard extends StatelessWidget {
  const _RatingsCard();

  static const _bars = [
    (5, 0.8),
    (4, 0.45),
    (3, 0.2),
    (2, 0.1),
    (1, 0.05),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'نظرات و امتیازات دریافتی',
      actionLabel: 'مشاهده همه',
      onAction: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: _bars
                      .map(
                        (bar) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                '${bar.$1} ستاره',
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
                                    value: bar.$2,
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
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    '4.8',
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
                    '124 نظر',
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
          _ReviewRow(),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.backgroundDark,
          child: Text(
            'سارا',
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'کوییز دنیای انیمه',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(
                    4,
                    (_) => const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFFFFD54F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'کوییز بسیار عالی بود و جالبی بود. سوالات چالش برانگیز و جذاب بودن.',
                style: AppTextTheme.getTextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'دو روز پیش',
          style: AppTextTheme.getTextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
