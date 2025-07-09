import 'package:flutter/material.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/auth/services/user_services.dart';

class LoginAdminForm extends StatefulWidget {
  const LoginAdminForm({super.key});

  @override
  LoginAdminFormState createState() => LoginAdminFormState();
}

class LoginAdminFormState extends State<LoginAdminForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      final isLoggedIn = await UserServices.login(_email, _password, 'Admin');
      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, AppRoutes.admin);
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 275.39,
            height: 75,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Código admin',
                filled: true,
                fillColor: Color(0xFFDBE2F6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1E3984), width: 1.0),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1E3984), width: 1.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese su email';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
          ),
          SizedBox(height: 7),
          SizedBox(
            width: 275.39,
            height: 75,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Contraseña admin',
                filled: true,
                fillColor: Color(0xFFDBE2F6),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1E3984), width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1E3984), width: 1.0),
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese su contraseña';
                }
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
          ),
          SizedBox(height: 7),
          SizedBox(
            width: 150,
            height: 48,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E3984),
                foregroundColor: Color(0xFFF5F5F5),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Ingresar'),
            ),
          ),
        ],
      ),
    );
  }
}
