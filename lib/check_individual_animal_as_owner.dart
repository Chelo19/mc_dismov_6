//check_individual_animal_as_owner.dart
import 'package:flutter/material.dart';
import 'package:google_mao/check_animals.dart';
import 'package:supabase/supabase.dart';
// import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CheckIndividualAnimalAsOwner extends StatefulWidget {
  CheckIndividualAnimalAsOwner({required this.supabase, required this.animalId});
  final SupabaseClient supabase;
  final int animalId;
  List<String> imgPaths = [];

  @override
  _CheckIndividualAnimalAsOwnerState createState() => _CheckIndividualAnimalAsOwnerState();
}

class _CheckIndividualAnimalAsOwnerState extends State<CheckIndividualAnimalAsOwner> {
  // final ImagePicker _picker = ImagePicker();
  // XFile? _imageFile;

  List<Map<String, dynamic>> animalData = [];
  List<String> imgPaths = [];


  Future<void> checkIndividualAnimalAsOwner() async {
    // print(widget.animalId);
    final data = await widget.supabase
        .from('animals')
        .select('*, owner_guid(*)')
        .eq('id', widget.animalId);

    List<Map<String,dynamic>> tempAnimalData;
    tempAnimalData = List<Map<String, dynamic>>.from(data);

    setState(() {
      animalData = tempAnimalData;
    });
    getPhotos(animalData);
    print(data);

  }

  Future<void> getPhotos(animalData) async {
    final List<FileObject> objects = await widget.supabase
        .storage
        .from('animals_pics')
        .list(path: '${animalData[0]['id']}');

    List<String> paths = [];
    for (var object in objects) {
      print('Object Name: ${object.name}');
      paths.add('https://jtnxusdkumjwecqhskxm.supabase.co/storage/v1/object/public/animals_pics/${animalData[0]['id']}/${object.name}');
    }

    setState(() {
      widget.imgPaths = paths;
    });
  }

  Future<void> uploadImage(selectedImage) async {
    print(selectedImage);
    // AQUI VA LA LOGICA DE SUPABASE PARA SUBIR LA IMAGEN
  }

  // Future<void> _selectImage() async {
  //   final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     _imageFile = selectedImage;
  //   });

  //   uploadImage(selectedImage);
  // }

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