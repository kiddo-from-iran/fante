import 'package:dio/dio.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/models/leaderboard_model.dart';

abstract class ILeaderboardDataSource {
  Future<LeaderboardResponse> getLeaderboard({
    required LeaderboardSortBy sortBy,
    int limit = 5,
  });
}

class LeaderboardRemoteData
    with HttpResponseValidator
    implements ILeaderboardDataSource {
  LeaderboardRemoteData(this.httpClient);

  final Dio httpClient;

  @override
  Future<LeaderboardResponse> getLeaderboard({
    required LeaderboardSortBy sortBy,
    int limit = 5,
  }) async {
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(
        Urls.leaderboardUrl,
        queryParameters: {
          'sort_by': sortBy.apiValue,
          'limit': limit,
        },
        options: Options(extra: {'requiresAuth': false}),
      ),
    );
    return LeaderboardResponse.fromJson(response);
  }
}
