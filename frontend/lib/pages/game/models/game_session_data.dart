import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/pages/game/models/game_kind.dart';

class GameOptionData {
  const GameOptionData({
    required this.label,
    required this.percent,
    this.isSelected = false,
  });

  final String label;
  final double percent;
  final bool isSelected;
}

class GameSidebarData {
  const GameSidebarData({
    required this.thumbnail,
    required this.description,
    required this.timeAgo,
    required this.participants,
    required this.secondaryTitle,
  });

  final String thumbnail;
  final String description;
  final String timeAgo;
  final int participants;
  final String secondaryTitle;
}

class GameSessionData {
  const GameSessionData({
    required this.kind,
    required this.title,
    required this.designerName,
    required this.background,
    required this.sidebar,
    this.designerAvatar = GameAssets.designerAvatar,
  });

  final GameKind kind;
  final String title;
  final String designerName;
  final String designerAvatar;
  final String background;
  final GameSidebarData sidebar;
}

class QuizPlayData extends GameSessionData {
  const QuizPlayData({
    required super.title,
    required super.designerName,
    required super.background,
    required super.sidebar,
    required this.questionNumber,
    required this.question,
    required this.options,
    this.selectedIndex = 1,
    this.correctIndex,
  }) : super(kind: GameKind.quiz);

  final int questionNumber;
  final String question;
  final List<String> options;
  final int selectedIndex;

  /// Designated correct option for quizzes; null means no right/wrong.
  final int? correctIndex;
}

class PollPlayData extends GameSessionData {
  const PollPlayData({
    required super.title,
    required super.designerName,
    required super.background,
    required super.sidebar,
    required this.question,
    required this.options,
    this.selectedIndex = 0,
    this.showPercentages = true,
  }) : super(kind: GameKind.poll);

  final String question;
  final List<GameOptionData> options;
  final int selectedIndex;
  final bool showPercentages;
}

class PollResultData extends GameSessionData {
  const PollResultData({
    required super.title,
    required super.designerName,
    required super.background,
    required super.sidebar,
    required this.successMessage,
    required this.options,
    required this.totalVotes,
    required this.footerMessage,
    this.selectedIndex = 0,
  }) : super(kind: GameKind.poll);

  final String successMessage;
  final List<GameOptionData> options;
  final int totalVotes;
  final String footerMessage;
  final int selectedIndex;
}

class QuizScoreResultData extends GameSessionData {
  const QuizScoreResultData({
    required super.title,
    required super.designerName,
    required super.background,
    required super.sidebar,
    required this.score,
    required this.totalQuestions,
    required this.xpEarned,
    required this.rank,
    required this.totalPlayers,
    required this.summary,
  }) : super(kind: GameKind.quiz);

  final int score;
  final int totalQuestions;
  final int xpEarned;
  final int rank;
  final int totalPlayers;
  final String summary;
}

class WorldDiscoveryResultData extends GameSessionData {
  const WorldDiscoveryResultData({
    required super.title,
    required super.designerName,
    required super.background,
    required super.sidebar,
    required this.bannerTitle,
    required this.subtitle,
    required this.selectedImages,
    required this.explorerName,
    required this.explorationScore,
    required this.highlightMessage,
  }) : super(kind: GameKind.personality);

  final String bannerTitle;
  final String subtitle;
  final List<String> selectedImages;
  final String explorerName;
  final String explorationScore;
  final String highlightMessage;
}

/// Demo fixtures matching the provided designs.
class GameDemoData {
  GameDemoData._();

  static GameSidebarData get _pollSidebar => const GameSidebarData(
        thumbnail: GameAssets.sidebarForest,
        description:
            'در این نظرسنجی، محبوب‌ترین قدرت‌های درونی کاربران فانتزی '
            'بررسی شده است.',
        timeAgo: '3 سال پیش',
        participants: 3500,
        secondaryTitle: 'محبوب‌ترین قدرت‌های درونی',
      );

