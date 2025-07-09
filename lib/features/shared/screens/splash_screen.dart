//Pantalla de bienvenida
import 'package:flutter/material.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/core/utils/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Esperar un momento para mostrar el logo
    await Future.delayed(const Duration(seconds: 2));

    // Verificar si el usuario está logueado
    bool isLoggedIn = await SessionManager().isLoggedIn();

    if (isLoggedIn) {
      final user = await SessionManager().getUser();
      if (mounted) {
        switch (user['role']) {
          case 'Admin':
            Navigator.pushReplacementNamed(context, AppRoutes.admin);
            break;
          case 'Reclutador':
            Navigator.pushReplacementNamed(context, AppRoutes.recruiter);
            break;
          case 'Estudiante':
            Navigator.pushReplacementNamed(context, AppRoutes.student);
            break;
          default:
            Navigator.pushReplacementNamed(context, AppRoutes.lobby);
            break;
        }
      }
    } else {
      // Si no está logueado, esperar 3 segundos más y mostrar el botón
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _showButton = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E3984),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo_blanco.png',
              height: 208,
              width: 211,
            ),
            SizedBox(height: 20),
            _showButton
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.lobby);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E1D94),
                      foregroundColor: Color(0xFFDEDEFF),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          )),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      minimumSize: const Size(180, 50),
                    ),
                    child: const Text('¡Vamos!'),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
