import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/catalog_routes.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class HomeGameStyleSection extends StatelessWidget {
  const HomeGameStyleSection({super.key});

  static const _cardSize = 300.0;

  static const _items = [
    _GameStyleItem(
      image: HomeAssets.gameStyle1,
      title: 'نظرسنجی‌ها',
      description: 'نظر خودت رو درباره موضوعات مختلف ثبت کن.',
      gameType: 'vote',
    ),
    _GameStyleItem(
      image: HomeAssets.gameStyle2,
      title: 'کوییزهای رقابتی',
      description: 'با دوستانت رقابت کن و امتیاز بگیر.',
      gameType: 'quiz',
    ),
    _GameStyleItem(
      image: HomeAssets.gameStyle3,
      title: 'تست‌های فانتزی',
      description: 'شخصیت و سبک بازی خودت رو کشف کن.',
      gameType: 'test',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundSecondSection,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(48, 72, 48, 72),
        child: Column(
        children: [
          Text(
            'سبک بازی خودت رو انتخاب کن',
            style: AppTextTheme.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 720) {
                final cardSize =
                    constraints.maxWidth.clamp(0, _cardSize).toDouble();

                return Column(
                  children: _items
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Center(
                            child: SizedBox(
                              width: cardSize,
                              height: cardSize,
                              child: _GameStyleCard(
                                item: item,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    CatalogRoutes.category,
                                    arguments: item.gameType,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          width: _cardSize,
                          height: _cardSize,
                          child: _GameStyleCard(
                            item: item,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                CatalogRoutes.category,
                                arguments: item.gameType,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
      ),
    );
  }
}

class _GameStyleItem {
  const _GameStyleItem({
    required this.image,
    required this.title,
    required this.description,
    required this.gameType,
  });

  final String image;
  final String title;
  final String description;
  final String gameType;
}

class _GameStyleCard extends StatelessWidget {
  const _GameStyleCard({
    required this.item,
    required this.onTap,
  });

  final _GameStyleItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.image,
                height: 72,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: AppTextTheme.getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
