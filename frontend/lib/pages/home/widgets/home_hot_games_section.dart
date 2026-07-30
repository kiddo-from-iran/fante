import 'package:flutter/material.dart';
import 'package:frontend/models/game_model.dart';
import 'package:frontend/pages/game/overview/game_overview_args.dart';
import 'package:frontend/pages/game/game_routes.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class _HotGameItem {
  const _HotGameItem({
    required this.id,
    required this.image,
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.meta,
    required this.gameType,
  });

  final int id;
  final String image;
  final String tag;
  final Color tagColor;
  final String title;
  final String meta;
  final String gameType;
}

class HomeHotGamesSection extends StatelessWidget {
  const HomeHotGamesSection({super.key});

  static final _games = [
    _HotGameItem(
      id: 1,
      image: HomeAssets.game1,
      tag: 'تست شخصیت',
      tagColor: AppColors.secondaryPurple,
      title: 'شخصیت قهرمان فانتزی تو',
      meta: '۳,۸۰۰ بار باز شده',
      gameType: 'test',
    ),
    _HotGameItem(
      id: 2,
      image: HomeAssets.game2,
      tag: 'کوییز رقابتی',
      tagColor: Color(0xFF8B2252),
      title: 'چallenge دانش فانتزی',
      meta: '۲,۴۵۰ بار باز شده',
      gameType: 'quiz',
    ),
    _HotGameItem(
      id: 3,
      image: HomeAssets.game3,
      tag: 'نظرسنجی',
      tagColor: Color(0xFF2D4A7A),
      title: 'محبوب‌ترین شخصیت‌ها',
      meta: '۵,۱۲۰ بار باز شده',
      gameType: 'vote',
    ),
    _HotGameItem(
      id: 4,
      image: HomeAssets.game4,
      tag: 'تست شخصیت',
      tagColor: AppColors.secondaryPurple,
      title: 'کدام جهان فانتزی مال توئه؟',
      meta: '۱,۶۸۰ بار باز شده',
      gameType: 'test',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundSecondSection,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: Column(
        children: [
          Text(
            'جدیدترین و داغ‌ترین بازی‌ها',
            style: AppTextTheme.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _games
                      .map(
                        (game) => SizedBox(
                          width: constraints.maxWidth < 480
                              ? double.infinity
                              : (constraints.maxWidth - 16) / 2,
                          child: _HotGameCard(
                            game: game,
                            onTap: () {
                              final demo = GameListItem.demoGames.firstWhere(
                                (item) => item.id == game.id,
                                orElse: () => GameListItem(
                                  id: game.id,
                                  title: game.title,
                                  description: '',
                                  picture: game.image,
                                  gameType: game.gameType,
                                  createdAt: DateTime.now(),
                                  questionsCount: 10,
                                ),
                              );
                              Navigator.of(context).pushNamed(
                                GameRoutes.overview,
                                arguments: GameOverviewArgs.fromListItem(demo),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                );
              }

              return Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _games
                      .map(
                        (game) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _HotGameCard(
                            game: game,
                            onTap: () {
                              final demo = GameListItem.demoGames.firstWhere(
                                (item) => item.id == game.id,
                                orElse: () => GameListItem(
                                  id: game.id,
                                  title: game.title,
                                  description: '',
                                  picture: game.image,
                                  gameType: game.gameType,
                                  createdAt: DateTime.now(),
                                  questionsCount: 10,
                                ),
                              );
                              Navigator.of(context).pushNamed(
                                GameRoutes.overview,
                                arguments: GameOverviewArgs.fromListItem(demo),
                              );
                            },
                          ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ],
      ),
      ),
    );
  }
}

class _HotGameCard extends StatelessWidget {
  const _HotGameCard({
    required this.game,
    required this.onTap,
  });

  final _HotGameItem game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  game.image,
                  fit: BoxFit.cover,
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 226),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: game.tagColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          game.tag,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        game.title,
                        textAlign: TextAlign.right,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 140),
                      const Divider(
                        color: AppColors.hoverButton,
                        height: 1,
                        thickness: 1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        game.meta,
                        textAlign: TextAlign.right,
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
