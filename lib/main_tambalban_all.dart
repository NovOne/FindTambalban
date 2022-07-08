/* google-maps3.dart */
/* Fitur: anymarkers (produced iterate), geolocator for get Current Position */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Location')),
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
  var j = 0;
  // bool hsl = false;
  double? latt;
  double? lonn;
  // final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  // _center = LatLng(0.0,0.0);
  // Future<double>? latitude;
  final List<Marker> _markers = <Marker>[];
  // Position _currentPosition;
  String? _currentAddress;
  late BitmapDescriptor iconMarker;

  @override
  void initState () {
    // _getCurrentLocation();
    // _future = _getCurrentLocation();
    getMarker();

    super.initState();
  }

  Future<void> gotoDirection(String origin, String destination) async {
      debugPrint('Masuk Go Direction');
      String strUrl = 'https://www.google.com/maps/dir/?api=1&origin=' + origin + '&destination=' + destination + '&travelmode=driving';
      await launchUrlString(strUrl, mode:LaunchMode.externalApplication);
  }

  markerOnTap(context, latmarker, lonmarker, area) async {
    debugPrint('LAT MARKER: ' + latmarker.toString());
    await _getAddressFromLatLng(latmarker, lonmarker);
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(left:20, right:20),
          child: DraggableScrollableSheet(
            maxChildSize: 1.0,
            initialChildSize: 0.8,
            expand: false,
            builder: (context, controller) {
              return Center(
                child: Column(
                  children: [
                    Text('LAT MARKER' + latmarker.toString() + 'LOKASI: ' + area.toString()),
                    Text(_currentAddress.toString()),
                    FlatButton(
                      onPressed: () => gotoDirection(latt!.toString() + ',' + lonn!.toString(),latmarker.toString() + ',' + lonmarker.toString()),
                      child: const Text('Arahkan ke sana')
                    )
                  ],
                )
              );          
            },
          )
        );
      },
    );
  }

  Future<String> getMarker() async {
    final String response = await rootBundle.loadString('assets/daftar.json');
    final data = await json.decode(response);

    debugPrint ("Data lat: " + data["results"][0]['lat'].toString());
    debugPrint ("Data lon: " + data["results"][0]['lon'].toString());

    for (var i=0; i<=1; i++) {
      var nomarker = i + 1;
      _markers.add(
        Marker(
          markerId: MarkerId('aa' + i.toString()),
          onTap: () {
            debugPrint('POSISI MARKER INI: ' + _markers[i].position.toString());
            markerOnTap(context, data["results"][i]['lat'], data["results"][i]['lon'], data["results"][i]['area']);
          },
          // position: LatLng(-6.142326, 108.739827),
          position: LatLng(data["results"][i]['lat'], data["results"][i]['lon']),
          infoWindow: InfoWindow(title:'Marker ' + nomarker.toString())
        )
      );
    }

    return "Berhasil";
  }
  
  Future<String> getMarkerCurrent(double lat, double lon) async {
    _markers.add(
      Marker(
        markerId: const MarkerId('Saatini001'),
        // position: LatLng(-6.142326, 108.739827),
        position: LatLng(lat, lon),
        infoWindow: const InfoWindow(title:'Saat ini')
      )
    );

    return "Berhasil";
  }

  /* void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  } */

  /* void _onCameraMove(CameraPosition position) {
    _lastMapPosition= position.target;
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: _lastMapPosition,
        infoWindow: InfoWindow(title:'Test')
      )
    );
    print('posisi = ' + _lastMapPosition.toString());
    //_getAddressFromLatLng();
  } */

  // Future<Position> _getCurrentLocation() async {
  /* Future<Position> _getCurrentLocation() async {
    // var _currentPosition;
    bool serviceEnabled;
    LocationPermission permission;

  // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    setState(() {
      Geolocator.getCurrentPosition().then((value) {

        debugPrint('LATITUDE: ' + value.latitude.toString());
        // LatLng _center = LatLng(value.latitude, value.longitude);
        latt = value.latitude;
        lonn = value.longitude;
        j = j + 1;
        debugPrint('LATTTTT111111: ' + latt.toString());
        debugPrint('LONNNNN111111: ' + lonn.toString());
        _markers.add(
          Marker(
            markerId: const MarkerId('1'),
            position: LatLng(latt!.toDouble(),lonn!.toDouble()),
            // position: _center,
            infoWindow: const InfoWindow(title:'Test')
          )
        );
      });
    });

    /* Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
          // _getAddressFromLatLng();
        });
      }).catchError((e) {
        debugPrint(e);
      });

      debugPrint ('Current Position: ' + _currentPosition); */
    return await Geolocator.getCurrentPosition();
    // return 'berhasil';
  }
  */
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 400,
            child: Listener(
              onPointerUp: (details) {
                // _getAddressFromLatLng();
              },
              child: latt == null ? const Center(child: Text('makan'),) : GoogleMap(
                markers: Set<Marker>.of(_markers),
                /* onTap: (latlng){
                  debugPrint('TAPPED: ' + latlng.latitude.toString());
                  markerOnTap(context, latlng.latitude, latlng.longitude);
                },
                onMapCreated: _onMapCreated, */
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
                /* onCameraMove: (CameraPosition position) {
                  _lastMapPosition= position.target;
                  //_getAddressFromLatLng();
                  if(_markers.length > 0) {
                    // MarkerId markerId = MarkerId(_markerIdVal());
                    Marker marker = _markers[0];
                    Marker updatedMarker = marker.copyWith(
                      positionParam: position.target,
                    );

                    setState(() {
                      _markers[0] = updatedMarker;
                    });
                  }
                },*/
                initialCameraPosition: CameraPosition(
                  // target: LatLng(0,0),
                  target: LatLng(latt!.toDouble(),lonn!.toDouble()),
                  zoom: 20.0,
                ),
              ),

            )           
          ),
          if (_currentAddress != null) Text(
            _currentAddress.toString()
          ),
          FlatButton(
            child: Text("Get location" + j.toString()),
            onPressed: () async {
              Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
                setState(() {
                  latt = value.latitude;
                  lonn = value.longitude;
                  j = j + 1;
                  debugPrint('LATTTTT111111: ' + latt.toString());
                  debugPrint('LONNNNN111111: ' + lonn.toString());
                  _markers.add(
                    Marker(
                      markerId: const MarkerId('1'),
                      icon: iconMarker,
                      position: LatLng(latt!.toDouble(),lonn!.toDouble()),
                      // position: _center,
                      infoWindow: const InfoWindow(title:'Lokasi Saat Ini')
                    )
                  );
                }); 
              });
              
              BitmapDescriptor.fromAssetImage(const ImageConfiguration(size:Size(12,12)), 'assets/motorcycle-icon.png')
                .then((d) => iconMarker = d);

              mapController?.animateCamera(
                CameraUpdate.newCameraPosition(
                  // const CameraPosition(target: LatLng(-6.00009, 102.000999))
                  CameraPosition(
                    target: LatLng(latt!.toDouble(), lonn!.toDouble()),
                    zoom: 20.0
                  )
                )
              );
              /* var x = await Geolocator.getCurrentPosition();

              latt = x.latitude;
              lonn = x.longitude;

              latt = latt == null ? 1.0 : x.latitude;
              lonn = lonn == null ? 2.0 : x.longitude;

              // getMarkerCurrent(d.latitude, d.longitude);
              // getMarker();
              // _getAddressFromLatLng(d.latitude, d.longitude);
              */
            },
          ),
        ],
      ),
    );
  }
    
  _getAddressFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        // _currentPosition.latitude,
        // _currentPosition.longitude
        // _lastMapPosition.latitude, _lastMapPosition.longitude
        lat, lon
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.street}, ${place.thoroughfare}, ${place.subThoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}