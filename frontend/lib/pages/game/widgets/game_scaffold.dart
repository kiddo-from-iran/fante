import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/pages/auth/widgets/auth_nav_bar.dart';
import 'package:frontend/theme/app_colors.dart';

class GameLayout {
  GameLayout._();

  static const maxContentWidth = 980.0;
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
            Image.asset(backgroundAsset, fit: BoxFit.cover),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withValues(alpha: 0.25)),
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

class GameSessionLayout extends StatelessWidget {
  const GameSessionLayout({
    super.key,
    required this.main,
    required this.sidebar,
  });

  final Widget main;
  final Widget sidebar;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              main,
              const SizedBox(height: 16),
              sidebar,
            ],
          );
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: GameLayout.mainFlex, child: main),
              const SizedBox(width: 16),
              SizedBox(
                width: GameLayout.sidebarWidth,
                child: sidebar,
              ),
            ],
          ),
        );
      },
    );
  }
}
