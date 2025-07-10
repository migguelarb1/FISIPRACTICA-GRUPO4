import 'package:flutter/material.dart';

class ReclutadorCard extends StatelessWidget {
  final Map<String, String> reclutador;
  final int index;
  final Function(Map<String, String>)? onUpdate; 

  const ReclutadorCard({
    super.key,
    required this.reclutador,
    required this.index,
    this.onUpdate,
  });

  void _showConfirmationDialog(
      Map<String, String> reclutador, BuildContext context) {
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
                // Aquí podrías notificar al padre con otra función si deseas eliminar realmente
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditarReclutadorDialog(
      Map<String, String> reclutador, BuildContext context) {
    final TextEditingController empresaController =
        TextEditingController(text: reclutador['empresa']);
    final TextEditingController experienciaController =
        TextEditingController(text: reclutador['experiencia']);
    final TextEditingController fechaController =
        TextEditingController(text: reclutador['fecha']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Editar Reclutador',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: empresaController,
                  decoration: InputDecoration(
                    labelText: 'Empresa',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: experienciaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Años de experiencia',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: fechaController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de ingreso',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        reclutador['empresa'] = empresaController.text;
                        reclutador['experiencia'] = experienciaController.text;
                        reclutador['fecha'] = fechaController.text;

                        Navigator.of(context).pop();
                        if (onUpdate != null) {
                          onUpdate!(reclutador); // Notificar al padre
                        }
                      },
                      child: Text('Guardar'),
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

  void _showReclutadorDialog(
      Map<String, String> reclutador, BuildContext context) {
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
            constraints: BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: const AssetImage('assets/profile_picture.png'),
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
                        Navigator.of(context).pop();
                        _showEditarReclutadorDialog(reclutador, context);
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
                    backgroundImage: AssetImage(reclutador['foto']!)),
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

