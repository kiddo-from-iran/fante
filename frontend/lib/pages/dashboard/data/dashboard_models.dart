import 'package:frontend/pages/dashboard/dashboard_assets.dart';

class DashboardBadge {
  const DashboardBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.assetPath,
    required this.earnedAt,
  });

  final String id;
  final String title;
  final String description;
  final String assetPath;
  final DateTime earnedAt;
}

class DashboardAnnouncement {
  const DashboardAnnouncement({
    required this.id,
    required this.title,
    required this.body,
    required this.publishedAt,
    this.isPinned = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime publishedAt;
  final bool isPinned;
}

class DashboardNotification {
  DashboardNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.linkRoute,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  bool isRead;
  final String? linkRoute;
}

class DashboardReview {
  const DashboardReview({
    required this.id,
    required this.authorName,
    required this.comment,
    required this.stars,
    required this.createdAt,
    required this.gameTitle,
    this.avatarAsset = DashboardAssets.avatar,
  });

  final String id;
  final String authorName;
  final String comment;
  final int stars;
  final DateTime createdAt;
  final String gameTitle;
  final String avatarAsset;
}

class DashboardRatingsSummary {
  const DashboardRatingsSummary({
    required this.average,
    required this.totalCount,
    required this.starShares,
    required this.latest,
  });

  final double average;
  final int totalCount;

  /// Index 0 = 5 stars … index 4 = 1 star, each 0–1.
  final List<double> starShares;
  final List<DashboardReview> latest;
}

class DashboardActivityPoint {
  const DashboardActivityPoint({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;
}
