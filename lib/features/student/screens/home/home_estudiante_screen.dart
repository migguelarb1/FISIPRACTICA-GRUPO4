import 'package:flutter/material.dart';
import 'package:flutter_app/core/core.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';
import 'package:flutter_app/features/student/widgets/dashed_line.dart';

class HomeEstudianteScreen extends StatefulWidget {
  const HomeEstudianteScreen({super.key});

  @override
  State<HomeEstudianteScreen> createState() => _HomeEstudianteScreenState();
}

class _HomeEstudianteScreenState extends State<HomeEstudianteScreen> {
  String _selectedEmpresa = "Todas";
  String _selectedRol = "Todos";
  String _searchQuery = "";
  int _paginaActual = 1;
  final int _itemsPorPagina = 2;

  final List<Map<String, dynamic>> _vacantes = [
    {
      "titulo": "Practicante Frontend",
      "empresa": "Interbank",
      "descripcion": "¡Únete a nuestro equipo!",
      "ubicacion": "San Isidro, Lima, Perú",
      "disponibilidad": "Inmediata"
    },
    {
      "titulo": "Practicante Backend",
      "empresa": "BCP",
      "descripcion": "Buscamos talento en backend.",
      "ubicacion": "Miraflores, Lima, Perú",
      "disponibilidad": "Inmediata"
    },
    {
      "titulo": "Analista de Datos",
      "empresa": "MiBanco",
      "descripcion": "Analiza datos financieros.",
      "ubicacion": "Surco, Lima, Perú",
      "disponibilidad": "Inmediata"
    },
  ];

  /* @override
  void initState() {
    super.initState();
    _getOfertas();
  }

  Future<void> _getOfertas() async {
    List<Map<String, dynamic>> ofertas = await OfertasServices.getOfertas();
    setState(() {
      _vacantes = ofertas;
    });
  } */

  List<Map<String, dynamic>> get _filteredVacantes {
    return _vacantes
        .where((vacante) =>
            (_selectedEmpresa == "Todas" ||
                vacante["empresa"] == _selectedEmpresa) &&
            (_selectedRol == "Todos" ||
                vacante["titulo"]!
                    .toLowerCase()
                    .contains(_selectedRol.toLowerCase())) &&
            (vacante["titulo"]!
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                vacante["empresa"]!
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    int totalPaginas = (_filteredVacantes.length / _itemsPorPagina).ceil();
    List<Map<String, dynamic>> vacantesPagina = _filteredVacantes
        .skip((_paginaActual - 1) * _itemsPorPagina)
        .take(_itemsPorPagina)
        .toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Column(
          children: [
            Header(
              isHome: true,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Buscar puestos de trabajo",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    value: _selectedEmpresa,
                    isExpanded: true,
                    items: [
                      "Todas",
                      "Banco de Crédito del Perú",
                      "Interbank",
                      "MiBanco",
                      "Pacífico"
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEmpresa = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    value: _selectedRol,
                    isExpanded: true,
                    items: [
                      "Todos",
                      "Desarrollador",
                      "Analista",
                      "Ciberseguridad"
                    ]
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRol = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: vacantesPagina.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.grey, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vacantesPagina[index]["titulo"]!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(vacantesPagina[index]["empresa"]!,
                                  style: const TextStyle(color: Colors.blue)),
                              const Icon(Icons.business, color: Colors.blue),
                            ],
                          ),
                          //const Divider(dashed: true),
                          const DashedLine(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(vacantesPagina[index]["ubicacion"]!),
                              Text("${vacantesPagina[index]["disponibilidad"]}",
                                  style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              final oferta = vacantesPagina[index];
                              Navigator.pushNamed(
                                context,
                                AppRoutes.studentOfferDetails,
                                arguments: oferta,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                            child: const Text("Ver Detalle",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildPaginationControls(totalPaginas),
          ],
        ),
      ),
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
}
