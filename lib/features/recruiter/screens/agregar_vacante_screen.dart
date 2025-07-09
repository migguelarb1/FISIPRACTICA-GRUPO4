import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:flutter_app/features/recruiter/services/reclutadores_services.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class AgregarVacanteReclutadorScreen extends StatefulWidget {
  const AgregarVacanteReclutadorScreen({super.key});

  @override
  State<AgregarVacanteReclutadorScreen> createState() =>
      _AgregarVacanteReclutadorScreenState();
}

class _AgregarVacanteReclutadorScreenState
    extends State<AgregarVacanteReclutadorScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _sedeController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _conocimientosController =
      TextEditingController();
  final TextEditingController _requisitosController = TextEditingController();
  final TextEditingController _salarioController =
      TextEditingController(); // Campo para salario
  final TextEditingController _urlJobPdfController =
      TextEditingController(); // Campo para URL del PDF
  final TextEditingController _funcionesTrabajoController =
      TextEditingController(); // Campo para funciones del trabajo

  bool _isLoading = false;

  Future<void> _guardarVacante() async {
    if (_nombreController.text.isEmpty ||
        _sedeController.text.isEmpty ||
        _descripcionController.text.isEmpty ||
        _conocimientosController.text.isEmpty ||
        _requisitosController.text.isEmpty ||
        _salarioController.text.isEmpty ||
        _urlJobPdfController.text.isEmpty) {
      _mostrarError("Todos los campos son obligatorios");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String? userId = (await SessionManager().getUser())['sub'];
    if (userId == null) {
      _mostrarError("No se pudo obtener el ID del reclutador");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    late int userIdInt;
    try {
      userIdInt = int.parse(userId);
    } catch (e) {
      _mostrarError("El ID del reclutador no es válido");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    Map<String, dynamic> reclutador =
        await ReclutadoresServices.getReclutadorByUserId(userIdInt);

    Map<String, dynamic> nuevaVacante = {
      "titulo": _nombreController.text,
      "ubicacion": _sedeController.text,
      "descripcion": _descripcionController.text,
      "salario": _salarioController.text, // Asegúrate de tener este campo
      "url_job_pdf": _urlJobPdfController.text, // Asegúrate de tener este campo
      "requisitos": _conocimientosController.text,
      "funciones_trabajo":
          _requisitosController.text, // Asegúrate de tener este campo
      "empresa_id": reclutador['empresa_id'], // Añade el ID de la empresa
      "user_creator_id": userIdInt
    };

    bool success = await ReclutadoresServices.registrarVacante(nuevaVacante);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _mostrarDialogoGuardado();
    } else {
      _mostrarError(
          "Hubo un problema al guardar la vacante. Inténtalo de nuevo.");
    }
  }

  void _mostrarDialogoGuardado() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Éxito"),
          content: const Text("Se ha guardado la vacante correctamente."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/lista_vacantes');
              },
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Ir a lista de vacantes",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(mensaje),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Header(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Título de la vacante", _nombreController),
            _buildTextField("Ubicación", _sedeController),
            _buildTextField("Descripción", _descripcionController),
            _buildTextField("Habilidades requeridas", _conocimientosController),
            _buildTextField("Requisitos", _requisitosController),
            _buildTextField("Salario", _salarioController), // Campo de salario
            _buildTextField("URL del PDF de trabajo",
                _urlJobPdfController), // Campo del PDF// Funciones del trabajo
            const SizedBox(height: 20),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            if (!_isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancelar",
                        style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _guardarVacante,
                    child: const Text("Guardar",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.blue.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
