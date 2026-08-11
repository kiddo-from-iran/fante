import 'package:flutter/foundation.dart';
import 'package:frontend/data/repository/profile_repository.dart';
import 'package:frontend/models/player_profile_model.dart';
import 'package:frontend/pages/dashboard/data/dashboard_local_store.dart';
import 'package:frontend/pages/dashboard/data/dashboard_models.dart';
import 'package:frontend/pages/dashboard/data/dashboard_remote.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/dashboard/tickets/player_ticket.dart';
import 'package:frontend/pages/game/models/game_kind.dart';

/// Aggregates profile API + local/remote dashboard feeds for `/dashboard`.
class DashboardController extends ChangeNotifier {
  DashboardController({
    ProfileRepository? profileRepo,
    DashboardRemoteData? remote,
    DashboardLocalStore? local,
  })  : _profileRepo = profileRepo ?? profileRepository,
        _remote = remote ?? DashboardRemoteData(),
        _local = local ?? DashboardLocalStore.instance;

  final ProfileRepository _profileRepo;
  final DashboardRemoteData _remote;
  final DashboardLocalStore _local;

  bool loading = false;
  String? error;
  PlayerProfile? profile;

  List<DashboardBadge> badges = const [];
  List<DashboardAnnouncement> announcements = const [];
  List<DashboardNotification> notifications = const [];
  List<DashboardReview> reviews = const [];
  List<DashboardActivityPoint> activitySeries = const [];
  List<PlayerTicket> recentTickets = const [];
  List<PlayerGame> incompleteGames = const [];
  DashboardRatingsSummary? ratings;

  List<PlayerActivity> get recentActivities {
    final fromProfile = profile?.recentActivities ?? const [];
    if (fromProfile.isNotEmpty) return fromProfile;
    return _syntheticActivities();
  }

  List<PlayerActivity> _syntheticActivities() {
    final games = PlayerGamesStore.instance.all;
    return [
      for (var i = 0; i < games.length && i < 8; i++)
        PlayerActivity(
          id: i + 1,
          title: games[i].title,
          activityType: games[i].kind == GameKind.poll
              ? 'poll'
              : games[i].kind == GameKind.personality
                  ? 'vote'
                  : 'quiz',
          pointsEarned: games[i].isPublished ? 50 : 10,
          completedAt: games[i].createdAt,
        ),
    ];
  }

  int _unreadCount = 0;

  int get unreadNotificationCount => _unreadCount;

  void _recomputeUnread() {
    _unreadCount = notifications.where((n) => !n.isRead).length;
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      try {
        profile = await _profileRepo.getMyProfile();
      } catch (_) {
        profile = null;
      }

      // Load independent remote feeds in parallel.
      final results = await Future.wait([
        _tryList(_remote.fetchBadges, _local.latestBadges(count: 20)),
        _tryList(_remote.fetchAnnouncements, _local.announcements),
        _tryList(
          _remote.fetchNotifications,
          List<DashboardNotification>.from(_local.notifications),
        ),
        _tryList(
          _remote.fetchReviews,
          List<DashboardReview>.from(_local.reviews),
        ),
        _tryList(_remote.fetchActivitySeries, _local.activitySeries()),
      ]);

      badges = results[0] as List<DashboardBadge>;
      announcements = results[1] as List<DashboardAnnouncement>;
      notifications = results[2] as List<DashboardNotification>;
      reviews = results[3] as List<DashboardReview>;
      activitySeries = results[4] as List<DashboardActivityPoint>;
      _recomputeUnread();

      recentTickets = _local.recentTickets();
      incompleteGames = _local.incompleteGames();
      ratings = _buildRatings(reviews);
    } catch (e) {
      error = e.toString();
      _applyLocalFallback();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void refreshLocalSlices() {
    recentTickets = _local.recentTickets();
    incompleteGames = _local.incompleteGames();
    if (activitySeries.isEmpty || profile == null) {
      activitySeries = _local.activitySeries();
    }
    notifyListeners();
  }

  Future<void> markNotificationRead(String id) async {
    for (final n in notifications) {
      if (n.id == id) n.isRead = true;
    }
    _recomputeUnread();
    _local.markNotificationRead(id);
    notifyListeners();
    try {
      await _remote.markNotificationRead(id);
    } catch (_) {}
  }

  Future<void> markAllNotificationsRead() async {
    for (final n in notifications) {
      n.isRead = true;
    }
    _recomputeUnread();
    _local.markAllNotificationsRead();
    notifyListeners();
    try {
      await _remote.markAllNotificationsRead();
    } catch (_) {}
  }

  int publishedCount(GameKind kind) => _local.createdCount(kind);

  void _applyLocalFallback() {
    badges = _local.latestBadges(count: 20);
    announcements = _local.announcements;
    notifications = List<DashboardNotification>.from(_local.notifications);
    reviews = List<DashboardReview>.from(_local.reviews);
    activitySeries = _local.activitySeries();
    recentTickets = _local.recentTickets();
    incompleteGames = _local.incompleteGames();
    ratings = _local.ratingsSummary();
    _recomputeUnread();
  }

  DashboardRatingsSummary _buildRatings(List<DashboardReview> items) {
    if (items.isEmpty) return _local.ratingsSummary();
    final total = items.length;
    var sum = 0;
    final counts = List<int>.filled(5, 0);
    for (final r in items) {
      final s = r.stars.clamp(1, 5);
      sum += s;
      counts[5 - s] += 1;
    }
    final latest = [...items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return DashboardRatingsSummary(
      average: sum / total,
      totalCount: total,
      starShares: counts.map((c) => c / total).toList(),
      latest: latest,
    );
  }

  Future<List<T>> _tryList<T>(
    Future<List<T>> Function() remote,
    List<T> fallback,
  ) async {
    try {
      final result = await remote();
      if (result.isEmpty) return fallback;
      return result;
    } catch (_) {
      return fallback;
    }
  }
}

/// Shared app-wide controller so the top-bar badge stays in sync.
final dashboardController = DashboardController();
