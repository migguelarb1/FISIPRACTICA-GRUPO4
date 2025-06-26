import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/screens/login_screen.dart';
import 'package:flutter_app/features/dashboard/screens/home_admin_screen.dart';
import 'package:flutter_app/features/students/screens/estudiantes_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String students = '/students';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    students: (context) => const EstudiantesScreen(),
  };

  // Private constructor to prevent instantiation
  AppRoutes._();
}
