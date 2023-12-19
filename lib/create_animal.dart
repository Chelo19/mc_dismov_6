import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  late String meds = '';
  File? imageFile;

  Future<void> checkSession() async {
    final Session? session = widget.supabase.auth.currentSession;
    print(session);
  }

  Future<void> insertAnimal() async {
    await widget.supabase
      .from('animals')
      .insert({
        'owner_guid': current_user, 
        'name': name, 
        'species': species, 
        'race': race, 
        'age': age, 
        'diseases': diseases, 
        'meds': meds});
  }

  Future<void> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  Future<void> _showImageSourceModal(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Subir desde la galería'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Tomar una foto'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImageFromCamera();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Mascota'),
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
                    name = value; // Almacena el valor del correo electrónico
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
                    species = value; // Almacena el valor de la contraseña
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
                    race = value; // Almacena el valor de la contraseña
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
                    age = value; // Almacena el valor de la contraseña
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
                    diseases = value; // Almacena el valor de la contraseña
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
                    meds = value; // Almacena el valor de la contraseña
                  });
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _showImageSourceModal(context);
                },
                child: const Text('Agregar Imagen'),
              ),

              // Mostrar la imagen seleccionada o tomada
              if (imageFile != null)
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.file(imageFile!),
                ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  insertAnimal(); // Llama a la función de registro con los valores ingresados
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
