/// Relative / short Persian date helpers for dashboard lists.
class DashboardTime {
  DashboardTime._();

  static String relative(DateTime date, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final diff = n.difference(date);
    if (diff.inMinutes < 1) return 'همین الان';
    if (diff.inMinutes < 60) return '${diff.inMinutes} دقیقه پیش';
    if (diff.inHours < 24) return '${_fa(diff.inHours)} ساعت پیش';
    if (diff.inDays == 1) return 'دیروز';
    if (diff.inDays < 7) return '${_fa(diff.inDays)} روز پیش';
    if (diff.inDays < 30) return '${_fa((diff.inDays / 7).floor())} هفته پیش';
    return '${_fa((diff.inDays / 30).floor())} ماه پیش';
  }

  static String _fa(int n) {
    const digits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    return n.toString().split('').map((c) {
      final i = int.tryParse(c);
      return i == null ? c : digits[i];
    }).join();
  }
}
