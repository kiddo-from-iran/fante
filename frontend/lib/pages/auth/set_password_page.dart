import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/bloc/auth_bloc.dart';
import 'package:frontend/pages/auth/widgets/auth_primary_button.dart';
import 'package:frontend/pages/auth/widgets/auth_privacy_footer.dart';
import 'package:frontend/pages/auth/widgets/auth_scaffold.dart';
import 'package:frontend/pages/auth/widgets/auth_spacing.dart';
import 'package:frontend/pages/auth/widgets/auth_text_field.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

/// Register step: set password after SMS code is validated.
class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({super.key});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.length < 6) {
      AppToast.warning(context, 'رمز عبور باید حداقل ۶ کاراکتر باشد');
      return;
    }
    if (password != confirm) {
      AppToast.warning(context, 'رمز عبور و تکرار آن یکسان نیست');
      return;
    }

    context.read<AuthBloc>().add(AuthRegisterPasswordSubmitted(password));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final awaiting = state is AuthRegisterAwaitingPassword
                ? state
                : (state is AuthFailure &&
                        state.previous is AuthRegisterAwaitingPassword)
                    ? state.previous as AuthRegisterAwaitingPassword
                    : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'تعیین رمز عبور',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'رمز عبور خود را برای ورودهای بعدی انتخاب کنید.',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.getTextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                if (awaiting?.fullName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    awaiting!.fullName!,
                    textAlign: TextAlign.center,
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
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
                AuthGaps.primaryButtonGap,
                AuthTextField(
                  controller: _confirmController,
                  hintText: 'تکرار رمز عبور',
                  obscureText: _obscureConfirm,
                  enabled: !isLoading,
                  prefixIcon: IconButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.inputIcon,
                    ),
                  ),
                ),
                AuthGaps.beforePrimaryButton,
                AuthPrimaryButton(
                  label: isLoading ? 'در حال ثبت‌نام...' : 'تکمیل ثبت‌نام',
                  onPressed: isLoading ? null : _submit,
                ),
                AuthGaps.beforeFooter,
                const AuthPrivacyFooter(),
              ],
            );
          },
        ),
    );
  }
}
