import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

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

    final AuthResponse res = await widget.supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final Session? session = res.session;
    final User? user = res.user;

    print(session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
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
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginUser(); // Llama a la función de registro con los valores ingresados
              },
              child: Text('Iniciar Sesion'),
            ),
            ElevatedButton(
              onPressed: () {
                checkSession(); // Llama a la función de registro con los valores ingresados
              },
              child: Text('Revisar sesion'),
            ),
          ],
        ),
      ),
    );
  }
}
