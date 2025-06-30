import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes/routes.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();

class _HomeNavState extends State<HomeNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/') {
              return AppRoutes.routes[AppRoutes.adminHome]!(context);
            }
            return AppRoutes.routes[settings.name]!(context);
          },
        );
      },
    );
  }
}
