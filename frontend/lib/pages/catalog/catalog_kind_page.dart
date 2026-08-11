import 'package:flutter/material.dart';
import 'package:frontend/models/game_model.dart';
import 'package:frontend/pages/catalog/widgets/creator_card.dart';
import 'package:frontend/pages/catalog/widgets/quiz_carousel_section.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/pages/game/game_routes.dart';
import 'package:frontend/pages/game/models/game_kind.dart';
import 'package:frontend/pages/game/overview/game_overview_args.dart';
import 'package:frontend/pages/game/utils/player_game_mapper.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/pages/home/widgets/home_nav_bar.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/footer/app_footer.dart';

const double _maxContentWidth = 1120;

/// Shared browse layout used by quizzes / polls / personality tests pages.
class CatalogKindPage extends StatefulWidget {
  const CatalogKindPage({
    super.key,
    required this.kind,
    required this.pageTitle,
    required this.pageSubtitle,
    required this.yoursSectionTitle,
    required this.popularSectionTitle,
    required this.suggestedSectionTitle,
    required this.creatorsSectionTitle,
    required this.creatorCountLabel,
    required this.demoPopular,
    required this.demoSuggested,
    required this.creators,
    required this.demoGameType,
    required this.fallbackDescription,
  });

  final GameKind kind;
  final String pageTitle;
  final String pageSubtitle;
  final String yoursSectionTitle;
  final String popularSectionTitle;
  final String suggestedSectionTitle;
  final String creatorsSectionTitle;
  final String creatorCountLabel;
  final List<QuizCarouselItem> demoPopular;
  final List<QuizCarouselItem> demoSuggested;
  final List<CatalogCreatorItem> creators;
  final String demoGameType;
  final String fallbackDescription;

  @override
  State<CatalogKindPage> createState() => _CatalogKindPageState();
}

class _CatalogKindPageState extends State<CatalogKindPage> {
  List<QuizCarouselItem> get _published {
    return PlayerGamesStore.instance
        .published(kind: widget.kind)
        .map(
          (game) => QuizCarouselItem(
            id: PlayerGameMapper.numericId(game),
            title: game.title,
            image: PlayerGameMapper.coverOf(game),
            playerGameId: game.id,
          ),
        )
        .toList();
  }

