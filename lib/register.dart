import 'package:flutter/material.dart';
import 'package:google_mao/login.dart';
import 'package:supabase/supabase.dart';
import 'auth_state.dart';

class RegisterScreen extends StatefulWidget {
  final SupabaseClient supabase;
  RegisterScreen({required this.supabase});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late String email = ''; // Inicializa con una cadena vacía
  late String name = ''; // Inicializa con una cadena vacía
  late String password = ''; // Inicializa con una cadena vacía

  Future<void> registerUser() async {
    print(email);
    print(password);

    final AuthResponse res = await widget.supabase.auth.signUp(
      email: email,
      password: password,
    );

    final Session? session = res.session;
    final User? user = res.user;

    print(user);

    await widget.supabase
    .from('users')
    .insert({'email': email, 'name': name, 'guid': user!.id});

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(supabase: widget.supabase)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  name = value; // Almacena el valor del correo electrónico
                });
              },
            ),
            const SizedBox(height: 20),
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
                registerUser(); // Llama a la función de registro con los valores ingresados
              },
              child: const Text('Registrarse'),
            ),

            const SizedBox(height: 20),
            const Text('Ya tienes cuenta?'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen(supabase: widget.supabase)),
                );
              },
              child: const Text('Inicia sesion'),
            ),
          ],
        ),
      ),
    );
  }
}
