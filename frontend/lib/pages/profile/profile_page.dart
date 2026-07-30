import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/data/repository/profile_repository.dart';
import 'package:frontend/pages/profile/bloc/profile_bloc.dart';
import 'package:frontend/pages/profile/widgets/profile_bottom_row.dart';
import 'package:frontend/pages/profile/widgets/profile_middle_row.dart';
import 'package:frontend/pages/profile/widgets/profile_scaffold.dart';
import 'package:frontend/pages/profile/widgets/profile_summary_section.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(profileRepository)
        ..add(const ProfileLoadRequested()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return ProfileScaffold(
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            ),
          );
        }

        if (state is ProfileFailure) {
          return ProfileScaffold(
            child: Center(
              child: Text(
                state.message,
                style: AppTextTheme.getTextStyle(color: AppColors.textLight),
              ),
            ),
          );
        }

        final profile = (state as ProfileLoaded).profile;

        return ProfileScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileSummarySection(profile: profile),
              const SizedBox(height: ProfileLayout.sectionGap),
              ProfileMiddleRow(profile: profile),
              const SizedBox(height: ProfileLayout.sectionGap),
              const ProfileBottomRow(),
            ],
          ),
        );
      },
    );
  }
}
