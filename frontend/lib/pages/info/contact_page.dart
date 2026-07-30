import 'package:flutter/material.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/pages/info/widgets/info_page_scaffold.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      AppToast.error(context, 'لطفاً نام و پیام را وارد کنید.');
      return;
    }
    AppToast.success(context, 'پیام شما با موفقیت ثبت شد. به‌زودی پاسخ می‌دهیم.');
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return InfoPageScaffold(
      title: 'تماس با ما',
      subtitle: 'سوال، پیشنهاد یا گزارشی دارید؟ خوشحال می‌شویم بشنویم.',
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 720;
              final cards = [
                const _ContactInfoTile(
                  icon: Icons.email_outlined,
                  title: 'ایمیل',
                  value: 'support@fantequiz.com',
                ),
                const _ContactInfoTile(
                  icon: Icons.access_time_rounded,
                  title: 'ساعات پاسخگویی',
                  value: 'همه‌روزه ۹ صبح تا ۹ شب',
                ),
                const _ContactInfoTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'شبکه‌های اجتماعی',
                  value: 'از طریق آیکون‌های فوتر',
                ),
              ];

              if (!wide) {
                return Column(
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      cards[i],
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 14),
                    Expanded(child: cards[i]),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final formCard = InfoSectionCard(
                title: 'ارسال پیام',
                child: _ContactFormFields(
                  nameController: _nameController,
                  emailController: _emailController,
                  subjectController: _subjectController,
                  messageController: _messageController,
                  onSubmit: _submit,
                ),
              );

              if (constraints.maxWidth < 780) {
                return Column(
                  children: [
                    Image.asset(
                      HomeAssets.phoenixContact,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    formCard,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: formCard),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: Image.asset(
                      HomeAssets.phoenixContact,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactFormFields extends StatelessWidget {
  const _ContactFormFields({
    required this.nameController,
    required this.emailController,
    required this.subjectController,
    required this.messageController,
    required this.onSubmit,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 420) {
              return Column(
                children: [
                  _ContactField(
                    label: 'نام',
                    controller: nameController,
                    hint: 'نام شما',
                  ),
                  const SizedBox(height: 14),
                  _ContactField(
                    label: 'ایمیل',
                    controller: emailController,
                    hint: 'email@example.com',
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: _ContactField(
                    label: 'نام',
                    controller: nameController,
                    hint: 'نام شما',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ContactField(
                    label: 'ایمیل',
                    controller: emailController,
                    hint: 'email@example.com',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        _ContactField(
          label: 'موضوع',
          controller: subjectController,
          hint: 'موضوع پیام',
        ),
        const SizedBox(height: 14),
        _ContactField(
          label: 'پیام',
          controller: messageController,
          hint: 'متن پیام خود را بنویسید...',
          maxLines: 6,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.textBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ارسال پیام',
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _ContactInfoTile extends StatelessWidget {
  const _ContactInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return InfoSectionCard(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGold, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextTheme.getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactField extends StatelessWidget {
  const _ContactField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.getTextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: AppColors.primaryGold,
          style: AppTextTheme.getTextStyle(
            color: AppColors.textLight,
            fontSize: 13,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextTheme.getTextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.transparent,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryGold),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryGold),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGold,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
