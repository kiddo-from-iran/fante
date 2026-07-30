import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/auth_routes.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/dashboard/dashboard_routes.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class HomeCreateQuizBanner extends StatelessWidget {
  const HomeCreateQuizBanner({super.key});

  void _onStartPressed(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      Navigator.of(context).pushNamed(DashboardRoutes.gameCreate);
      return;
    }
    Navigator.of(context).pushNamed(AuthRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Column(
        children: [
          Text(
            'طراح کوییزهای فانتزی خودت باش!',
            style: AppTextTheme.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 240),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  AppColors.secondaryPurple,
                  AppColors.secondaryPurple.withValues(alpha: 0.7),
                  const Color(0xFF1A0619),
                ],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final sideInset = constraints.maxWidth * 0.18;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      right: sideInset,
                      child: Image.asset(
                        HomeAssets.icon2,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      left: sideInset,
                      child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Image.asset(
                          HomeAssets.icon1,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'تست شخصیت یا کوییز رقابتی خودت رو بساز!',
                          textAlign: TextAlign.center,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'دوستات رو به چالش بکش و به یک طراح برتر در فانته کوییز تبدیل شو.',
                          textAlign: TextAlign.center,
                          style: AppTextTheme.getTextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () => _onStartPressed(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              foregroundColor: AppColors.secondaryPurple,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'شروع و ساخت تست و کوییز',
                              style: AppTextTheme.getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryPurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
