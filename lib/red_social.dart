import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RedSocialPage extends StatefulWidget {
  const RedSocialPage({Key? key});

  @override
  _RedSocialPageState createState() => _RedSocialPageState();
}

class _RedSocialPageState extends State<RedSocialPage> {
  Set<Marker> markers = <Marker>{};
  TextEditingController resenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Social'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(25.689470285602457, -100.31649801084538),
                zoom: 13.5,
              ),
              markers: markers,
              onTap: (LatLng position) {
                _mostrarDialogoResena(context, position);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: resenaController,
              decoration: const InputDecoration(
                hintText: 'Deja tu reseña...',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _agregarResena();
                },
                child: const Text('Agregar Reseña'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _borrarResena(); // Llamada para borrar la última reseña
                },
                child: const Text('Borrar Última Reseña'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoResena(BuildContext context, LatLng position) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Reseña'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Ubicación: ${position.latitude}, ${position.longitude}'),
                TextField(
                  controller: resenaController,
                  decoration: const InputDecoration(labelText: 'Reseña'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _agregarResenaEnPosicion(position);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _agregarResena() {
    LatLng selectedPosition = const LatLng(25.689470285602457, -100.31649801084538);

    if (resenaController.text.isNotEmpty) {
      _agregarResenaEnPosicion(selectedPosition);
    }
  }

  void _agregarResenaEnPosicion(LatLng position) {
    if (resenaController.text.isNotEmpty) {
      final Marker marker = Marker(
        markerId: MarkerId(DateTime.now().toString()),
        position: position,
        infoWindow: InfoWindow(
          title: 'Reseña',
          snippet: resenaController.text,
        ),
      );

      setState(() {
        markers.add(marker);
        resenaController.clear();
      });
    }
  }

  void _borrarResena() {
    if (markers.isNotEmpty) {
      setState(() {
        markers.remove(markers.last);
      });
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: RedSocialPage(),
  ));
}
