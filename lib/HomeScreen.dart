import 'package:flutter/material.dart';
import 'package:google_mao/login.dart';
import 'package:supabase/supabase.dart';
import 'register.dart';
import 'login.dart';
import 'create_animal.dart';
import 'check_animals.dart';
import 'check_all_animals.dart';

class HomeScreen extends StatelessWidget {
  final SupabaseClient supabase;

  HomeScreen({required this.supabase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Fondo blanco para toda la barra de la aplicación
        title: const Text(
          'PetCare Connect',
          style: TextStyle(
            color: Colors.green,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menú'),
            ),
            ListTile(
              title: const Text('Registro'),
              onTap: () {
                // Navegar a la página de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(supabase: supabase)),
                );
              },
            ),
            ListTile(
              title: const Text('Cerrar sesion'),
              onTap: () {
                // Navegar a la página de inicio de sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(supabase: supabase)),
                );
              },
            ),
            ListTile(
              title: const Text('Registro de mascota'),
              onTap: () {
                // Navegar a la página de registro de mascota
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAnimal(supabase: supabase)),
                );
              },
            ),
            ListTile(
              title: const Text('Mis mascotas'),
              onTap: () {
                // Navegar a la página de mis mascotas
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckAnimals(
                          supabase: supabase,
                        userId: supabase.auth.currentUser!.id,
                      ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Todas las mascotas'),
              onTap: () {
                // Navegar a la página de todas las mascotas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckAllAnimals(supabase: supabase)),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sobre nosotros',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Somos una comunidad apasionada por el cuidado de las mascotas y estamos comprometidos con proporcionar información valiosa y recursos para garantizar la salud y el bienestar de tus mascotas.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/perrosentado.png', // Ruta de la imagen local
                height: 300, // Altura de la imagen
                width: 300, // Ancho de la imagen
                fit: BoxFit.cover, // Ajustar la imagen dentro del contenedor
              ),
            ],
          ),
        ),
      ),
    );
  }
}
