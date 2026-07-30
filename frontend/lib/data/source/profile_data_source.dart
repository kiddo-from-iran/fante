import 'package:dio/dio.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/models/player_profile_model.dart';

abstract class IProfileDataSource {
  Future<PlayerProfile> getMyProfile();
}

class ProfileRemoteData with HttpResponseValidator implements IProfileDataSource {
  ProfileRemoteData(this.httpClient);

  final Dio httpClient;

  @override
  Future<PlayerProfile> getMyProfile() async {
    final response = await validateResponse<Map<String, dynamic>>(
      httpClient.get(Urls.profileMeUrl),
    );
    return PlayerProfile.fromJson(response);
  }
}
