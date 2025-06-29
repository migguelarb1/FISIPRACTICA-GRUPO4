import 'package:flutter/material.dart';
import 'package:flutter_app/features/services/user_services.dart';
import 'package:flutter_app/features/shared/widgets/main_estudiantes.dart';
import 'package:flutter_app/features/shared/widgets/main_reclutadores.dart';
//import '../screens/register_screen.dart';
//import '../screens/reinicio_contraseña_screen.dart';

class LoginForm extends StatefulWidget {
  final int index;
  const LoginForm(this.index, {super.key});

  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _email;
  late TextEditingController _password;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final response = await UserServices.login(_email.text, _password.text,
          widget.index == 0 ? 'Reclutador' : 'Estudiante');
      if (!mounted) return;

      if (response.containsKey('token')) {
        UserServices.setToken(response['token']!);
        _formKey.currentState!.save();
        print('Email: $_email, Password: $_password');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => widget.index == 0
                ? MainReclutadores()
                : MainEstudiantes(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Error de inicio de sesión. Por favor, verifique sus credenciales.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Image.asset(
            'assets/logo_azul.png',
            height: 208,
            width: 211,
          ),
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ej: pepito@unmsm.edu.pe',
                label: Text("Correo electrónico o telefono")),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _password,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ej: 123456',
                label: Text("Contraseña")),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              _submit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E3984),
              foregroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              shadowColor: Colors.black.withAlpha(128),
              elevation: 10,
            ),
            child: Text('Iniciar sesión'),
          ),
          const SizedBox(height: 10),
          if (widget.index == 1) ...[
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Aun no eres usuario?',
                    style: TextStyle(fontSize: 14)),
                TextButton(
                  onPressed: null,
                  child: const Text(
                    'Registrate',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: null,
              child: const Text('Olvidaste tu contraseña?'),
            )
          ]
        ]),
      ),
    );
  }
}
