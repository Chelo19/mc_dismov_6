import 'package:flutter/material.dart';
import 'package:google_mao/login.dart';
import 'package:supabase/supabase.dart';
import 'register.dart';
import 'login.dart';
import 'create_animal.dart';
import 'check_animals.dart';
import 'check_all_animals.dart';

class HomeScreen extends StatefulWidget {
  final SupabaseClient supabase;
  HomeScreen({required this.supabase});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String current_user = '';
  late String current_user_role = '0';

  Future<void> checkSession() async {
    final Session? session = widget.supabase.auth.currentSession;
    print(session);
    if (session != null) {
      current_user = session.user!.id;
    }
    print('current_user');
    print(current_user);

    final data = await widget.supabase
    .from('users')
    .select('*')
    .eq('guid', current_user);

    if(data[0]['role'] == 1){
      print('object');
      setState(() {
        current_user_role = '1';
      });
    }

    print(data[0]['role']);
    print(current_user_role);
  }

  // Future<void> debug() async {
  //   print('//////');
  //   final Session? session = widget.supabase.auth.currentSession;
  //   if (session != null) {
  //     setState(() {
  //       current_user = session.user!.id;
  //     });
  //   }
  // }

  ListTile buildListTile(String title, Function() onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.8,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.lightGreen.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }

  @override
  void initState() {
    super.initState();
    checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: ListView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                  child: Text(
                    'Menú',
                    style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildListTile('Registro', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen(supabase: widget.supabase)),
                );
              }),
              const SizedBox(height: 20),
              buildListTile('Cerrar sesión', () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(supabase: widget.supabase)),
                );
              }),
              const SizedBox(height: 20),
              buildListTile('Registro de mascota', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAnimal(supabase: widget.supabase)),
                );
              }),
              const SizedBox(height: 20),
              buildListTile('Mis mascotas', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckAnimals(
                      supabase: widget.supabase,
                      userId: widget.supabase.auth.currentUser!.id,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              current_user_role == '1' ?
                buildListTile('Todas las mascotas', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckAllAnimals(supabase: widget.supabase)),
                  );
                })
              :
              const SizedBox(height: 20),
            ],
          ),
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