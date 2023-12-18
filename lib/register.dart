import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

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

    // final Session? session = res.session;
    // final User? user = res.user;
    // print(res);

    // print(user!.id);

    // await widget.supabase
    // .from('users')
    // .insert({'email': email, 'name': name, 'guid': user!.id});
    
    // // Llama a la función de registro con los valores ingresados por el usuario
    // final response = await widget.supabase.auth.signUp(email, password);
    // if (response.error == null) {
    //   // Registro exitoso
    //   print('User registered successfully: ${response.data}');
    // } else {
    //   // Registro fallido
    //   print('Error registering user: ${response.error!.message}');
    // }
  }

  Future<void> fetchUserData() async {
    final response = await widget.supabase.from('users').select('*').execute();

    if (response.status == 200) {
      // Operación exitosa
      print('Datos de usuarios obtenidos exitosamente: ${response.data}');
    } else {
      // Error al obtener datos
      print('Error al obtener datos de usuarios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
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
                registerUser(); // Llama a la función de registro con los valores ingresados
                // fetchUserData(); // Llama a la función para obtener datos de usuario
              },
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
