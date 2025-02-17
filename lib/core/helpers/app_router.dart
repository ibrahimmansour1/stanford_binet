import 'package:flutter/material.dart';
import 'package:stanford_binet/features/child/views/student_exam_entry_screen.dart';
import 'package:stanford_binet/features/reports/views/reports_view.dart';
import 'package:stanford_binet/features/session/views/teacher_session_code_entry_screen.dart';

import '../../features/auth/views/login_screen.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/session/views/register_data_view.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String sessionTestData = '/sessionTestData';

  static const String childHomeView = '/childHomeView';
  static const String specialistHomeView = '/specialistHomeView';
  static const String registerDataView = '/registerDataView';
  static const String teacherSessionCodeEntryScreen =
      '/teacherMonitoringScreen';
  static const String reportsView = '/reportsView';
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
        builder: (_) => StudentExamEntryScreen(),
        settings: settings,
      );

    case AppRoutes.specialistHomeView:
      return MaterialPageRoute(
        builder: (_) => const Text('Specialist Home View'),
        settings: settings,
      );
    case AppRoutes.registerDataView:
      return MaterialPageRoute(
        builder: (_) => RegisterDataView(),
        settings: settings,
      );
    case AppRoutes.teacherSessionCodeEntryScreen:
      return MaterialPageRoute(
        builder: (_) => TeacherSessionCodeEntryScreen(),
        settings: settings,
      );
    case AppRoutes.reportsView:
      return MaterialPageRoute(
        builder: (_) => ReportsView(),
        settings: settings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
        settings: settings,
      );
  }
}
