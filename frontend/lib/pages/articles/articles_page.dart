import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/pages/info/widgets/info_page_scaffold.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/utils/jalali_date.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  static final _articles = [
    _ArticleItem(
      title: 'چطور یک کوییز فانتزی جذاب طراحی کنیم؟',
      excerpt:
          'از انتخاب تم و سوالات تا تصاویر و نتایج — نکات عملی برای ساخت '
          'کوییزی که بازیکنان تا آخر همراهش بمانند.',
      category: 'راهنما',
      image: HomeAssets.gameStyle1,
      publishedAt: DateTime(2026, 5, 12),
    ),
    _ArticleItem(
      title: 'دنیای انیمه در فانته کوییز',
      excerpt:
          'محبوب‌ترین کوییزها و تست‌های شخصیت با تم انیمه را بشناسید و '
          'ببینید جامعه چه آثاری را بیشتر دوست دارد.',
      category: 'جامعه',
      image: HomeAssets.game2,
      publishedAt: DateTime(2026, 5, 8),
    ),
    _ArticleItem(
      title: 'راهنمای جدول رنکینگ و امتیازگیری',
      excerpt:
          'امتیاز چطور محاسبه می‌شود؟ ساخت کوییز، شرکت در بازی‌ها و '
          'نشان‌ها چه تاثیری روی رتبه شما دارند؟',
      category: 'سیستم بازی',
      image: HomeAssets.game3,
      publishedAt: DateTime(2026, 4, 28),
    ),
    _ArticleItem(
      title: 'تست شخصیت یا کوییز رقابتی؟',
      excerpt:
          'تفاوت فرمت‌های بازی در فانته کوییز و اینکه برای چه هدفی '
          'کدام‌یک را انتخاب کنید.',
      category: 'آموزش',
      image: HomeAssets.gameStyle2,
      publishedAt: DateTime(2026, 4, 20),
    ),
    _ArticleItem(
      title: 'پنج ایده برای نظرسنجی‌های گروهی',
      excerpt:
          'از انتخاب پایان داستان تا محبوب‌ترین قدرت جادویی — ایده‌هایی '
          'برای نظرسنجی‌هایی که دوستان را درگیر می‌کند.',
      category: 'ایده',
      image: HomeAssets.gameStyle3,
      publishedAt: DateTime(2026, 4, 10),
    ),
    _ArticleItem(
      title: 'به‌روزرسانی بهار ۱۴۰۵',
      excerpt:
          'تصویر پس‌زمینه پخش، داشبورد بازیکن و امکانات جدید ساخت بازی '
          'را در این یادداشت مرور کنید.',
      category: 'اخبار',
      image: HomeAssets.game1,
      publishedAt: DateTime(2026, 3, 25),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'مطالب',
      subtitle:
          'راهنماها، اخبار و نوشته‌های جامعه فانته کوییز را اینجا بخوانید.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          if (!wide) {
            return Column(
              children: [
                for (var i = 0; i < _articles.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  _ArticleCard(article: _articles[i]),
                ],
              ],
            );
          }

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final article in _articles)
                SizedBox(
                  width: (constraints.maxWidth - 16) / 2,
                  child: _ArticleCard(article: article),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ArticleItem {
  const _ArticleItem({
    required this.title,
    required this.excerpt,
    required this.category,
    required this.image,
    required this.publishedAt,
  });

  final String title;
  final String excerpt;
  final String category;
  final String image;
  final DateTime publishedAt;
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final _ArticleItem article;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDetail(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryGold.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    article.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryGold.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            article.category,
                            style: AppTextTheme.getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          JalaliDate.format(article.publishedAt),
                          style: AppTextTheme.getTextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      article.excerpt,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.65,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ادامه مطلب',
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.primaryGold.withValues(alpha: 0.45),
            ),
          ),
          title: Text(
            article.title,
            style: AppTextTheme.getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              '${article.excerpt}\n\n'
              'این مطلب نمونه‌ای از محتوای مجله فانته کوییز است. '
              'به‌زودی نسخه‌های کامل‌تر مقالات با تصاویر و لینک‌های مرتبط '
              'منتشر می‌شوند.',
              style: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.7,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'بستن',
                style: AppTextTheme.getTextStyle(color: AppColors.primaryGold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
