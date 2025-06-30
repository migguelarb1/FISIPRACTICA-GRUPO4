import 'package:flutter/material.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
          ),
        ],
      ),
    );
  }
}
