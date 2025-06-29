import 'package:flutter/material.dart';
import 'package:flutter_app/features/features.dart';

class MainAdmin extends StatefulWidget {
  const MainAdmin({super.key});

  @override
  State<MainAdmin> createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  int currentIndex = 0;
  String currentHomeSubpage = 'home'; // 'home', 'estudiantes', 'reclutadores', 'empresas'
  
  void goToPage(int index) {
    setState(() {
      currentIndex = index;
      // Resetear a home cuando se cambie de pestaña
      if (index == 0) {
        currentHomeSubpage = 'home';
      }
    });
  }

  void navigateToHomeSubpage(String subpage) {
    setState(() {
      currentHomeSubpage = subpage;
    });
  }

  void backToHome() {
    setState(() {
      currentHomeSubpage = 'home';
    });
  }

  bool _handleBackPress() {
    if (currentIndex == 0 && currentHomeSubpage != 'home') {
      // Si estamos en una subpantalla de Home, regresamos a Home
      backToHome();
      return false; // No permitir que el sistema maneje el back
    }
    return true; // Permitir que el sistema maneje el back (cerrar app)
  }

  Widget _buildCurrentHomePage() {
    switch (currentHomeSubpage) {
      case 'estudiantes':
        return EstudiantesScreen();
      case 'reclutadores':
        return ReclutadoresScreen();
      case 'empresas':
        return Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 100, color: Color(0xFF1E3984)),
                SizedBox(height: 20),
                Text(
                  'Empresas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3984),
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return HomeScreen(onNavigateToSubpage: navigateToHomeSubpage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildCurrentHomePage(),
      Container(
        child: Center(
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
      ),
      Container(
        child: Center(
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
      ),
    ];

    return PopScope(
      canPop: currentIndex != 0 || currentHomeSubpage == 'home',
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackPress();
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Column(
            children: [
              Header(
                isHome: currentIndex == 0 && currentHomeSubpage == 'home',
                onBackPressed: currentIndex == 0 && currentHomeSubpage != 'home' 
                    ? backToHome 
                    : null,
              )
            ],
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Color(0xFF1E3984),
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
              label: 'Ofertas',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/user_icon.png',
                color: currentIndex == 2 ? Colors.white : Colors.grey,
              ),
              label: 'Perfil',
            )
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
