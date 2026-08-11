import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/widgets/auth_nav_bar.dart';
import 'package:frontend/pages/profile/profile_assets.dart';
import 'package:frontend/theme/app_colors.dart';

class ProfileLayout {
  ProfileLayout._();

  static const maxContentWidth = 1280.0;
  static const sectionGap = 16.0;

  // Legacy constants kept for older profile widgets.
  static const avatarRadius = 48.0;
  static const xpBarWidth = 190.0;
}

class ProfileScaffold extends StatefulWidget {
  const ProfileScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ProfileScaffold> createState() => _ProfileScaffoldState();
}

class _ProfileScaffoldState extends State<ProfileScaffold> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ProfileAssets.background,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
            const ColoredBox(color: Color(0x8C000000)),
            SafeArea(
              child: Column(
                children: [
                  const AuthNavBar(),
                  Expanded(
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: ProfileLayout.maxContentWidth,
                            ),
                            child: widget.child,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
