import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/recruiter/navigation/chats_nav.dart';
import 'package:flutter_app/features/recruiter/navigation/home_nav.dart';
import 'package:flutter_app/features/recruiter/navigation/offers_nav.dart';

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
    RecruiterHomeNav(),
    OffersNav(),
    RecruiterChatsNav(),
  ];

  @override
  void initState() {
    super.initState(); /* 
    _getRecruiterId(); */
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    recruiterHomeNavigatorKey,
    recruiterOffersNavigatorKey,
    recruiterChatsNavigatorKey,
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _systemBackButtonPressed(result);
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
