import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/auth_routes.dart';
import 'package:frontend/pages/auth/models/auth_flow_args.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/auth/widgets/auth_primary_button.dart';
import 'package:frontend/pages/auth/widgets/auth_privacy_footer.dart';
import 'package:frontend/pages/auth/widgets/auth_scaffold.dart';
import 'package:frontend/pages/auth/widgets/auth_social_section.dart';
import 'package:frontend/pages/auth/widgets/auth_spacing.dart';
import 'package:frontend/pages/auth/widgets/auth_text_field.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginWithPassword() {
    context.read<AuthBloc>().add(
          AuthPasswordLoginSubmitted(
            phoneNumber: _phoneController.text,
            password: _passwordController.text,
          ),
        );
  }

  void _loginWithOtp() {
    context.read<AuthBloc>().add(
          AuthLoginOtpRequested(_phoneController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent &&
            state.flowMode == AuthFlowMode.login) {
          Navigator.of(context).pushNamed(
            AuthRoutes.otp,
            arguments: AuthFlowArgs(
              mode: AuthFlowMode.login,
              phoneNumber: state.phoneNumber,
            ),
          );
        }
      },
      child: AuthScaffold(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'به Fante Quiz خوش آمدید!',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'شماره موبایل و رمز عبور خود را وارد کنید.',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _phoneController,
                  hintText: 'شماره موبایل (۰۹xxxxxxxxx)',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  enabled: !isLoading,
                  prefixIcon: const Icon(
                    Icons.smartphone_outlined,
                    color: AppColors.inputIcon,
                  ),
                ),
                AuthGaps.primaryButtonGap,
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'رمز عبور',
                  obscureText: _obscurePassword,
                  enabled: !isLoading,
                  prefixIcon: IconButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.inputIcon,
                    ),
                  ),
                ),
                AuthGaps.beforePrimaryButton,
                AuthPrimaryButton(
                  label: isLoading ? 'در حال ورود...' : 'ورود',
                  onPressed: isLoading ? null : _loginWithPassword,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: isLoading ? null : _loginWithOtp,
                  child: Text(
                    'ورود با کد یکبار مصرف (پیامک)',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),
                const AuthSocialSection(),
                AuthGaps.beforeFooter,
                const AuthPrivacyFooter(),
              ],
            );
          },
        ),
      ),
    );
  }
}
