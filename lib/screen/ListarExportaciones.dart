import 'dart:convert';

import 'package:exportaciones/screen/EditarExportaciones.dart';
import 'package:exportaciones/screen/EliminarExportaciones.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Exportacion {
  final String id;
  // ignore: non_constant_identifier_names
  final int id_p;
  // ignore: non_constant_identifier_names
  final String producto;

  final int kilos;

  // ignore: non_constant_identifier_names
  final int precio_kilo;

  // ignore: non_constant_identifier_names
  final double precio_dolar_actual;

  Exportacion(
      {required this.id,
      required this.id_p,
      required this.producto,
      required this.kilos,
      required this.precio_kilo,
      required this.precio_dolar_actual});

  factory Exportacion.fromJson(Map<String, dynamic> json) {
    return Exportacion(
      id: json['_id'],
      id_p: json['id_p'],
      producto: json['producto'],
      kilos: json['kilos'],
      precio_kilo: json['precio_kilo'],
      precio_dolar_actual: json['precio_dolar_actual'],
    );
  }
}

Future<List<Exportacion>> fetchPosts() async {
  final response = await http
      .get(Uri.parse("https://exportaciones-api.onrender.com/exportaciones"));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> exportacionesJson = jsonData['msg'];
    return exportacionesJson.map((json) => Exportacion.fromJson(json)).toList();
  } else {
    throw Exception('Fallo la carga de las exportaciones');
  }
}

class ListarExportacion extends StatefulWidget {
  const ListarExportacion({super.key});

  @override
  State<ListarExportacion> createState() => _ListarExportacionState();
}

class _ListarExportacionState extends State<ListarExportacion> {
  late List<Exportacion> exportaciones;

  @override
  void initState() {
    super.initState();
    // Inicialización de la lista en el initState
    exportaciones = [];
  }

  void editarExportacion(BuildContext context, Exportacion exportacion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarExportacion(exportacion: exportacion),
      ),
    );
  }

  late Future<List<Exportacion>> futureExportaciones;

  void eliminarExportacion(int id_p) async {
    final response = await http.delete(
      Uri.parse("https://exportaciones-api.onrender.com/exportaciones?$id_p"),
    );
    print(response.body);
    if (response.statusCode == 200) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportaciones'),
        backgroundColor: Colors.blue, // Color para la cabecera
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Agregar aquí la lógica del menú
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Exportacion> exportaciones =
                snapshot.data as List<Exportacion>;
            return ListView.builder(
              itemCount: exportaciones.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      exportaciones[index].producto,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Id: ${exportaciones[index].id_p.toInt()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Kilos: ${exportaciones[index].kilos.toInt()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Precio por kilo: ${exportaciones[index].precio_kilo.toInt()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Precio Dólar actual: ${exportaciones[index].precio_dolar_actual.toDouble()}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            editarExportacion(context, exportaciones[index]);
                            // Implementar la lógica para editar aquí
                            print('Editar');
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            eliminarExportacion(exportaciones[index].id_p);
                            // Implementar la lógica para eliminar aquí
                            print('Eliminar');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
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
