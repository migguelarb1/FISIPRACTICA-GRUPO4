import 'package:flutter/material.dart';

class SobreEmpresaTab extends StatelessWidget {
  final Map<String, dynamic>? oferta;
  const SobreEmpresaTab({super.key, this.oferta});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            oferta!["empresa"].toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3984),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            oferta!["empresa_descripcion"].toString(),
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(
                'assets/map_icon.png', // Ruta del icono en assets
                width: 24, // Tamaño similar al de un icono
                height:
                    24, // Opcional, si la imagen es monocromática y quieres cambiar el color
              ),
              const SizedBox(width: 8),
              Text(
                oferta!["empresa_locacion"].toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPostularButton(context),
        ],
      ),
    );
  }
}
