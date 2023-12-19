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

  Future<void> saveChanges() async {
    print(animalData);
    await widget.supabase
    .from('animals')
    .update({ 'name': '${animalData[0]['name']}', 'species': '${animalData[0]['species']}', 'race': '${animalData[0]['race']}', 'age': '${animalData[0]['age']}', 'diseases': '${animalData[0]['diseases']}', 'meds': '${animalData[0]['meds']}', 'prev_vac_dates': '${animalData[0]['prev_vac_dates']}', 'next_vac_dates': '${animalData[0]['next_vac_dates']}' })
    .match({ 'id': '${animalData[0]['id']}' });
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
        title: const Text('Ver mascota individual'),
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
                        const Text('Nombre de la mascota:'),
                        TextFormField(
                          initialValue: animalData[0]['name'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['name'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Nombre del dueño:'),
                        const SizedBox(height: 20),
                        Text('${animalData[0]['owner_guid']['name']}'),
                        TextFormField(
                          initialValue: animalData[0]['species'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['species'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Raza:'),
                        TextFormField(
                          initialValue: animalData[0]['race'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['race'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Edad:'),
                        TextFormField(
                          initialValue: animalData[0]['age'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['age'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Enfermedades:'),
                        TextFormField(
                          initialValue: animalData[0]['diseases'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['diseases'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Medicamentos:'),
                        TextFormField(
                          initialValue: animalData[0]['meds'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['meds'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Fechas de vacunación:'),
                        TextFormField(
                          initialValue: animalData[0]['prev_vac_dates'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['prev_vac_dates'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Próxima fecha de vacunación:'),
                        TextFormField(
                          initialValue: animalData[0]['next_vac_dates'],
                          onChanged: (newValue) {
                            setState(() {
                              animalData[0]['next_vac_dates'] = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            saveChanges(); // Llamar a la función para guardar los cambios
                          },
                          child: const Text('Guardar cambios'),
                        ),
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
