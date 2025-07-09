import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class EmpresasScreen extends StatefulWidget {
  const EmpresasScreen({super.key});

  @override
  State<EmpresasScreen> createState() => _EmpresasScreenState();
}

class _EmpresasScreenState extends State<EmpresasScreen> {
  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 5;
  int _currentPage = 1;
  String _searchQuery = "";
  bool _mostrarFormulario = false;
  final TextEditingController _nombreEmpresaController = TextEditingController();

  final List<Map<String, dynamic>> empresas = [
    {'nombre': 'Banco de Crédito del Perú', 'foto': 'assets/bcp.png'},
    {'nombre': 'Interbank', 'foto': 'assets/interbank.png'},
    {'nombre': 'BBVA', 'foto': 'assets/bbva.png'},
    {'nombre': 'Scotiabank', 'foto': 'assets/scotiabank.jpg'},
    {'nombre': 'MiBanco', 'foto': 'assets/mibanco.png'},
    {'nombre': 'Alicorp', 'foto': 'assets/alicorp.png'},
    {'nombre': 'Backus', 'foto': 'assets/backus.jpg'},
    {'nombre': 'Cemex Perú', 'foto': 'assets/cemex.png'},
    {'nombre': 'Corporación Lindley', 'foto': 'assets/lindley.png'},
    {'nombre': 'Ferreyros', 'foto': 'assets/ferreyros.png'},
    {'nombre': 'Cosapi', 'foto': 'assets/cosapi.jpg'},
    {'nombre': 'Southern Copper Corporation', 'foto': 'assets/southern.png'},
    {'nombre': 'Claro Perú', 'foto': 'assets/claro.png'},
    {'nombre': 'Inca Kola', 'foto': 'assets/inca.jpg'},
    {'nombre': 'Tottus', 'foto': 'assets/tottus.png'},
  ];

  List<Map<String, dynamic>> get _filteredEmpresas {
    return empresas
        .where((empresa) => empresa['nombre']!
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 1) _currentPage--;
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentPage * _itemsPerPage < _filteredEmpresas.length) _currentPage++;
    });
  }

  void _mostrarFormularioCrearEmpresa() {
    setState(() {
      _mostrarFormulario = true;
      _nombreEmpresaController.clear();
    });
  }

  void _guardarEmpresa() {
    if (_nombreEmpresaController.text.trim().isEmpty) return;
    setState(() {
      empresas.add({
        'nombre': _nombreEmpresaController.text.trim(),
        'foto': 'assets/empresa.png'
      });
      _mostrarFormulario = false;
    });
  }

  void _cancelarFormulario() {
    setState(() => _mostrarFormulario = false);
  }

  @override
  Widget build(BuildContext context) {
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    List<Map<String, dynamic>> currentEmpresas = _filteredEmpresas.sublist(
      startIndex,
      endIndex > _filteredEmpresas.length ? _filteredEmpresas.length : endIndex,
    );

    int totalPages = (_filteredEmpresas.length / _itemsPerPage).ceil();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Header(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Empresas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3984),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Escriba la empresa',
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 155, 194, 204)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _filteredEmpresas.isEmpty
                    ? const Center(child: Text('No hay empresas disponibles.'))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: currentEmpresas.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              elevation: 5,
                              child: SizedBox(
                                height: 90,
                                child: Center(
                                  child: ListTile(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Acción'),
                                            content: const Text('¿Qué deseas hacer con esta empresa?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: const Text('Mantener'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    empresas.removeAt(startIndex + index);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                                child: const Text('Eliminar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                        currentEmpresas[index]['foto'] ?? 'assets/empresa.png',
                                      ),
                                    ),
                                    title: Text(
                                      currentEmpresas[index]['nombre'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF1E3984),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: _previousPage),
                  Expanded(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: List.generate(
                        totalPages,
                        (index) => TextButton(
                          onPressed: () => setState(() => _currentPage = index + 1),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight:
                                  _currentPage == index + 1 ? FontWeight.bold : FontWeight.normal,
                              color: _currentPage == index + 1 ? Colors.blue : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.arrow_forward), onPressed: _nextPage),
                ],
              ),
            ],
          ),
          if (_mostrarFormulario)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          if (_mostrarFormulario)
            Center(
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Futuro: lógica para imagen
                        },
                        icon: const Icon(Icons.image),
                        label: const Text("Agregar Foto"),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nombreEmpresaController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la empresa',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _cancelarFormulario,
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: _guardarEmpresa,
                            child: const Text('Guardar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: _mostrarFormularioCrearEmpresa,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
