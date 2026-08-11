import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/auth/widgets/auth_divider.dart';
import 'package:frontend/pages/auth/widgets/auth_social_button.dart';
import 'package:frontend/pages/auth/widgets/auth_spacing.dart';

class AuthSocialSection extends StatelessWidget {
  const AuthSocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthGaps.beforeDivider,
            const AuthDivider(),
            AuthGaps.afterDivider,
            AuthSocialButton(
              provider: AuthSocialProvider.google,
              onPressed: isLoading
                  ? null
                  : () => context
                      .read<AuthBloc>()
                      .add(const AuthGoogleSignInRequested()),
            ),
          ],
        );
      },
    );
  }
}
