import 'package:dio/dio.dart';
import 'package:frontend/common/constants.dart';
import 'package:frontend/data/network/http_client.dart';
import 'package:frontend/data/network/http_response_validator.dart';
import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/data/dashboard_models.dart';

/// Optional remote dashboard endpoints. Failures are swallowed by the controller.
class DashboardRemoteData with HttpResponseValidator {
  DashboardRemoteData([Dio? client]) : _client = client ?? httpClient;

  final Dio _client;

  Future<List<DashboardAnnouncement>> fetchAnnouncements() async {
    final raw = await validateResponse<List<dynamic>>(
      _client.get(Urls.dashboardAnnouncementsUrl),
    );
    return raw
        .map((e) => _announcementFromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DashboardNotification>> fetchNotifications() async {
    final raw = await validateResponse<List<dynamic>>(
      _client.get(Urls.dashboardNotificationsUrl),
    );
    return raw
        .map((e) => _notificationFromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markNotificationRead(String id) async {
    await validateResponse<dynamic>(
      _client.post(Urls.dashboardNotificationReadUrl(id)),
    );
  }

  Future<void> markAllNotificationsRead() async {
    await validateResponse<dynamic>(
      _client.post(Urls.dashboardNotificationsReadAllUrl),
    );
  }

  Future<List<DashboardBadge>> fetchBadges() async {
    final raw = await validateResponse<List<dynamic>>(
      _client.get(Urls.dashboardBadgesUrl),
    );
    return raw.map((e) => _badgeFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<DashboardReview>> fetchReviews() async {
    final raw = await validateResponse<List<dynamic>>(
      _client.get(Urls.dashboardReviewsUrl),
    );
    return raw.map((e) => _reviewFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<DashboardActivityPoint>> fetchActivitySeries() async {
    final raw = await validateResponse<List<dynamic>>(
      _client.get(Urls.dashboardActivitySeriesUrl),
    );
    return raw
        .map(
          (e) => DashboardActivityPoint(
            label: (e as Map<String, dynamic>)['label'] as String? ?? '',
            value: (e['value'] as num?)?.toDouble() ?? 0,
          ),
        )
        .toList();
  }

  DashboardAnnouncement _announcementFromJson(Map<String, dynamic> json) {
    return DashboardAnnouncement(
      id: '${json['id']}',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      publishedAt: DateTime.tryParse('${json['published_at']}') ??
          DateTime.now(),
      isPinned: json['is_pinned'] as bool? ?? false,
    );
  }

  DashboardNotification _notificationFromJson(Map<String, dynamic> json) {
    return DashboardNotification(
      id: '${json['id']}',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdAt:
          DateTime.tryParse('${json['created_at']}') ?? DateTime.now(),
      isRead: json['is_read'] as bool? ?? false,
      linkRoute: json['link_route'] as String?,
    );
  }

  DashboardBadge _badgeFromJson(Map<String, dynamic> json) {
    final asset = json['asset_key'] as String? ?? 'silver';
    return DashboardBadge(
      id: '${json['id']}',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      assetPath: asset == 'bronze'
          ? DashboardAssets.badgeBronze
          : DashboardAssets.badgeSilver,
      earnedAt:
          DateTime.tryParse('${json['earned_at']}') ?? DateTime.now(),
    );
  }

  DashboardReview _reviewFromJson(Map<String, dynamic> json) {
    return DashboardReview(
      id: '${json['id']}',
      authorName: json['author_name'] as String? ?? 'کاربر',
      comment: json['comment'] as String? ?? '',
      stars: json['stars'] as int? ?? 5,
      createdAt:
          DateTime.tryParse('${json['created_at']}') ?? DateTime.now(),
      gameTitle: json['game_title'] as String? ?? '',
    );
  }
}
