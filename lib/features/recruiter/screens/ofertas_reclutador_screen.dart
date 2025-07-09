import 'package:flutter/material.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/core/utils/session_manager.dart';
import 'package:flutter_app/features/recruiter/services/ofertas_services.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class OfertasReclutadorScreen extends StatefulWidget {
  const OfertasReclutadorScreen({super.key});

  @override
  State<OfertasReclutadorScreen> createState() =>
      _OfertasReclutadorScreenState();
}

class _OfertasReclutadorScreenState extends State<OfertasReclutadorScreen> {
  List<Map<String, dynamic>> vacantes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVacantes();
  }

  Future<void> _loadVacantes() async {
    try {
      Map<String, dynamic> user = await SessionManager().getUser();
      List<Map<String, dynamic>> data =
          await OfertasServices.getOfertasByRecruiter(
              user['recruiter_id'].toString());
      setState(() {
        vacantes = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error al obtener vacantes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: const Header(isHome: true),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : vacantes.isEmpty
              ? const Center(child: Text("No hay vacantes disponibles"))
              : RefreshIndicator(
                  onRefresh: _loadVacantes,
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: vacantes.length,
                      itemBuilder: (context, index) {
                        final vacante = vacantes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text(
                                        vacante["empresa"]?[0] ?? '?',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(vacante["titulo"] ?? "Sin título",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Text(vacante["empresa"] ??
                                            "Sin empresa"),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    vacante["descripcion"] ?? "Sin descripción",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.info, color: Colors.blue),
                                    const SizedBox(width: 5),
                                    Text(
                                        "Inicio: ${vacante["fecha_inicio"] ?? 'No disponible'}",
                                        style:
                                            const TextStyle(color: Colors.red)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.recruiterAddOffer);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
