import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.textDirection,
    this.textAlign = TextAlign.right,
    this.prefixIcon,
    this.enabled = true,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final Widget? prefixIcon;
  final bool enabled;
  final bool obscureText;

  static TextStyle get _inputTextStyle => AppTextTheme.getTextStyle(
        color: AppColors.textBlack,
        fontSize: 15,
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textDirection: textDirection,
      textAlign: textAlign,
      style: _inputTextStyle,
      cursorColor: AppColors.textBlack,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextTheme.getTextStyle(
          color: AppColors.inputHint,
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppColors.inputBackground,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
