import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/constants.dart';
import 'package:google_mao/elegirredes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RedSocialPage extends StatefulWidget {
  @override
  _RedSocialPageState createState() => _RedSocialPageState();
}

class _RedSocialPageState extends State<RedSocialPage> {
  Set<Marker> markers = Set<Marker>();
  TextEditingController resenaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Red Social'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(25.689470285602457, -100.31649801084538), // Ubicación de referencia
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
              decoration: InputDecoration(
                hintText: 'Deja tu reseña...',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _agregarResena();
            },
            child: Text('Agregar Reseña'),
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
          title: Text('Agregar Reseña'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text('Ubicación: ${position.latitude}, ${position.longitude}'),
                TextField(
                  controller: resenaController,
                  decoration: InputDecoration(labelText: 'Reseña'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _agregarResena();
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _agregarResena() {
    if (resenaController.text.isNotEmpty) {
      final Marker marker = Marker(
        markerId: MarkerId(DateTime.now().toString()),
        position: LatLng(25.689470285602457, -100.31649801084538), // Usar la ubicación actual o la seleccionada
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
}