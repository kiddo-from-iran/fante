import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class TopNavBar extends StatelessWidget {
  final VoidCallback onSettings;
  final VoidCallback onToggleTheme;
  final VoidCallback onNotifications;

  const TopNavBar({
    super.key,
    required this.onSettings,
    required this.onToggleTheme,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.grey.shade100,
      child: Row(
        children: [
          // 🔹 Draggable area + logo
          Expanded(
            child: DragToMoveArea(
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.layers, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Avesta',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 App action buttons
          _IconButton(
            icon: Icons.settings,
            tooltip: 'Settings',
            onTap: onSettings,
          ),
          _IconButton(
            icon: Icons.dark_mode,
            tooltip: 'Toggle theme',
            onTap: onToggleTheme,
          ),
          _IconButton(
            icon: Icons.notifications_none,
            tooltip: 'Notifications',
            onTap: onNotifications,
          ),

          const SizedBox(width: 8),

          // 🔹 Window controls
          _WindowButton(
            icon: Icons.minimize,
            onTap: () => windowManager.minimize(),
          ),
          _WindowButton(
            icon: Icons.crop_square,
            onTap: () async {
              if (await windowManager.isMaximized()) {
                windowManager.restore();
              } else {
                windowManager.maximize();
              }
            },
          ),
          _WindowButton(
            icon: Icons.close,
            hoverColor: Colors.red,
            onTap: () => windowManager.close(),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? hoverColor;

  const _WindowButton({
    required this.icon,
    required this.onTap,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: hoverColor?.withOpacity(0.2),
      child: SizedBox(
        width: 46,
        height: 40,
        child: Icon(icon, size: 16),
      ),
    );
  }
}

