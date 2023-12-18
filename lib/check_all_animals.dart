import 'package:flutter/material.dart';
import 'package:google_mao/check_individual_animal.dart';
import 'package:supabase/supabase.dart';

class CheckAllAnimals extends StatefulWidget {
  final SupabaseClient supabase;
  CheckAllAnimals({required this.supabase});

  @override
  _CheckAllAnimalsState createState() => _CheckAllAnimalsState();
}

class _CheckAllAnimalsState extends State<CheckAllAnimals> {
  late String current_user = 'd70b27a2-0297-4d60-90b4-f69998fc6a11';  // esto se tiene que cambiar a una funcion que obtenga el id
  late String email = 'marcelo1@gmail.com';  // esto se tiene que cambiar a una funcion que obtenga el id
  late String pass = 'marcelo';  // esto se tiene que cambiar a una funcion que obtenga el id

  List<Map<String, dynamic>> animalsData = [];

  Future<void> checkAllAnimals() async {
    
    final data = await widget.supabase
    .from('animals')
    .select('*, owner_guid(*)');

    List<Map<String,dynamic>> tempAnimalsData;
    tempAnimalsData = List<Map<String, dynamic>>.from(data);

    print(tempAnimalsData);

    setState(() {
      animalsData = tempAnimalsData;
    });
 
  }

  @override
  void initState() {
    super.initState();
    checkAllAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todas las mascotas'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                        MaterialPageRoute(builder: (context) => CheckIndividualAnimal(supabase: widget.supabase, animalId: animal['id'],)),
                      ),
                    },
                    child: Card(
                      child: ListTile(
                        title: Text('Nombre de mascota: ${animal['name']}'),
                        subtitle: Text('Especie: ${animal['species']}     Dueño: ${animal['owner_guid']['name']}'),
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
