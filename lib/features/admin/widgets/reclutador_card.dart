import 'package:flutter/material.dart';

class ReclutadorCard extends StatelessWidget {
  const ReclutadorCard(
      {super.key, required this.reclutador, required this.index});
  final Map<String, String> reclutador;
  final int index;

  void _showConfirmationDialog(
      Map<String, dynamic> reclutador, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content:
              Text('¿Seguro de que deseas eliminar a ${reclutador['nombre']}?'),
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
                // Lógica para eliminar al reclutador
              },
            ),
          ],
        );
      },
    );
  }

  void _showReclutadorDialog(
      Map<String, dynamic> reclutador, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            constraints: BoxConstraints(
              maxHeight: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: /* reclutador['foto'] != null
                      ? MemoryImage(reclutador['foto'] as Uint8List)
                      : */
                      const AssetImage('assets/profile_picture.png')
                          as ImageProvider,
                ),
                SizedBox(height: 10),
                Text(
                  reclutador['nombre']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('- RR/HH de ${reclutador['empresa']}'),
                Text('- ${reclutador['experiencia']} años de experiencia'),
                Text('- ${reclutador['fecha']}'),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Editar'),
                      onPressed: () {
                        Navigator.of(context).pop(); // Cierra el diálogo actual
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditarReclutadorScreen(reclutador: reclutador),
                          ),
                        ); */
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
                        _showConfirmationDialog(reclutador, context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String empresa = reclutador['empresa']!;
    Color empresaColor;

    switch (empresa) {
      case 'Banco de Crédito del Perú':
        empresaColor = Colors.blue;
        break;
      case 'Interbank':
        empresaColor = Colors.green;
        break;
      case 'BBVA':
        empresaColor = Colors.blue;
        break;
      case 'Scotiabank':
        empresaColor = Colors.red;
        break;
      case 'MiBanco':
        empresaColor = Colors.yellow;
        break;
      case 'Alicorp':
        empresaColor = Colors.red;
        break;
      case 'Backus':
        empresaColor = Colors.orange;
        break;
      case 'Cemex Perú':
        empresaColor = Colors.blue;
        break;
      case 'Corporación Lindley':
        empresaColor = Colors.red;
        break;
      case 'Ferreyros':
        empresaColor = Colors.green;
        break;
      case 'Cosapi':
        empresaColor = Colors.yellow;
        break;
      case 'Southern Copper Corporation':
        empresaColor = Colors.red;
        break;
      case 'Graña y Montero':
        empresaColor = Colors.orange;
        break;
      case 'Inca Kola':
        empresaColor = Colors.yellow;
        break;
      case 'Tottus':
        empresaColor = Colors.green;
        break;
      default:
        empresaColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showReclutadorDialog(reclutador, context),
        child: SizedBox(
          height: 100,
          child: Center(
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                    backgroundImage: /* reclutador['foto'] != null
                        ? MemoryImage(reclutador['foto'] as Uint8List)
                        :  */
                        AssetImage(reclutador['foto']!)),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    reclutador['nombre']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF1E3984),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: empresaColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      empresa,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
