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
        title: const Text('PetCare Connect'),
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
              title: const Text('Inicio de sesión'),
              onTap: () {
                // Navegar a la página de inicio de sesión
                Navigator.push(
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
                  MaterialPageRoute(builder: (context) => CheckAnimals(supabase: supabase)),
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
      body: const Center(
        child: Text('Contenido principal'),
      ),
    );
  }
}
