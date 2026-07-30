import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_assets.dart';

class GamePictureHelper {
  GamePictureHelper._();

  static String resolveAssetPath(String picture) {
    if (picture.isEmpty) {
      return HomeAssets.game1;
    }
    if (picture.startsWith('assets/')) {
      return picture;
    }
    if (picture.startsWith('http')) {
      return picture;
    }
    return 'assets/images/$picture';
  }

  static Widget image({
    required String picture,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
  }) {
    final resolved = resolveAssetPath(picture);

    if (resolved.startsWith('http')) {
      return Image.network(
        resolved,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _fallback(fit: fit, width: width, height: height),
      );
    }

    return Image.asset(
      resolved,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _fallback(fit: fit, width: width, height: height),
    );
  }

  static Widget _fallback({
    required BoxFit fit,
    double? width,
    double? height,
  }) {
    return Image.asset(
      HomeAssets.game1,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
