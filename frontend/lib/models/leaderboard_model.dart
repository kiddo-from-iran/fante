enum LeaderboardSortBy {
  totalPoints('total_points'),
  quizzesCreated('quizzes_created'),
  gamesParticipated('games_participated');

  const LeaderboardSortBy(this.apiValue);

  final String apiValue;

  static LeaderboardSortBy fromTabIndex(int index) {
    return LeaderboardSortBy.values[index.clamp(0, LeaderboardSortBy.values.length - 1)];
  }
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    this.fullName,
    this.profilePicture,
    required this.score,
  });

  final int rank;
  final int userId;
  final String? fullName;
  final String? profilePicture;
  final int score;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      fullName: json['full_name'] as String?,
      profilePicture: json['profile_picture'] as String?,
      score: json['score'] as int? ?? 0,
    );
  }
}

class LeaderboardResponse {
  const LeaderboardResponse({
    required this.sortBy,
    required this.entries,
  });

  final LeaderboardSortBy sortBy;
  final List<LeaderboardEntry> entries;

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    final sortValue = json['sort_by'] as String? ?? 'total_points';
    return LeaderboardResponse(
      sortBy: LeaderboardSortBy.values.firstWhere(
        (value) => value.apiValue == sortValue,
        orElse: () => LeaderboardSortBy.totalPoints,
      ),
      entries: (json['entries'] as List<dynamic>? ?? [])
          .map((item) => LeaderboardEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
