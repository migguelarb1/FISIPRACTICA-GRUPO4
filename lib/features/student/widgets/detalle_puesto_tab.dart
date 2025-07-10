import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:flutter_app/features/student/screens/chat/chat_bot_screen.dart';
import 'package:flutter_app/features/student/services/chat_services.dart';
import 'package:flutter_app/features/student/services/postulaciones_services.dart';

final SessionManager _sessionManager = SessionManager();

class DetallePuestoTab extends StatelessWidget {
  final Map<String, dynamic>? oferta;
  const DetallePuestoTab({super.key, this.oferta});

  void onPressed(BuildContext context) async {
    bool success = await PostulacionesServices.postularse(oferta!["id"]);

    if (!context.mounted) return;

    if (success) {
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text('Error al postularse'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }

  void onPressedChat(BuildContext context) async {
    final userData = await _sessionManager.getUser();
    final chat =
        await ChatServices().createChat(userData['sub'], oferta!["id"], null);

    if (!context.mounted) return;
    if (chat.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Error al crear el chat"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cerrar"),
              ),
            ],
          );
        },
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatBotScreen(
          company: oferta!["empresa"],
          chatId: chat['id'].toString(),
          jobId: oferta!["id"].toString(),
          recruiter: oferta!["recruiter"],
        ),
      ),
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
      child: SizedBox(
        width: 150,
        child: ElevatedButton(
          onPressed: () => onPressedChat(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3984),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Contactar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecruiterInfo(BuildContext context) {
    Uint8List? photo = oferta!["recruiter"]?["user"]?["photo"];
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    photo != null
                        ? Image.memory(photo, width: 80, height: 80)
                        : const Icon(
                            Icons.person,
                            size: 80,
                            color: Color(0xFF1E3984),
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${oferta!["recruiter"]?["user"]?["first_name"]} ${oferta!["recruiter"]?["user"]?["last_name"]}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3984),
                          ),
                        ),
                        Text(
                          oferta!["recruiter"]?["description"] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1E3984),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 1,
                indent: 10,
                endIndent: 10,
              ),
              _buildContactButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostularButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () => onPressed(context),
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
            _buildRecruiterInfo(context),
          ],
        ),
      ),
    );
  }
}
