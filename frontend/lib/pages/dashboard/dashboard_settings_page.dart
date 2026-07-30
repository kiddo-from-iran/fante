import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

class DashboardSettingsPage extends StatelessWidget {
  const DashboardSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardShell(
      active: DashboardSection.settings,
      child: _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1000;

        final rightColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _ProfileSummaryCard(),
            SizedBox(height: 16),
            _AvatarPickerCard(),
          ],
        );

        const middleColumn = _PersonalInfoCard();

        final leftColumn = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _SocialMediaCard(),
            SizedBox(height: 16),
            _QuickSettingsCard(),
          ],
        );

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              rightColumn,
              const SizedBox(height: 16),
              middleColumn,
              const SizedBox(height: 16),
              leftColumn,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: rightColumn),
            const SizedBox(width: 16),
            const Expanded(flex: 5, child: middleColumn),
            const SizedBox(width: 16),
            Expanded(flex: 3, child: leftColumn),
          ],
        );
      },
    );
  }
}

// ===========================================================================
// Profile summary (right column top)
// ===========================================================================

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard();

  static const _stats = [
    ('تست های کامل شده', '30'),
    ('کوییزهای کامل شده', '45'),
    ('نظرسنجی‌ها', '12'),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.surfaceCard,
                backgroundImage: AssetImage(DashboardAssets.avatar),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'آرین کاوشگر',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: AppColors.primaryGold),
                        const SizedBox(width: 4),
                        Text(
                          '@arian',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '15,400 XP',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 11,
                            color: AppColors.primaryGold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.4,
                              minHeight: 6,
                              backgroundColor: AppColors.backgroundDark,
                              valueColor: AlwaysStoppedAnimation(
                                  AppColors.primaryGold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'سطح 15',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: _stats
                  .map(
                    (s) => Expanded(
                      child: Column(
                        children: [
                          Text(
                            s.$2,
                            style: AppTextTheme.getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Icon(Icons.workspace_premium_rounded,
                              size: 16, color: AppColors.primaryGold),
                          const SizedBox(height: 6),
                          Text(
                            s.$1,
                            textAlign: TextAlign.center,
                            style: AppTextTheme.getTextStyle(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metaLine('ایران - تهران'),
              _metaLine('fantequiz.ir/arin'),
              _metaLine('عضو از 1405/06/24'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaLine(String text) => Text(
        text,
        style: AppTextTheme.getTextStyle(
          fontSize: 10,
          color: AppColors.textMuted,
        ),
      );
}

// ===========================================================================
// Avatar picker (right column bottom)
// ===========================================================================

class _AvatarPickerCard extends StatelessWidget {
  const _AvatarPickerCard();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textLight,
                  side: const BorderSide(color: AppColors.cardBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'اپلود عکس',
                  style: AppTextTheme.getTextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'تغییر آواتار',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'یک آواتار برای نمایش در پروفایل خود انتخاب کنید',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final selected = index == 0;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? AppColors.primaryGold
                        : AppColors.cardBorder,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image.asset(
                    DashboardAssets.avatar,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGold,
                    side: BorderSide(
                      color: AppColors.primaryGold.withValues(alpha: 0.6),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'حذف آواتار',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundDark,
                    foregroundColor: AppColors.textLight,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ثبت آواتار',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Personal info (middle column)
// ===========================================================================

class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'اطلاعات شخصی',
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اطلاعات عمومی خود را ویرایش کنید',
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          const _LabeledField(
            label: 'نام و نام خانوادگی',
            hint: 'نام و نام خانوادگی',
          ),
          const _LabeledField(label: 'نام کاربری', hint: 'نام کاربری'),
          const _LabeledField(label: 'ایمیل', hint: 'sakdakdakd@gmail.com'),
          const _LabeledField(
            label: 'بیوگرافی',
            hint: 'علاقه‌مند به تاریخ، انیمه، کوییزهای جذاب...',
            maxLines: 4,
          ),
          Row(
            children: const [
              Expanded(
                child: _LabeledField(label: 'کشور', hint: 'ایران'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'تاریخ تولد',
                  hint: '1380/07/30',
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Expanded(
                child: _LabeledField(label: 'شهر', hint: 'فارس'),
              ),
              SizedBox(width: 12),
              Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.backgroundDark,
                foregroundColor: AppColors.textLight,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'ثبت تغییرات',
                style: AppTextTheme.getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  final String label;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: maxLines,
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextTheme.getTextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.backgroundDark.withValues(alpha: 0.4),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primaryGold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Social media (left column top)
// ===========================================================================

class _SocialMediaCard extends StatelessWidget {
  const _SocialMediaCard();

  static const _socials = [
    ('اینستاگرام', Icons.camera_alt_rounded, Color(0xFFE1306C)),
    ('تلگرام', Icons.send_rounded, Color(0xFF229ED9)),
    ('واتساپ', Icons.chat_rounded, Color(0xFF25D366)),
    ('ایکس', Icons.close_rounded, Color(0xFF1A1A1A)),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'شبکه های اجتماعی',
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'حساب‌های اجتماعی خود را متصل کنید',
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          ..._socials.map(
            (social) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chevron_left_rounded,
                            size: 16, color: AppColors.textMuted),
                        Text(
                          'متصل نشده',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: social.$3,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(social.$2,
                        size: 20, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Quick settings (left column bottom)
// ===========================================================================

class _QuickSettingsCard extends StatelessWidget {
  const _QuickSettingsCard();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'تنظیمات سریع',
            textAlign: TextAlign.right,
            style: AppTextTheme.getTextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 16),
          _QuickSettingRow(
            label: 'تغییر رمزعبور',
            icon: Icons.lock_outline_rounded,
          ),
          const Divider(color: AppColors.cardBorder, height: 24),
          _QuickSettingRow(
            label: 'نوتیفیکیشن ها',
            icon: Icons.notifications_none_rounded,
          ),
          const Divider(color: AppColors.cardBorder, height: 24),
          _QuickSettingRow(
            label: 'حذف حساب کاربری',
            icon: Icons.delete_outline_rounded,
            danger: true,
          ),
        ],
      ),
    );
  }
}

class _QuickSettingRow extends StatelessWidget {
  const _QuickSettingRow({
    required this.label,
    required this.icon,
    this.danger = false,
  });

  final String label;
  final IconData icon;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.errorColor : AppColors.textLight;
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const Spacer(),
          Text(
            label,
            style: AppTextTheme.getTextStyle(
              fontSize: 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
