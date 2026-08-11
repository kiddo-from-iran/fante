import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/widgets/auth_nav_bar.dart';
import 'package:frontend/pages/game/utils/game_picture_helper.dart';
import 'package:frontend/theme/app_colors.dart';

class GameLayout {
  GameLayout._();

  static const maxContentWidth = 1100.0;
  static const sidebarWidth = 260.0;
  static const mainFlex = 3;
  static const sidebarFlex = 2;
}

class GameScaffold extends StatelessWidget {
  const GameScaffold({
    super.key,
    required this.backgroundAsset,
    required this.child,
  });

  final String backgroundAsset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Isolate background so option selection rebuilds do not re-blur.
            RepaintBoundary(
              child: _StableBlurredBackground(picture: backgroundAsset),
            ),
            SafeArea(
              child: Column(
                children: [
                  const AuthNavBar(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: GameLayout.maxContentWidth,
                          ),
                          child: child,
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

class _StableBlurredBackground extends StatefulWidget {
  const _StableBlurredBackground({required this.picture});

  final String picture;

  @override
  State<_StableBlurredBackground> createState() =>
      _StableBlurredBackgroundState();
}

class _StableBlurredBackgroundState extends State<_StableBlurredBackground> {
  late String _picture = widget.picture;

  @override
  void didUpdateWidget(covariant _StableBlurredBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.picture != widget.picture) {
      _picture = widget.picture;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GamePictureHelper.image(picture: _picture),
        // Light overlay instead of heavy live blur (much smoother on Chrome).
        const ColoredBox(color: Color(0x66000000)),
      ],
    );
  }
}

class GameSessionLayout extends StatelessWidget {
  const GameSessionLayout({
    super.key,
    required this.main,
    required this.sidebar,
    this.footer,
  });

  final Widget main;
  final Widget sidebar;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 760;
        final row = stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sidebar,
                  const SizedBox(height: 16),
                  main,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Swapped vs previous: game-info on the start (right in RTL).
                  SizedBox(
                    width: GameLayout.sidebarWidth,
                    child: sidebar,
                  ),
                  const SizedBox(width: 16),
                  Expanded(flex: GameLayout.mainFlex, child: main),
                ],
              );

        if (footer == null) return row;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            row,
            const SizedBox(height: 20),
            footer!,
          ],
        );
      },
    );
  }
}
