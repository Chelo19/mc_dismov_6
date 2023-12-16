import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class RegisterScreen extends StatelessWidget {
  final SupabaseClient supabase;

  RegisterScreen({required this.supabase});

  // Future<void> registerUser(String email, String password) async {
  //   // final response = await supabase.auth.signUp(email, password);
  //   // if (response.error == null) {
  //   //   // Registration successful
  //   //   print('User registered successfully: ${response.data}');
  //   // } else {
  //   //   // Registration failed
  //   //   print('Error registering user: ${response.error!.message}');
  //   // }
  // }

Future<void> fetchUserData() async {
  final response = await supabase.from('users').select('*').execute();

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
        title: Text('Register'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace with your user registration logic
            // registerUser('user@example.com', 'password123');
            fetchUserData();
          },
          child: Text('Register User'),
        ),
      ),
    );
  }
}
