import 'package:flutter/material.dart';
import '../../shared/widgets/header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: colors.surface,
            child: const Header(
              allowedAdminLogin: true,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
          ),
        ],
      ),
    );
  }
} 