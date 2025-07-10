import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/admin/navigation/navigation.dart';
import 'package:flutter_app/features/admin/screens/offers/admin_ofertas_screen.dart';
import 'package:flutter_app/features/admin/screens/screens.dart';

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
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
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
      EditarOfertasScreen(),
      // EditarAdminScreen(),
      AdminProfileScreen(), // 👈 PERFIL ACTIVO
      /* Center(
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
      ), */
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
            labelTextStyle:
                WidgetStateProperty.all(TextStyle(color: Colors.white)),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: goToPage,
            destinations: [
              NavigationDestination(
                icon: Image.asset(
                  'assets/home_icon.png',
                  color: Colors.white,
                  width: 24,
                  height: 24,
                ),
                selectedIcon: Image.asset(
                  'assets/home_icon.png',
                  color: AppColors.primary,
                  width: 24,
                  height: 24,
                ),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/portfolio_icon.png',
                  color: Colors.white,
                  width: 24,
                  height: 24,
                ),
                selectedIcon: Image.asset(
                  'assets/portfolio_icon.png',
                  color: AppColors.primary,
                  width: 24,
                  height: 24,
                ),
                label: 'Ofertas',
              ),
              NavigationDestination(
                icon: Image.asset(
                  'assets/user_icon.png',
                  color: Colors.white,
                  width: 24,
                  height: 24,
                ),
                selectedIcon: Image.asset(
                  'assets/user_icon.png',
                  color: AppColors.primary,
                  width: 24,
                  height: 24,
                ),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
