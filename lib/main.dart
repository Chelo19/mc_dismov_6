import 'package:flutter/material.dart';
import 'package:google_mao/elegirredes.dart';
import 'package:google_mao/order_traking_page.dart';
import 'package:google_mao/redes5g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignalFinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(13, 57, 180, 1),
          elevation: 20,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OrderTrackingPage(),
        'RedesSeleccion':(context) => RedesSeleccion(),
        'Redes5G': ((context) => const Redes5G())
      },
    );
  }
}
