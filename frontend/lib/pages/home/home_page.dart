import 'package:flutter/material.dart';
import 'package:frontend/pages/home/widgets/home_create_quiz_banner.dart';
import 'package:frontend/widgets/footer/app_footer.dart';
import 'package:frontend/pages/home/widgets/home_game_style_section.dart';
import 'package:frontend/pages/home/widgets/home_hero_section.dart';
import 'package:frontend/pages/home/widgets/home_hot_games_section.dart';
import 'package:frontend/pages/home/widgets/home_leaderboard_section.dart';
import 'package:frontend/pages/home/widgets/home_nav_bar.dart';
import 'package:frontend/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: HomeNavBar()),
            const SliverToBoxAdapter(child: HomeHeroSection()),
            const SliverToBoxAdapter(child: HomeGameStyleSection()),
            const SliverToBoxAdapter(child: HomeLeaderboardSection()),
            const SliverToBoxAdapter(child: HomeHotGamesSection()),
            const SliverToBoxAdapter(child: HomeCreateQuizBanner()),
            const SliverToBoxAdapter(child: AppFooter()),
          ],
        ),
      ),
    );
  }
}
