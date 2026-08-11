import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/catalog_routes.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/pages/home/home_routes.dart';
import 'package:frontend/pages/info/info_routes.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundSecondSection,
      padding: const EdgeInsets.fromLTRB(48, 48, 0, 24),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.only(start: 64),
                      child: _BrandColumn(),
                    ),
                    const SizedBox(height: 28),
                    const _QuickLinksColumn(),
                    const SizedBox(height: 28),
                    const _SocialColumn(),
                    const SizedBox(height: 28),
                    const _InfoColumn(),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: const Offset(56, 0),
                        child: const _PhoenixImage(height: 180),
                      ),
                    ),
                  ],
                );
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(start: 64),
                        child: _BrandColumn(),
                      ),
                    ),
                    const SizedBox(width: 32),
                    const Expanded(flex: 2, child: _QuickLinksColumn()),
                    const SizedBox(width: 32),
                    const Expanded(flex: 2, child: _SocialColumn()),
                    const SizedBox(width: 32),
                    const Expanded(flex: 2, child: _InfoColumn()),
                    Transform.translate(
                      offset: const Offset(80, 0),
                      child: const _PhoenixImage(height: 220),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          const Divider(color: AppColors.hoverButton, height: 1),
          const SizedBox(height: 20),
          Text(
            'تمام حقوق مادی و معنوی متعلق به فانته کوییز است - ۱۴۰۵',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoenixImage extends StatelessWidget {
  const _PhoenixImage({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      HomeAssets.phoenix,
      height: height,
      fit: BoxFit.contain,
      alignment: Alignment.centerRight,
    );
  }
}

class _BrandColumn extends StatelessWidget {
  const _BrandColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fante Quiz',
          style: AppTextTheme.getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'فانته کوییز پلتفرمی برای طرفداران دنیای فانتزی، انیمه و فیلم است تا دانش خود را به چالش بکشند و تست‌های اختصاصی خودشان را طراحی کنند.',
          style: AppTextTheme.getTextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

class _QuickLinksColumn extends StatelessWidget {
  const _QuickLinksColumn();

  static const _links = <({String label, String? route, Object? args})>[
    (label: 'خانه', route: HomeRoutes.home, args: null),
    (label: 'کوییزها', route: CatalogRoutes.quizzes, args: null),
    (label: 'تست‌های شخصیت', route: CatalogRoutes.tests, args: null),
    (label: 'نظرسنجی‌ها', route: CatalogRoutes.polls, args: null),
    (label: 'دسته‌بندی', route: CatalogRoutes.category, args: null),
    (label: 'جدول رنکینگ', route: InfoRoutes.ranking, args: null),
    (label: 'مطالب', route: InfoRoutes.articles, args: null),
  ];

  @override
  Widget build(BuildContext context) {
    return _FooterLinkColumn(title: 'دسترسی سریع', links: _links);
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn();

  static const _links = <({String label, String? route, Object? args})>[
    (label: 'درباره ما', route: InfoRoutes.about, args: null),
    (label: 'تماس با ما', route: InfoRoutes.contact, args: null),
    (label: 'قوانین و مقررات', route: InfoRoutes.terms, args: null),
    (label: 'گزارش خطا / انتقادات', route: InfoRoutes.contact, args: null),
  ];

  @override
  Widget build(BuildContext context) {
    return _FooterLinkColumn(title: 'اطلاعات', links: _links);
  }
}

class _SocialColumn extends StatelessWidget {
  const _SocialColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'همراه ما باشید',
          style: AppTextTheme.getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),
        Image.asset(
          HomeAssets.socialMedia,
          height: 40,
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }
}

class _FooterLinkColumn extends StatelessWidget {
  const _FooterLinkColumn({
    required this.title,
    required this.links,
  });

  final String title;
  final List<({String label, String? route, Object? args})> links;

  void _onPressed(
    BuildContext context,
    ({String label, String? route, Object? args}) link,
  ) {
    if (link.route == null) return;
    if (link.route == HomeRoutes.home) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeRoutes.home,
        (route) => false,
      );
      return;
    }
    Navigator.of(context).pushNamed(link.route!, arguments: link.args);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.getTextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextButton(
              onPressed: link.route == null
                  ? null
                  : () => _onPressed(context, link),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.textMuted,
              ),
              child: Text(
                link.label,
                style: AppTextTheme.getTextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
