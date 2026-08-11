import 'package:flutter/material.dart';
import 'package:frontend/models/game_model.dart';
import 'package:frontend/pages/catalog/widgets/catalog_game_card.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

/// E-commerce style results: 4 cards/row, 12 per page, with pagination.
class CatalogResultsGrid extends StatelessWidget {
  const CatalogResultsGrid({
    super.key,
    required this.games,
    required this.page,
    required this.pageSize,
    required this.onPageChanged,
    required this.onGameTap,
    required this.onBack,
    this.heading,
  });

  final List<GameListItem> games;
  final int page;
  final int pageSize;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<GameListItem> onGameTap;
  final VoidCallback onBack;
  final String? heading;

  int get _pageCount {
    if (games.isEmpty) return 1;
    return ((games.length - 1) ~/ pageSize) + 1;
  }

  List<GameListItem> get _pageItems {
    if (games.isEmpty) return const [];
    final safePage = page.clamp(0, _pageCount - 1);
    final start = safePage * pageSize;
    final end = (start + pageSize).clamp(0, games.length);
    return games.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final items = _pageItems;
    final totalPages = _pageCount;
    final safePage = page.clamp(0, totalPages - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              heading ?? '${games.length} بازی یافت شد',
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const Spacer(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onBack,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryGold.withValues(alpha: 0.7),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: AppColors.primaryGold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'بازگشت',
                        style: AppTextTheme.getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Text(
              'بازی‌ای با این فیلتر پیدا نشد.',
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 960
                  ? 4
                  : width >= 700
                      ? 3
                      : width >= 480
                          ? 2
                          : 1;
              const gap = 16.0;
              final cardWidth =
                  (width - gap * (columns - 1)) / columns;
              final cardHeight = cardWidth * 1.35;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final game in items)
                    SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: CatalogGameCard(
                        game: game,
                        onTap: () => onGameTap(game),
                      ),
                    ),
                ],
              );
            },
          ),
        if (games.isNotEmpty) ...[
          const SizedBox(height: 28),
          _PaginationBar(
            page: safePage,
            pageCount: totalPages,
            onChanged: onPageChanged,
          ),
        ],
      ],
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.page,
    required this.pageCount,
    required this.onChanged,
  });

  final int page;
  final int pageCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageArrow(
          icon: Icons.chevron_left_rounded,
          enabled: page > 0,
          onTap: () => onChanged(page - 1),
        ),
        const SizedBox(width: 8),
        for (var i = 0; i < pageCount; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          _PageChip(
            label: '${i + 1}',
            selected: i == page,
            onTap: () => onChanged(i),
          ),
        ],
        const SizedBox(width: 8),
        _PageArrow(
          icon: Icons.chevron_right_rounded,
          enabled: page < pageCount - 1,
          onTap: () => onChanged(page + 1),
        ),
      ],
    );
  }
}

class _PageArrow extends StatelessWidget {
  const _PageArrow({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled
                  ? AppColors.primaryGold
                  : AppColors.textMuted.withValues(alpha: 0.35),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? AppColors.primaryGold : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _PageChip extends StatelessWidget {
  const _PageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryGold : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? AppColors.primaryGold
                  : AppColors.textMuted.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            label,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? AppColors.textBlack : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}
