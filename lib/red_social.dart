import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedSocialPage extends StatefulWidget {
  const RedSocialPage({Key? key}) : super(key: key);

  @override
  _RedSocialPageState createState() => _RedSocialPageState();
}

class _RedSocialPageState extends State<RedSocialPage> {
  Set<Marker> markers = <Marker>{};
  TextEditingController resenaController = TextEditingController();
  late SharedPreferences prefs;
  late GoogleMapController mapController; // Agrega el controlador del mapa

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    prefs = await SharedPreferences.getInstance();
    final List<String>? savedMarkers = prefs.getStringList('markers');
    if (savedMarkers != null) {
      setState(() {
        markers = savedMarkers.map((String markerString) {
          final List<String> parts = markerString.split(',');
          return Marker(
            markerId: MarkerId(parts[0]),
            position: LatLng(double.parse(parts[1]), double.parse(parts[2])),
            infoWindow: InfoWindow(
              title: 'Reseña',
              snippet: parts[3],
            ),
          );
        }).toSet();
      });
    }
  }

  Future<void> _saveMarkers() async {
    final List<String> markerStrings = markers.map((Marker marker) {
      return '${marker.markerId.value},${marker.position.latitude},${marker.position.longitude},${marker.infoWindow!.snippet}';
    }).toList();

    await prefs.setStringList('markers', markerStrings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Social'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 80, bottom: 30, left: 16, right: 16),
              color: const Color.fromARGB(255, 0, 89, 161),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explora las Reseñas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Descubre experiencias de otros usuarios',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            for (Marker marker in markers)
              ListTile(
                title: Text(
                  marker.infoWindow.snippet!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Lat: ${marker.position.latitude}, Long: ${marker.position.longitude}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                leading: const Icon(
                  Icons.location_pin,
                  color: Colors.blue,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _moveToMarker(marker);
                },
              ),
          ],
        ),
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
              // Captura el controlador del mapa cuando se crea
              onMapCreated: (controller) {
                mapController = controller;
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
                  _borrarResena();
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
                _confirmarAgregarResena(context, position);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarAgregarResena(BuildContext context, LatLng position) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text('¿Estás seguro de agregar esta reseña en esta ubicación?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _agregarResenaEnPosicion(position);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Sí'),
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
        _saveMarkers();
      });
    }
  }

  void _borrarResena() {
    if (markers.isNotEmpty) {
      setState(() {
        markers.remove(markers.last);
        _saveMarkers();
      });
    }
  }

  void _moveToMarker(Marker marker) {
    mapController.animateCamera(CameraUpdate.newLatLng(marker.position));
  }
}

void main() {
  runApp(const MaterialApp(
    home: RedSocialPage(),
  ));
}
