import 'package:flutter/material.dart';
import 'package:google_mao/main.dart';

class RedesSeleccion extends StatelessWidget {
  const RedesSeleccion({Key? key});

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/background_patterns.jpg'), // Ruta de la imagen
            fit: BoxFit.cover, // Ajustar la imagen al contenedor
            colorFilter: ColorFilter.mode(
              const Color.fromARGB(255, 177, 176, 176).withOpacity(0.6), // Opacidad del patrón
              BlendMode.darken, // Modo de fusión
            ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Red 4G Telcel'),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              const SizedBox(height: 24), // Espacio en blanco entre botones
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Red 5G Telcel'),
                onPressed: () {
                  Navigator.pushNamed(context, 'Redes5G');
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'RedSocialPage');
                },
                child: const Text('Red Social'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
