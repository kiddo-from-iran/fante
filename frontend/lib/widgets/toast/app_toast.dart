import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/theme/text_theme.dart';

enum AppToastType { error, success, warning, info }

/// Vue-style toast: slides in from the right, then slides out.
/// Brand style: orange background + black text.
class AppToast {
  AppToast._();

  /// Set from [MaterialApp.navigatorKey] so toasts work from any context.
  static GlobalKey<NavigatorState>? navigatorKey;

  static OverlayEntry? _current;

  static OverlayState? _resolveOverlay(BuildContext? context) {
    if (context != null) {
      final fromContext = Overlay.maybeOf(context, rootOverlay: true);
      if (fromContext != null) return fromContext;
    }
    return navigatorKey?.currentState?.overlay;
  }

  static void show(
    BuildContext? context,
    String message, {
    AppToastType type = AppToastType.error,
    Duration duration = const Duration(seconds: 3),
  }) {
    void insert() {
      final overlay = _resolveOverlay(context);
      if (overlay == null) return;

      _current?.remove();
      _current = null;

      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (_) => _ToastHost(
          message: message,
          type: type,
          duration: duration,
          onDone: () {
            entry.remove();
            if (_current == entry) _current = null;
          },
        ),
      );

      _current = entry;
      overlay.insert(entry);
    }

    // Wait one frame so navigation/overlay are ready (login → home).
    WidgetsBinding.instance.addPostFrameCallback((_) => insert());
  }

  static void error(BuildContext? context, String message) =>
      show(context, message, type: AppToastType.error);

  static void success(BuildContext? context, String message) =>
      show(context, message, type: AppToastType.success);

  static void warning(BuildContext? context, String message) =>
      show(context, message, type: AppToastType.warning);

  static void info(BuildContext? context, String message) =>
      show(context, message, type: AppToastType.info);
}

class _ToastHost extends StatefulWidget {
  const _ToastHost({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDone,
  });

  final String message;
  final AppToastType type;
  final Duration duration;
  final VoidCallback onDone;

  @override
  State<_ToastHost> createState() => _ToastHostState();
}

class _ToastHostState extends State<_ToastHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      reverseDuration: const Duration(milliseconds: 260),
    );

    _slide = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();
    Future<void>.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) widget.onDone();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData get _icon {
    switch (widget.type) {
      case AppToastType.error:
        return Icons.error_outline_rounded;
      case AppToastType.success:
        return Icons.check_circle_outline_rounded;
      case AppToastType.warning:
        return Icons.warning_amber_rounded;
      case AppToastType.info:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _fade,
                child: Material(
                  color: Colors.transparent,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 280,
                      maxWidth: 420,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.28),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 4),
                            child: Icon(
                              _icon,
                              color: AppColors.textBlack,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 14,
                              ),
                              child: Text(
                                widget.message,
                                style: AppTextTheme.getTextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _dismiss,
                            iconSize: 16,
                            color: AppColors.textBlack,
                            splashRadius: 16,
                            tooltip: 'بستن',
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
