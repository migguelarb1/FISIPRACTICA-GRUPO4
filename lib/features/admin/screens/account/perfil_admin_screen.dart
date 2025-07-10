import 'package:flutter/material.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/auth/services/user_services.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class EditarAdminScreen extends StatelessWidget {
  const EditarAdminScreen({super.key});

  Future<void> _logout() async {
    try {
      // await AuthService.logout();
      await UserServices.logout();
    } catch (e) {
      logger.e(e);
      // En producción, aquí podrías registrar el error en un servicio de logging
    }
  }

  // Función para mostrar el cuadro de confirmación
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            children: <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Se ha guardado los cambios',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Color.fromARGB(255, 8, 76, 131),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            // Botón "Ir a inicio"
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(180, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  try {
                    await _logout();
                    if (context.mounted) {
                      // Cerrar el diálogo primero
                      Navigator.of(context).pop();
                      // Navegar al splash y limpiar la pila de navegación
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.splash,
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                /* () {
                  Navigator.pushReplacementNamed(context, AppRoutes.splash);
                }, */
                child: const Text('Ir a inicio'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        // Permite desplazarse cuando el teclado está visible
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Información del Administrador',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3984),
                ),
              ),
              const SizedBox(height: 20),
              // Imagen de perfil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage:
                          const AssetImage('assets/profile_picture.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            size: 30, color: Colors.white),
                        onPressed: () {
                          // Agregar funcionalidad para cambiar la foto de perfil
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Campos de texto
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombres',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Celular',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),
              // Botones de guardar y cancelar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(120, 50),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context); // Regresar a la pantalla anterior sin guardar
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(120, 50),
                    ),
                    onPressed: () {
                      // Mostrar cuadro de confirmación al guardar
                      _showConfirmationDialog(context);
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      //bottomNavigationBar: Footer(), // Agregamos el Footer
    );
  }
}
