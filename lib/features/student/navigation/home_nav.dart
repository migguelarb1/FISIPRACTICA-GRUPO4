import 'package:flutter/material.dart';
import 'package:flutter_app/core/core.dart';

class HomeEstudianteNav extends StatefulWidget {
  const HomeEstudianteNav({super.key});

  @override
  State<HomeEstudianteNav> createState() => _HomeEstudianteNavState();
}

GlobalKey<NavigatorState> homeEstudianteNavigatorKey =
    GlobalKey<NavigatorState>();

class _HomeEstudianteNavState extends State<HomeEstudianteNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeEstudianteNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/') {
              return AppRoutes.routes[AppRoutes.studentOffers]!(context);
            }
            return AppRoutes.routes[settings.name]!(context);
          },
        );
      },
    );
  }
}
