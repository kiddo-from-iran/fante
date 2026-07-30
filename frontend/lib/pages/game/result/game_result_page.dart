import 'package:flutter/material.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/models/game_session_data.dart';
import 'package:frontend/pages/game/widgets/game_author_header.dart';
import 'package:frontend/pages/game/widgets/game_glass_card.dart';
import 'package:frontend/pages/game/widgets/game_option_widgets.dart';
import 'package:frontend/pages/game/widgets/game_scaffold.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// Shell for all result-phase screens; content varies by [variant].
class GameResultPage extends StatelessWidget {
  const GameResultPage({
    super.key,
    required this.variant,
    required this.data,
  });

  final GameResultVariant variant;
  final GameSessionData data;

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: data.background,
      child: GameSessionLayout(
        main: GameGlassCard(child: _buildResultContent()),
        sidebar: GameSidebar(data: data.sidebar),
      ),
    );
  }

  Widget _buildResultContent() {
    switch (variant) {
      case GameResultVariant.pollBars:
        return PollResultView(data: data as PollResultData);
      case GameResultVariant.quizScore:
        return QuizScoreResultView(data: data as QuizScoreResultData);
      case GameResultVariant.worldDiscovery:
        return WorldDiscoveryResultView(
          data: data as WorldDiscoveryResultData,
        );
    }
  }
}

class PollResultView extends StatelessWidget {
  const PollResultView({super.key, required this.data});

  final PollResultData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameAuthorHeader(
          title: data.title,
          designerName: data.designerName,
          designerAvatar: data.designerAvatar,
        ),
        const SizedBox(height: 24),
        Text(
          data.successMessage,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 14,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 20),
        ...List.generate(data.options.length, (index) {
          return GameResultBar(
            option: data.options[index],
            highlighted: index == data.selectedIndex,
          );
        }),
        const SizedBox(height: 16),
        Text(
          'تعداد کل رای‌ها: ${data.totalVotes} شرکت‌کننده',
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.footerMessage,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGold,
          ),
        ),
      ],
    );
  }
}

class QuizScoreResultView extends StatelessWidget {
  const QuizScoreResultView({super.key, required this.data});

  final QuizScoreResultData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameAuthorHeader(
          title: data.title,
          designerName: data.designerName,
          designerAvatar: data.designerAvatar,
        ),
        const SizedBox(height: 24),
        Text(
          'امتیاز نهایی',
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 14,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 28),
            const SizedBox(width: 12),
            Text(
              '${data.score} از ${data.totalQuestions}',
              style: AppTextTheme.getTextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.star, color: Colors.amber, size: 28),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(color: AppColors.cardBorder),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'جوایز و رتبه‌بندی',
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GameGlowStatBar(label: 'امتیاز کسب شده : ${data.xpEarned} XP'),
        GameGlowStatBar(
          label: 'رتبه شما: نفر ${data.rank} از ${data.totalPlayers}',
        ),
        const SizedBox(height: 12),
        Text(
          data.summary,
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GameOrangeButton(
                label: 'اشتراک‌گذاری نتیجه',
                expand: false,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GameOrangeButton(
                label: 'مشاهده گزینه‌های خود',
                expand: false,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class WorldDiscoveryResultView extends StatelessWidget {
  const WorldDiscoveryResultView({super.key, required this.data});

  final WorldDiscoveryResultData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameAuthorHeader(
          title: data.title,
          designerName: data.designerName,
          designerAvatar: data.designerAvatar,
        ),
        const SizedBox(height: 16),
        _GradientBanner(title: data.bannerTitle),
        const SizedBox(height: 20),
        Text(
          data.subtitle,
          style: AppTextTheme.getTextStyle(
            fontSize: 13,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 14),
        _WorldImageGrid(images: data.selectedImages),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'کاوشگر شما: ${data.explorerName}',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.cardBorder),
                  const SizedBox(height: 8),
                  Text(
                    'امتیاز اکتشاف : ${data.explorationScore}',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.highlightMessage,
                    style: AppTextTheme.getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GameOrangeButton(
                label: 'اشتراک‌گذاری نتیجه',
                expand: false,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GameOrangeButton(
                label: 'مشاهده دنیای خود',
                expand: false,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GradientBanner extends StatelessWidget {
  const _GradientBanner({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withValues(alpha: 0.85),
            AppColors.surfaceCard.withValues(alpha: 0.9),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: AppTextTheme.getTextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}

class _WorldImageGrid extends StatelessWidget {
  const _WorldImageGrid({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    if (images.length < 3) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _WorldImageTile(image: images[0])),
            const SizedBox(width: 10),
            Expanded(child: _WorldImageTile(image: images[1])),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: (MediaQuery.sizeOf(context).width - 48) / 2,
            child: _WorldImageTile(image: images[2]),
          ),
        ),
      ],
    );
  }
}

class _WorldImageTile extends StatelessWidget {
  const _WorldImageTile({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              color: Colors.black.withValues(alpha: 0.55),
              child: Text(
                'انتخاب شده',
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
