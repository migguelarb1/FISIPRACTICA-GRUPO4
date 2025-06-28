import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xFF1E3984),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            blurRadius: 0,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Image.asset(
                  'assets/home_icon.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Acción para el icono de inicio
                },
              ),
              Text(
                'Inicio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Image.asset(
                  'assets/portfolio_icon.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Acción para el icono de portafolio
                },
              ),
              Text(
                'Portafolio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Image.asset(
                  'assets/user_icon.png',
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Acción para el icono de usuario
                },
              ),
              Text(
                'Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 