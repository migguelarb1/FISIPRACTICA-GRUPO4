import 'package:flutter/material.dart';

class MiEmpresaTab extends StatelessWidget {
  const MiEmpresaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> vacantes = [
      {
        "titulo": "Practicante Analista Datos",
        "empresa": "Adecco",
        "descripcion": "Apoyo en análisis de datos empresariales.",
        "ubicacion": "San Isidro, Lima, Perú",
        "disponibilidad": "Inmediata"
      },
      {
        "titulo": "Practicante Backend",
        "empresa": "Adecco",
        "descripcion": "Desarrollo y mantenimiento de APIs.",
        "ubicacion": "La Molina, Lima, Perú",
        "disponibilidad": "Inmediata"
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Vacantes Disponibles",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: vacantes.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(vacantes[index]["titulo"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${vacantes[index]["empresa"]} - ${vacantes[index]["ubicacion"]}"),
                        Text(vacantes[index]["descripcion"]!),
                        Text(
                            "Disponibilidad: ${vacantes[index]["disponibilidad"]}",
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
