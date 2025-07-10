import 'package:flutter/material.dart';

class PerfilEstudianteScreen extends StatefulWidget {
  const PerfilEstudianteScreen({super.key});

  @override
  State<PerfilEstudianteScreen> createState() => _PerfilEstudianteScreenState();
}

class _PerfilEstudianteScreenState extends State<PerfilEstudianteScreen> {
  int _currentPage = 1;
  bool _isAvailableImmediately = false;
  bool _isAvailableIn1To2Months = false;
  bool _isAvailableInMoreThan2Months = false;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _currentPage == 1 ? _buildPage1() : _buildPage2(),
        ),
        _buildPagination(),
      ],
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 50, backgroundColor: Colors.grey[300]),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildEditableField("Nombre"),
          const SizedBox(height: 16),
          _buildEditableField("Apellido"),
          const SizedBox(height: 16),
          _buildEditableField("Correo"),
          const SizedBox(height: 16),
          _buildEditableField("Contraseña", isPassword: true),
          const SizedBox(height: 16),
          _buildDropdown("Universidad"),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildDateField("Fecha de inicio", _startDate,
                      (date) => setState(() => _startDate = date))),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildDateField("Fecha fin", _endDate,
                      (date) => setState(() => _endDate = date))),
            ],
          ),
          const SizedBox(height: 10),
          _buildToggle(
              "Actualmente estoy en la universidad", false, (value) {}),
          const SizedBox(height: 10),
          _buildEditableField("Descripción", isLarge: true),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildDropdown("Tecnologías"),
          const SizedBox(height: 14),
          _buildTagList(["Html", "Css", "Javascript"]),
          const SizedBox(height: 16),
          _buildDropdown("Disponibilidad"),
          const SizedBox(height: 14),
          _buildToggle("Inmediata", _isAvailableImmediately, (value) {
            setState(() {
              _isAvailableImmediately = value;
              if (value) {
                _isAvailableIn1To2Months = false;
                _isAvailableInMoreThan2Months = false;
              }
            });
          }),
          _buildToggle("1 mes - 2 meses", _isAvailableIn1To2Months, (value) {
            setState(() {
              _isAvailableIn1To2Months = value;
              if (value) {
                _isAvailableImmediately = false;
                _isAvailableInMoreThan2Months = false;
              }
            });
          }),
          _buildToggle("> 2 meses", _isAvailableInMoreThan2Months, (value) {
            setState(() {
              _isAvailableInMoreThan2Months = value;
              if (value) {
                _isAvailableImmediately = false;
                _isAvailableIn1To2Months = false;
              }
            });
          }),
          const SizedBox(height: 16),
          _buildFileUpload("Adjuntar CV"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton("Cancelar", Colors.red),
              _buildButton("Guardar", Colors.blue[900]!),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              _currentPage > 1 ? () => setState(() => _currentPage--) : null,
        ),
        Text("Página $_currentPage de 2"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed:
              _currentPage < 2 ? () => setState(() => _currentPage++) : null,
        ),
      ],
    );
  }

  Widget _buildEditableField(String label,
      {bool isPassword = false, bool isLarge = false}) {
    return TextFormField(
      obscureText: isPassword,
      maxLines: isLarge ? 3 : 1,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }

  Widget _buildDropdown(String label) {
    return DropdownButtonFormField(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: [DropdownMenuItem(value: "", child: Text("Seleccionar"))],
      onChanged: (value) {},
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
        title: Text(label), value: value, onChanged: onChanged);
  }

  Widget _buildFileUpload(String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: Colors.black),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Icon(Icons.attach_file, color: const Color(0xFF8894FC)),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color, foregroundColor: Colors.white),
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget _buildTagList(List<String> tags) {
    return Wrap(
      spacing: 8.0,
      children: tags
          .map((tag) => FilterChip(
                selected: _selectedTags.contains(tag),
                label: Text(tag),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                selectedColor: const Color(0xFF8894FC),
                checkmarkColor: Colors.white,
              ))
          .toList(),
    );
  }

  Widget _buildDateField(
      String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }
}
