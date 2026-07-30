import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class CatalogFilterSection extends StatelessWidget {
  const CatalogFilterSection({
    super.key,
    required this.searchController,
    required this.selectedCategory,
    required this.selectedGameType,
    required this.selectedTime,
    required this.selectedSort,
    required this.selectedStatus,
    required this.selectedPlayers,
    required this.selectedDifficulty,
    required this.onCategoryChanged,
    required this.onGameTypeChanged,
    required this.onTimeChanged,
    required this.onSortChanged,
    required this.onStatusChanged,
    required this.onPlayersChanged,
    required this.onDifficultyChanged,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController searchController;
  final String? selectedCategory;
  final String? selectedGameType;
  final String? selectedTime;
  final String? selectedSort;
  final String? selectedStatus;
  final String? selectedPlayers;
  final String? selectedDifficulty;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onGameTypeChanged;
  final ValueChanged<String?> onTimeChanged;
  final ValueChanged<String?> onSortChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onPlayersChanged;
  final ValueChanged<String?> onDifficultyChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text(
            'جستجو و فیلتر بازی‌ها',
            style: AppTextTheme.getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              const columns = 4;
              return Column(
                children: [
                  _FilterRow(
                    columns: columns,
                    children: [
                      _FilterField(
                        label: 'جستجو',
                        child: TextField(
                          controller: searchController,
                          style: AppTextTheme.getTextStyle(
                            color: AppColors.textBlack,
                            fontSize: 13,
                          ),
                          decoration: _inputDecoration('جستجوی بازی'),
                          onSubmitted: (_) => onSearch(),
                        ),
                      ),
                      _FilterDropdown(
                        label: 'دسته‌بندی‌ها',
                        value: selectedCategory,
                        hint: 'دسته‌بندی بازی',
                        items: const [
                          'تست‌های فانتزی',
                          'کوییزهای رقابتی',
                          'نظرسنجی‌ها',
                          'چالش‌ها',
                        ],
                        onChanged: onCategoryChanged,
                      ),
                      _FilterDropdown(
                        label: 'نوع بازی',
                        value: _gameTypeLabel(selectedGameType),
                        hint: 'انواع',
                        items: const [
                          'کوییز رقابتی',
                          'نظرسنجی',
                          'تست شخصیت',
                        ],
                        onChanged: (value) =>
                            onGameTypeChanged(_gameTypeValue(value)),
                      ),
                      _FilterDropdown(
                        label: 'میزان زمان',
                        value: selectedTime,
                        hint: 'همه زمان‌ها',
                        items: const [
                          'کمتر از ۵ دقیقه',
                          '۵ تا ۱۵ دقیقه',
                          'بیشتر از ۱۵ دقیقه',
                        ],
                        onChanged: onTimeChanged,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _FilterRow(
                    columns: columns,
                    children: [
                      _FilterDropdown(
                        label: 'مرتب‌سازی براساس',
                        value: selectedSort,
                        hint: 'محبوب‌ترین‌ها',
                        items: const [
                          'محبوب‌ترین‌ها',
                          'جدیدترین‌ها',
                          'بیشترین امتیاز',
                        ],
                        onChanged: onSortChanged,
                      ),
                      _FilterDropdown(
                        label: 'وضعیت',
                        value: selectedStatus,
                        hint: 'همه وضعیت‌ها',
                        items: const [
                          'فعال',
                          'در حال برگزاری',
                          'پایان‌یافته',
                        ],
                        onChanged: onStatusChanged,
                      ),
                      _FilterDropdown(
                        label: 'تعداد بازیکن',
                        value: selectedPlayers,
                        hint: 'تعداد بازیکن',
                        items: const [
                          '۱ تا ۱۰۰',
                          '۱۰۰ تا ۱۰۰۰',
                          'بیش از ۱۰۰۰',
                        ],
                        onChanged: onPlayersChanged,
                      ),
                      _FilterDropdown(
                        label: 'سطح سختی',
                        value: selectedDifficulty,
                        hint: 'همه سطح‌ها',
                        items: const [
                          'آسان',
                          'متوسط',
                          'سخت',
                        ],
                        onChanged: onDifficultyChanged,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: onClear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textLight,
                    side: const BorderSide(color: AppColors.textLight),
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'حذف فیلترها',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: AppColors.textLight,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'جستجو',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextTheme.getTextStyle(
        color: AppColors.textMuted,
        fontSize: 13,
      ),
      filled: true,
      fillColor: AppColors.textLight,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.primaryGold),
      ),
    );
  }

  static String? _gameTypeLabel(String? value) {
    switch (value) {
      case 'quiz':
        return 'کوییز رقابتی';
      case 'vote':
        return 'نظرسنجی';
      case 'test':
        return 'تست شخصیت';
      default:
        return null;
    }
  }

  static String? _gameTypeValue(String? label) {
    switch (label) {
      case 'کوییز رقابتی':
        return 'quiz';
      case 'نظرسنجی':
        return 'vote';
      case 'تست شخصیت':
        return 'test';
      default:
        return null;
    }
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.columns,
    required this.children,
  });

  final int columns;
  final List<Widget> children;

  static const double _gap = 24;

  @override
  Widget build(BuildContext context) {
    if (columns == 1) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: child,
                ))
            .toList(),
      );
    }

    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final rowChildren = <Widget>[];
      for (var j = 0; j < columns; j++) {
        final index = i + j;
        if (j > 0) {
          rowChildren.add(const SizedBox(width: _gap));
        }
        rowChildren.add(
          Expanded(
            child: index < children.length
                ? children[index]
                : const SizedBox.shrink(),
          ),
        );
      }
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 16));
      }
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
    }

    return Column(children: rows);
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FilterField(
      label: label,
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: AppTextTheme.getTextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: AppTextTheme.getTextStyle(
                    color: AppColors.textBlack,
                    fontSize: 13,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        decoration: CatalogFilterSection._inputDecoration(hint),
        style: AppTextTheme.getTextStyle(
          color: AppColors.textBlack,
          fontSize: 13,
        ),
        dropdownColor: AppColors.textLight,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
      ),
    );
  }
}
