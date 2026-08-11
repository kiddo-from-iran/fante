import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_assets.dart';

/// Decodes and caches [ImageProvider]s so rebuilds (typing, selection) do not
/// flash/black-out data-URL or network images.
class GamePictureHelper {
  GamePictureHelper._();

  static final Map<String, ImageProvider> _cache = {};

  static String resolveAssetPath(String picture) {
    if (picture.isEmpty) {
      return HomeAssets.game1;
    }
    if (picture.startsWith('assets/') ||
        picture.startsWith('http') ||
        picture.startsWith('data:') ||
        picture.startsWith('blob:')) {
      return picture;
    }
    return 'assets/images/$picture';
  }

  static ImageProvider providerFor(String picture) {
    final resolved = resolveAssetPath(picture);
    final cached = _cache[resolved];
    if (cached != null) return cached;

    late final ImageProvider provider;
    if (resolved.startsWith('data:')) {
      final bytes = _decodeDataUrl(resolved);
      provider = bytes == null
          ? const AssetImage(HomeAssets.game1)
          : MemoryImage(bytes);
    } else if (resolved.startsWith('http') || resolved.startsWith('blob:')) {
      provider = NetworkImage(resolved);
    } else {
      provider = AssetImage(resolved);
    }
    _cache[resolved] = provider;
    return provider;
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

  static Widget image({
    required String picture,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Alignment alignment = Alignment.center,
  }) {
    return Image(
      image: providerFor(picture),
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => Image.asset(
        HomeAssets.game1,
        fit: fit,
        width: width,
        height: height,
      ),
    );
  }
}
