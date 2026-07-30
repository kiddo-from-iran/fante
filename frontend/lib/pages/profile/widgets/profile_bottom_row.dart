import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileBottomRow extends StatelessWidget {
  const ProfileBottomRow({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _RatingsCard(),
              SizedBox(height: 16),
              _RecentTicketsCard(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(flex: 2, child: _RecentTicketsCard()),
            SizedBox(width: 16),
            Expanded(flex: 3, child: _RatingsCard()),
          ],
        );
      },
    );
  }
}

class _RecentTicketsCard extends StatelessWidget {
  const _RecentTicketsCard();

  static const _tickets = [
    (
      'مشکل در انتشار کوئیز',
      'متوسط',
      'پاسخ داده شده',
      Color(0xFF2D7D46),
      'دو ساعت پیش',
    ),
    (
      'درخواست قابلیت جدید',
      'بالا',
      'در حال بررسی',
      Color(0xFFB8862B),
      'یک روز پیش',
    ),
    (
      'مشکل در نمایش نتایج',
      'پایین',
      'باز',
      Color(0xFF2D4A7A),
      'دو روز پیش',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: 'تیکت‌های اخیر',
      actionLabel: 'مشاهده همه',
      onAction: () {},
      child: Column(
        children: [
          Row(
            children: [
              _headerCell('وضعیت', flex: 2),
              _headerCell('اولویت', flex: 2),
              _headerCell('موضوع', flex: 4),
              _headerCell('آخرین بروزرسانی', flex: 3),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: AppColors.cardBorder, height: 1),
          ..._tickets.map(
            (t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _StatusChip(label: t.$3, color: t.$4),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      t.$2,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      t.$1,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      t.$5,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
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
      children: [
        Column(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceCard,
              backgroundImage: AssetImage(DashboardAssets.avatar),
            ),
            const SizedBox(height: 4),
            Text(
              'سارا',
              style: AppTextTheme.getTextStyle(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'کوییز دنیای انیمه',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(
                    4,
                    (_) => const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'کوییز بسیار عالی بود و جالبی بود. سوالات چالش‌برانگیز و جذاب بودن.',
                textAlign: TextAlign.right,
                style: AppTextTheme.getTextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'دو روز پیش',
                style: AppTextTheme.getTextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
