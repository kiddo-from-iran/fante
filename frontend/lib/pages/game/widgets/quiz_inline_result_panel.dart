import 'package:flutter/material.dart';
import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Inline quiz result panel matching the design mock (girl + score + rewards).
class QuizInlineResultPanel extends StatelessWidget {
  const QuizInlineResultPanel({
    super.key,
    required this.title,
    required this.designerName,
    required this.score,
    required this.totalQuestions,
    this.xpEarned,
    this.rank = 24,
    this.totalPlayers = 120,
    this.summary = 'اطلاعات شما در سطح عالی قرار دارد',
    this.onShare,
    this.onViewChoices,
  });

  final String title;
  final String designerName;
  final int score;
  final int totalQuestions;
  final int? xpEarned;
  final int rank;
  final int totalPlayers;
  final String summary;
  final VoidCallback? onShare;
  final VoidCallback? onViewChoices;

  String get _girlAsset {
    final ratio = totalQuestions == 0 ? 0.0 : score / totalQuestions;
    if (ratio >= 0.7) return GameAssets.resultGood;
    if (ratio >= 0.4) return GameAssets.resultOk;
    return GameAssets.resultSad;
  }

  @override
  Widget build(BuildContext context) {
    final xp = xpEarned ?? (score * 20);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: const Color(0xE6121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.65)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 560;
          final content = _ResultContent(
            title: title,
            designerName: designerName,
            score: score,
            totalQuestions: totalQuestions,
            xp: xp,
            rank: rank,
            totalPlayers: totalPlayers,
            summary: summary,
            onShare: onShare,
            onViewChoices: onViewChoices,
          );
          final girl = Image.asset(
            _girlAsset,
            height: wide ? 420 : 280,
            fit: BoxFit.contain,
          );

          if (!wide) {
            return Column(
              children: [
                girl,
                const SizedBox(height: 16),
                content,
              ],
            );
          }

          // RTL: first child = right side (text), second = left (girl).
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 5, child: content),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.center,
                  child: girl,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ResultContent extends StatelessWidget {
  const _ResultContent({
    required this.title,
    required this.designerName,
    required this.score,
    required this.totalQuestions,
    required this.xp,
    required this.rank,
    required this.totalPlayers,
    required this.summary,
    this.onShare,
    this.onViewChoices,
  });

  final String title;
  final String designerName;
  final int score;
  final int totalQuestions;
  final int xp;
  final int rank;
  final int totalPlayers;
  final String summary;
  final VoidCallback? onShare;
  final VoidCallback? onViewChoices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'نتیجه کوییز شما در $title',
          textAlign: TextAlign.right,
          style: AppTextTheme.getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGold,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'طراح: $designerName',
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(GameAssets.designerAvatar),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'امتیاز نهایی',
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 14,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(Icons.star_rounded,
                    color: AppColors.primaryGold, size: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '$score از $totalQuestions',
                style: AppTextTheme.getTextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
            ),
            ...List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Icon(Icons.star_rounded,
                    color: AppColors.primaryGold, size: 22),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'جوایز و رتبه بندی',
          textAlign: TextAlign.right,
          style: AppTextTheme.getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 10),
        _GlowBox(text: 'امتیاز کسب شده : $xp XP'),
        const SizedBox(height: 10),
        _GlowBox(text: 'رتبه شما: نفر $rank از $totalPlayers'),
        const SizedBox(height: 12),
        Text(
          summary,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _OrangeAction(
                label: 'مشاهده گزارش های خود',
                onPressed: onViewChoices,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OrangeAction(
                label: 'اشتراک گذاری نتیجه',
                onPressed: onShare,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GlowBox extends StatelessWidget {
  const _GlowBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withValues(alpha: 0.22),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextTheme.getTextStyle(
          fontSize: 13,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}

class _OrangeAction extends StatelessWidget {
  const _OrangeAction({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.textBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}
