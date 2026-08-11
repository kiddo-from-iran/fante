import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/catalog_kind_page.dart';
import 'package:frontend/pages/catalog/category_page.dart';

class CatalogRoutes {
  CatalogRoutes._();

  static const category = '/games/category';
  static const quizzes = '/games/quizzes';
  static const polls = '/games/polls';
  static const tests = '/games/tests';

  static Map<String, WidgetBuilder> get routes => {
        category: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is String) {
            return CategoryPage(initialGameType: args);
          }
          return const CategoryPage();
        },
        quizzes: (_) => const QuizzesPage(),
        polls: (_) => const PollsPage(),
        tests: (_) => const TestsPage(),
      };
}
