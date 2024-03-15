import 'dart:convert';

import 'package:exportaciones/screen/ListarExportaciones.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Http {
  static String url =
      "https://exportaciones-api.onrender.com/exportaciones"; //link de mi codigo consumible
  static postExportancion(Map exportacion) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(exportacion),
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Falló la inserción contacta con el administrador del sistema");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class Exportaciones extends StatefulWidget {
  const Exportaciones({super.key});

  @override
  State<Exportaciones> createState() => _ExportacionesState();
}

TextEditingController id_p = TextEditingController();
TextEditingController producto = TextEditingController();
TextEditingController kilos = TextEditingController();
TextEditingController precio_kilos = TextEditingController();
TextEditingController precio_dolar_actual = TextEditingController();

class _ExportacionesState extends State<Exportaciones> {
  static String url_dolar = "https://www.datos.gov.co/resource/mcec-87by.json";
  @override
  void initState() {
    super.initState();
    actualizarValorDolar();
  }

  Future<void> actualizarValorDolar() async {
    try {
      final response = await http.get(Uri.parse(url_dolar));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          final primerObjeto = jsonData[0];
          setState(() {
            precio_dolar_actual.text = primerObjeto['valor'].toString();
          });
        } else {
          throw Exception('Formato de respuesta incorrecto o array vacío');
        }
      } else {
        throw Exception('Error en la solicitud de la API');
      }
    } catch (error) {
      print('Error al obtener el valor del dólar: $error');
      setState(() {
        precio_dolar_actual.text = 'Error al obtener el valor del dólar';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar exportación'),
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: id_p,
                decoration: const InputDecoration(
                  labelText: 'ID del producto',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: producto,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                controller: kilos,
                decoration: const InputDecoration(
                  labelText: 'Kilos',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                controller: precio_kilos,
                decoration: const InputDecoration(
                  labelText: 'Precio por kilo',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: precio_dolar_actual,
                decoration: const InputDecoration(
                  labelText: 'Precio Dólar',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  var exportacion = {
                    "id_p": id_p.text,
                    "producto": producto.text,
                    "kilos": kilos.text,
                    "precio_kilo": precio_kilos.text,
                    "precio_dolar_actual": precio_dolar_actual.text
                  };

                  print(exportacion);
                  Http.postExportancion(exportacion);

                  final route = MaterialPageRoute(
                      builder: (context) => const ListarExportacion());
                  Navigator.push(context, route);
                },
                icon: const Icon(Icons.check),
                label: const Text('Registrar',
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
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
}
