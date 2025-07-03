import 'package:flutter/material.dart';

class DetallePuesto extends StatelessWidget {
  final Map<String, dynamic>? oferta;
  const DetallePuesto({super.key, this.oferta});

  Widget _buildPostularButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF1E3984),
                        size: 70,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '¡Postulación exitosa!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3984),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tu postulación ha sido enviada correctamente.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3984),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3984),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Postular',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3984),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (oferta == null) {
      return const Center(child: Text('No hay información disponible'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              oferta!["titulo"] ?? 'Sin título',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3984),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow("Empresa", oferta!["empresa"] ?? 'No especificada'),
            _buildInfoRow(
                "Ubicación", oferta!["ubicacion"] ?? 'No especificada'),
            _buildInfoRow("Disponibilidad",
                oferta!["disponibilidad"] ?? 'No especificada'),
            const SizedBox(height: 16),
            const Text(
              "Descripción del puesto",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3984),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              oferta!["descripcion"] ?? 'Sin descripción disponible',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildPostularButton(context),
          ],
        ),
      ),
    );
  }
}
