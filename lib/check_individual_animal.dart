import 'package:flutter/material.dart';
import 'package:google_mao/check_animals.dart';
import 'package:supabase/supabase.dart';

class CheckIndividualAnimal extends StatefulWidget {
  CheckIndividualAnimal({required this.supabase, required this.animalId});
  final SupabaseClient supabase;
  final int animalId;

  @override
  _CheckIndividualAnimalState createState() => _CheckIndividualAnimalState();
}

class _CheckIndividualAnimalState extends State<CheckIndividualAnimal> {

  List<Map<String, dynamic>> animalData = [];

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
    
    print(data);

  }

  @override
  void initState() {
    super.initState();
    checkIndividualAnimal();
  }

  @override
  Widget build(BuildContext context) {
    print('animalData');
    print(animalData);
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver mascota individual'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${animalData[0]['name']}'),
            Text('Nombre del dueño: ${animalData[0]['owner_guid']['name']}'),
            Text('Especie: ${animalData[0]['species']}'),
            Text('Raza: ${animalData[0]['race']}'),
          ],
        ),
      ),
    );
  }
}
