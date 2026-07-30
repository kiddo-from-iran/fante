import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_routes.dart';

/// Clickable Fante Quiz brand logo — navigates to home from any page.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.height = 44,
  });

  static const _assetPath = 'assets/images/FanteQuiz Cover transparent 1.png';

  final double height;

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      HomeRoutes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _goHome(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Image.asset(
        _assetPath,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
