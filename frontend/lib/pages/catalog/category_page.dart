import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/catalog_assets.dart';
import 'package:frontend/pages/catalog/catalog_routes.dart';
import 'package:frontend/pages/catalog/widgets/catalog_filter_section.dart';
import 'package:frontend/pages/catalog/widgets/category_topic_card.dart';
import 'package:frontend/pages/catalog/widgets/category_topic_row.dart';
import 'package:frontend/pages/home/widgets/home_nav_bar.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/footer/app_footer.dart';

const double _maxContentWidth = 1120;

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    this.initialGameType,
  });

  final String? initialGameType;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedGameType;
  String? _selectedTime;
  String? _selectedSort;
  String? _selectedStatus;
  String? _selectedPlayers;
  String? _selectedDifficulty;

  static final _topicItems = [
    CategoryTopicItem(
      title: 'تست هوش',
      grayImage: CatalogAssets.iqTestGray,
    ),
    CategoryTopicItem(
      title: 'تست روانشناسی',
      grayImage: CatalogAssets.psychologyTestGray,
    ),
    CategoryTopicItem(
      title: 'تست فیلم و سینما',
      grayImage: CatalogAssets.cinemaTestGray,
      colorImage: CatalogAssets.cinemaTestColor,
    ),
    CategoryTopicItem(
      title: 'تست سریال',
      grayImage: CatalogAssets.seriesTestColor,
    ),
    CategoryTopicItem(
      title: 'تست MBTI',
      grayImage: CatalogAssets.psychologyTestGray,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedGameType = widget.initialGameType;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {});
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _selectedGameType = null;
      _selectedTime = null;
      _selectedSort = null;
      _selectedStatus = null;
      _selectedPlayers = null;
      _selectedDifficulty = null;
    });
  }

  void _onTopicTap(CategoryTopicItem item, String gameType) {
    if (gameType == 'quiz') {
      Navigator.of(context).pushNamed(CatalogRoutes.quizzes);
      return;
    }
    setState(() => _selectedGameType = gameType);
  }

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
                      const BoxConstraints(maxWidth: _maxContentWidth),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                    child: Column(
                      children: [
                        Text(
                          'دسته بندی بازی ها',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'از بین بازی های فانته کوییز یکی رو انتخاب کنید و '
                          'وارد دنیای رقابت، چالش و هیجان شوید!!',
                          textAlign: TextAlign.center,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 16,
                            color: AppColors.textLight,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 36),
                        CatalogFilterSection(
                          searchController: _searchController,
                          selectedCategory: _selectedCategory,
                          selectedGameType: _selectedGameType,
                          selectedTime: _selectedTime,
                          selectedSort: _selectedSort,
                          selectedStatus: _selectedStatus,
                          selectedPlayers: _selectedPlayers,
                          selectedDifficulty: _selectedDifficulty,
                          onCategoryChanged: (value) =>
                              setState(() => _selectedCategory = value),
                          onGameTypeChanged: (value) =>
                              setState(() => _selectedGameType = value),
                          onTimeChanged: (value) =>
                              setState(() => _selectedTime = value),
                          onSortChanged: (value) =>
                              setState(() => _selectedSort = value),
                          onStatusChanged: (value) =>
                              setState(() => _selectedStatus = value),
                          onPlayersChanged: (value) =>
                              setState(() => _selectedPlayers = value),
                          onDifficultyChanged: (value) =>
                              setState(() => _selectedDifficulty = value),
                          onSearch: _applyFilters,
                          onClear: _clearFilters,
                        ),
                        const SizedBox(height: 40),
                        CategoryTopicRow(
                          title: 'تست ها',
                          items: _topicItems,
                          onItemTap: (item) => _onTopicTap(item, 'test'),
                        ),
                        const SizedBox(height: 36),
                        CategoryTopicRow(
                          title: 'کوئیز ها',
                          items: _topicItems,
                          onItemTap: (item) => _onTopicTap(item, 'quiz'),
                        ),
                        const SizedBox(height: 36),
                        CategoryTopicRow(
                          title: 'نظرسنجی ها',
                          items: _topicItems,
                          onItemTap: (item) => _onTopicTap(item, 'vote'),
                        ),
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
