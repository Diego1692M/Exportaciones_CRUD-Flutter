import 'dart:convert';

import 'package:exportaciones/screen/ListarExportaciones.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditarExportacion extends StatefulWidget {
  final Exportacion exportacion;
  const EditarExportacion({Key? key, required this.exportacion})
      : super(key: key);

  @override
  State<EditarExportacion> createState() => _EditarExportacionState();
}

class _EditarExportacionState extends State<EditarExportacion> {
  late TextEditingController productoController;
  late TextEditingController kilosController;
  late TextEditingController precioKilosController;
  late TextEditingController precioDolarController;

  @override
  void initState() {
    super.initState();
    productoController =
        TextEditingController(text: widget.exportacion.producto);
    kilosController =
        TextEditingController(text: widget.exportacion.kilos.toString());
    precioKilosController =
        TextEditingController(text: widget.exportacion.precio_kilo.toString());
    precioDolarController = TextEditingController(
        text: widget.exportacion.precio_dolar_actual.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar exportación'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Agregar aquí la lógica del menú
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: productoController,
              decoration: const InputDecoration(
                labelText: 'Producto',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: kilosController,
              decoration: const InputDecoration(
                labelText: 'Kilos',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioKilosController,
              decoration: const InputDecoration(
                labelText: 'Precio por kilo',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioDolarController,
              decoration: const InputDecoration(
                labelText: 'Precio en dólares',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Convertir los valores de texto a tipos numéricos
                int kilos = int.parse(kilosController.text);
                int precioKilos = int.parse(precioKilosController.text);
                double precioDolar = double.parse(precioDolarController.text);

                // Crear la instancia de Exportacion con los valores convertidos
                Exportacion exportacionActualizada = Exportacion(
                  id: widget.exportacion.id,
                  id_p: widget.exportacion.id_p,
                  producto: productoController.text,
                  kilos: kilos,
                  precio_kilo: precioKilos,
                  precio_dolar_actual: precioDolar,
                );
                await editarExportacion(exportacionActualizada);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Cambios guardados'),
                      content:
                          const Text('Los cambios se guardaron con éxito.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                            Navigator.of(context)
                                .pop(); // Vuelve a la pantalla de listado
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Guardar',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Agregar aquí la lógica del menú
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Agregar aquí la lógica de búsqueda
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Agregar aquí la lógica de configuración
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editarExportacion(Exportacion exportacion) async {
    // URL de la API donde se encuentra el recurso a editar
    const String url = 'https://exportaciones-api.onrender.com/exportaciones';

    // Convierte los datos de la exportación a un formato que la API pueda entender (JSON)
    final Map<String, dynamic> datosActualizados = {
      // Aquí debes incluir los campos que deseas actualizar
      '_id': exportacion.id,
      'id_p': exportacion.id_p,
      'producto': exportacion.producto,
      'kilos': exportacion.kilos,
      'precioKilos': exportacion.precio_kilo,
      'precioDolar': exportacion.precio_dolar_actual,
    };
    print('Datos actualizados:');
    print(datosActualizados);

    // Codificar los datos a JSON
    final String cuerpoJson = jsonEncode(datosActualizados);

    try {
      // Realiza la solicitud PUT al servidor
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        }, // Establecer la cabecera para indicar que el cuerpo es JSON
        body: cuerpoJson, // Pasar el cuerpo codificado JSON
      );

      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        print('Exportación editada con éxito');
        setState(() {});
      } else {
        print('Error al editar exportación: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
    }
  }
}
