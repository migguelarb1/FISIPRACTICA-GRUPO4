import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/student/navigation/home_nav.dart';

class MainEstudiantes extends StatefulWidget {
  const MainEstudiantes({super.key});

  @override
  State<MainEstudiantes> createState() => _MainEstudiantesState();
}

class _MainEstudiantesState extends State<MainEstudiantes> {
  int currentIndex = 0;

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    homeEstudianteNavigatorKey,
  ];

  Future<void> _systemBackButtonPressed(result) async {
    if (_navigatorKeys[currentIndex].currentState?.canPop() ?? true) {
      _navigatorKeys[currentIndex].currentState?.pop(result);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  final List<Widget> _pages = [
    HomeEstudianteNav(),
    //HomeEstudianteScreen(),
    //MisPostulacionesScreen(),
    //ChatScreen(),
    //PerfilEstudianteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
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
            children: _pages,
          ),
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: AppColors.secondary,
            backgroundColor: AppColors.primary,
            labelTextStyle: WidgetStateProperty.all(
              TextStyle(color: Colors.white),
            ),
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
                  'assets/chatbot_icon.png',
                  color: Colors.white,
                  width: 24,
                  height: 24,
                ),
                selectedIcon: Image.asset(
                  'assets/chatbot_icon.png',
                  color: AppColors.primary,
                  width: 24,
                  height: 24,
                ),
                label: 'Chat',
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
/* 
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Color(0xFF1E3984),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/home_icon.png',
                color: currentIndex == 0 ? Colors.white : Colors.grey,
              ),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/portfolio_icon.png',
                color: currentIndex == 1 ? Colors.white : Colors.grey,
              ),
              label: 'Mis Postulaciones',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/chatbot_icon.png',
                color: currentIndex == 2 ? Colors.white : Colors.grey,
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/user_icon.png',
                color: currentIndex == 3 ? Colors.white : Colors.grey,
              ),
              label: 'Perfil',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          onTap: goToPage,
        ),
      ),
    );
  }
}
 */
