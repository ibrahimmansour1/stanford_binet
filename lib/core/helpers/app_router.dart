import 'package:flutter/material.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/home/views/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String sessionTestData = '/sessionTestData';

  static const String childHomeView = '/childHomeView';
  static const String specialistHomeView = '/specialistHomeView';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.login:
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
        settings: settings,
      );

    case AppRoutes.home:
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: settings,
      );

    case AppRoutes.sessionTestData:
      return MaterialPageRoute(
        builder: (_) => const Text('Session Test Data'),
        settings: settings,
      );

    case AppRoutes.childHomeView:
      return MaterialPageRoute(
        builder: (_) => const Text('Child Home View'),
        settings: settings,
      );

    case AppRoutes.specialistHomeView:
      return MaterialPageRoute(
        builder: (_) => const Text('Specialist Home View'),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
        settings: settings,
      );
  }
}
