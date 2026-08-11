import 'package:shared_preferences/shared_preferences.dart';

/// Extra profile fields + custom avatar not always on the user API.
class PlayerSettingsStore {
  PlayerSettingsStore._();

  static final PlayerSettingsStore instance = PlayerSettingsStore._();

  static const _prefix = 'player_settings_';

  Future<Map<String, String>> load(int? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(userId);
    return {
      'username': prefs.getString('${key}_username') ?? '',
      'bio': prefs.getString('${key}_bio') ?? '',
      'country': prefs.getString('${key}_country') ?? 'ایران',
      'city': prefs.getString('${key}_city') ?? '',
      'birthday': prefs.getString('${key}_birthday') ?? '',
      'customAvatar': prefs.getString('${key}_custom_avatar') ?? '',
      'avatarAsset': prefs.getString('${key}_avatar_asset') ?? '',
    };
  }

  Future<void> save({
    required int? userId,
    required String username,
    required String bio,
    required String country,
    required String city,
    required String birthday,
    String? customAvatar,
    String? avatarAsset,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(userId);
    await prefs.setString('${key}_username', username);
    await prefs.setString('${key}_bio', bio);
    await prefs.setString('${key}_country', country);
    await prefs.setString('${key}_city', city);
    await prefs.setString('${key}_birthday', birthday);
    if (customAvatar != null) {
      if (customAvatar.isEmpty) {
        await prefs.remove('${key}_custom_avatar');
      } else {
        await prefs.setString('${key}_custom_avatar', customAvatar);
      }
    }
    if (avatarAsset != null) {
      if (avatarAsset.isEmpty) {
        await prefs.remove('${key}_avatar_asset');
      } else {
        await prefs.setString('${key}_avatar_asset', avatarAsset);
      }
    }
  }

  Future<String?> customAvatar(int? userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_key(userId)}_custom_avatar');
  }

  Future<String?> avatarAsset(int? userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_key(userId)}_avatar_asset');
  }

  Future<void> clearAvatar(int? userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _key(userId);
    await prefs.remove('${key}_custom_avatar');
    await prefs.remove('${key}_avatar_asset');
  }

  String _key(int? userId) => '$_prefix${userId ?? 0}';
}
