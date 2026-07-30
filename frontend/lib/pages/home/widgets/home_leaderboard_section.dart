import 'package:flutter/material.dart';
import 'package:frontend/data/repository/leaderboard_repository.dart';
import 'package:frontend/models/leaderboard_model.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class HomeLeaderboardSection extends StatefulWidget {
  const HomeLeaderboardSection({super.key});

  @override
  State<HomeLeaderboardSection> createState() => _HomeLeaderboardSectionState();
}

class _HomeLeaderboardSectionState extends State<HomeLeaderboardSection> {
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

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await leaderboardRepository.getLeaderboard(
        sortBy: LeaderboardSortBy.fromTabIndex(_selectedTab),
      );
      if (!mounted) return;
      setState(() {
        _entries = response.entries;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'بارگذاری لیدربورد ناموفق بود';
        _loading = false;
      });
    }
  }

  void _onTabSelected(int index) {
    if (_selectedTab == index) return;
    setState(() => _selectedTab = index);
    _loadLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 48, 48, 24),
      child: Column(
        children: [
          Text(
            'برترین بازیکنان فانته کوییز',
            style: AppTextTheme.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final isSelected = _selectedTab == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: TextButton(
                      onPressed: () => _onTabSelected(index),
                      style: TextButton.styleFrom(
                        backgroundColor: isSelected
                            ? AppColors.hoverButton
                            : Colors.transparent,
                        foregroundColor: isSelected
                            ? AppColors.primaryGold
                            : AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        _tabs[index],
                        style: AppTextTheme.getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
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
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3D2E10),
                  Color(0xFF121212),
                  Color(0xFF000000),
                ],
              ),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: _buildBody(),
          ),
        ],
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
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadLeaderboard,
              child: Text(
                'تلاش مجدد',
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGold,
                ),
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
          'هنوز بازیکنی در این جدول ثبت نشده است',
          textAlign: TextAlign.center,
          style: AppTextTheme.getTextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return Column(
      children: _entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _LeaderboardRow(
                entry: entry,
                fallbackAvatar: _fallbackAvatars[
                    (entry.rank - 1).clamp(0, _fallbackAvatars.length - 1)],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.entry,
    required this.fallbackAvatar,
  });

  final LeaderboardEntry entry;
  final String fallbackAvatar;

  @override
  Widget build(BuildContext context) {
    final displayName = entry.fullName?.trim();
    final name = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : 'کاربر Fante Quiz';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '${entry.rank}',
            style: AppTextTheme.getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundImage: _avatarImage(entry.profilePicture, fallbackAvatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: AppTextTheme.getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
            ),
          ),
          Text(
            '${entry.score}',
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
