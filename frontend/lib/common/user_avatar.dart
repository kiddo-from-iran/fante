import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/profile/profile_assets.dart';

class UserAvatarHelper {
  UserAvatarHelper._();

  static final Map<String, ImageProvider> _cache = {};

  static ImageProvider avatarImage(UserModel? user, {String? overridePath}) {
    final value = (overridePath != null && overridePath.isNotEmpty)
        ? overridePath
        : user?.profilePicture;
    return providerFor(value);
  }

  static ImageProvider providerFor(String? value) {
    if (value == null || value.isEmpty) {
      return const AssetImage(ProfileAssets.avatar);
    }

    final cached = _cache[value];
    if (cached != null) return cached;

    late final ImageProvider provider;
    if (_isNetworkUrl(value)) {
      provider = NetworkImage(value);
    } else if (value.startsWith('data:')) {
      final bytes = _decodeDataUrl(value);
      provider = bytes == null
          ? const AssetImage(ProfileAssets.avatar)
          : MemoryImage(bytes);
    } else if (value.startsWith('assets/')) {
      provider = AssetImage(value);
    } else {
      return const AssetImage(ProfileAssets.avatar);
    }

    _cache[value] = provider;
    return provider;
  }

  static bool _isNetworkUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  static Uint8List? _decodeDataUrl(String data) {
    final comma = data.indexOf(',');
    if (comma < 0) return null;
    try {
      return base64Decode(data.substring(comma + 1));
    } catch (_) {
      return null;
    }
  }

  static String displayName(UserModel? user) {
    final name = user?.fullName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return 'کاربر Fante Quiz';
  }
}
