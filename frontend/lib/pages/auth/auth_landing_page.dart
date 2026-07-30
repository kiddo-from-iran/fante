import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/auth_routes.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/auth/widgets/auth_primary_button.dart';
import 'package:frontend/pages/auth/widgets/auth_privacy_footer.dart';
import 'package:frontend/pages/auth/widgets/auth_scaffold.dart';
import 'package:frontend/pages/auth/widgets/auth_social_section.dart';
import 'package:frontend/pages/auth/widgets/auth_spacing.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'به Fante Quiz خوش آمدید!',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          AuthGaps.afterTitle,
          AuthPrimaryButton(
            label: 'ورود',
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(const AuthFlowModeSelected(isRegister: false));
              Navigator.of(context).pushNamed(AuthRoutes.login);
            },
          ),
          AuthGaps.primaryButtonGap,
          AuthPrimaryButton(
            label: 'ثبت‌نام',
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(const AuthFlowModeSelected(isRegister: true));
              Navigator.of(context).pushNamed(AuthRoutes.register);
            },
          ),
          const AuthSocialSection(),
          AuthGaps.beforeFooter,
          const AuthPrivacyFooter(),
        ],
      ),
    );
  }
}
