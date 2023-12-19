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
        title: const Text('Tu mascota'),
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
                        const Text('Nombre de la mascota:'),
                        Text('${animalData[0]['name']}'),
                        const SizedBox(height: 20),
                        const Text('Especie:'),
                        Text('${animalData[0]['species']}'),
                        const SizedBox(height: 20),
                        const Text('Raza:'),
                        Text('${animalData[0]['race']}'),
                        const SizedBox(height: 20),
                        const Text('Edad:'),
                        Text('${animalData[0]['age']}'),
                        const SizedBox(height: 20),
                        const Text('Enfermedades:'),
                        Text('${animalData[0]['diseases']}'),
                        const SizedBox(height: 20),
                        const Text('Medicamentos:'),
                        Text('${animalData[0]['meds']}'),
                        const SizedBox(height: 20),
                        const Text('Fechas de vacunación:'),
                        Text('${animalData[0]['prev_vac_dates']}'),
                        const SizedBox(height: 20),
                        const Text('Próxima fecha de vacunación:'),
                        Text('${animalData[0]['next_vac_dates']}'),
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
}
