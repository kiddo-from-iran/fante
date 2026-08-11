import 'package:flutter/material.dart';
import 'package:frontend/common/user_avatar.dart';
import 'package:frontend/data/repository/auth_repository.dart';
import 'package:frontend/data/repository/profile_repository.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/data/dashboard_controller.dart';
import 'package:frontend/pages/dashboard/data/player_settings_store.dart';
import 'package:frontend/pages/dashboard/game_editor/question_tools/image_pick_helper.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_shell.dart';
import 'package:frontend/pages/home/home_assets.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';
import 'package:frontend/utils/jalali_date.dart';
import 'package:frontend/widgets/toast/app_toast.dart';

class DashboardSettingsPage extends StatefulWidget {
  const DashboardSettingsPage({super.key});

  @override
  State<DashboardSettingsPage> createState() => _DashboardSettingsPageState();
}

class _DashboardSettingsPageState extends State<DashboardSettingsPage> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _birthdayController = TextEditingController();

  PlayerProfile? _profile;
  UserModel? _user;
  bool _loading = true;
  bool _saving = false;
  bool _savingAvatar = false;

  /// Selected preset asset, custom data-URL, or empty for default.
  String? _selectedAvatar;
  String? _customAvatarDataUrl;

  static const _presetAvatars = [
    HomeAssets.profile1,
    HomeAssets.profile2,
    HomeAssets.profile3,
    HomeAssets.profile4,
    HomeAssets.profile5,
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final authUser = AuthRepository.authChangeNotifier.value?.user;
      PlayerProfile? profile;
      try {
        profile = await profileRepository.getMyProfile();
      } catch (_) {
        profile = dashboardController.profile;
      }

      final user = profile?.user ?? authUser;
      final extras = await PlayerSettingsStore.instance.load(user?.id);

      _fullNameController.text = user?.fullName?.trim() ?? '';
      _emailController.text = user?.email?.trim() ?? '';
      _usernameController.text = extras['username'] ?? '';
      _bioController.text = extras['bio'] ?? '';
      _countryController.text =
          (extras['country']?.isNotEmpty ?? false) ? extras['country']! : 'ایران';
      _cityController.text = extras['city'] ?? '';
      _birthdayController.text = extras['birthday'] ?? '';

      final custom = extras['customAvatar'];
      final asset = extras['avatarAsset'];
      if (custom != null && custom.isNotEmpty) {
        _customAvatarDataUrl = custom;
        _selectedAvatar = custom;
      } else if (asset != null && asset.isNotEmpty) {
        _selectedAvatar = asset;
      } else if (user?.profilePicture != null &&
          user!.profilePicture!.isNotEmpty) {
        _selectedAvatar = user.profilePicture;
      } else {
        _selectedAvatar = _presetAvatars.first;
      }

      if (!mounted) return;
      setState(() {
        _profile = profile;
        _user = user;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppToast.error(context, 'خطا در بارگذاری تنظیمات');
    }
  }

  String get _effectiveAvatar =>
      _selectedAvatar ?? _presetAvatars.first;

  Future<void> _savePersonalInfo() async {
    final name = _fullNameController.text.trim();
    if (name.length < 2) {
      AppToast.warning(context, 'نام باید حداقل ۲ حرف باشد');
      return;
    }

    setState(() => _saving = true);
    try {
      final avatar = _effectiveAvatar;
      final apiPicture =
          avatar.startsWith('data:') ? _presetAvatars.first : avatar;

      await authRepository.applyProfileUpdate(
        fullName: name,
        email: _emailController.text.trim(),
        profilePicture: apiPicture,
      );

      await PlayerSettingsStore.instance.save(
        userId: _user?.id ??
            AuthRepository.authChangeNotifier.value?.userId,
        username: _usernameController.text.trim(),
        bio: _bioController.text.trim(),
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
        birthday: _birthdayController.text.trim(),
        customAvatar: avatar.startsWith('data:') ? avatar : '',
        avatarAsset: avatar.startsWith('data:') ? '' : avatar,
      );

      await dashboardController.load();
      if (!mounted) return;
      AppToast.success(context, 'تغییرات ذخیره شد');
      await _load();
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, 'ذخیره تنظیمات ناموفق بود');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickUpload() async {
    try {
      final dataUrl = await pickImageAsDataUrl();
      if (dataUrl == null || dataUrl.isEmpty) return;
      setState(() {
        _customAvatarDataUrl = dataUrl;
        _selectedAvatar = dataUrl;
      });
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, 'خطا در انتخاب تصویر');
    }
  }

  Future<void> _saveAvatar() async {
    setState(() => _savingAvatar = true);
    try {
      final avatar = _effectiveAvatar;
      final isCustom = avatar.startsWith('data:');

      await PlayerSettingsStore.instance.save(
        userId: _user?.id ??
            AuthRepository.authChangeNotifier.value?.userId,
        username: _usernameController.text.trim(),
        bio: _bioController.text.trim(),
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
        birthday: _birthdayController.text.trim(),
        customAvatar: isCustom ? avatar : '',
        avatarAsset: isCustom ? '' : avatar,
      );

      final apiPicture = isCustom ? _presetAvatars.first : avatar;
      final name = _fullNameController.text.trim().isEmpty
          ? (UserAvatarHelper.displayName(_user))
          : _fullNameController.text.trim();

      try {
        await authRepository.applyProfileUpdate(
          fullName: name,
          email: _emailController.text.trim(),
          profilePicture: apiPicture,
        );
      } catch (_) {}

      // Keep custom preview in auth cache via settings store; refresh dashboard.
      await dashboardController.load();
      if (!mounted) return;
      AppToast.success(context, 'آواتار ذخیره شد');
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      AppToast.error(context, 'ذخیره آواتار ناموفق بود');
    } finally {
      if (mounted) setState(() => _savingAvatar = false);
    }
  }

  Future<void> _clearAvatar() async {
    final userId =
        _user?.id ?? AuthRepository.authChangeNotifier.value?.userId;
    await PlayerSettingsStore.instance.clearAvatar(userId);
    setState(() {
      _customAvatarDataUrl = null;
      _selectedAvatar = _presetAvatars.first;
    });
    try {
      await authRepository.applyProfileUpdate(
        fullName: _fullNameController.text.trim().isEmpty
            ? UserAvatarHelper.displayName(_user)
            : _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        profilePicture: _presetAvatars.first,
      );
    } catch (_) {}
    if (!mounted) return;
    AppToast.success(context, 'آواتار به حالت پیش‌فرض برگشت');
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      active: DashboardSection.settings,
      child: _loading
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryGold),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final profileCard = _ProfileSummaryCard(
                  user: _user,
                  profile: _profile,
                  avatarPath: _effectiveAvatar,
                  username: _usernameController.text.trim(),
                  city: _cityController.text.trim(),
                  country: _countryController.text.trim(),
                );
                final avatarCard = _AvatarPickerCard(
                  presets: _presetAvatars,
                  selected: _effectiveAvatar,
                  customDataUrl: _customAvatarDataUrl,
                  saving: _savingAvatar,
                  onSelect: (path) => setState(() => _selectedAvatar = path),
                  onUpload: _pickUpload,
                  onSave: _saveAvatar,
                  onClear: _clearAvatar,
                );
                final infoCard = _PersonalInfoCard(
                  fullNameController: _fullNameController,
                  usernameController: _usernameController,
                  emailController: _emailController,
                  bioController: _bioController,
                  countryController: _countryController,
                  cityController: _cityController,
                  birthdayController: _birthdayController,
                  saving: _saving,
                  onSave: _savePersonalInfo,
                );

                if (!isWide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      profileCard,
                      const SizedBox(height: 16),
                      avatarCard,
                      const SizedBox(height: 16),
                      infoCard,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          profileCard,
                          const SizedBox(height: 16),
                          avatarCard,
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(flex: 5, child: infoCard),
                  ],
                );
              },
            ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
    required this.user,
    required this.profile,
    required this.avatarPath,
    required this.username,
    required this.city,
    required this.country,
  });

  final UserModel? user;
  final PlayerProfile? profile;
  final String avatarPath;
  final String username;
  final String city;
  final String country;

  @override
  Widget build(BuildContext context) {
    final stats = profile?.stats;
    final level = stats?.level;
    final name = UserAvatarHelper.displayName(user);
    final handle = username.isNotEmpty
        ? '@$username'
        : (user?.email?.contains('@') == true
            ? '@${user!.email!.split('@').first}'
            : '@player');
    final memberSince = user?.createdAt != null
        ? JalaliDate.format(user!.createdAt!)
        : '—';
    final location = [
      if (country.isNotEmpty) country,
      if (city.isNotEmpty) city,
    ].join(' - ');

    final statBoxes = [
      ('تست های کامل شده', '${stats?.pollsCompleted ?? 0}'),
      ('کوییزهای کامل شده', '${stats?.quizzesCompleted ?? 0}'),
      ('نظرسنجی‌ها', '${stats?.votesCompleted ?? 0}'),
    ];

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.surfaceCard,
                backgroundImage: UserAvatarHelper.providerFor(avatarPath),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      handle,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          level?.xpLabel ?? '0 XP',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 11,
                            color: AppColors.primaryGold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: level?.xpProgress.clamp(0.0, 1.0) ?? 0,
                              minHeight: 6,
                              backgroundColor: AppColors.backgroundDark,
                              valueColor: const AlwaysStoppedAnimation(
                                AppColors.primaryGold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          level == null ? 'سطح —' : 'سطح ${level.level}',
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
              children: [
                for (final s in statBoxes)
                  Expanded(
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
                        const Icon(
                          Icons.workspace_premium_rounded,
                          size: 16,
                          color: AppColors.primaryGold,
                        ),
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
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                location.isEmpty ? '—' : location,
                style: AppTextTheme.getTextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                'عضو از $memberSince',
                style: AppTextTheme.getTextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarPickerCard extends StatelessWidget {
  const _AvatarPickerCard({
    required this.presets,
    required this.selected,
    required this.customDataUrl,
    required this.saving,
    required this.onSelect,
    required this.onUpload,
    required this.onSave,
    required this.onClear,
  });

  final List<String> presets;
  final String selected;
  final String? customDataUrl;
  final bool saving;
  final ValueChanged<String> onSelect;
  final VoidCallback onUpload;
  final VoidCallback onSave;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final options = <String>[
      ...presets,
      if (customDataUrl != null && customDataUrl!.isNotEmpty) customDataUrl!,
    ];

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.surfaceCard,
                backgroundImage: UserAvatarHelper.providerFor(selected),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تغییر آواتار',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'یک آواتار آماده انتخاب کنید یا عکس خود را آپلود کنید',
                      textAlign: TextAlign.left,
                      style: AppTextTheme.getTextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: onUpload,
                        icon: const Icon(Icons.upload_rounded, size: 18),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGold,
                          side: BorderSide(
                            color:
                                AppColors.primaryGold.withValues(alpha: 0.7),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        label: Text(
                          'آپلود عکس',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 12,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final path in options)
                _AvatarOption(
                  path: path,
                  selected: selected == path,
                  onTap: () => onSelect(path),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: saving ? null : onClear,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGold,
                    side: BorderSide(
                      color: AppColors.primaryGold.withValues(alpha: 0.6),
                    ),
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'حذف آواتار',
                    style: AppTextTheme.getTextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: saving ? null : onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: AppColors.textBlack,
                    elevation: 0,
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'ثبت آواتار',
                          style: AppTextTheme.getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textBlack,
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

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.path,
    required this.selected,
    required this.onTap,
  });

  final String path;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 72,
        height: 72,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primaryGold : AppColors.cardBorder,
            width: selected ? 2.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withValues(alpha: 0.25),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CircleAvatar(
                backgroundImage: UserAvatarHelper.providerFor(path),
              ),
            ),
            if (selected)
              const Positioned(
                bottom: 0,
                left: 0,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.primaryGold,
                  child: Icon(Icons.check, size: 14, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PersonalInfoCard extends StatelessWidget {
  const _PersonalInfoCard({
    required this.fullNameController,
    required this.usernameController,
    required this.emailController,
    required this.bioController,
    required this.countryController,
    required this.cityController,
    required this.birthdayController,
    required this.saving,
    required this.onSave,
  });

  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController bioController;
  final TextEditingController countryController;
  final TextEditingController cityController;
  final TextEditingController birthdayController;
  final bool saving;
  final VoidCallback onSave;

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
          _LabeledField(
            label: 'نام و نام خانوادگی',
            controller: fullNameController,
            hint: 'نام و نام خانوادگی',
          ),
          _LabeledField(
            label: 'نام کاربری',
            controller: usernameController,
            hint: 'نام کاربری',
          ),
          _LabeledField(
            label: 'ایمیل',
            controller: emailController,
            hint: 'email@example.com',
          ),
          _LabeledField(
            label: 'بیوگرافی',
            controller: bioController,
            hint: 'علاقه‌مند به تاریخ، انیمه، کوییزهای جذاب...',
            maxLines: 4,
          ),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'کشور',
                  controller: countryController,
                  hint: 'ایران',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  label: 'تاریخ تولد',
                  controller: birthdayController,
                  hint: '1380/07/30',
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: 'شهر',
                  controller: cityController,
                  hint: 'تهران',
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: saving ? null : onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.textBlack,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'ثبت تغییرات',
                      style: AppTextTheme.getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
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
            controller: controller,
            maxLines: maxLines,
            textAlign: TextAlign.right,
            cursorColor: AppColors.primaryGold,
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
