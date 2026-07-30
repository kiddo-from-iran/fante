import 'package:frontend/data/network/http_client.dart';
import 'package:frontend/data/source/leaderboard_data_source.dart';
import 'package:frontend/models/leaderboard_model.dart';

final leaderboardRepository = LeaderboardRepository(
  LeaderboardRemoteData(httpClient),
);

class LeaderboardRepository {
  LeaderboardRepository(this._leaderboardDataSource);

  final ILeaderboardDataSource _leaderboardDataSource;

  Future<LeaderboardResponse> getLeaderboard({
    required LeaderboardSortBy sortBy,
    int limit = 5,
  }) =>
      _leaderboardDataSource.getLeaderboard(sortBy: sortBy, limit: limit);
}
