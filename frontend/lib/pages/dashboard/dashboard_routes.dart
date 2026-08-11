import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_extra_pages.dart';
import 'package:frontend/pages/dashboard/dashboard_games_page.dart';
import 'package:frontend/pages/dashboard/dashboard_page.dart';
import 'package:frontend/pages/dashboard/dashboard_settings_page.dart';
import 'package:frontend/pages/dashboard/game_editor/dashboard_game_editor_page.dart';
import 'package:frontend/pages/dashboard/tickets/dashboard_ticket_editor_page.dart';
import 'package:frontend/pages/dashboard/tickets/dashboard_tickets_page.dart';
import 'package:frontend/pages/game/models/game_kind.dart';

class DashboardRoutes {
  DashboardRoutes._();

  static const dashboard = '/dashboard';
  static const settings = '/dashboard/settings';
  static const games = '/dashboard/games';
  static const gameCreate = '/dashboard/games/create';
  static const gameEdit = '/dashboard/games/edit';
  static const tickets = '/dashboard/tickets';
  static const ticketCreate = '/dashboard/tickets/create';
  static const ticketEdit = '/dashboard/tickets/edit';
  static const badges = '/dashboard/badges';
  static const announcements = '/dashboard/announcements';
  static const reviews = '/dashboard/reviews';
  static const activity = '/dashboard/activity';
  static const notifications = '/dashboard/notifications';

  static Map<String, WidgetBuilder> get routes => {
        dashboard: (_) => const DashboardPage(),
        settings: (_) => const DashboardSettingsPage(),
        games: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          var draftsOnly = false;
          if (args is Map && args['draftsOnly'] == true) {
            draftsOnly = true;
          }
          return DashboardGamesPage(draftsOnly: draftsOnly);
        },
        gameCreate: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          GameKind? kind;
          if (args is GameKind) kind = args;
          if (args is Map && args['kind'] is GameKind) {
            kind = args['kind'] as GameKind;
          }
          return DashboardGameEditorPage(initialKind: kind);
        },
        gameEdit: (context) {
          final id = ModalRoute.of(context)?.settings.arguments as String?;
          return DashboardGameEditorPage(gameId: id);
        },
        tickets: (_) => const DashboardTicketsPage(),
        ticketCreate: (_) => const DashboardTicketEditorPage(),
        ticketEdit: (context) {
          final id = ModalRoute.of(context)?.settings.arguments as String?;
          return DashboardTicketEditorPage(ticketId: id);
        },
        badges: (_) => const DashboardBadgesPage(),
        announcements: (_) => const DashboardAnnouncementsPage(),
        reviews: (_) => const DashboardReviewsPage(),
        activity: (_) => const DashboardActivityPage(),
        notifications: (_) => const DashboardNotificationsPage(),
      };
}
