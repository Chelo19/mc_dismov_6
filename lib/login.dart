import 'package:flutter/material.dart';
import 'package:google_mao/register.dart';
import 'package:supabase/supabase.dart';
import 'HomeScreen.dart';
import 'auth_state.dart';

class LoginScreen extends StatefulWidget {
  final SupabaseClient supabase;
  LoginScreen({required this.supabase});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email = ''; // Inicializa con una cadena vacía
  late String password = ''; // Inicializa con una cadena vacía

  Future<void> checkSession() async {
    final Session? session = widget.supabase.auth.currentSession;
    print(session);
  }

  Future<void> loginUser() async {
  print(email);
  print(password);

  try {
    final AuthResponse res = await widget.supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final Session? session = res.session;
    final User? user = res.user;

    // Si el usuario no existe, muestra un mensaje de error
    if (user == null) {
      // Muestra un mensaje de error en la app
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faltan'),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
          MaterialPageRoute(builder: (context) => HomeScreen(supabase: widget.supabase)),
      );
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Los datos son incorrectos'),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 140),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value; // Almacena el valor del correo electrónico
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value; // Almacena el valor de la contraseña
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loginUser(); // Llama a la función de registro con los valores ingresados
                },
                child: const Text('Iniciar Sesion'),
              ),
              const SizedBox(height: 20),
              const Text('No tienes cuenta?'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen(supabase: widget.supabase)),
                  );
                },
                child: const Text('Registrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}