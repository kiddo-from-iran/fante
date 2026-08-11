import 'package:flutter/material.dart';
import 'package:frontend/pages/articles/articles_page.dart';
import 'package:frontend/pages/info/about_page.dart';
import 'package:frontend/pages/info/contact_page.dart';
import 'package:frontend/pages/info/terms_page.dart';
import 'package:frontend/pages/ranking/ranking_page.dart';

class InfoRoutes {
  InfoRoutes._();

  static const about = '/about';
  static const terms = '/terms';
  static const contact = '/contact';
  static const articles = '/articles';
  static const ranking = '/ranking';

  static Map<String, WidgetBuilder> get routes => {
        about: (_) => const AboutPage(),
        terms: (_) => const TermsPage(),
        contact: (_) => const ContactPage(),
        articles: (_) => const ArticlesPage(),
        ranking: (_) => const RankingPage(),
      };
}
