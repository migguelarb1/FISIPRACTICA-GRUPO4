import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes/routes.dart';

class RecruiterChatsNav extends StatefulWidget {
  const RecruiterChatsNav({super.key});

  @override
  State<RecruiterChatsNav> createState() => _RecruiterChatsNavState();
}

GlobalKey<NavigatorState> recruiterChatsNavigatorKey =
    GlobalKey<NavigatorState>();

class _RecruiterChatsNavState extends State<RecruiterChatsNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: recruiterChatsNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/') {
              return AppRoutes.routes[AppRoutes.recruiterChats]!(context);
            }
            return AppRoutes.routes[settings.name]!(context);
          },
        );
      },
    );
  }
}
