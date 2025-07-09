import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes/routes.dart';

class RecruiterHomeNav extends StatefulWidget {
  const RecruiterHomeNav({super.key});

  @override
  State<RecruiterHomeNav> createState() => _RecruiterHomeNavState();
}

GlobalKey<NavigatorState> recruiterHomeNavigatorKey =
    GlobalKey<NavigatorState>();

class _RecruiterHomeNavState extends State<RecruiterHomeNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: recruiterHomeNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/') {
              return AppRoutes.routes[AppRoutes.recruiterHome]!(context);
            }
            return AppRoutes.routes[settings.name]!(context);
          },
        );
      },
    );
  }
}
