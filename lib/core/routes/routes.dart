import 'package:flutter/material.dart';
import 'package:flutter_app/features/admin/main.dart';
import 'package:flutter_app/features/admin/screens/screens.dart';
import 'package:flutter_app/features/auth/screens/screens.dart';
import 'package:flutter_app/features/recruiter/main_reclutadores.dart';
import 'package:flutter_app/features/recruiter/screens/agregar_vacante_screen.dart';
import 'package:flutter_app/features/recruiter/screens/home_reclutador_screen.dart';
import 'package:flutter_app/features/recruiter/screens/ofertas_reclutador_screen.dart';
import 'package:flutter_app/features/shared/screens/screens.dart';
import 'package:flutter_app/features/student/main_estudiantes.dart';
import 'package:flutter_app/features/student/screens/home/detalle_oferta_estudiante.dart';
import 'package:flutter_app/features/student/screens/home/home_estudiante_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String lobby = '/lobby';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String adminHome = '/admin/home';
  static const String students = '/admin/home/students';
  static const String recruiters = '/admin/home/recruiters';
  static const String companies = '/admin/home/companies';
  static const String student = '/student';
  static const String studentOffers = '/student/home/offers';
  static const String studentOfferDetails = '/student/home/offers/details';
  static const String studentProfile = '/student/home/profile';
  static const String studentSettings = '/student/home/settings';
  static const String studentNotifications = '/student/home/notifications';
  static const String studentMessages = '/student/home/messages';
  static const String recruiter = '/recruiter';
  static const String recruiterHome = '/recruiter/home';
  static const String recruiterOffers = '/recruiter/offers';
  static const String recruiterAddOffer = '/recruiter/offers/add';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    lobby: (context) => const PickUserScreen(),
    login: (context) => const LoginScreen(),
    admin: (context) => const MainAdmin(),
    adminHome: (context) => const HomeScreen(),
    students: (context) => const EstudiantesScreen(),
    recruiters: (context) => const ReclutadoresScreen(),
    companies: (context) => const EmpresasScreen(),
    student: (context) => const MainEstudiantes(),
    studentOffers: (context) => const HomeEstudianteScreen(),
    studentOfferDetails: (context) => const DetalleOfertaEstudianteScreen(),
    recruiter: (context) => const MainReclutadores(),
    recruiterHome: (context) => const HomeReclutadorScreen(),
    recruiterOffers: (context) => const OfertasReclutadorScreen(),
    recruiterAddOffer: (context) => const AgregarVacanteReclutadorScreen(),
  };

  // Private constructor to prevent instantiation
  AppRoutes._();
}
