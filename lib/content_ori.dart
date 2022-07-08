/* FILE: content.dart */

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // ^2.0.0
import 'package:google_maps_flutter/google_maps_flutter.dart'; // ^2.0.4
import 'package:geolocator/geolocator.dart'; // ^7.0.2
import 'package:flutter/services.dart';
import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart'; // ^6.0.4
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/* void main() async {
  runApp(MyApp());
}

class Content extends StatefulWidget {
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

*/

class Content extends StatefulWidget {
  final curLat;
  final curLon;
  const Content({Key? key, required this.curLat, required this.curLon}) : super(key: key);
  
  @override
  _ContentState createState() => _ContentState();

}

class _ContentState extends State<Content> {
  var j = 0;
  double? latt;
  double? lonn;
  double distance = 0.0;
  GoogleMapController? mapController;
  // _center = LatLng(0.0,0.0);
  // Future<double>? latitude;
  final List<Marker> _markers = <Marker>[];
  // String? _currentAddress;
  String? addressformated;
  String? currentAddress;
  // late BitmapDescriptor iconMarker;
  late Uint8List iconMarker;
  @override
  void initState () {
    /* BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size:Size(0.2,0.3)),
      'assets/motorcycle-icon.png')
    .then((d) {
      iconMarker = d;
      _markers.add(
        Marker(
          markerId: const MarkerId('1'),
          icon: iconMarker,
          position: LatLng(latt!.toDouble(),lonn!.toDouble()),
          infoWindow: const InfoWindow(title:'Lokasi Saat Ini')
        )
      );
    });*/

    // debugPrint('ICON MARKER: ' + iconMarker.toString());
    markerIcon();
    getMarker();
    super.initState();
  }

  shareLocation(BuildContext context, double lat, double lon) async {
    String urlShare = 'Kunjungi tambal ban ini: \nhttps://maps.google.com/?q=' + lat.toString() + ',' + lon.toString();
    String subject = 'https://maps.google.com/?q=' + lat.toString() + ',' + lon.toString();

    final RenderBox box = context.findRenderObject() as RenderBox;
    {
      await Share.share(urlShare,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
      );
    }
  }

