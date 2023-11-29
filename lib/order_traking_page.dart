//archivo order_traking_page.dart
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_mao/constants.dart';
import 'package:google_mao/elegirredes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng debugLocation = LatLng(37.334295, -122.3);

  List<LatLng> polylineCoordinates = [];

  List<LatLng> coordenadasMTYTelcel4G = [
  const LatLng(25.60011868422257, -100.35859341429429), 
  const LatLng(25.625822346718962, -100.40169102719402), 
  const LatLng(25.64957252272365, -100.40248494897526), 
  const LatLng(25.661048033706177, -100.41419277141274), 
  const LatLng(25.662776508801134, -100.4012411192637),
  const LatLng(25.680444839853635, -100.39866173217119),
  const LatLng(25.693867996346086, -100.41971895353502),
  const LatLng(25.70306264542256, -100.44525419471499),
  const LatLng(25.710089624253573, -100.46158019787582),
  const LatLng(25.69592889300567, -100.47726010691643),
  const LatLng(25.677946058564316, -100.52877750860766),
  const LatLng(25.690332107981682, -100.57603421237509),
  const LatLng(25.755863686995873, -100.63141233153968),
  const LatLng(25.82274238768272, -100.64893962246501),
  const LatLng(25.834020705999286, -100.67156497905688),
  const LatLng(25.86344139120226, -100.64239583686512),
  const LatLng(25.85443691220988, -100.53219116798307),
  const LatLng(25.881712923662693, -100.54460521926768),
  const LatLng(25.844717865863895, -100.51258337044595),
  const LatLng(25.82247130453391, -100.44596962814451),
  const LatLng(25.842682854555495, -100.44862346016292),
  const LatLng(25.869962969533926, -100.46107605675164),
  const LatLng(25.870367893570727, -100.39083561421275),
  const LatLng(25.92204933040203, -100.40308586703956),
  const LatLng(25.955352746935898, -100.48195453556279),
  const LatLng(25.982699777582667, -100.52795391813113),
  const LatLng(25.957200127892072, -100.56897896665923),
  const LatLng(26.036041290932417, -100.57086597247748),
  const LatLng(26.012070614341113, -100.45487765147412),
  const LatLng(25.954871388315485, -100.3553574240167),
  const LatLng(25.963909734456536, -100.32785970603287),
  const LatLng(26.026459048725464, -100.31527138848521),
  const LatLng(26.086072897607767, -100.29735390560029),
  const LatLng(26.000913081229974, -100.20804925193119),
  const LatLng(26.00170467123065, -100.07914606351906),
  const LatLng(25.916972368504844, -100.00083833763252),
  const LatLng(25.874823196966492, -100.0098206738655),
  const LatLng(25.88621031309522, -99.93539231587692),
  const LatLng(25.8370584215058, -99.92009806817227),
  const LatLng(25.844159401715075, -99.98722282402042),
  const LatLng(25.80707574611122, -99.98885778230164),
  const LatLng(25.785544079421033, -99.88956914412562),
  const LatLng(25.727273663181105, -99.9159292256074),
  const LatLng(25.66926669319172, -99.9885652930465),
  const LatLng(25.73179555464607, -100.00336214648532),
  const LatLng(25.715117716106043, -100.05914404398337),
  const LatLng(25.702878902199714, -100.07723377277487),
  const LatLng(25.664054763443534, -100.06083588352595),
  const LatLng(25.635810824513975, -100.03863821720039),
  const LatLng(25.617300903413955, -99.99602045963996),
  const LatLng(25.60828771569493, -99.98216338404123),
  const LatLng(25.612013107422907, -99.96055063859811),
  const LatLng(25.630575546650956, -99.94334258795064),
  const LatLng(25.61615094800374, -99.91995794078139),
  const LatLng(25.604034957607084, -99.90335518397593),
  const LatLng(25.59371785504966, -99.91716300954172),
  const LatLng(25.580608556737012, -99.90462750693129),
  const LatLng(25.569111512888114, -99.90145177157179),
  const LatLng(25.56359363379022, -99.92308873057166),
  const LatLng(25.53048647072474, -99.92457603523414),
  const LatLng(25.51176015792215, -99.91806806445885),
  const LatLng(25.500415488436797, -99.93378229061507),
  const LatLng(25.517286499049607, -99.95630080257409),
  const LatLng(25.52065943997211, -99.97141264266308),
  const LatLng(25.547040685545447, -99.97685863891799),
  const LatLng(25.553610434314553, -99.99586871225452),
  const LatLng(25.517941127594785, -99.99694487037011),
  const LatLng(25.500361372268372, -99.9964899322521),
  const LatLng(25.503646923175772, -100.01694044049879),
  const LatLng(25.49568832089091, -100.03042989404625),
  const LatLng(25.481709496170993, -100.0155554586834),
  const LatLng(25.489898786612184, -100.00229720690515),
  const LatLng(25.487165147039615, -99.97880524652405),
  const LatLng(25.478453220008237, -99.96231155072577),
  const LatLng(25.461787457414765, -99.96020047732976),
  const LatLng(25.44695656652284, -99.98102727192891),
  const LatLng(25.429782711326116, -99.99777784072164),
  const LatLng(25.415446171744208, -100.0214625180951),
  const LatLng(25.418158865448003, -100.06957992443121),
  const LatLng(25.440466526949116, -100.10294751980776),
  const LatLng(25.465038409939368, -100.11254673123825),
  const LatLng(25.503135937874173, -100.12271989562262),
  const LatLng(25.524999632023526, -100.13184068572389),
  const LatLng(25.551419074671667, -100.14487391934867),
  const LatLng(25.561394854229896, -100.1618073797135),
  const LatLng(25.60090373668544, -100.1879641163229),
  const LatLng(25.632087442352557, -100.21574722088901),
  const LatLng(25.624486343274707, -100.2458196365061),
  const LatLng(25.59181692518841, -100.24209585600929),
  const LatLng(25.54496033484588, -100.20917144654616),
  const LatLng(25.39948855346263, -100.13230688894733),
  const LatLng(25.6179366836161, -100.31391037488807),
  const LatLng(25.622789956335563, -100.38330089018422),
  ];

  // Función para encontrar la coordenada más cercana a la ubicación actual
  LatLng coordenadamascerca(LocationData? currentLocation, List<LatLng> coordinates) {
    if (currentLocation == null) {
      // Si no se pudo obtener la ubicación actual, devolvemos una coordenada en el centro de monterrey
      return const LatLng(25.689470285602457, -100.31649801084538);
    }

    double minDistance = double.infinity;
    LatLng nearestCoordinate = coordinates[0];

    // Iteramos a través de todas las coordenadas en la lista
    for (LatLng coordinate in coordinates) {
      double x1 = currentLocation.latitude!;
      double y1 = currentLocation.longitude!;
      double x2 = coordinate.latitude;
      double y2 = coordinate.longitude;

      //Formula para sacar la distancia entre dos coordenadas
      double distance = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));

      
      // Comparamos la distancia actual con la distancia mínima
      if (distance < minDistance) {
        minDistance = distance;
        nearestCoordinate = coordinate;
      }
    }

  // Devolvemos la coordenada más cercana encontrada
    return nearestCoordinate;
  }

  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  // Define la zona 5G como un conjunto de polígonos
  Set<Polygon> zona5G = {
    Polygon(
      polygonId: const PolygonId("zona5G"),
      //ME DA ERROR EN coordenadasMTYTelcel4G
      fillColor: const Color.fromRGBO(34, 165, 34, 0.466),
      strokeWidth: 1,
      strokeColor: Color.fromARGB(255, 12, 129, 12),
    ),
  };

  // Función para verificar si la ubicación está dentro de la zona 5G
  bool estaEnZona5G(LocationData? currentLocation) {
    if (currentLocation == null) {
      return false;
    }

    // Utilizar el polígono de la zona 5G para determinar si la ubicación está dentro
    LatLng point = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    return isPointInPolygon(point, coordenadasMTYTelcel4G);
  }

  // Función para verificar si un punto está dentro de un polígono
  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;

    for (int j = 0; j < polygon.length - 1; j++) {
      if ((polygon[j].longitude! <= point.longitude! &&
          point.longitude! < polygon[j + 1].longitude!) ||
          (polygon[j + 1].longitude! <= point.longitude! &&
              point.longitude! < polygon[j].longitude!)) {
        if (point.latitude! <
            polygon[j].latitude! +
                (point.longitude! - polygon[j].longitude!) /
                    (polygon[j + 1].longitude! - polygon[j].longitude!) *
                    (polygon[j + 1].latitude! - polygon[j].latitude!)) {
          intersectCount++;
        }
      }
    }

    return (intersectCount % 2) == 1;
  }

  void getCurrentLocation() async{
    Location location = Location();

    // GoogleMapController googleMapController = await _controller.future;

    location.getLocation().then(
      (location){
        currentLocation = location;
        getPolyPoints(currentLocation);
      },
    );

    // location.onLocationChanged.listen(
    //   (newLoc) {
    //     currentLocation = newLoc;

    //     googleMapController.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //           zoom: 13.5,
    //           target: LatLng(
    //             newLoc.longitude!,
    //             newLoc.latitude!,
    //           ),
    //         ),
    //       ),
    //     );

    //     setState(() {});
    //   }
    // );
  }

  void getPolyPoints(currentLoc) async {
    // Llamamos a la función para encontrar la coordenada más cercana
    LatLng destination = coordenadamascerca(currentLocation, coordenadasMTYTelcel4G);
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(currentLoc.latitude, currentLoc.longitude),
      PointLatLng(destination.latitude, destination.longitude)
    );

    if(result.points.isNotEmpty){
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  void setCustomMarkerIcon(){
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_source.png")
        .then(
      (icon) {
          sourceIcon = icon;
        }
      );
      BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_destination.png")
        .then(
      (icon) {
          destinationIcon = icon;
        }
      );
      BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Badge.png")
        .then(
      (icon) {
          currentLocationIcon = icon;
        }
      );
  }

  @override
  void initState(){
    getCurrentLocation();
    setCustomMarkerIcon();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    LatLng destinomarcador = coordenadamascerca(currentLocation, coordenadasMTYTelcel4G);
   
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SignalFinder",
          style: TextStyle(
            color: Color.fromRGBO(244, 175, 27, 1), 
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'GoblinOne',
            shadows: [
                Shadow(
                  offset: Offset(5, 5),
                  blurRadius: 5.0,
                  color: Color.fromRGBO(0, 0, 0, 0.658),
                ),
              ],
            ),
        ),
        actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
            Navigator.pushNamed(context, 'RedesSeleccion');
        },
      ),
    ],
      ),
      body: 
      currentLocation == null 
      ? const Center(child: Text("Cargando"))
      : GoogleMap(

        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), 
          zoom: 13.5,
        ),
        polylines: {
          Polyline(
              polylineId: const PolylineId("Ruta"),
              points: polylineCoordinates,
              color: const Color.fromRGBO(13, 57, 180, 1),
              width: 6,
            ),
        },
        markers: {
          Marker(
            markerId: const MarkerId("currentLocation"),
            icon: currentLocationIcon, 
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          ),
          Marker(
            markerId: const MarkerId("source"),
            icon: sourceIcon,
            position: sourceLocation,
          ),
          Marker(
            markerId: const MarkerId("destination"),
            icon: destinationIcon,
            position: destinomarcador,
          )
        },
        polygons: estaEnZona5G(currentLocation) ? zona5G : {
          Polygon(
            polygonId: const PolygonId("1"),
            points: coordenadasMTYTelcel4G,
            fillColor: const Color.fromRGBO(34, 165, 34, 0.466),
            strokeWidth: 1,
            strokeColor: Color.fromARGB(255, 12, 129, 12),
          ), 
        },
      ),
      floatingActionButton: estaEnZona5G(currentLocation)
          ? FloatingActionButton(
        onPressed: () {
          // Mostrar un Snackbar al presionar el botón
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usted ya se encuentra en la zona con conexión óptima AAAAAAAAAAAAAAAAAAAAA'),
              duration: const Duration(seconds: 3),
            ),
          );
        },
        child: Icon(Icons.info),
      )
          : null,
    );
  }
}
