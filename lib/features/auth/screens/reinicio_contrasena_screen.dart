import 'package:flutter/material.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;

  void _sendCode() {
    setState(() {
      _codeSent = true;
    });
  }

  void _confirmCode() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Header(
            allowedAdminLogin: true,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Correo electrónico o teléfono',
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _sendCode,
                  child: Text('Enviar código'),
                ),
                if (_codeSent) ...[
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Código de verificación',
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _confirmCode,
                    child: Text('Confirmar código'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