  void _openItem(BuildContext context, QuizCarouselItem item) {
    if (item.playerGameId != null) {
      final player = PlayerGamesStore.instance.byId(item.playerGameId!);
      if (player != null) {
        Navigator.of(context).pushNamed(
          GameRoutes.overview,
          arguments: GameOverviewArgs.fromListItem(
            PlayerGameMapper.toListItem(player),
            playerGameId: player.id,
          ),
        );
        return;
      }
    }

    final demo = GameListItem.demoGames.firstWhere(
      (game) => game.id == item.id && game.gameType == widget.demoGameType,
      orElse: () => GameListItem(
        id: item.id,
        title: item.title,
        description: widget.fallbackDescription,
        picture: item.image,
        gameType: widget.demoGameType,
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
    final published = _published;
    final popular = [
      ...published,
      ...widget.demoPopular,
    ];

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
              gaplessPlayback: true,
            ),
            const ColoredBox(color: Color(0x66000000)),
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
                              widget.pageTitle,
                              style: AppTextTheme.getTextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.pageSubtitle,
                              textAlign: TextAlign.center,
                              style: AppTextTheme.getTextStyle(
                                fontSize: 16,
                                color: AppColors.textLight,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 48),
                            if (published.isNotEmpty) ...[
                              QuizCarouselSection(
                                title: widget.yoursSectionTitle,
                                items: published,
                                onItemPressed: (item) =>
                                    _openItem(context, item),
                              ),
                              const SizedBox(height: 56),
                            ],
                            QuizCarouselSection(
                              title: widget.popularSectionTitle,
                              items: popular,
                              onItemPressed: (item) =>
                                  _openItem(context, item),
                              onSeeAll: () {},
                            ),
                            const SizedBox(height: 56),
                            QuizCarouselSection(
                              title: widget.suggestedSectionTitle,
                              items: widget.demoSuggested,
                              onItemPressed: (item) =>
                                  _openItem(context, item),
                              onSeeAll: () {},
                            ),
                            const SizedBox(height: 56),
                            CreatorsCarouselSection(
                              title: widget.creatorsSectionTitle,
                              onSeeAll: () {},
                              children: widget.creators
                                  .map(
                                    (creator) => CreatorCard(
                                      name: creator.name,
                                      avatar: creator.avatar,
                                      quizzesCount: creator.count,
                                      countLabel: widget.creatorCountLabel,
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

class CatalogCreatorItem {
  const CatalogCreatorItem({
    required this.name,
    required this.avatar,
    required this.count,
    required this.rating,
  });

  final String name;
  final String avatar;
  final int count;
  final double rating;
}

/// Quizzes listing — same layout as polls / tests.
class QuizzesPage extends StatelessWidget {
  const QuizzesPage({super.key});

  static final _demoPopular = [
    QuizCarouselItem(id: 1, title: 'ارباب حلقه ها', image: HomeAssets.game1),
    QuizCarouselItem(id: 2, title: 'وان پیس', image: HomeAssets.game2),
    QuizCarouselItem(id: 5, title: 'هری پاتر', image: HomeAssets.game3),
    QuizCarouselItem(id: 6, title: 'بازی تاج و تخت', image: HomeAssets.game4),
  ];

  static final _demoSuggested = [
    QuizCarouselItem(id: 7, title: 'ناروتو', image: HomeAssets.gameStyle1),
    QuizCarouselItem(id: 8, title: 'آواتار', image: HomeAssets.gameStyle2),
    QuizCarouselItem(id: 3, title: 'ویچر', image: HomeAssets.gameStyle3),
    QuizCarouselItem(id: 4, title: 'دراگون ایج', image: HomeAssets.game1),
  ];

  static const _creators = [
    CatalogCreatorItem(
      name: 'شاهزاده تاریکی',
      avatar: HomeAssets.profile1,
      count: 220,
      rating: 4.6,
    ),
    CatalogCreatorItem(
      name: 'جادوگر سفید',
      avatar: HomeAssets.profile2,
      count: 185,
      rating: 4.8,
    ),
    CatalogCreatorItem(
      name: 'نگهبان جنگل',
      avatar: HomeAssets.profile3,
      count: 142,
      rating: 4.5,
    ),
    CatalogCreatorItem(
      name: 'شوالیه نقره‌ای',
      avatar: HomeAssets.profile4,
      count: 98,
      rating: 4.3,
    ),
    CatalogCreatorItem(
      name: 'ملکه سایه',
      avatar: HomeAssets.profile5,
      count: 76,
      rating: 4.7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CatalogKindPage(
      kind: GameKind.quiz,
      pageTitle: 'کوییزها',
      pageSubtitle: 'از بین کوییزهای زیر یکی را انتخاب کنید',
      yoursSectionTitle: 'کوییزهای شما',
      popularSectionTitle: 'جدیدترین های پرطرفدار',
      suggestedSectionTitle: 'گزینه‌های پیشنهادی برای شما',
      creatorsSectionTitle: 'بهترین سازندگان',
      creatorCountLabel: 'کوییز ساخته',
      demoPopular: _demoPopular,
      demoSuggested: _demoSuggested,
      creators: _creators,
      demoGameType: 'quiz',
      fallbackDescription: 'کوییز فانتزی آماده بازی.',
    );
  }
}

/// Polls listing.
class PollsPage extends StatelessWidget {
  const PollsPage({super.key});

  static final _demoPopular = [
    QuizCarouselItem(
      id: 201,
      title: 'محبوب‌ترین شخصیت‌ها',
      image: HomeAssets.gameStyle1,
    ),
    QuizCarouselItem(
      id: 202,
      title: 'بهترین قدرت درونی',
      image: HomeAssets.gameStyle2,
    ),
    QuizCarouselItem(
      id: 203,
      title: 'کدام فصل محبوب‌تر است؟',
      image: HomeAssets.gameStyle3,
    ),
    QuizCarouselItem(
      id: 204,
      title: 'بهترین پایان داستان',
      image: HomeAssets.game2,
    ),
  ];

  static final _demoSuggested = [
    QuizCarouselItem(
      id: 205,
      title: 'محبوب‌ترین سلاح',
      image: HomeAssets.game3,
    ),
    QuizCarouselItem(
      id: 206,
      title: 'کدام قلعه؟',
      image: HomeAssets.game4,
    ),
    QuizCarouselItem(
      id: 207,
      title: 'بهترین هم‌تیمی',
      image: HomeAssets.game1,
    ),
    QuizCarouselItem(
      id: 208,
      title: 'محبوب‌ترین هیولا',
      image: HomeAssets.gameStyle1,
    ),
  ];

  static const _creators = [
    CatalogCreatorItem(
      name: 'رأی‌گیر فانتزی',
      avatar: HomeAssets.profile2,
      count: 156,
      rating: 4.7,
    ),
    CatalogCreatorItem(
      name: 'صداهای جمع',
      avatar: HomeAssets.profile4,
      count: 134,
      rating: 4.5,
    ),
    CatalogCreatorItem(
      name: 'پرسشگر شب',
      avatar: HomeAssets.profile1,
      count: 112,
      rating: 4.4,
    ),
    CatalogCreatorItem(
      name: 'انجمن جادو',
      avatar: HomeAssets.profile5,
      count: 89,
      rating: 4.6,
    ),
    CatalogCreatorItem(
      name: 'تالار اژدها',
      avatar: HomeAssets.profile3,
      count: 67,
      rating: 4.2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CatalogKindPage(
      kind: GameKind.poll,
      pageTitle: 'نظرسنجی‌ها',
      pageSubtitle: 'در نظرسنجی‌های فانتزی شرکت کنید و رأی بدهید',
      yoursSectionTitle: 'نظرسنجی‌های شما',
      popularSectionTitle: 'پرطرفدارترین نظرسنجی‌ها',
      suggestedSectionTitle: 'پیشنهاد برای رأی‌گیری شما',
      creatorsSectionTitle: 'بهترین برگزارکنندگان',
      creatorCountLabel: 'نظرسنجی ساخته',
      demoPopular: _demoPopular,
      demoSuggested: _demoSuggested,
      creators: _creators,
      demoGameType: 'vote',
      fallbackDescription: 'نظرسنجی فانتزی آماده رأی‌گیری.',
    );
  }
}

/// Personality / fantasy tests listing.
class TestsPage extends StatelessWidget {
  const TestsPage({super.key});

  static final _demoPopular = [
    QuizCarouselItem(
      id: 301,
      title: 'کدام جهان فانتزی مال توئه؟',
      image: HomeAssets.gameStyle2,
    ),
    QuizCarouselItem(
      id: 302,
      title: 'تست شخصیت ماجراجو',
      image: HomeAssets.game1,
    ),
    QuizCarouselItem(
      id: 303,
      title: 'MBTI جادوگران',
      image: HomeAssets.gameStyle3,
    ),
    QuizCarouselItem(
      id: 304,
      title: 'کدام قهرمان هستی؟',
      image: HomeAssets.game3,
    ),
  ];

  static final _demoSuggested = [
    QuizCarouselItem(
      id: 305,
      title: 'تست روانشناسی سایه',
      image: HomeAssets.game4,
    ),
    QuizCarouselItem(
      id: 306,
      title: 'کدام عنصر مال توست؟',
      image: HomeAssets.game2,
    ),
    QuizCarouselItem(
      id: 307,
      title: 'شخصیت سریال محبوب',
      image: HomeAssets.gameStyle1,
    ),
    QuizCarouselItem(
      id: 308,
      title: 'کدام اژدها هستی؟',
      image: HomeAssets.gameStyle2,
    ),
  ];

  static const _creators = [
    CatalogCreatorItem(
      name: 'روان‌شناس جادویی',
      avatar: HomeAssets.profile5,
      count: 198,
      rating: 4.9,
    ),
    CatalogCreatorItem(
      name: 'آینه‌ی شخصیت',
      avatar: HomeAssets.profile3,
      count: 167,
      rating: 4.7,
    ),
    CatalogCreatorItem(
      name: 'کاشف جهان‌ها',
      avatar: HomeAssets.profile1,
      count: 145,
      rating: 4.6,
    ),
    CatalogCreatorItem(
      name: 'ستاره‌خوان',
      avatar: HomeAssets.profile2,
      count: 121,
      rating: 4.4,
    ),
    CatalogCreatorItem(
      name: 'سایه‌نویس',
      avatar: HomeAssets.profile4,
      count: 88,
      rating: 4.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CatalogKindPage(
      kind: GameKind.personality,
      pageTitle: 'تست‌ها',
      pageSubtitle: 'تست شخصیت و دنیای فانتزی خودت را پیدا کن',
      yoursSectionTitle: 'تست‌های شما',
      popularSectionTitle: 'پرطرفدارترین تست‌ها',
      suggestedSectionTitle: 'پیشنهاد برای کشف شخصیت شما',
      creatorsSectionTitle: 'بهترین طراحان تست',
      creatorCountLabel: 'تست ساخته',
      demoPopular: _demoPopular,
      demoSuggested: _demoSuggested,
      creators: _creators,
      demoGameType: 'test',
      fallbackDescription: 'تست شخصیت فانتزی آماده کشف.',
    );
  }
}
