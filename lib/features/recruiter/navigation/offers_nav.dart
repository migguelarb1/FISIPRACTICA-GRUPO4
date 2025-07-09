import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes/routes.dart';

class OffersNav extends StatefulWidget {
  const OffersNav({super.key});

  @override
  State<OffersNav> createState() => _OffersNavState();
}

GlobalKey<NavigatorState> recruiterOffersNavigatorKey =
    GlobalKey<NavigatorState>();

class _OffersNavState extends State<OffersNav> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: recruiterOffersNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/') {
              return AppRoutes.routes[AppRoutes.recruiterOffers]!(context);
            }
            return AppRoutes.routes[settings.name]!(context);
          },
        );
      },
    );
  }
}
