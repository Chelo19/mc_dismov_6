import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class CreateAnimal extends StatefulWidget {
  final SupabaseClient supabase;
  CreateAnimal({required this.supabase});

  @override
  _CreateAnimalState createState() => _CreateAnimalState();
}

class _CreateAnimalState extends State<CreateAnimal> {
  late String current_user = 'd70b27a2-0297-4d60-90b4-f69998fc6a11';
  late String name = ''; // Inicializa con una cadena vacía
  late String species = ''; // Inicializa con una cadena vacía
  late String race = ''; // Inicializa con una cadena vacía
  late String age = ''; // Inicializa con una cadena vacía
  late String diseases = ''; // Inicializa con una cadena vacía
  late String meds = ''; // Inicializa con una cadena vacía

  Future<void> checkSession() async {
    final Session? session = widget.supabase.auth.currentSession;
    print(session);
  }

  Future<void> insertAnimal() async {
    await widget.supabase
      .from('animals')
      .insert({'owner_guid': current_user, 'name': name, 'species': species, 'race': race, 'age': age, 'diseases': diseases, 'meds': meds});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Mascota'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nombre de la mascota',
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
                labelText: 'Especie',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  species = value; // Almacena el valor de la contraseña
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Raza',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  race = value; // Almacena el valor de la contraseña
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  age = value; // Almacena el valor de la contraseña
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enfermedades',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  diseases = value; // Almacena el valor de la contraseña
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Medicamentos',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  meds = value; // Almacena el valor de la contraseña
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                insertAnimal(); // Llama a la función de registro con los valores ingresados
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
