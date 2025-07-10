import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/student/navigation/chats_nav.dart';
import 'package:flutter_app/features/student/navigation/home_nav.dart';
import 'package:flutter_app/features/student/screens/account/perfil_estudiante_screen.dart';
import 'package:flutter_app/features/student/screens/applications/postulaciones_screen.dart';
import 'package:flutter_app/features/student/screens/chat/chat_estudiante_screen.dart';

class MainEstudiantes extends StatefulWidget {
  final int initialTabIndex;

  const MainEstudiantes({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<MainEstudiantes> createState() => _MainEstudiantesState();

  // Método estático para cambiar la pestaña desde un descendiente
  static void changeTabAndNavigateToChat(
      BuildContext context, Map<String, String> chatInfo) {
    final mainEstudiantesState =
        context.findAncestorStateOfType<_MainEstudiantesState>();
    if (mainEstudiantesState != null) {
      mainEstudiantesState._changeTabAndNavigateToChat(chatInfo);
    }
  }
}

class _MainEstudiantesState extends State<MainEstudiantes> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTabIndex;
  }

  void _changeTabAndNavigateToChat(Map<String, String> chatInfo) {
    // Cambiar a la pestaña de Chat (índice 2)
    setState(() {
      currentIndex = 2;
    });

    // Esperar a que se actualice la interfaz y luego navegar al chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        studentChatsNavigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ChatEstudianteScreen(
              recruiterId: chatInfo['recruiterId']!,
              jobId: chatInfo['jobId']!,
              recruiterName: chatInfo['recruiterName']!,
              chatId: chatInfo['chatId']!,
            ),
          ),
        );
      });
    });
  }

  void goToPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // Método público para cambiar a la pestaña de chat
  void goToChatsTab() {
    goToPage(2);
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    homeEstudianteNavigatorKey,
    GlobalKey<NavigatorState>(),
    studentChatsNavigatorKey,
    GlobalKey<NavigatorState>(),
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
    MisPostulacionesScreen(),
    StudentChatsNav(),
    PerfilEstudianteScreen(),
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
                  'assets/chat_icon.png',
                  color: Colors.white,
                  width: 24,
                  height: 24,
                ),
                selectedIcon: Image.asset(
                  'assets/chat_icon.png',
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
