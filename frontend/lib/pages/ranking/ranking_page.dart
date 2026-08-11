import 'package:flutter/material.dart';
import 'package:frontend/data/repository/leaderboard_repository.dart';
import 'package:frontend/models/leaderboard_model.dart';
import 'package:frontend/pages/game/game_assets.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/pages/home/widgets/home_nav_bar.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/footer/app_footer.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int _selectedTab = 0;
  bool _loading = true;
  String? _error;
  List<LeaderboardEntry> _entries = const [];

  static const _tabs = [
    'برترین امتیاز',
    'بیشترین کوییز ساخته شده',
    'تعداد شرکت در بازی‌ها',
  ];

  static const _fallbackAvatars = [
    HomeAssets.profile1,
    HomeAssets.profile2,
    HomeAssets.profile3,
    HomeAssets.profile4,
    HomeAssets.profile5,
  ];

  static const _demoFallback = [
    LeaderboardEntry(rank: 1, userId: 1, fullName: 'شاهزاده تاریکی', score: 15400),
    LeaderboardEntry(rank: 2, userId: 2, fullName: 'جادوگر سفید', score: 14250),
    LeaderboardEntry(rank: 3, userId: 3, fullName: 'نگهبان جنگل', score: 13110),
    LeaderboardEntry(rank: 4, userId: 4, fullName: 'شوالیه نقره‌ای', score: 11880),
    LeaderboardEntry(rank: 5, userId: 5, fullName: 'ملکه سایه', score: 10940),
    LeaderboardEntry(rank: 6, userId: 6, fullName: 'ستاره‌خوان', score: 9760),
    LeaderboardEntry(rank: 7, userId: 7, fullName: 'سایه‌نویس', score: 8640),
    LeaderboardEntry(rank: 8, userId: 8, fullName: 'کاشف جهان‌ها', score: 7520),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await leaderboardRepository.getLeaderboard(
        sortBy: LeaderboardSortBy.fromTabIndex(_selectedTab),
        limit: 50,
      );
      if (!mounted) return;
      setState(() {
        _entries = response.entries.isEmpty ? _demoFallback : response.entries;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _entries = _demoFallback;
        _error = null;
        _loading = false;
      });
    }
  }

  void _onTabSelected(int index) {
    if (_selectedTab == index) return;
    setState(() => _selectedTab = index);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              GameAssets.backgroundForest,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
            const ColoredBox(color: Color(0x73000000)),
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: HomeNavBar()),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
                        child: Column(
                          children: [
                            Text(
                              'رنکینگ',
                              style: AppTextTheme.getTextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'برترین بازیکنان فانته کوییز را ببینید و جایگاه خود را پیدا کنید',
                              textAlign: TextAlign.center,
                              style: AppTextTheme.getTextStyle(
                                fontSize: 16,
                                color: AppColors.textLight,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 28),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard.withValues(
                                  alpha: 0.92,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(_tabs.length, (index) {
                                    final selected = _selectedTab == index;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      child: TextButton(
                                        onPressed: () => _onTabSelected(index),
                                        style: TextButton.styleFrom(
                                          backgroundColor: selected
                                              ? AppColors.hoverButton
                                              : Colors.transparent,
                                          foregroundColor: selected
                                              ? AppColors.primaryGold
                                              : AppColors.textMuted,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text(
                                          _tabs[index],
                                          style: AppTextTheme.getTextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: selected
                                                ? AppColors.primaryGold
                                                : AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: Colors.black.withValues(alpha: 0.55),
                                border: Border.all(
                                  color: AppColors.primaryGold.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                              ),
                              child: _buildBody(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryGold),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Text(
              _error!,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            TextButton(
              onPressed: _load,
              child: Text(
                'تلاش مجدد',
                style: AppTextTheme.getTextStyle(color: AppColors.primaryGold),
              ),
            ),
          ],
        ),
      );
    }

    if (_entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Text(
          'هنوز رتبه‌ای ثبت نشده است',
          style: AppTextTheme.getTextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final entry = _entries[i];
        return _RankingRow(
          entry: entry,
          fallbackAvatar: _fallbackAvatars[
              (entry.rank - 1).clamp(0, _fallbackAvatars.length - 1)],
          highlight: i < 3,
        );
      },
    );
  }
}

class _RankingRow extends StatelessWidget {
  const _RankingRow({
    required this.entry,
    required this.fallbackAvatar,
    this.highlight = false,
  });

  final LeaderboardEntry entry;
  final String fallbackAvatar;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final displayName = entry.fullName?.trim();
    final name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'کاربر Fante Quiz';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primaryGold.withValues(alpha: 0.12)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: highlight
            ? Border.all(color: AppColors.primaryGold.withValues(alpha: 0.55))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '${entry.rank}',
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 24,
            backgroundImage: _avatarImage(entry.profilePicture, fallbackAvatar),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              name,
              style: AppTextTheme.getTextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
          ),
          Text(
            '${entry.score}',
            style: AppTextTheme.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _avatarImage(String? url, String fallback) {
    if (url != null &&
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'))) {
      return NetworkImage(url);
    }
    return AssetImage(fallback);
  }
}
