import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/auth/widgets/auth_nav_bar.dart';
import 'package:frontend/pages/auth/widgets/auth_spacing.dart';
import 'package:frontend/pages/home/home_routes.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.maxCardWidth = AuthLayout.maxCardWidth,
  });

  final Widget child;
  final double maxCardWidth;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            HomeRoutes.home,
            (route) => false,
          );
        } else if (state is AuthFailure) {
          AppToast.error(context, state.message);
        }
      },
      child: Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/auth_background.png',
              fit: BoxFit.cover,
            ),
            // Solid dim instead of full-screen blur for smoother Chrome scrolling.
            Container(color: Colors.black.withValues(alpha: 0.35)),
            SafeArea(
              child: Column(
                children: [
                  const AuthNavBar(),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxCardWidth),
                          child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AuthLayout.cardBorderRadius),
                          child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AuthLayout.cardPaddingHorizontal,
                                vertical: AuthLayout.cardPaddingVertical,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground,
                                borderRadius: BorderRadius.circular(
                                  AuthLayout.cardBorderRadius,
                                ),
                                border: Border.all(
                                  color: AppColors.cardBorder,
                                ),
                              ),
                              child: child,
                            ),
                        ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