  Future<String> markerIcon() async {
    Uint8List iconMarker = await getBytesFromAsset('assets/motorcycle-icon.png', 75);
    _markers.add(
        Marker(
          markerId: const MarkerId('1'),
          icon: BitmapDescriptor.fromBytes(iconMarker),
          position: LatLng(latt!.toDouble(),lonn!.toDouble()),
          infoWindow: const InfoWindow(title:'Lokasi Saat Ini')
        )
      );
    debugPrint('DI DALAM MARKER ICON');
    return 'OK aja lah';
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format:ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> gotoDirection(String origin, String destination) async {
      debugPrint('Masuk Go Direction');
      String strUrl = 'https://www.google.com/maps/dir/?api=1&origin=' + origin + '&destination=' + destination + '&travelmode=driving';
      await launchUrlString(strUrl, mode:LaunchMode.externalApplication);
  }

  double getDistance(LatLng start, LatLng end) {
    double deltaLat = (start.latitude - end.latitude).abs();
    double deltaLon = (start.longitude - end.longitude).abs();
    double distanceX = (deltaLon/0.001)* 110;
    double distanceY = (deltaLat/0.001)* 110;  
    
    return sqrt(pow(distanceX,2)+pow(distanceY,2));
  }

  markerOnTap(context, latmarker, lonmarker, latcur, loncur) async {
    debugPrint('LAT MARKER: ' + latmarker.toString());
    currentAddress = await _formattedAddress(latcur, loncur);
    addressformated = await _formattedAddress(latmarker, lonmarker);
    await _formattedAddress(latmarker, lonmarker);

    distance = getDistance(LatLng(latt!.toDouble(),lonn!.toDouble()), LatLng(latmarker,lonmarker));
    showModalBottomSheet<void>(
      //elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          // color: Colors.yellow,
          padding: const EdgeInsets.only(left:20, right:20),
          child: DraggableScrollableSheet(
            maxChildSize: 1.0,
            initialChildSize: 0.5,
            minChildSize: 0.5,
            expand: false,
            builder: (context, controller) {
              return Align(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:10, bottom:10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Icon(Icons.location_on_rounded, color: Colors.orange,)
                              ),
                              Text(addressformated.toString())
                            ]
                          )
                        )                   
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10, bottom:10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: Icon(Icons.gps_fixed_rounded, color: Colors.orange)
                            ),
                            Text(currentAddress.toString())
                          ]
                        )
                        )                       
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10, bottom:10),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: Icon(Icons.linear_scale_rounded, color: Colors.orange)
                            ),
                            Text(distance == 0.0 ? '0.0 m' : (distance < 1000 ? distance.toStringAsFixed(0) + ' m': (distance/1000).toStringAsFixed(1) + ' km'))
                          ]
                        )
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              child: OutlinedButton.icon(
                                label: const Text('Arahkan ke sana'),
                                icon: const Icon(Icons.send, color: Colors.orange),
                                onPressed: () => gotoDirection(latt.toString() + ',' + lonn.toString(),latmarker.toString() + ',' + lonmarker.toString())
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left:10),
                              child: OutlinedButton.icon(
                                label: const Text('Bagikan Lokasi'),
                                icon: const FaIcon(FontAwesomeIcons.share, color: Colors.orange),
                                onPressed: () => shareLocation(context, latmarker, lonmarker)
                              ),
                            )
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10, bottom: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.grey, width: 0.5) 
                          ),
                          padding: const EdgeInsets.only(left: 5, top:5, bottom: 5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 12),
                                    child: Icon(Icons.warning_amber_rounded)
                                  ),
                                  Text('Jarak ditentukan dari titik ke titik (jarak paling dekat)',
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 10),
                                  )
                                ]
                              )
                            )

                          )                   
                        )                       
                      )                                        
                    ],
                  )
                )               
              );          
            },
          )
        );
      },
    );
  }

  /* Buat Marker Tambal Ban terdekat */
  Future<String> getMarker() async {
    final String response = await rootBundle.loadString('assets/daftar.json');
    final data = await json.decode(response);
    final Uint8List iconMarker2 = await getBytesFromAsset('assets/marker-motorcycle.png', 75);

    debugPrint ("Data lat: " + data["results"][0]['lat'].toString());
    debugPrint ("Data lon: " + data["results"][0]['lon'].toString());

    for (var i=0; i<30; i++) {
      // var nomarker = i + 1;
      _markers.add(
        Marker(
          markerId: MarkerId('aa' + i.toString()),
          onTap: () {
            debugPrint('POSISI MARKER INI: ' + _markers[i].position.toString());
            markerOnTap(context, data["results"][i]['lat'], data["results"][i]['lon'], latt!.toDouble(), lonn!.toDouble());
          },
          icon: BitmapDescriptor.fromBytes(iconMarker2),
          position: LatLng(data["results"][i]['lat'], data["results"][i]['lon']),
          // infoWindow: InfoWindow(title:'Marker ' + nomarker.toString())
        )
      );
    }

    return "Berhasil";
  }
  
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
    if (latt == null) {
      latt = widget.curLat;
      lonn = widget.curLon;
    }
    else {
      latt = latt;
      lonn = lonn;
    }
    debugPrint('HALAMAN content - latt: ' + latt.toString());
    debugPrint('HALAMAN content - lonn: ' + lonn.toString());

    return Scaffold(
      appBar: AppBar(title: const Text('Cari Tambal Ban'), centerTitle: true, backgroundColor: Colors.orangeAccent),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Listener(
                onPointerUp: (details) {
                  // _getAddressFromLatLng();
                },
                child: GoogleMap(
                  markers: Set<Marker>.of(_markers),
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  initialCameraPosition: CameraPosition(
                    // target: LatLng(0,0),
                    target: LatLng(latt!.toDouble(),lonn!.toDouble()),
                    zoom: 20.0,
                  ),
                ),

              )           
            ),
            OutlinedButton(
              child: Text("SEGARKAN LOKASI" + j.toString()),
              onPressed: () async {
                Uint8List iconMarker = await getBytesFromAsset('assets/motorcycle-icon.png', 75);

                var a = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                setState(() {
                  latt = a.latitude;
                  lonn = a.longitude;

                  _markers.add(
                    Marker(
                      markerId: const MarkerId('1'),
                      icon: BitmapDescriptor.fromBytes(iconMarker),
                      position: LatLng(latt!.toDouble(),lonn!.toDouble()),
                      infoWindow: const InfoWindow(title:'Lokasi Saat Ini')
                    )
                  );
                });
                
                mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    // const CameraPosition(target: LatLng(-6.00009, 102.000999))
                    CameraPosition(
                      target: LatLng(latt!.toDouble(), lonn!.toDouble()),
                      zoom: 20.0
                    )
                  )
                );
              },
            ),
          ],
        )
    );   
  }

  Future<String> _formattedAddress(double lat, double lon) async {
    var jalan = '';
    var nojalan = '';
    var kelurahan = '';
    var kecamatan = '';
    var kota = '';
    // var propinsi = '';

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat, lon
      );

      Placemark place = placemarks[0];

      // setState(() {
        // var rt = place.street != null ? place.street : '';
        jalan = place.thoroughfare != '' ? place.thoroughfare.toString() : '';
        nojalan = place.subThoroughfare != '' ? ' ' + place.subThoroughfare.toString() : '';
        kelurahan = place.subLocality != '' ? ', ' + place.subLocality.toString() : '';
        kecamatan = place.locality != '' ? ', ' + place.locality.toString() : '';
        kota = place.subAdministrativeArea != '' ? ', ' + place.subAdministrativeArea.toString() : '';    
        // propinsi = place.administrativeArea != '' ? ', ' + place.administrativeArea.toString() : '';
        // _currentAddress = "${place.street}, ${place.thoroughfare}, ${place.subThoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
        // addressformated = jalan + nojalan + kelurahan + kecamatan + kota + propinsi;
      // });
    } catch (e) {
      debugPrint(e.toString());
    }
    return ((jalan + nojalan + kelurahan + kecamatan + kota).substring(0,2) != ', ' ? jalan + nojalan + kelurahan + kecamatan + kota : (jalan + nojalan + kelurahan + kecamatan + kota).substring(2));
  }
  
  /* _getAddressFromLatLng(double lat, double lon) async {
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
  } */
}