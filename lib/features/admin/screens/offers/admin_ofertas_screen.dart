import 'package:flutter/material.dart';
import 'package:flutter_app/features/shared/widgets/header.dart';

class EditarOfertasScreen extends StatefulWidget {
  const EditarOfertasScreen({super.key});

  @override
  State<EditarOfertasScreen> createState() => _EditarOfertasScreen();
}

class _EditarOfertasScreen extends State<EditarOfertasScreen> {
  String _filtroFecha = "Hoy";
  final List<Map<String, String>> _ofertas = [
    {
      "titulo": "Practicante TI",
      "empresa": "Interbank",
      "descripcion": "Soporte en desarrollo de software.",
      "ubicacion": "San Isidro, Lima, Perú",
      "fecha": "Hoy"
    },
    {
      "titulo": "Practicante de Marketing",
      "empresa": "BBVA",
      "descripcion": "Apoyo en campañas digitales.",
      "ubicacion": "Miraflores, Lima, Perú",
      "fecha": "Ayer"
    },
    {
      "titulo": "Practicante de Finanzas",
      "empresa": "BCP",
      "descripcion": "Análisis financiero.",
      "ubicacion": "San Borja, Lima, Perú",
      "fecha": "Hoy"
    },
  ];

  void _editarOferta(int index) {
    TextEditingController tituloController =
        TextEditingController(text: _ofertas[index]["titulo"]);
    TextEditingController empresaController =
        TextEditingController(text: _ofertas[index]["empresa"]);
    TextEditingController descripcionController =
        TextEditingController(text: _ofertas[index]["descripcion"]);
    TextEditingController ubicacionController =
        TextEditingController(text: _ofertas[index]["ubicacion"]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Oferta"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: tituloController,
                  decoration: InputDecoration(labelText: "Título")),
              TextField(
                  controller: empresaController,
                  decoration: InputDecoration(labelText: "Empresa")),
              TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(labelText: "Descripción")),
              TextField(
                  controller: ubicacionController,
                  decoration: InputDecoration(labelText: "Ubicación")),
            ],
          ), //
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ofertas[index] = {
                    "titulo": tituloController.text,
                    "empresa": empresaController.text,
                    "descripcion": descripcionController.text,
                    "ubicacion": ubicacionController.text,
                    "fecha": _ofertas[index]["fecha"]!,
                  };
                });
                Navigator.pop(context);
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> ofertasFiltradas =
        _ofertas.where((oferta) => oferta["fecha"] == _filtroFecha).toList();

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
          children: [
            DropdownButton<String>(
              value: _filtroFecha,
              items: ["Hoy", "Ayer", "Última Semana"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _filtroFecha = newValue!;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ofertasFiltradas.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(ofertasFiltradas[index]["titulo"]!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${ofertasFiltradas[index]["empresa"]} - ${ofertasFiltradas[index]["ubicacion"]}"),
                          Text(ofertasFiltradas[index]["descripcion"]!),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editarOferta(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                setState(() => _ofertas.removeAt(index)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: Footer(),
    );
  }
}
