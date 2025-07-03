import 'package:flutter/material.dart';

class EstudiantesTab extends StatefulWidget {
  const EstudiantesTab({super.key});

  @override
  State<EstudiantesTab> createState() => _EstudiantesTabState();
}

class _EstudiantesTabState extends State<EstudiantesTab> {
  int _paginaActual = 1;
  final int _itemsPorPagina = 3;

  final List<Map<String, String>> estudiantes = [
    {
      'nombre': 'Juan Pérez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Juan Pérez'
    },
    {
      'nombre': 'María López',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de María López'
    },
    {
      'nombre': 'Carlos García',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Carlos García'
    },
    {
      'nombre': 'Ana Martínez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Ana Martínez'
    },
    {
      'nombre': 'Luis Rodríguez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Luis Rodríguez'
    },
  ];

  void _showStudentDialog(Map<String, String> estudiante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(estudiante['foto']!),
                radius: 50,
              ),
              const SizedBox(height: 10),
              Text(
                estudiante['nombre']!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(estudiante['descripcion']!),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaginationControls(int totalPaginas) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _paginaActual > 1
              ? () {
                  setState(() {
                    _paginaActual--;
                  });
                }
              : null,
        ),
        Text("Página $_paginaActual de $totalPaginas"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _paginaActual < totalPaginas
              ? () {
                  setState(() {
                    _paginaActual++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPaginas = (estudiantes.length / _itemsPorPagina).ceil();
    List<Map<String, String>> estudiantesPagina = estudiantes
        .skip((_paginaActual - 1) * _itemsPorPagina)
        .take(_itemsPorPagina)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Estudiantes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: estudiantesPagina.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          AssetImage(estudiantesPagina[index]['foto']!),
                    ),
                    title: Text(estudiantesPagina[index]['nombre']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(estudiantesPagina[index]['descripcion']!),
                    onTap: () => _showStudentDialog(estudiantesPagina[index]),
                  ),
                );
              },
            ),
          ),
          _buildPaginationControls(totalPaginas),
        ],
      ),
    );
  }
}
