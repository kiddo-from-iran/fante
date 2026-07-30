import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/widgets/category_topic_card.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class CategoryTopicRow extends StatelessWidget {
  const CategoryTopicRow({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap,
  });

  final String title;
  final List<CategoryTopicItem> items;
  final ValueChanged<CategoryTopicItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: AppTextTheme.getTextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primaryGold.withValues(alpha: 0.85),
              width: 1.2,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 640) {
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  alignment: WrapAlignment.center,
                  children: items
                      .map(
                        (item) => SizedBox(
                          width: constraints.maxWidth < 420
                              ? (constraints.maxWidth - 14) / 2
                              : 140,
                          child: CategoryTopicCard(
                            item: item,
                            onTap: () => onItemTap(item),
                          ),
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const SizedBox(width: 14),
                    Expanded(
                      child: CategoryTopicCard(
                        item: itemAt(i),
                        onTap: () => onItemTap(itemAt(i)),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  CategoryTopicItem itemAt(int index) => items[index];
}
