import 'package:flutter/material.dart';

class EstudianteCard extends StatelessWidget {
  const EstudianteCard({super.key, required this.estudiante});
  final Map<String, String> estudiante;

  void _showConfirmationDialog(
      Map<String, String> estudiante, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content:
              Text('¿Seguro de que deseas eliminar a ${estudiante['nombre']}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showStudentDialog(
      Map<String, String> estudiante, BuildContext context) {
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
              SizedBox(height: 10),
              Text(
                estudiante['nombre']!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(estudiante['descripcion']!),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: Text('Mantener'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Eliminar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showConfirmationDialog(estudiante, context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showStudentDialog(estudiante, context),
        child: SizedBox(
          height: 100,
          child: Center(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(estudiante['foto']!),
              ),
              title: Text(
                estudiante['nombre']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1E3984),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
