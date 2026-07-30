import 'package:flutter/material.dart';

/// Identifies which dashboard destination is currently active.
enum DashboardSection {
  dashboard,
  myQuizzes,
  myTests,
  settings,
  myPolls,
  tickets,
  feedback,
  logout,
}

class DashboardNavItem {
  const DashboardNavItem({
    required this.section,
    required this.label,
    required this.icon,
    this.route,
    this.isLogout = false,
  });

  final DashboardSection section;
  final String label;
  final IconData icon;

  /// Named route to navigate to. When null the item is a not-yet-wired stub.
  final String? route;
  final bool isLogout;
}
