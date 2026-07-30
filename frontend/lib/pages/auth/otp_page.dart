import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/auth_routes.dart';
import 'package:frontend/pages/auth/models/auth_flow_args.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/auth/widgets/auth_primary_button.dart';
import 'package:frontend/pages/auth/widgets/auth_privacy_footer.dart';
import 'package:frontend/pages/auth/widgets/auth_scaffold.dart';
import 'package:frontend/pages/auth/widgets/auth_social_section.dart';
import 'package:frontend/pages/auth/widgets/auth_spacing.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _pinController = TextEditingController();
  String? _routePhone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AuthFlowArgs && args.phoneNumber != null) {
      _routePhone = args.phoneNumber;
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _submit() {
    final state = context.read<AuthBloc>().state;
    final phone = state is AuthOtpSent
        ? state.phoneNumber
        : _routePhone;
    context.read<AuthBloc>().add(
          AuthOtpSubmitted(_pinController.text, phoneNumber: phone),
        );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: AuthLayout.otpBoxSize,
      height: AuthLayout.otpBoxSize,
      textStyle: AppTextTheme.getTextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterAwaitingPassword) {
          Navigator.of(context).pushNamed(AuthRoutes.setPassword);
        }
      },
      child: AuthScaffold(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final otpState = state is AuthOtpSent ? state : null;

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
                  'لطفاً کد تأییدی که برای شما ارسال شده را وارد نمایید.',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                if (otpState?.phoneNumber != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    otpState!.phoneNumber,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 5,
                    controller: _pinController,
                    enabled: !isLoading,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration?.copyWith(
                        border: Border.all(
                          color: AppColors.primaryGold,
                          width: 2,
                        ),
                      ),
                    ),
                    separatorBuilder: (_) => const SizedBox(width: 8),
                    onCompleted: (_) => _submit(),
                  ),
                ),
                AuthGaps.beforePrimaryButton,
                AuthPrimaryButton(
                  label: isLoading ? 'در حال تأیید...' : 'ادامه',
                  onPressed: isLoading ? null : _submit,
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => context
                          .read<AuthBloc>()
                          .add(const AuthResendOtpRequested()),
                  child: Text(
                    'ارسال مجدد کد',
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
