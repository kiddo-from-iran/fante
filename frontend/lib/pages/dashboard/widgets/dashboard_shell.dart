import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_nav.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_sidebar.dart';
import 'package:frontend/pages/dashboard/widgets/dashboard_top_bar.dart';
import 'package:frontend/theme/app_colors.dart';

/// Shared dashboard chrome: background, top bar and right-side sidebar.
///
/// The sidebar spans the full height (covering the top-bar row on the right).
/// A hamburger control expands / collapses it for more content space.
class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.active,
    required this.child,
  });

  final DashboardSection active;
  final Widget child;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  bool _sidebarExpanded = true;

  void _toggleSidebar() {
    setState(() => _sidebarExpanded = !_sidebarExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        const DashboardTopBar(),
                        Expanded(
                          child: ClipRect(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: widget.child,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: DashboardSidebar(
                    active: widget.active,
                    expanded: _sidebarExpanded,
                    onToggle: _toggleSidebar,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