  static GameSidebarData get _quizSidebar => const GameSidebarData(
        thumbnail: GameAssets.sidebarAnime,
        description:
            'در این کوییز، دانش شما درباره دنیای انیمه و قدرت‌های '
            'درونی سنجیده می‌شود.',
        timeAgo: '3 سال پیش',
        participants: 3500,
        secondaryTitle: 'مسابقه اطلاعات دنیای انیمه',
      );

  static QuizPlayData get quizPlay => QuizPlayData(
        title: 'مسابقه بزرگ اطلاعات دنیای انیمه',
        designerName: 'Hpkage No',
        background: GameAssets.backgroundForest,
        sidebar: _quizSidebar,
        questionNumber: 1,
        question: 'چه کسی جیرایا رو کشت؟',
        options: const [
          'ناروتو',
          'پین',
          'سوناده',
          'ساسوکه',
          'مادارا',
        ],
        selectedIndex: 1,
      );

  static PollPlayData get pollPlay => PollPlayData(
        title: 'محبوب‌ترین قدرت‌های درونی',
        designerName: 'Hpkage No',
        background: GameAssets.backgroundForest,
        sidebar: _pollSidebar,
        question: 'کدام قدرت را ترجیح می‌دهی؟',
        options: const [
          GameOptionData(label: 'قدرت کنترل عناصر (آب، خاک، آتش، باد)', percent: 42, isSelected: true),
          GameOptionData(label: 'غیب شدن', percent: 12),
          GameOptionData(label: 'پیشگویی و دیدن آینده', percent: 18),
          GameOptionData(label: 'قدرت درمان و بازسازی', percent: 28),
        ],
        selectedIndex: 0,
      );

  static PollResultData get pollResult => PollResultData(
        title: 'محبوب‌ترین قدرت‌های درونی',
        designerName: 'Hpkage No',
        background: GameAssets.backgroundForest,
        sidebar: _pollSidebar,
        successMessage: 'نظر شما با موفقیت ثبت شد.',
        options: const [
          GameOptionData(label: 'قدرت کنترل عناصر (آب، خاک، آتش، باد)', percent: 42, isSelected: true),
          GameOptionData(label: 'غیب شدن', percent: 12),
          GameOptionData(label: 'پیشگویی و دیدن آینده', percent: 18),
          GameOptionData(label: 'قدرت درمان و بازسازی', percent: 28),
        ],
        totalVotes: 3500,
        footerMessage: 'شما جزو محبوب‌ترین قدرت‌ها هستین',
        selectedIndex: 0,
      );

  static QuizScoreResultData get quizScoreResult => QuizScoreResultData(
        title: 'نتیجه کوییز شما در دنیای انیمه',
        designerName: 'hpkage Na',
        background: GameAssets.backgroundCoastal,
        sidebar: _pollSidebar,
        score: 8,
        totalQuestions: 10,
        xpEarned: 150,
        rank: 24,
        totalPlayers: 120,
        summary: 'اطلاعات شما در سطح عالی قرار دارد',
      );

  static WorldDiscoveryResultData get worldDiscoveryResult =>
      WorldDiscoveryResultData(
        title: 'دنیای شما: کاوشگر جنگل زمردین',
        designerName: 'Hpkage No',
        background: GameAssets.backgroundForest,
        sidebar: GameSidebarData(
          thumbnail: GameAssets.sidebarLantern,
          description:
              'در این تست شخصیت، دنیای فانتزی منحصربه‌فرد شما براساس '
              'انتخاب‌هایتان ساخته می‌شود.',
          timeAgo: '3 سال پیش',
          participants: 3500,
          secondaryTitle: 'خودتو در دنیای جدید کشف کن',
        ),
        bannerTitle: 'دنیای جنگل زمردین: مهد نیروهای درونی',
        subtitle: 'دنیای شما براساس انتخاب‌هایتان:',
        selectedImages: const [
          GameAssets.worldImage1,
          GameAssets.worldImage2,
          GameAssets.worldImage3,
        ],
        explorerName: 'لونا',
        explorationScore: '100%',
        highlightMessage: 'دنیای نادری کشف شد!!',
      );
}
