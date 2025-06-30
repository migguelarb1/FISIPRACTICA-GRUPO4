import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/constants/constants.dart';
import 'package:flutter_app/features/admin/navigation/home_nav.dart';

class MainAdmin extends StatefulWidget {
  const MainAdmin({super.key});

  @override
  State<MainAdmin> createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  int currentIndex = 0;

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    homeNavigatorKey,
  ];

  Future<void> _systemBackButtonPressed(result) async {
    if (_navigatorKeys[currentIndex].currentState?.canPop() ?? true) {
      _navigatorKeys[currentIndex].currentState?.pop(result);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeNav(),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work, size: 100, color: Color(0xFF1E3984)),
            SizedBox(height: 20),
            Text(
              'Ofertas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3984),
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100, color: Color(0xFF1E3984)),
            SizedBox(height: 20),
            Text(
              'Perfil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3984),
              ),
            ),
          ],
        ),
      ),
    ];

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await _systemBackButtonPressed(result);
          }
        },
        child: Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: currentIndex,
                children: pages,
              ),
            ),
            bottomNavigationBar: NavigationBarTheme(
                data: NavigationBarThemeData(
                    indicatorColor: AppColors.secondary,
                    backgroundColor: AppColors.primary,
                    labelTextStyle: WidgetStateProperty.all(
                        TextStyle(color: Colors.white))),
                child: NavigationBar(
                    selectedIndex: currentIndex,
                    onDestinationSelected: goToPage,
                    indicatorColor: AppColors.secondary,
                    destinations: const [
                      NavigationDestination(
                          icon: Icon(
                            Icons.home_outlined,
                            color: Colors.white,
                          ),
                          selectedIcon: Icon(Icons.home),
                          label: 'Inicio'),
                      NavigationDestination(
                          icon: Icon(Icons.work_outline, color: Colors.white),
                          selectedIcon: Icon(Icons.work),
                          label: 'Ofertas'),
                      NavigationDestination(
                          icon: Icon(Icons.person_outline, color: Colors.white),
                          selectedIcon: Icon(Icons.person),
                          label: 'Perfil'),
                    ]))));
  }
}
