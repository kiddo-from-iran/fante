import 'package:frontend/pages/dashboard/dashboard_assets.dart';
import 'package:frontend/pages/dashboard/data/dashboard_models.dart';
import 'package:frontend/pages/dashboard/game_editor/player_game.dart';
import 'package:frontend/pages/dashboard/tickets/player_ticket.dart';
import 'package:frontend/pages/game/models/game_kind.dart';

/// Local seed / fallback data until (or when) remote dashboard APIs fail.
class DashboardLocalStore {
  DashboardLocalStore._();

  static final DashboardLocalStore instance = DashboardLocalStore._();

  final List<DashboardBadge> badges = [
    DashboardBadge(
      id: 'b1',
      title: 'مخترع',
      description: 'اولین بازی خود را منتشر کردید',
      assetPath: DashboardAssets.badgeSilver,
      earnedAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    DashboardBadge(
      id: 'b2',
      title: 'تست ساز',
      description: 'سه تست شخصیت ساختید',
      assetPath: DashboardAssets.badgeBronze,
      earnedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    DashboardBadge(
      id: 'b3',
      title: 'نظرسنجی حرفه‌ای',
      description: 'پنج نظرسنجی فعال دارید',
      assetPath: DashboardAssets.badgeBronze,
      earnedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    DashboardBadge(
      id: 'b4',
      title: 'کوییزمستر',
      description: 'ده کوییز منتشر کردید',
      assetPath: DashboardAssets.badgeSilver,
      earnedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<DashboardAnnouncement> announcements = [
    DashboardAnnouncement(
      id: 'a1',
      title: 'آپدیت جدید بازی‌ها',
      body:
          'امکان افزودن تصویر پس‌زمینه هنگام پخش بازی اضافه شد. از داشبورد بازی‌ها می‌توانید آن را تنظیم کنید.',
      publishedAt: DateTime(2026, 5, 13),
      isPinned: true,
    ),
    DashboardAnnouncement(
      id: 'a2',
      title: 'مراقب اطلاعاتتان باشید',
      body:
          'هرگز رمز عبور یا کد تأیید را با دیگران به اشتراک نگذارید. پشتیبانی فنت‌کوییز هرگز آن‌ها را نمی‌پرسد.',
      publishedAt: DateTime(2026, 5, 13),
    ),
    DashboardAnnouncement(
      id: 'a3',
      title: 'پروفایل شما به‌روز شد',
      body: 'سطح‌بندی و نشان‌ها در پروفایل عمومی نمایش داده می‌شوند.',
      publishedAt: DateTime(2026, 5, 10),
    ),
    DashboardAnnouncement(
      id: 'a4',
      title: 'مسابقه هفتگی',
      body: 'با ساخت سه کوییز این هفته شانس برنده شدن نشان ویژه را دارید.',
      publishedAt: DateTime(2026, 5, 5),
    ),
  ];

  final List<DashboardNotification> notifications = [
    DashboardNotification(
      id: 'n1',
      title: 'پاسخ تیکت شما',
      body: 'پشتیبانی به تیکت «مشکل در انتشار کوییز» پاسخ داد.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      linkRoute: '/dashboard/tickets',
    ),
    DashboardNotification(
      id: 'n2',
      title: 'بازی منتشر شد',
      body: 'کوییز «دنیای انیمه» با موفقیت منتشر شد.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      linkRoute: '/dashboard/games',
    ),
    DashboardNotification(
      id: 'n3',
      title: 'نظر جدید',
      body: 'یک کاربر به بازی شما ۵ ستاره داد.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      linkRoute: '/dashboard/reviews',
    ),
    DashboardNotification(
      id: 'n4',
      title: 'اعلان سیستم',
      body: 'نسخه جدید داشبورد در دسترس است.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      linkRoute: '/dashboard/announcements',
    ),
  ];

  final List<DashboardReview> reviews = [
    DashboardReview(
      id: 'r1',
      authorName: 'سارا م.',
      comment: 'کوییز خیلی جذاب و حرفه‌ای بود، ممنون!',
      stars: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      gameTitle: 'دنیای انیمه',
    ),
    DashboardReview(
      id: 'r2',
      authorName: 'رضا ک.',
      comment: 'سوالات خوب بود ولی بعضی گزینه‌ها مبهم بودند.',
      stars: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      gameTitle: 'دنیای انیمه',
    ),
    DashboardReview(
      id: 'r3',
      authorName: 'نیما پ.',
      comment: 'نظرسنجی عالی برای تصمیم‌گیری گروهی.',
      stars: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      gameTitle: 'نظرسنجی فصل جدید',
    ),
    DashboardReview(
      id: 'r4',
      authorName: 'مینا ش.',
      comment: 'تست شخصیت سرگرم‌کننده بود.',
      stars: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      gameTitle: 'تست شخصیت ماجراجو',
    ),
  ];

  List<DashboardBadge> latestBadges({int count = 3}) {
    final sorted = [...badges]
      ..sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
    return sorted.take(count).toList();
  }

  List<PlayerTicket> recentTickets({int count = 3}) {
    final tickets = [...PlayerTicketsStore.instance.all]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return tickets.take(count).toList();
  }

  List<PlayerGame> incompleteGames({int count = 5}) {
    final drafts = PlayerGamesStore.instance.all
        .where((g) => !g.isPublished)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return drafts.take(count).toList();
  }

  DashboardRatingsSummary ratingsSummary() {
    if (reviews.isEmpty) {
      return const DashboardRatingsSummary(
        average: 0,
        totalCount: 0,
        starShares: [0, 0, 0, 0, 0],
        latest: [],
      );
    }
    final total = reviews.length;
    var sum = 0;
    final counts = List<int>.filled(5, 0);
    for (final r in reviews) {
      sum += r.stars.clamp(1, 5);
      counts[5 - r.stars.clamp(1, 5)] += 1;
    }
    final shares = counts.map((c) => c / total).toList();
    final latest = [...reviews]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return DashboardRatingsSummary(
      average: sum / total,
      totalCount: total,
      starShares: shares,
      latest: latest,
    );
  }

  /// Monthly activity from local games + reviews (normalized 0–1).
  List<DashboardActivityPoint> activitySeries() {
    final now = DateTime.now();
    final buckets = <String, int>{};
    final labels = <String>[];

    for (var i = 11; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
      labels.add(key);
      buckets[key] = 0;
    }

    for (final g in PlayerGamesStore.instance.all) {
      final key =
          '${g.createdAt.year}-${g.createdAt.month.toString().padLeft(2, '0')}';
      if (buckets.containsKey(key)) {
        buckets[key] = buckets[key]! + (g.isPublished ? 2 : 1);
      }
    }
    for (final r in reviews) {
      final key =
          '${r.createdAt.year}-${r.createdAt.month.toString().padLeft(2, '0')}';
      if (buckets.containsKey(key)) {
        buckets[key] = buckets[key]! + 1;
      }
    }
    for (final t in PlayerTicketsStore.instance.all) {
      final key =
          '${t.createdAt.year}-${t.createdAt.month.toString().padLeft(2, '0')}';
      if (buckets.containsKey(key)) {
        buckets[key] = buckets[key]! + 1;
      }
    }

    final maxVal = buckets.values.fold<int>(0, (m, v) => v > m ? v : m);
    final denom = maxVal == 0 ? 1 : maxVal;

    return [
      for (final key in labels)
        DashboardActivityPoint(
          label: key.substring(5), // MM
          value: (buckets[key] ?? 0) / denom,
        ),
    ];
  }

  int createdCount(GameKind kind) => PlayerGamesStore.instance.all
      .where((g) => g.kind == kind && g.isPublished)
      .length;

  int draftCount(GameKind kind) => PlayerGamesStore.instance.all
      .where((g) => g.kind == kind && !g.isPublished)
      .length;

  void markNotificationRead(String id) {
    for (final n in notifications) {
      if (n.id == id) {
        n.isRead = true;
        break;
      }
    }
  }

  void markAllNotificationsRead() {
    for (final n in notifications) {
      n.isRead = true;
    }
  }

  int get unreadNotificationCount =>
      notifications.where((n) => !n.isRead).length;
}
