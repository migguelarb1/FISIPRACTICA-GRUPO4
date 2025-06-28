import 'package:flutter/material.dart';
import 'package:flutter_app/features/features.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/admin';
  static const String students = '/admin/students';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    home: (context) => const MainAdmin(),
    students: (context) => const EstudiantesScreen(),
  };

  // Private constructor to prevent instantiation
  AppRoutes._();
}
