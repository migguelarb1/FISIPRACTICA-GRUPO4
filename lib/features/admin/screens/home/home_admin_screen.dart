import 'package:flutter/material.dart';
import 'package:flutter_app/app/core/core.dart';
import 'package:flutter_app/app/routes/routes.dart';
import 'package:flutter_app/features/features.dart';

class HomeScreen extends StatefulWidget {
  final Function(String)? onNavigateToSubpage;

  const HomeScreen({super.key, this.onNavigateToSubpage});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void _onButtonPressed(int index) {
    if (index == 0) {
      // Navegar a EstudiantesScreen
      Navigator.pushNamed(context, AppRoutes.students);
      // widget.onNavigateToSubpage?.call('estudiantes');
    } else if (index == 1) {
      // Navegar a ReclutadoresScreen
      Navigator.pushNamed(context, AppRoutes.recruiters);
      // widget.onNavigateToSubpage?.call('reclutadores');
    } else if (index == 2) {
      // Navegar a EmpresasScreen
      Navigator.pushNamed(context, AppRoutes.companies);
      // widget.onNavigateToSubpage?.call('empresas');
    }
  }

  /* Map<String, dynamic> buttons = {
    'estudiantes': {
      'label': 'Estudiantes',
      'icon': Icons.school,
      'route': AppRoutes.students,
    },
    'reclutadores': {
      'label': 'Reclutadores',
      'icon': Icons.business_center,
      'route': AppRoutes.recruiters,
    },
    'empresas': {
      'label': 'Empresas',
      'icon': Icons.apartment,
      'route': AppRoutes.companies,
    },
  }; */

  @override
  Widget build(BuildContext context) {
    /* List<Widget> buttonWidgets = buttons.values.map((value) {
      return SizedBox(
        width: 363,
        height: 79,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, value['route']);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Color(0xFFF5F5F5),
            textStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadowColor: Colors.black.withAlpha(128),
            elevation: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(value['icon'], size: 32),
              SizedBox(width: 10),
              Text(value['label']),
            ],
          ),
        ),
      );
    }).toList(); */

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Column(
          children: [
            Header(
              isHome: true,
            )
          ],
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // children: buttonWidgets,
                  children: <Widget>[
                    SizedBox(
                      width: 363,
                      height: 79,
                      child: ElevatedButton(
                        onPressed: () {
                          _onButtonPressed(0);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Color(0xFFF5F5F5),
                          textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.black.withAlpha(128),
                          elevation: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.school, size: 32),
                            SizedBox(width: 10),
                            Text('Estudiantes'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: 363,
                      height: 79,
                      child: ElevatedButton(
                        onPressed: () {
                          _onButtonPressed(1);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Color(0xFFF5F5F5),
                          textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.black.withAlpha(128),
                          elevation: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.business_center, size: 32),
                            SizedBox(width: 10),
                            Text('Reclutadores'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    SizedBox(
                      width: 363,
                      height: 79,
                      child: ElevatedButton(
                        onPressed: () {
                          _onButtonPressed(2);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Color(0xFFF5F5F5),
                          textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.black.withAlpha(128),
                          elevation: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.apartment, size: 32),
                            SizedBox(width: 10),
                            Text('Empresas'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
