import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EliminarExportacion extends StatefulWidget {
  final String idProducto;

  const EliminarExportacion(this.idProducto, {Key? key}) : super(key: key);

  @override
  State<EliminarExportacion> createState() => _EliminarExportacionState();
}

class _EliminarExportacionState extends State<EliminarExportacion> {
  late Future<void> _futureDelete;

  @override
  void initState() {
    super.initState();
    _futureDelete = _eliminarExportacion();
  }

  Future<void> _eliminarExportacion() async {
    // URL de la API donde se encuentra el recurso a eliminar
    final String url =
        'https://exportaciones-api.onrender.com/exportaciones/${widget.idProducto}';

    try {
      // Realiza la solicitud DELETE al servidor
      final response = await http.delete(Uri.parse(url));

      // Verifica si la solicitud fue exitosa (código de estado 200)
      if (response.statusCode == 200) {
        print('Exportación eliminada con éxito');
      } else {
        print('Error al eliminar exportación: ${response.statusCode}');
        throw Exception('Failed to delete exportación.');
      }
    } catch (e) {
      // Manejo de errores
      print('Error al eliminar la exportación: $e');
      throw Exception('Failed to delete exportación.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eliminar Exportación'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _futureDelete,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Text('Exportación eliminada con éxito');
            }
          },
        ),
      ),
    );
  }
}
