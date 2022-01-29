import 'package:flutter/material.dart';
import 'package:mobile_buyer_guide/screens/catalog.dart';
import 'package:mobile_buyer_guide/screens/detail.dart';

class AppRoutePaths {
  static const String catalog = '/';
  static const String detail = '/detail';
}

class AppRouter {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case AppRoutePaths.catalog:
        return MaterialPageRoute(settings: settings, builder: (_) => const Catalog());
      case AppRoutePaths.detail:
        return MaterialPageRoute(settings: settings, builder: (_) => const Detail());


      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}