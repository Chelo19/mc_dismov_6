import 'package:flutter/material.dart';
import 'package:google_mao/check_individual_animal.dart';
import 'package:google_mao/check_individual_animal_as_owner.dart';
import 'package:supabase/supabase.dart';

class CheckAnimals extends StatefulWidget {
  final SupabaseClient supabase;
  CheckAnimals({required this.supabase});

  @override
  _CheckAnimalsState createState() => _CheckAnimalsState();
}

class _CheckAnimalsState extends State<CheckAnimals> {
  late String current_user = 'd70b27a2-0297-4d60-90b4-f69998fc6a11';  // esto se tiene que cambiar a una funcion que obtenga el id
  late String email = 'marcelo1@gmail.com';  // esto se tiene que cambiar a una funcion que obtenga el id
  late String pass = 'marcelo';  // esto se tiene que cambiar a una funcion que obtenga el id

  List<Map<String, dynamic>> animalsData = [];

  Future<void> checkSession() async {
    final AuthResponse res = await widget.supabase.auth.signInWithPassword(
      email: email,
      password: pass,
    );

    final User? user = widget.supabase.auth.currentUser;
    // current_user = user!.id;
    // print(user!.id);
    setState(() {   // esto no funciona
      current_user = user!.id;
    });
  }

  Future<void> checkAnimals() async {
    final data = await widget.supabase
    .from('animals')
    .select('*')
    .eq('owner_guid', current_user);

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
    checkAnimals();
    checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis mascotas'),
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
                        MaterialPageRoute(builder: (context) => CheckIndividualAnimalAsOwner(supabase: widget.supabase, animalId: animal['id'],)),
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
