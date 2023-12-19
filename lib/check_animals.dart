//check_animals.dart
import 'package:flutter/material.dart';
import 'package:google_mao/check_individual_animal.dart';
import 'package:google_mao/check_individual_animal_as_owner.dart';
import 'package:supabase/supabase.dart';

class CheckAnimals extends StatefulWidget {
  final SupabaseClient supabase;
  final String userId; // Agregar el ID del usuario como parámetro
  CheckAnimals({required this.supabase, required this.userId});

  @override
  _CheckAnimalsState createState() => _CheckAnimalsState();
}

class _CheckAnimalsState extends State<CheckAnimals> {

  List<Map<String, dynamic>> animalsData = [];

  Future<void> checkAnimals() async {
    final data = await widget.supabase
        .from('animals')
        .select('*')
        .eq('owner_guid', widget.userId); // Usar el ID del usuario actual

    List<Map<String, dynamic>> tempAnimalsData;
    tempAnimalsData = List<Map<String, dynamic>>.from(data);

    print(tempAnimalsData);

    setState(() {
      animalsData = tempAnimalsData;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis mascotas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: animalsData.length,
                itemBuilder: (context, index) {
                  final animal = animalsData[index];
                  return GestureDetector(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckIndividualAnimalAsOwner(
                            supabase: widget.supabase,
                            animalId: animal['id'],
                          ),
                        ),
                      ),
                    },
                    child: Card(
                      child: ListTile(
                        title: Text('Nombre de mascota: ${animal['name']}'),
                        subtitle: Text('Especie: ${animal['species']}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
