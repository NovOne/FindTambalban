/* FILE: calculate_distance_gmaps.dart */
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Calculate Distance in GMaps')),
        body: HomePage()
      )
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = 'AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs';
  Set<Marker> markers = Set();
  Map<PolylineId, Polyline> polylines = {};

  LatLng startLocation = const LatLng(27.6683619, 85.3101895);  
  LatLng endLocation = const LatLng(27.6875436, 85.2751138); 

  
  List<LatLng> polylineCoordinates = [];
  double distance = 0.0;


  void initState() {
    markers.add(Marker( //add start location marker
        markerId: MarkerId(startLocation.toString()),
        position: startLocation, //position of marker
        infoWindow: const InfoWindow( //popup info 
          title: 'Starting Point ',
          snippet: 'Start Marker',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

    markers.add(Marker( //add distination location marker
      markerId: MarkerId(endLocation.toString()),
      position: endLocation, //position of marker
      infoWindow: const InfoWindow( //popup info 
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections();
    super.initState();
  }

  getDirections() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    googleAPiKey,
    PointLatLng(startLocation.latitude, startLocation.longitude),
    PointLatLng(endLocation.latitude, endLocation.longitude),
    travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) { 
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    else {
      debugPrint(result.errorMessage);
    }
    
    double totalDistance = 0;
    for(var i = 0; i < polylineCoordinates.length-1; i++) {
      totalDistance += calculateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i+1].latitude,
        polylineCoordinates[i+1].longitude
      );
    }
    debugPrint('Jarak total: ' + totalDistance.toString());
    setState(() {
      distance = totalDistance;
    });
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.orange,
      points: polylineCoordinates,
      width: 8
    );
    polylines[id] = polyline;
    setState(() {});
  }
  
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 + 
          cos(lat1 * p) * cos(lat2 * p) * 
          (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculate Distance in Google Map'),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: CameraPosition(target: startLocation, zoom: 14),
            markers: markers,
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            }
          ),
          Positioned(
            bottom: 200,
            left: 10,
            child: Container(
              child: Card(
                child: Container(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Text('Total distance: ' + distance.toStringAsFixed(2) + 'km',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  )
                )
              )
            ),
          )
        ],
      )
    );
  }
}