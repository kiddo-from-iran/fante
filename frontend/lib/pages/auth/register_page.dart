import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/auth/auth_routes.dart';
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _submit() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      AppToast.warning(context, 'لطفاً نام و نام خانوادگی را وارد کنید');
      return;
    }

    context.read<AuthBloc>().add(
          AuthRegisterNameSubmitted(
            firstName: firstName,
            lastName: lastName,
          ),
        );
    Navigator.of(context).pushNamed(AuthRoutes.registerPhone);
  }

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
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'لطفا جهت ثبت‌نام، موارد زیر را وارد نمایید.',
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          AuthTextField(
            controller: _firstNameController,
            hintText: 'نام',
          ),
          AuthGaps.primaryButtonGap,
          AuthTextField(
            controller: _lastNameController,
            hintText: 'نام خانوادگی',
          ),
          AuthGaps.beforePrimaryButton,
          AuthPrimaryButton(
            label: 'ادامه',
            onPressed: _submit,
          ),
          const AuthSocialSection(),
          AuthGaps.beforeFooter,
          const AuthPrivacyFooter(),
        ],
      ),
    );
  }
}
