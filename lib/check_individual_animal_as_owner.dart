import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CheckIndividualAnimalAsOwner extends StatefulWidget {
  CheckIndividualAnimalAsOwner({required this.supabase, required this.animalId});
  final SupabaseClient supabase;
  final int animalId;
  List<String> imgPaths = [];

  @override
  _CheckIndividualAnimalAsOwnerState createState() => _CheckIndividualAnimalAsOwnerState();
}

class _CheckIndividualAnimalAsOwnerState extends State<CheckIndividualAnimalAsOwner> {
  List<Map<String, dynamic>> animalData = [];
  List<String> imgPaths = [];
  final ImagePicker _picker = ImagePicker();
  late XFile? _imageFile;

  Future<void> checkIndividualAnimalAsOwner() async {
    final data = await widget.supabase
        .from('animals')
        .select('*, owner_guid(*)')
        .eq('id', widget.animalId);

    List<Map<String, dynamic>> tempAnimalData;
    tempAnimalData = List<Map<String, dynamic>>.from(data);

    setState(() {
      animalData = tempAnimalData;
    });
    getPhotos(animalData);
  }

  Future<void> getPhotos(animalData) async {
    final List<FileObject> objects = await widget.supabase
        .storage
        .from('animals_pics')
        .list(path: '${animalData[0]['id']}');

    List<String> paths = [];
    for (var object in objects) {
      paths.add('https://jtnxusdkumjwecqhskxm.supabase.co/storage/v1/object/public/animals_pics/${animalData[0]['id']}/${object.name}');
    }

    setState(() {
      widget.imgPaths = paths;
    });
  }

  Future<void> uploadImage(File selectedImage) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Puedes cambiar el nombre del archivo según tus necesidades
      final response = await widget.supabase
          .storage
          .from('animals_pics')
          .upload(
        '${widget.animalId}/${fileName}', // Ruta dentro del bucket: [ID de la mascota]/[Nombre del archivo]
        selectedImage, // Archivo a subir

      );

      
    } catch (e) {
      // Manejo de excepciones
      print('Error: $e');
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Subir desde la galería'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
                  if (selectedImage != null) {
                    uploadImage(File(selectedImage.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar una foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? selectedImage = await picker.pickImage(source: ImageSource.camera);
                  if (selectedImage != null) {
                    uploadImage(File(selectedImage.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkIndividualAnimalAsOwner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tu Mascota',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 179, 105), // Color verde
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              animalData.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildDetail('Nombre de la mascota:', animalData[0]['name']),
                  const SizedBox(height: 20),
                  _buildDetail('Especie:', animalData[0]['species']),
                  const SizedBox(height: 20),
                  _buildDetail('Raza:', animalData[0]['race']),
                  const SizedBox(height: 20),
                  _buildDetail('Edad:', animalData[0]['age']),
                  const SizedBox(height: 20),
                  _buildDetail('Enfermedades:', animalData[0]['diseases']),
                  const SizedBox(height: 20),
                  _buildDetail('Medicamentos:', animalData[0]['meds']),
                  const SizedBox(height: 20),
                  _buildDetail('Fechas de vacunación:', animalData[0]['prev_vac_dates']),
                  const SizedBox(height: 20),
                  _buildDetail('Próxima fecha de vacunación:', animalData[0]['next_vac_dates']),
                  const SizedBox(height: 20),
                  for (int i = 0; i < widget.imgPaths.length; i++)
                    Container(
                      width: 200,
                      height: 200,
                      child: Image.network(
                        widget.imgPaths[i],
                        fit: BoxFit.cover,
                      ),
                    )
                ],
              )
                  : const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cargando'),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectImage,
        tooltip: 'Subir Foto',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 52, 179, 105), // Color verde más oscuro
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
