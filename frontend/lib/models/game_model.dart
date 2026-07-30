import 'package:frontend/pages/game/models/game_kind.dart';

class GameListItem {
  const GameListItem({
    required this.id,
    required this.title,
    required this.description,
    required this.picture,
    required this.gameType,
    required this.createdAt,
    required this.questionsCount,
    this.creatorName = 'کاربر فانته',
    this.rating = 4.8,
    this.reviewCount = 124,
  });

  final int id;
  final String title;
  final String description;
  final String picture;
  final String gameType;
  final DateTime createdAt;
  final int questionsCount;
  final String creatorName;
  final double rating;
  final int reviewCount;

  GameKind get kind => gameKindFromApi(gameType);

  factory GameListItem.fromJson(Map<String, dynamic> json) {
    return GameListItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      gameType: json['game_type'] as String? ?? 'quiz',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      questionsCount: json['questions_count'] as int? ?? 0,
    );
  }

  static List<GameListItem> get demoGames => [
        GameListItem(
          id: 1,
          title: 'گیم اف ترونز',
          description:
              'دنیای حماسی وستروس را در بازی Game of Thrones تجربه کن. '
              'انتخاب‌های مهم انجام بده، اتحاد بساز و سرنوشت هفت پادشاهی را در '
              'یک ماجراجویی نقش‌آفرینی داستان‌محور تعیین کن. با هر تصمیم، مسیر '
              'داستان تغییر می‌کند و آینده‌ی قهرمانان در دستان توست.',
          picture: 'assets/images/game_1.png',
          gameType: 'quiz',
          createdAt: DateTime(1405, 1, 30),
          questionsCount: 12,
          creatorName: 'آرین کاوشگر',
        ),
        GameListItem(
          id: 2,
          title: 'چالش دانش فانتزی',
          description:
              'دانش خود را درباره دنیای فانتزی محک بزنید و با دیگر بازیکنان رقابت کنید.',
          picture: 'assets/images/game_2.png',
          gameType: 'quiz',
          createdAt: DateTime(2026, 3, 19),
          questionsCount: 10,
          creatorName: 'سارا مهر',
        ),
        GameListItem(
          id: 3,
          title: 'محبوب‌ترین شخصیت‌ها',
          description:
              'نظر خود را درباره محبوب‌ترین شخصیت‌های دنیای فانتزی ثبت کنید.',
          picture: 'assets/images/game_3.png',
          gameType: 'vote',
          createdAt: DateTime(2026, 3, 17),
          questionsCount: 8,
          creatorName: 'امیر نور',
        ),
        GameListItem(
          id: 4,
          title: 'کدام جهان فانتزی مال توئه؟',
          description:
              'با پاسخ به سوالات، جهان فانتزی منحصربه‌فرد خود را کشف کنید.',
          picture: 'assets/images/game_4.png',
          gameType: 'test',
          createdAt: DateTime(2026, 3, 15),
          questionsCount: 15,
          creatorName: 'نیلوفر رها',
        ),
      ];
}

class GameDetail extends GameListItem {
  const GameDetail({
    required super.id,
    required super.title,
    required super.description,
    required super.picture,
    required super.gameType,
    required super.createdAt,
    required super.questionsCount,
    super.creatorName,
    super.rating,
    super.reviewCount,
    this.galleryImages = const [],
  });

  final List<String> galleryImages;

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    final base = GameListItem.fromJson(json);
    final questions = json['questions'] as List<dynamic>? ?? [];
    final gallery = <String>[
      if (base.picture.isNotEmpty) base.picture,
      for (final question in questions)
        if (question is Map<String, dynamic> &&
            (question['picture'] as String?)?.isNotEmpty == true)
          question['picture'] as String,
    ];

    return GameDetail(
      id: base.id,
      title: base.title,
      description: base.description,
      picture: base.picture,
      gameType: base.gameType,
      createdAt: base.createdAt,
      questionsCount: base.questionsCount,
      galleryImages: gallery.isEmpty ? [base.picture] : gallery.toSet().toList(),
    );
  }

  factory GameDetail.fromListItem(
    GameListItem item, {
    List<String>? galleryImages,
  }) {
    return GameDetail(
      id: item.id,
      title: item.title,
      description: item.description,
      picture: item.picture,
      gameType: item.gameType,
      createdAt: item.createdAt,
      questionsCount: item.questionsCount,
      creatorName: item.creatorName,
      rating: item.rating,
      reviewCount: item.reviewCount,
      galleryImages: galleryImages ?? [item.picture],
    );
  }
}

GameKind gameKindFromApi(String type) {
  switch (type) {
    case 'vote':
      return GameKind.poll;
    case 'test':
      return GameKind.personality;
    case 'quiz':
    default:
      return GameKind.quiz;
  }
}

String gameTypeLabel(String type) {
  switch (type) {
    case 'vote':
      return 'نظرسنجی';
    case 'test':
      return 'تست شخصیت';
    case 'quiz':
    default:
      return 'کوییز رقابتی';
  }
}

String formatPersianDate(DateTime date) {
  final year = date.year.toString();
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year/$month/$day';
}
