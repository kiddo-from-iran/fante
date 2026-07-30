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
import 'package:frontend/widgets/toast/app_toast.dart';

/// Register step: collect phone and request SMS code.
class RegisterPhonePage extends StatefulWidget {
  const RegisterPhonePage({super.key});

  @override
  State<RegisterPhonePage> createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(AuthPhoneSubmitted(_phoneController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent && state.flowMode == AuthFlowMode.register) {
          Navigator.of(context).pushNamed(
            AuthRoutes.otp,
            arguments: AuthFlowArgs(
              mode: AuthFlowMode.register,
              phoneNumber: state.phoneNumber,
              fullName: state.fullName,
            ),
          );
        } else if (state is AuthFailure) {
          AppToast.error(context, state.message);
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
                  'تأیید شماره موبایل',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'برای تکمیل ثبت‌نام، شماره همراه خود را وارد کنید.',
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
                AuthGaps.beforePrimaryButton,
                AuthPrimaryButton(
                  label: isLoading ? 'در حال ارسال...' : 'دریافت کد تأیید',
                  onPressed: isLoading ? null : _submit,
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
