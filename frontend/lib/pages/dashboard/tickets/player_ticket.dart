import 'package:flutter/material.dart';
import 'package:frontend/theme/app_colors.dart';

enum TicketPriority { low, medium, high }

enum TicketStatus { open, inReview, answered, closed }

extension TicketPriorityX on TicketPriority {
  String get label {
    switch (this) {
      case TicketPriority.low:
        return 'پایین';
      case TicketPriority.medium:
        return 'متوسط';
      case TicketPriority.high:
        return 'بالا';
    }
  }
}

extension TicketStatusX on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.open:
        return 'باز';
      case TicketStatus.inReview:
        return 'درحال بررسی';
      case TicketStatus.answered:
        return 'پاسخ داده شده';
      case TicketStatus.closed:
        return 'بسته';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.open:
        return const Color(0xFF2D4A7A);
      case TicketStatus.inReview:
        return const Color(0xFFB8862B);
      case TicketStatus.answered:
        return const Color(0xFF2D7D46);
      case TicketStatus.closed:
        return AppColors.hoverButton;
    }
  }
}

class PlayerTicket {
  PlayerTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  final String id;
  String subject;
  String description;
  TicketPriority priority;
  TicketStatus status;
  DateTime createdAt;
  DateTime updatedAt;

  PlayerTicket copy() {
    return PlayerTicket(
      id: id,
      subject: subject,
      description: description,
      priority: priority,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class PlayerTicketsStore {
  PlayerTicketsStore._();

  static final PlayerTicketsStore instance = PlayerTicketsStore._();

  final List<PlayerTicket> _tickets = [
    PlayerTicket(
      id: '1',
      subject: 'مشکل در انتشار کوییز',
      description: 'هنگام انتشار کوییز خطای ناشناخته می‌گیرم.',
      priority: TicketPriority.medium,
      status: TicketStatus.answered,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    PlayerTicket(
      id: '2',
      subject: 'درخواست قابلیت جدید',
      description: 'امکان فیلتر نتایج بر اساس تاریخ را اضافه کنید.',
      priority: TicketPriority.high,
      status: TicketStatus.inReview,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PlayerTicket(
      id: '3',
      subject: 'مشکل در نمایش نتایج',
      description: 'صفحه نتایج روی موبایل درست رندر نمی‌شود.',
      priority: TicketPriority.low,
      status: TicketStatus.open,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<PlayerTicket> get all => List.unmodifiable(_tickets);

  PlayerTicket? byId(String id) {
    try {
      return _tickets.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void upsert(PlayerTicket ticket) {
    final index = _tickets.indexWhere((t) => t.id == ticket.id);
    if (index >= 0) {
      _tickets[index] = ticket;
    } else {
      _tickets.insert(0, ticket);
    }
  }

  void delete(String id) {
    _tickets.removeWhere((t) => t.id == id);
  }

  String nextId() => DateTime.now().millisecondsSinceEpoch.toString();
}
