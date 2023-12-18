import 'package:flutter/material.dart';
import 'package:google_mao/check_animals.dart';
import 'package:supabase/supabase.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

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

  Future<void> _selectImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = selectedImage;
    });

    uploadImage(selectedImage);
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
        title: Text('Ver mascota individual'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            animalData.isNotEmpty
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${animalData[0]['name']}'),
                Text('Nombre del dueño: ${animalData[0]['owner_guid']['name']}'),
                Text('Especie: ${animalData[0]['species']}'),
                Text('Raza: ${animalData[0]['race']}'),
                _imageFile != null
                ? Image.file(File(_imageFile!.path))
                : Text('No has seleccionado ninguna imagen'),
                ElevatedButton(
                  onPressed: _selectImage,
                  child: Text('Subir imagen'),
                ),
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
            :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cargando'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
