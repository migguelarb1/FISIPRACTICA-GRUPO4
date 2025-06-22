import 'package:flutter/material.dart';
import '../widgets/header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Header(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
          ),
        ],
      ),
    );
  }
}