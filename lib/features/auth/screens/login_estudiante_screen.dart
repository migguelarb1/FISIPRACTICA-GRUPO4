import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/widgets/login_form.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class LoginEstudianteScreen extends StatelessWidget {
  const LoginEstudianteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Column(
          children: [
            Header(
              isHome: false,
              allowedAdminLogin: true,
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            LoginForm(1), // El formulario de login
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
            ),
          ],
        ),
      ),
    );
  }
}
