import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/catalog_routes.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          HomeAssets.banner,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Center(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CatalogRoutes.category);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: AppColors.textBlack,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'شروع بازی و تست‌ها',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
