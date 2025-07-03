import 'package:flutter/material.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/recruiter/screens/home_reclutador_screen.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class MainReclutadores extends StatefulWidget {
  const MainReclutadores({super.key});

  @override
  State<MainReclutadores> createState() => _MainReclutadoresState();
}

class _MainReclutadoresState extends State<MainReclutadores> {
  int currentIndex = 0;

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  late int recruiterId;

  final List<Widget> _pages = [
    HomeReclutadorScreen(),
    //HomeReclutadorScreen(),
    //OfertasReclutadorScreen(),
    //ChatReclutadorScreen(),
  ];

  @override
  void initState() {
    super.initState(); /* 
    _getRecruiterId(); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Column(
          children: const [Header(isHome: true)],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
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
          ],
        ),
      ),
    );
  }
}
