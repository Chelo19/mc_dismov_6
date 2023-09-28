import 'package:flutter/material.dart';
import 'package:google_mao/main.dart';

class RedesSeleccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SignalFinder",
          style: TextStyle(
            color: Color.fromRGBO(244, 175, 27, 1),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'GoblinOne',
            shadows: [
              Shadow(
                offset: Offset(5, 5),
                blurRadius: 5.0,
                color: Color.fromRGBO(0, 0, 0, 0.658),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Red 4G Telcel'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            const SizedBox(height: 16), // Espacio en blanco entre botones
            ElevatedButton(
              child: const Text('Red 5G Telcel'),
              onPressed: () {
                Navigator.pushNamed(context, 'Redes5G');
              },
            ),
          ],
        ),
      ),
    );
  }
}
