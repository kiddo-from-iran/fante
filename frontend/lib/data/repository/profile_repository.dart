import 'package:frontend/data/network/http_client.dart';
import 'package:frontend/data/source/profile_data_source.dart';
import 'package:frontend/models/player_profile_model.dart';

final profileRepository = ProfileRepository(ProfileRemoteData(httpClient));

class ProfileRepository {
  ProfileRepository(this._profileDataSource);

  final IProfileDataSource _profileDataSource;

  Future<PlayerProfile> getMyProfile() => _profileDataSource.getMyProfile();
}
