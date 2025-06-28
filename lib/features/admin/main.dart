import 'package:flutter/material.dart';
import 'package:flutter_app/features/features.dart';

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

  final List<Widget> _pages = [
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Column(
          children: const [Header(isHome: true)],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
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
              color: currentIndex == 3 ? Colors.white : Colors.grey,
            ),
            label: 'Perfil',
          )
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: goToPage,
      ),
    );
  }
}
