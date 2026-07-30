import 'package:flutter/material.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/profile/widgets/profile_panel.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfileStatCardsRow extends StatelessWidget {
  const ProfileStatCardsRow({super.key, required this.profile});

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    final stats = profile.stats;

    final cards = [
      _StatCardData(
        lines: [
          'نشان‌ها = 12',
          'امتیاز کل = ${formatProfileNumber(stats.totalPoints)}',
        ],
      ),
      _StatCardData(
        lines: [
          'تست‌های شرکت کرده = ${stats.votesCompleted}',
          'تست‌های ساخته شده = 21',
        ],
      ),
      _StatCardData(
        lines: [
          'کوئیزهای شرکت کرده = ${stats.quizzesCompleted}',
          'کوئیزهای ساخته شده = ${stats.quizzesCreated}',
        ],
      ),
      _StatCardData(
        lines: [
          'نظرسنجی‌های شرکت کرده = ${stats.pollsCompleted}',
          'نظرسنجی‌های ساخته شده = 21',
        ],
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cards
                .map(
                  (card) => SizedBox(
                    width: (constraints.maxWidth - 12) / 2,
                    child: _StatCard(data: card),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: _StatCard(data: cards[i])),
            ],
          ],
        );
      },
    );
  }
}

class _StatCardData {
  const _StatCardData({required this.lines});

  final List<String> lines;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatCardData data;

  @override
  Widget build(BuildContext context) {
    return ProfilePanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < data.lines.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            Text(
              data.lines[i],
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
