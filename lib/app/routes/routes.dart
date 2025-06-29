import 'package:flutter/material.dart';
import 'package:flutter_app/features/features.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String adminHome = '/admin/home';
  static const String students = '/admin/home/students';
  static const String recruiters = '/admin/home/recruiters';
  static const String companies = '/admin/home/companies';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    admin: (context) => const MainAdmin(),
    adminHome: (context) => const HomeScreen(),
    students: (context) => const EstudiantesScreen(),
    recruiters: (context) => const ReclutadoresScreen(),
    companies: (context) => const EmpresasScreen(),
  };

  // Private constructor to prevent instantiation
  AppRoutes._();
}
