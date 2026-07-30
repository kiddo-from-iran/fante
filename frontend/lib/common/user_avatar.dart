import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/profile/profile_assets.dart';

class UserAvatarHelper {
  UserAvatarHelper._();

  static ImageProvider avatarImage(UserModel? user) {
    final url = user?.profilePicture;
    if (url != null && url.isNotEmpty && _isNetworkUrl(url)) {
      return NetworkImage(url);
    }
    return const AssetImage(ProfileAssets.avatar);
  }

  static bool _isNetworkUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  static String displayName(UserModel? user) {
    final name = user?.fullName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'کاربر Fante Quiz';
  }
}
