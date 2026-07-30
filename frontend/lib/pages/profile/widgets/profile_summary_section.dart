import 'package:flutter/material.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/profile/widgets/profile_badges_panel.dart';
import 'package:frontend/pages/profile/widgets/profile_quick_actions_panel.dart';
import 'package:frontend/pages/profile/widgets/profile_sidebar.dart';
import 'package:frontend/pages/profile/widgets/profile_stat_cards_row.dart';

class ProfileSummarySection extends StatelessWidget {
  const ProfileSummarySection({super.key, required this.profile});

  final PlayerProfile profile;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 720;

          final rightSide = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileStatCardsRow(profile: profile),
              const SizedBox(height: 16),
              const _BadgesAndActionsRow(),
            ],
          );

          if (!isWide) {
            return Column(
              children: [
                ProfileSidebar(profile: profile),
                const SizedBox(height: 16),
                rightSide,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: rightSide),
              const SizedBox(width: 20),
              ProfileSidebar(profile: profile),
            ],
          );
        },
      ),
    );
  }
}

class _BadgesAndActionsRow extends StatelessWidget {
  const _BadgesAndActionsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileQuickActionsPanel(),
              SizedBox(height: 16),
              ProfileBadgesPanel(),
            ],
          );
        }

        return const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: ProfileQuickActionsPanel()),
            SizedBox(width: 16),
            Expanded(flex: 5, child: ProfileBadgesPanel()),
          ],
        );
      },
    );
  }
}
