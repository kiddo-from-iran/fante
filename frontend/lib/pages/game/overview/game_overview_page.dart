import 'package:flutter/material.dart';
import 'package:frontend/data/repository/game_repository.dart';
import 'package:frontend/models/game_model.dart';
import 'package:frontend/pages/game/game_routes.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/overview/game_overview_args.dart';
import 'package:frontend/pages/game/utils/game_picture_helper.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';
import 'package:share_plus/share_plus.dart';

class GameOverviewPage extends StatefulWidget {
  const GameOverviewPage({
    super.key,
    required this.args,
  });

  final GameOverviewArgs args;

  @override
  State<GameOverviewPage> createState() => _GameOverviewPageState();
}

class _GameOverviewPageState extends State<GameOverviewPage> {
  late Future<GameDetail> _gameFuture;
  late final PageController _galleryController;
  int _galleryIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _gameFuture = gameRepository.getGameWithFallback(widget.args.gameId);
    _galleryController = PageController(viewportFraction: 0.32);
  }

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: FutureBuilder<GameDetail>(
          future: _gameFuture,
          initialData: widget.args.preview != null
              ? GameDetail.fromListItem(widget.args.preview!)
              : GameDetail.fromListItem(GameListItem.demoGames.first),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGold),
              );
            }

            final game = snapshot.data ??
                GameDetail.fromListItem(GameListItem.demoGames.first);

            return Stack(
              fit: StackFit.expand,
              children: [
                GamePictureHelper.image(picture: game.picture),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.28),
                        Colors.black.withValues(alpha: 0.48),
                        Colors.black.withValues(alpha: 0.78),
                      ],
                      stops: const [0.0, 0.42, 1.0],
                    ),
                  ),
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 900;
                      final horizontal = isWide ? 72.0 : 24.0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontal,
                              isWide ? 28 : 16,
                              horizontal,
                              0,
                            ),
                            child: _OverviewTopBar(
                              onBack: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(
                                horizontal,
                                isWide ? 48 : 28,
                                horizontal,
                                28,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight -
                                      (isWide ? 120 : 90),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (isWide)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 11,
                                            child: _OverviewHeader(game: game),
                                          ),
                                          const SizedBox(width: 40),
                                          Expanded(
                                            flex: 10,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                              ),
                                              child: _OverviewStats(game: game),
                                            ),
                                          ),
                                        ],
                                      )
                                    else ...[
                                      _OverviewHeader(game: game),
                                      const SizedBox(height: 28),
                                      _OverviewStats(game: game),
                                    ],
                                    SizedBox(height: isWide ? 44 : 32),
                                    _GallerySection(
                                      images: _galleryImages(game),
                                      controller: _galleryController,
                                      onPrevious: _showPreviousImage,
                                      onNext: _showNextImage,
                                      onPageChanged: (index) {
                                        setState(() => _galleryIndex = index);
                                      },
                                    ),
                                    SizedBox(height: isWide ? 40 : 28),
                                    Divider(
                                      color: AppColors.textLight
                                          .withValues(alpha: 0.85),
                                      thickness: 1,
                                      height: 1,
                                    ),
                                    const SizedBox(height: 20),
                                    _OverviewActions(
                                      isFavorite: _isFavorite,
                                      onStart: () =>
                                          _startGame(context, game),
                                      onShare: () => _shareGame(game),
                                      onFavorite: () {
                                        setState(
                                          () => _isFavorite = !_isFavorite,
                                        );
                                        AppToast.success(
                                          context,
                                          _isFavorite
                                              ? 'به علاقه‌مندی‌ها اضافه شد'
                                              : 'از علاقه‌مندی‌ها حذف شد',
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<String> _galleryImages(GameDetail game) {
    final fallbacks = [
      game.picture,
      HomeAssets.game2,
      HomeAssets.game3,
      HomeAssets.game4,
      HomeAssets.game1,
    ];

    final images = <String>[
      ...game.galleryImages.where((image) => image.isNotEmpty),
    ];

    for (final fallback in fallbacks) {
      if (images.length >= 3) break;
      if (fallback.isNotEmpty && !images.contains(fallback)) {
        images.add(fallback);
      }
    }

    return images;
  }

  void _showPreviousImage(int total) {
    if (total == 0) return;
    final next = (_galleryIndex - 1 + total) % total;
    _galleryController.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _showNextImage(int total) {
    if (total == 0) return;
    final next = (_galleryIndex + 1) % total;
    _galleryController.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _startGame(BuildContext context, GameDetail game) {
    final route = switch (game.kind) {
      GameKind.poll => GameRoutes.playPoll,
      GameKind.personality => GameRoutes.playQuiz,
      GameKind.quiz => GameRoutes.playQuiz,
    };
    Navigator.of(context).pushNamed(route);
  }

  Future<void> _shareGame(GameDetail game) async {
    await SharePlus.instance.share(
      ShareParams(text: '${game.title}\nبازی را در فانته کوییز امتحان کن!'),
    );
  }
}

class _OverviewTopBar extends StatelessWidget {
  const _OverviewTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onBack,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.ltr,
            children: [
              const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: AppColors.primaryGold,
              ),
              const SizedBox(width: 6),
              Text(
                'برگشت',
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader({required this.game});

  final GameDetail game;

  @override
  Widget build(BuildContext context) {
    final title = game.title.trim().isNotEmpty ? game.title : 'گیم اف ترونز';
    final description = game.description.trim().isNotEmpty
        ? game.description
        : 'دنیای حماسی وستروس را در بازی Game of Thrones تجربه کن. '
            'انتخاب‌های مهم انجام بده، اتحاد بساز و سرنوشت هفت پادشاهی را در '
            'یک ماجراجویی نقش‌آفرینی داستان‌محور تعیین کن. با هر تصمیم، مسیر '
            'داستان تغییر می‌کند و آینده‌ی قهرمانان در دستان توست.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.getTextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGold,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          description,
          style: AppTextTheme.getTextStyle(
            fontSize: 14,
            color: AppColors.textLight,
            height: 1.9,
          ),
        ),
      ],
    );
  }
}

class _OverviewStats extends StatelessWidget {
  const _OverviewStats({required this.game});

  final GameDetail game;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatColumn(
            top: Text(
              'تاریخ انتشار',
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            middle: Text(
              formatPersianDate(game.createdAt),
              style: AppTextTheme.getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
        const _StatDivider(),
        Expanded(
          child: _StatColumn(
            top: Text(
              'سازنده بازی',
              style: AppTextTheme.getTextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            middle: Text(
              game.creatorName,
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
        const _StatDivider(),
        Expanded(
          child: _StatColumn(
            top: Text(
              game.rating.toStringAsFixed(1),
              style: AppTextTheme.getTextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            middle: _RatingStars(rating: game.rating),
            bottom: '${game.reviewCount} نظر',
          ),
        ),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.top,
    this.middle,
    this.bottom,
  });

  final Widget top;
  final Widget? middle;
  final String? bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        top,
        if (middle != null) ...[
          const SizedBox(height: 8),
          middle!,
        ],
        if (bottom != null) ...[
          const SizedBox(height: 8),
          Text(
            bottom!,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 72,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.textLight.withValues(alpha: 0.4),
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star_rounded;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: 18, color: AppColors.primaryGold);
      }),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.images,
    required this.controller,
    required this.onPrevious,
    required this.onNext,
    required this.onPageChanged,
  });

  final List<String> images;
  final PageController controller;
  final ValueChanged<int> onPrevious;
  final ValueChanged<int> onNext;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SizedBox(
        height: 188,
        child: Row(
          children: [
            _GalleryArrow(
              icon: Icons.chevron_left_rounded,
              onTap: () => onPrevious(images.length),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: images.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GamePictureHelper.image(
                        picture: images[index],
                        height: 188,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            _GalleryArrow(
              icon: Icons.chevron_right_rounded,
              onTap: () => onNext(images.length),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryArrow extends StatelessWidget {
  const _GalleryArrow({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.92),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 28, color: AppColors.textBlack),
        ),
      ),
    );
  }
}

class _OverviewActions extends StatelessWidget {
  const _OverviewActions({
    required this.isFavorite,
    required this.onStart,
    required this.onShare,
    required this.onFavorite,
  });

  final bool isFavorite;
  final VoidCallback onStart;
  final VoidCallback onShare;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;

        final secondaryActions = [
          _SecondaryActionButton(
            label: 'اشتراک گذاری',
            onPressed: onShare,
          ),
          _SecondaryActionButton(
            label: isFavorite
                ? 'حذف از علاقه‌مندی‌ها'
                : 'افزودن به مورد علاقه ها',
            onPressed: onFavorite,
          ),
        ];

        final startButton = SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: AppColors.textBlack,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'شروع بازی',
              style: AppTextTheme.getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
          ),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              startButton,
              const SizedBox(height: 12),
              ...secondaryActions.map(
                (button) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: button,
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            startButton,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  secondaryActions[0],
                  const SizedBox(width: 12),
                  secondaryActions[1],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textLight,
          backgroundColor: Colors.black.withValues(alpha: 0.72),
          side: BorderSide(
            color: AppColors.textLight.withValues(alpha: 0.18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: AppTextTheme.getTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }
}
