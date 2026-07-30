import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/models/game_model.dart';
import 'package:frontend/pages/catalog/widgets/creator_card.dart';
import 'package:frontend/pages/catalog/widgets/quiz_carousel_section.dart';
import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/pages/game/game_routes.dart';
import 'package:frontend/pages/game/overview/game_overview_args.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/pages/home/widgets/home_nav_bar.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/footer/app_footer.dart';

const double _maxContentWidth = 1120;

class QuizzesPage extends StatelessWidget {
  const QuizzesPage({super.key});

  static final _popularQuizzes = [
    QuizCarouselItem(
      id: 1,
      title: 'ارباب حلقه ها',
      image: HomeAssets.game1,
    ),
    QuizCarouselItem(
      id: 2,
      title: 'وان پیس',
      image: HomeAssets.game2,
    ),
    QuizCarouselItem(
      id: 5,
      title: 'هری پاتر',
      image: HomeAssets.game3,
    ),
    QuizCarouselItem(
      id: 6,
      title: 'بازی تاج و تخت',
      image: HomeAssets.game4,
    ),
  ];

  static final _suggestedQuizzes = [
    QuizCarouselItem(
      id: 7,
      title: 'ناروتو',
      image: HomeAssets.gameStyle1,
    ),
    QuizCarouselItem(
      id: 8,
      title: 'آواتار',
      image: HomeAssets.gameStyle2,
    ),
    QuizCarouselItem(
      id: 3,
      title: 'ویچر',
      image: HomeAssets.gameStyle3,
    ),
    QuizCarouselItem(
      id: 4,
      title: 'دراگون ایج',
      image: HomeAssets.game1,
    ),
  ];

  static const _creators = [
    _CreatorItem(
      name: 'شاهزاده تاریکی',
      avatar: HomeAssets.profile1,
      quizzesCount: 220,
      rating: 4.6,
    ),
    _CreatorItem(
      name: 'جادوگر سفید',
      avatar: HomeAssets.profile2,
      quizzesCount: 185,
      rating: 4.8,
    ),
    _CreatorItem(
      name: 'نگهبان جنگل',
      avatar: HomeAssets.profile3,
      quizzesCount: 142,
      rating: 4.5,
    ),
    _CreatorItem(
      name: 'شوالیه نقره‌ای',
      avatar: HomeAssets.profile4,
      quizzesCount: 98,
      rating: 4.3,
    ),
    _CreatorItem(
      name: 'ملکه سایه',
      avatar: HomeAssets.profile5,
      quizzesCount: 76,
      rating: 4.7,
    ),
  ];

  void _openQuiz(BuildContext context, QuizCarouselItem item) {
    final demo = GameListItem.demoGames.firstWhere(
      (game) => game.id == item.id,
      orElse: () => GameListItem(
        id: item.id,
        title: item.title,
        description: 'کوییز فانتزی آماده بازی.',
        picture: item.image,
        gameType: 'quiz',
        createdAt: DateTime.now(),
        questionsCount: 10,
      ),
    );
    Navigator.of(context).pushNamed(
      GameRoutes.overview,
      arguments: GameOverviewArgs.fromListItem(demo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              GameAssets.backgroundForest,
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: HomeNavBar()),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: _maxContentWidth),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                        child: Column(
                          children: [
                            Text(
                              'کوییزها',
                              style: AppTextTheme.getTextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'از بین کوییزهای زیر یکی را انتخاب کنید',
                              textAlign: TextAlign.center,
                              style: AppTextTheme.getTextStyle(
                                fontSize: 16,
                                color: AppColors.textLight,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 48),
                            QuizCarouselSection(
                              title: 'جدیدترین های پرطرفدار',
                              items: _popularQuizzes,
                              onItemPressed: (item) =>
                                  _openQuiz(context, item),
                              onSeeAll: () {},
                            ),
                            const SizedBox(height: 56),
                            QuizCarouselSection(
                              title: 'گزینه‌های پیشنهادی برای شما',
                              items: _suggestedQuizzes,
                              onItemPressed: (item) =>
                                  _openQuiz(context, item),
                              onSeeAll: () {},
                            ),
                            const SizedBox(height: 56),
                            CreatorsCarouselSection(
                              title: 'بهترین سازندگان',
                              onSeeAll: () {},
                              children: _creators
                                  .map(
                                    (creator) => CreatorCard(
                                      name: creator.name,
                                      avatar: creator.avatar,
                                      quizzesCount: creator.quizzesCount,
                                      rating: creator.rating,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: AppFooter()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreatorItem {
  const _CreatorItem({
    required this.name,
    required this.avatar,
    required this.quizzesCount,
    required this.rating,
  });

  final String name;
  final String avatar;
  final int quizzesCount;
  final double rating;
}
