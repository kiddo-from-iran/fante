import 'package:frontend/models/game_model.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/game/utils/player_game_mapper.dart';
import 'package:frontend/pages/home/home_assets.dart';

/// Local catalog dataset for browse / filter mode on the category page.
class CatalogCatalog {
  CatalogCatalog._();

  static const _pictures = [
    HomeAssets.game1,
    HomeAssets.game2,
    HomeAssets.game3,
    HomeAssets.game4,
    HomeAssets.gameStyle1,
    HomeAssets.gameStyle2,
    HomeAssets.gameStyle3,
  ];

  static const _quizTitles = [
    'گیم اف ترونز',
    'چالش دانش فانتزی',
    'ارباب حلقه‌ها',
    'وان پیس',
    'هری پاتر',
    'ناروتو',
    'آواتار',
    'ویچر',
    'دراگون ایج',
    'مسابقه دنیای انیمه',
    'قدرت‌های جادویی',
    'دژهای تاریک',
  ];

  static const _testTitles = [
    'کدام جهان فانتزی مال توئه؟',
    'تست شخصیت ماجراجو',
    'MBTI جادوگران',
    'تست هوش فانتزی',
    'کدام قهرمان هستی؟',
    'تست روانشناسی سایه',
    'کدام عنصر مال توست؟',
    'شخصیت سریال محبوب',
    'تست فیلم و سینما',
    'کدام اژدها هستی؟',
    'تست اتحادها',
    'کدام سرنوشت؟',
  ];

  static const _voteTitles = [
    'محبوب‌ترین شخصیت‌ها',
    'بهترین قدرت درونی',
    'کدام فصل محبوب‌تر است؟',
    'بهترین پایان داستان',
    'محبوب‌ترین سلاح',
    'کدام قلعه؟',
    'بهترین هم‌تیمی',
    'محبوب‌ترین هیولا',
    'کدام نقشه؟',
    'بهترین زره',
    'محبوب‌ترین اسب',
    'کدام جادو؟',
  ];

  static List<GameListItem> get allDemo {
    final list = <GameListItem>[];
    var id = 100;

    void addBatch(List<String> titles, String type) {
      for (var i = 0; i < titles.length; i++) {
        list.add(
          GameListItem(
            id: id++,
            title: titles[i],
            description: 'بازی فانتزی آماده‌ی کشف در فانته‌کوییز.',
            picture: _pictures[i % _pictures.length],
            gameType: type,
            createdAt: DateTime(2026, 1, 1).add(Duration(days: i * 3)),
            questionsCount: 8 + (i % 8),
            creatorName: i.isEven ? 'آرین کاوشگر' : 'سارا مهر',
            rating: 4.2 + (i % 7) * 0.1,
            reviewCount: 40 + i * 11,
          ),
        );
      }
    }

    addBatch(_quizTitles, 'quiz');
    addBatch(_testTitles, 'test');
    addBatch(_voteTitles, 'vote');
    return list;
  }

  static List<GameListItem> catalogSource() {
    final published = PlayerGamesStore.instance
        .published()
        .map(PlayerGameMapper.toListItem)
        .toList();
    return [...published, ...allDemo];
  }

  static List<GameListItem> filter({
    String? query,
    String? gameType,
    String? sort,
  }) {
    var games = catalogSource();

    final q = query?.trim() ?? '';
    if (q.isNotEmpty) {
      final lower = q.toLowerCase();
      games = games
          .where(
            (g) =>
                g.title.toLowerCase().contains(lower) ||
                g.description.toLowerCase().contains(lower) ||
                g.creatorName.toLowerCase().contains(lower),
          )
          .toList();
    }

    if (gameType != null && gameType.isNotEmpty) {
      games = games.where((g) => g.gameType == gameType).toList();
    }

    switch (sort) {
      case 'جدیدترین‌ها':
        games = [...games]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'بیشترین امتیاز':
        games = [...games]..sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'محبوب‌ترین‌ها':
      default:
        games = [...games]
          ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
    }

    return games;
  }
}
