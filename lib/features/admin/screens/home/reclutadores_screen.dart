import 'package:flutter/material.dart';
import 'package:flutter_app/features/admin/widgets/widgets.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class ReclutadoresScreen extends StatefulWidget {
  const ReclutadoresScreen({super.key});

  @override
  ReclutadoresScreenState createState() => ReclutadoresScreenState();
}

class ReclutadoresScreenState extends State<ReclutadoresScreen> {
  final List<Map<String, String>> reclutadores = [
    {
      'nombre': 'Carlos Díaz Sánchez',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Banco de Crédito del Perú',
      'experiencia': '5',
      'fecha': 'junio, 2024 - actualidad'
    },
    {
      'nombre': 'Ana Rodríguez Martínez',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Interbank',
      'experiencia': '2',
      'fecha': 'julio, 2024 - actualidad'
    },
    {
      'nombre': 'Luis Gómez Herrera',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'BBVA',
      'experiencia': '1',
      'fecha': 'agosto, 2024 - actualidad'
    },
    {
      'nombre': 'María García López',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Scotiabank',
      'experiencia': '4',
      'fecha': 'septiembre, 2024 - actualidad'
    },
    {
      'nombre': 'José Martínez Ríos',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'MiBanco',
      'experiencia': '3',
      'fecha': 'octubre, 2024 - actualidad'
    },
    {
      'nombre': 'Carlos Pérez Vargas',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Alicorp',
      'experiencia': '5',
      'fecha': 'noviembre, 2024 - actualidad'
    },
    {
      'nombre': 'Andrea Sánchez Gómez',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Backus',
      'experiencia': '2',
      'fecha': 'diciembre, 2024 - actualidad'
    },
    {
      'nombre': 'Sofía Fernández López',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Cemex Perú',
      'experiencia': '1',
      'fecha': 'enero, 2025 - actualidad'
    },
    {
      'nombre': 'Jorge Ruiz Fernández',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Corporación Lindley',
      'experiencia': '3',
      'fecha': 'febrero, 2025 - actualidad'
    },
    {
      'nombre': 'Felipe Vega González',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Ferreyros',
      'experiencia': '4',
      'fecha': 'marzo, 2025 - actualidad'
    },
    {
      'nombre': 'Laura Romero Cáceres',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Cosapi',
      'experiencia': '2',
      'fecha': 'abril, 2025 - actualidad'
    },
    {
      'nombre': 'Antonio Díaz Martínez',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Southern Copper Corporation',
      'experiencia': '3',
      'fecha': 'mayo, 2025 - actualidad'
    },
    {
      'nombre': 'Vanessa Rodríguez Ortiz',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Graña y Montero',
      'experiencia': '4',
      'fecha': 'junio, 2025 - actualidad'
    },
    {
      'nombre': 'Carlos Díaz Ramírez',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Inca Kola',
      'experiencia': '5',
      'fecha': 'julio, 2025 - actualidad'
    },
    {
      'nombre': 'Cristina Soto Blanco',
      'foto': 'assets/profile_picture.jpg',
      'empresa': 'Tottus',
      'experiencia': '1',
      'fecha': 'agosto, 2025 - actualidad'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Column(
          children: [
            Header(
              isHome: false,
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF1E3984).withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: Color(0xFF1E3984), size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lista de Reclutadores',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3984),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reclutadores.length,
              itemBuilder: (context, index) {
                return ReclutadorCard(
                    reclutador: reclutadores[index], index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
