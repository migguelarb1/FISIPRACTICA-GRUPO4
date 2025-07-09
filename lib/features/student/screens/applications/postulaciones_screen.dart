import 'package:flutter/material.dart';

class MisPostulacionesScreen extends StatefulWidget {
  const MisPostulacionesScreen({super.key});

  @override
  State<MisPostulacionesScreen> createState() => _MisPostulacionesScreenState();
}

class _MisPostulacionesScreenState extends State<MisPostulacionesScreen> {
  String _selectedFilter = "En proceso";
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  final List<Map<String, dynamic>> _allPostulaciones = [
    {
      "titulo": "Practicante Frontend",
      "empresa": "Interbank",
      "estatus": "En proceso",
      "tiempo": "Hace 2 semanas",
      "candidatos": 120
    },
    {
      "titulo": "Practicante Backend",
      "empresa": "BBVA",
      "estatus": "CV visto",
      "tiempo": "Hace 3 días",
      "candidatos": 89
    },
    {
      "titulo": "Data Analyst Intern",
      "empresa": "BCP",
      "estatus": "Finalista",
      "tiempo": "Hace 1 semana",
      "candidatos": 50
    },
    {
      "titulo": "Software Engineer Intern",
      "empresa": "Google",
      "estatus": "En proceso",
      "tiempo": "Hace 1 mes",
      "candidatos": 200
    },
    {
      "titulo": "Machine Learning Intern",
      "empresa": "Microsoft",
      "estatus": "CV visto",
      "tiempo": "Hace 5 días",
      "candidatos": 70
    },
    {
      "titulo": "Cybersecurity Intern",
      "empresa": "Amazon",
      "estatus": "Finalista",
      "tiempo": "Hace 2 semanas",
      "candidatos": 40
    },
    {
      "titulo": "Cloud Engineer Intern",
      "empresa": "IBM",
      "estatus": "En proceso",
      "tiempo": "Hace 3 semanas",
      "candidatos": 85
    },
    {
      "titulo": "Data Scientist Intern",
      "empresa": "Facebook",
      "estatus": "CV visto",
      "tiempo": "Hace 6 días",
      "candidatos": 65
    },
    {
      "titulo": "QA Tester Intern",
      "empresa": "Intel",
      "estatus": "Finalista",
      "tiempo": "Hace 4 semanas",
      "candidatos": 55
    },
    {
      "titulo": "IT Support Intern",
      "empresa": "Tesla",
      "estatus": "En proceso",
      "tiempo": "Hace 3 días",
      "candidatos": 30
    },
    {
      "titulo": "DevOps Intern",
      "empresa": "Oracle",
      "estatus": "En proceso",
      "tiempo": "Hace 2 semanas",
      "candidatos": 95
    },
    {
      "titulo": "UX/UI Designer Intern",
      "empresa": "Adobe",
      "estatus": "En proceso",
      "tiempo": "Hace 1 mes",
      "candidatos": 60
    },
  ];

  List<Map<String, dynamic>> get _filteredPostulaciones => _allPostulaciones
      .where((post) => post["estatus"] == _selectedFilter)
      .toList();

  int get _totalPages => (_filteredPostulaciones.length / _itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildFilter(),
        const SizedBox(height: 10),
        Expanded(child: _buildPostulacionesList()),
        _buildPaginationControls(),
      ],
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        value: _selectedFilter,
        items: ["En proceso", "CV visto", "Finalista"]
            .map((filter) => DropdownMenuItem(
                  value: filter,
                  child: Text(filter),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedFilter = value!;
            _currentPage = 1;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Filtrar por",
        ),
      ),
    );
  }

  Widget _buildPostulacionesList() {
    List<Map<String, dynamic>> displayedPostulaciones = _filteredPostulaciones
        .skip((_currentPage - 1) * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    return ListView.builder(
      itemCount: displayedPostulaciones.length,
      itemBuilder: (context, index) {
        final post = displayedPostulaciones[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 3,
          child: ListTile(
            leading: const Icon(Icons.work, color: Colors.blue),
            title: Text(post["titulo"],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post["empresa"]),
                Text(post["estatus"],
                    style: const TextStyle(color: Colors.green)),
                Text(post["tiempo"]),
                Text("Candidatos: ${post["candidatos"]}"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        Text("Página $_currentPage de $_totalPages"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _currentPage < _totalPages
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }
}
