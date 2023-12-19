import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class CreateAnimal extends StatefulWidget {
  final SupabaseClient supabase;
  CreateAnimal({required this.supabase});

  @override
  _CreateAnimalState createState() => _CreateAnimalState();
}

class _CreateAnimalState extends State<CreateAnimal> {
  late String current_user = '';
  late String name = '';
  late String species = '';
  late String race = '';
  late String age = '';
  late String diseases = '';
  late String meds = '';

  Future<void> checkSession() async {
    final Session? session = widget.supabase.auth.currentSession;
    if (session != null) {
      setState(() {
        current_user = session.user!.id;
      });
    }
  }

  Future<void> insertAnimal() async {
    // Validar los campos de entrada
    if (name.isEmpty || species.isEmpty) {
      // Muestra un mensaje de error si los campos obligatorios están vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nombre y especie son obligatorios'),
        ),
      );
      return;
    }

    // Insertar la mascota en la base de datos
    final response = await widget.supabase
        .from('animals')
        .insert({
      'owner_guid': current_user,
      'name': name,
      'species': species,
      'race': race,
      'age': age,
      'diseases': diseases,
      'meds': meds,
    });

    /* Verificar si la inserción fue exitosa
    if (response.error == null) {
      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mascota registrada exitosamente'),
        ),
      );
    } else {
      // Muestra un mensaje de error si hay algún problema
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar la mascota'),
        ),
      );
    }*/
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
      title: const Text(
        'Registrar Mascota',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 52, 179, 105), // Color verde
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre de la mascota',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Especie',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    species = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Raza',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    race = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    age = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Enfermedades',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    diseases = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Medicamentos',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    meds = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  insertAnimal();
                },
                child: const Text('Enviar'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
