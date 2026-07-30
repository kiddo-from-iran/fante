import 'package:flutter/material.dart';
import 'package:frontend/pages/catalog/category_page.dart';
import 'package:frontend/pages/catalog/quizzes_page.dart';

class CatalogRoutes {
  CatalogRoutes._();

  static const category = '/games/category';
  static const quizzes = '/games/quizzes';

  static Map<String, WidgetBuilder> get routes => {
        category: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is String) {
            return CategoryPage(initialGameType: args);
          }
          return const CategoryPage();
        },
        quizzes: (_) => const QuizzesPage(),
      };
}
