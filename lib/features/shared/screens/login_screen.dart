import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, 
      body: SingleChildScrollView(  
        child: Column(
          children: <Widget>[
            const Header(allowedAdminLogin: true,),
            SizedBox(height: 20),
            LoginForm(1),  // El formulario de login
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
