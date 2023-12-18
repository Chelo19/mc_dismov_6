import 'package:flutter/material.dart';
import 'package:google_mao/check_animals.dart';
import 'package:supabase/supabase.dart';

class CheckIndividualAnimal extends StatefulWidget {
  CheckIndividualAnimal({required this.supabase, required this.animalId});
  final SupabaseClient supabase;
  final int animalId;
  List<String> imgPaths = [];

  @override
  _CheckIndividualAnimalState createState() => _CheckIndividualAnimalState();
}

class _CheckIndividualAnimalState extends State<CheckIndividualAnimal> {

  List<Map<String, dynamic>> animalData = [];
  List<String> imgPaths = [];

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

  Future<void> checkIndividualAnimal() async {
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

  @override
  void initState() {
    super.initState();
    checkIndividualAnimal();
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
