import 'package:frontend/models/user_model.dart';

class PlayerLevelProgress {
  const PlayerLevelProgress({
    required this.level,
    this.levelTitle,
    required this.xpInLevel,
    required this.xpForNextLevel,
    required this.xpProgress,
    required this.xpLabel,
  });

  final int level;
  final String? levelTitle;
  final int xpInLevel;
  final int xpForNextLevel;
  final double xpProgress;
  final String xpLabel;

  factory PlayerLevelProgress.fromJson(Map<String, dynamic> json) {
    return PlayerLevelProgress(
      level: json['level'] as int? ?? 1,
      levelTitle: json['level_title'] as String?,
      xpInLevel: json['xp_in_level'] as int? ?? 0,
      xpForNextLevel: json['xp_for_next_level'] as int? ?? 1000,
      xpProgress: (json['xp_progress'] as num?)?.toDouble() ?? 0,
      xpLabel: json['xp_label'] as String? ?? '0/1000',
    );
  }
}

class PlayerStats {
  const PlayerStats({
    required this.totalPoints,
    required this.quizzesCompleted,
    required this.pollsCompleted,
    required this.votesCompleted,
    required this.quizzesCreated,
    required this.level,
  });

  final int totalPoints;
  final int quizzesCompleted;
  final int pollsCompleted;
  final int votesCompleted;
  final int quizzesCreated;
  final PlayerLevelProgress level;

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      totalPoints: json['total_points'] as int? ?? 0,
      quizzesCompleted: json['quizzes_completed'] as int? ?? 0,
      pollsCompleted: json['polls_completed'] as int? ?? 0,
      votesCompleted: json['votes_completed'] as int? ?? 0,
      quizzesCreated: json['quizzes_created'] as int? ?? 0,
      level: PlayerLevelProgress.fromJson(
        json['level'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class PlayerRanking {
  const PlayerRanking({
    required this.rank,
    required this.totalPlayers,
  });

  final int rank;
  final int totalPlayers;

  factory PlayerRanking.fromJson(Map<String, dynamic> json) {
    return PlayerRanking(
      rank: json['rank'] as int? ?? 1,
      totalPlayers: json['total_players'] as int? ?? 1,
    );
  }

  String get label => '$rank از $totalPlayers';
}

class PlayerActivity {
  const PlayerActivity({
    required this.id,
    required this.title,
    required this.activityType,
    required this.pointsEarned,
    this.stars,
    required this.completedAt,
    this.gameId,
  });

  final int id;
  final String title;
  final String activityType;
  final int pointsEarned;
  final int? stars;
  final DateTime completedAt;
  final int? gameId;

  factory PlayerActivity.fromJson(Map<String, dynamic> json) {
    return PlayerActivity(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      activityType: json['activity_type'] as String? ?? 'quiz',
      pointsEarned: json['points_earned'] as int? ?? 0,
      stars: json['stars'] as int?,
      completedAt: DateTime.parse(json['completed_at'] as String),
      gameId: json['game_id'] as int?,
    );
  }

  String get typeLabel {
    switch (activityType) {
      case 'poll':
        return 'نظرسنجی';
      case 'vote':
        return 'رأی';
      default:
        return 'کوییز';
    }
  }

  String get displayTitle => '$typeLabel: $title';
}

class PlayerProfile {
  const PlayerProfile({
    required this.user,
    required this.stats,
    required this.ranking,
    required this.recentActivities,
  });

  final UserModel user;
  final PlayerStats stats;
  final PlayerRanking ranking;
  final List<PlayerActivity> recentActivities;

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    final activities = json['recent_activities'] as List<dynamic>? ?? [];
    return PlayerProfile(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      stats: PlayerStats.fromJson(json['stats'] as Map<String, dynamic>),
      ranking: PlayerRanking.fromJson(json['ranking'] as Map<String, dynamic>),
      recentActivities: activities
          .map((e) => PlayerActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
