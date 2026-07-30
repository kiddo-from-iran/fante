import 'package:flutter/material.dart';
import 'package:frontend/pages/dashboard/dashboard_games_page.dart';
import 'package:frontend/pages/dashboard/dashboard_page.dart';
import 'package:frontend/pages/dashboard/dashboard_settings_page.dart';
import 'package:frontend/pages/dashboard/game_editor/dashboard_game_editor_page.dart';
import 'package:frontend/pages/dashboard/tickets/dashboard_ticket_editor_page.dart';
import 'package:frontend/pages/dashboard/tickets/dashboard_tickets_page.dart';

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

  static Map<String, WidgetBuilder> get routes => {
        dashboard: (_) => const DashboardPage(),
        settings: (_) => const DashboardSettingsPage(),
        games: (_) => const DashboardGamesPage(),
        gameCreate: (_) => const DashboardGameEditorPage(),
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
      };
}
