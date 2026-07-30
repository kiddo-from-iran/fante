import 'package:flutter/material.dart';
import 'package:frontend/pages/home/widgets/home_nav_bar.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/footer/app_footer.dart';

const double infoMaxContentWidth = 960;

/// Shared chrome for static info pages (about / terms / contact).
class InfoPageScaffold extends StatelessWidget {
  const InfoPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.belowSubtitle,
  });

  final String title;
  final String subtitle;
  final Widget? belowSubtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundSecondSection,
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: HomeNavBar()),
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: infoMaxContentWidth),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 16,
                            color: AppColors.textMuted,
                            height: 1.7,
                          ),
                        ),
                        if (belowSubtitle != null) ...[
                          const SizedBox(height: 28),
                          belowSubtitle!,
                        ],
                        const SizedBox(height: 36),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }
}

class InfoSectionCard extends StatelessWidget {
  const InfoSectionCard({
    super.key,
    required this.child,
    this.title,
  });

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGold.withValues(alpha: 0.55),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: AppTextTheme.getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}

class InfoBodyText extends StatelessWidget {
  const InfoBodyText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextTheme.getTextStyle(
        fontSize: 14,
        color: AppColors.textLight,
        height: 1.9,
      ),
    );
  }
}

class InfoBulletList extends StatelessWidget {
  const InfoBulletList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Icon(
                    Icons.circle,
                    size: 7,
                    color: AppColors.primaryGold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: InfoBodyText(item)),
              ],
            ),
          ),
      ],
    );
  }
}
