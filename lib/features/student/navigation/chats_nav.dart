import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes/routes.dart';

class StudentChatsNav extends StatefulWidget {
  const StudentChatsNav({super.key});

  @override
  State<StudentChatsNav> createState() => _StudentChatsNavState();
}

GlobalKey<NavigatorState> studentChatsNavigatorKey =
    GlobalKey<NavigatorState>();

class _StudentChatsNavState extends State<StudentChatsNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: studentChatsNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/') {
              return AppRoutes.routes[AppRoutes.studentChats]!(context);
            }
            return AppRoutes.routes[settings.name]!(context);
          },
        );
      },
    );
  }
}
