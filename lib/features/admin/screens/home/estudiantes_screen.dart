import 'package:flutter/material.dart';
import 'package:flutter_app/features/features.dart';

class EstudiantesScreen extends StatefulWidget {
  const EstudiantesScreen({super.key});

  @override
  EstudiantesScreenState createState() => EstudiantesScreenState();
}

class EstudiantesScreenState extends State<EstudiantesScreen> {
  final List<Map<String, String>> estudiantes = [
    {
      'nombre': 'Juan Pérez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Juan Pérez'
    },
    {
      'nombre': 'María López',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de María López'
    },
    {
      'nombre': 'Carlos García',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Carlos García'
    },
    {
      'nombre': 'Ana Martínez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Ana Martínez'
    },
    {
      'nombre': 'Luis Rodríguez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Luis Rodríguez'
    },
    {
      'nombre': 'Sofía Hernández',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Sofía Hernández'
    },
    {
      'nombre': 'Miguel Torres',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Miguel Torres'
    },
    {
      'nombre': 'Laura Gómez',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Laura Gómez'
    },
    {
      'nombre': 'Pedro Díaz',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Pedro Díaz'
    },
    {
      'nombre': 'Lucía Fernández',
      'foto': 'assets/profile_picture.jpg',
      'descripcion': 'Descripción de Lucía Fernández'
    },
  ];

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 1) {
        _currentPage--;
      }
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentPage * _itemsPerPage < estudiantes.length) {
        _currentPage++;
      }
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  List<Widget> _buildPageNumbers(int totalPages) {
    List<Widget> pageNumbers = [];

    pageNumbers.add(_buildPageNumberButton(1));

    if (_currentPage > 3) {
      pageNumbers.add(Text('...'));
    }

    if (_currentPage > 1 && _currentPage < totalPages) {
      pageNumbers.add(_buildPageNumberButton(_currentPage));
    }

    if (_currentPage < totalPages - 2) {
      pageNumbers.add(Text('...'));
    }

    if (totalPages > 1) {
      pageNumbers.add(_buildPageNumberButton(totalPages));
    }

    return pageNumbers;
  }

  Widget _buildPageNumberButton(int page) {
    return TextButton(
      onPressed: () => _goToPage(page),
      child: Text(
        '$page',
        style: TextStyle(
          fontWeight:
              _currentPage == page ? FontWeight.bold : FontWeight.normal,
          color: _currentPage == page ? Color(0xFF1E3984) : Colors.black,
        ),
      ),
    );
  }

  void _showStudentDialog(Map<String, String> estudiante) {
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
                    _showConfirmationDialog(estudiante);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(Map<String, String> estudiante) {
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

  @override
  Widget build(BuildContext context) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final currentEstudiantes = estudiantes.sublist(
      startIndex,
      endIndex > estudiantes.length ? estudiantes.length : endIndex,
    );
    final totalPages = (estudiantes.length / _itemsPerPage).ceil();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Column(
          children: [
            Header(
              isHome: false,
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF1E3984).withValues(alpha: 0.1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(Icons.school, color: Color(0xFF1E3984), size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Lista de Estudiantes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3984),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: currentEstudiantes.length,
                    itemBuilder: (context, index) {
                      final estudiante = currentEstudiantes[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => _showStudentDialog(estudiante),
                          child: SizedBox(
                            height: 100,
                            child: Center(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(estudiante['foto']!),
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
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: _previousPage,
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: _buildPageNumbers(totalPages),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: _nextPage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
