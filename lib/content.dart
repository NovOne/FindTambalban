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
  final List<Marker> _markers = <Marker>[];
  // String? _currentAddress;
  String? addressformated;
  String? currentAddress;
  // late BitmapDescriptor iconMarker;
  late Uint8List iconMarker;
  String? response;
  var data;

  @override
  void initState () {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]); // Untuk menghilangkan status bar/notification bar
    markerIcon(); // Add marker for only current location
    getLocation();
    // getMarker();
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values); // untuk menjadikan normal kembali tampilannya
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

  Future<String> markerIcon() async { // Add marker for only current location
    Uint8List iconMarker = await getBytesFromAsset('assets/motorcycle-icon.png', 75);
    _markers.add(
        Marker(
          markerId: const MarkerId('1'),
          icon: BitmapDescriptor.fromBytes(iconMarker),
          position: LatLng(latt!.toDouble(),lonn!.toDouble()),
          infoWindow: const InfoWindow(title:'Lokasi Saat Ini')
        )
      );
    return 'OK aja lah';
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format:ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> gotoDirection(String origin, String destination) async {
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

  // List<double> datas = [8, 0.7, 9.8, 7.0]; 

  Future <List<double>> bubbleSort(datas) async {
    int n = datas.length;
    double dummy;
    List<LatLng> destiLoc = [];
    response = await rootBundle.loadString('assets/daftar.json');
    data = await json.decode(response!.toString());


    for (var i = 0; i<n; i++) {
      for (var j = n-1; j>i; j--) {
        if (datas[j] < datas[j-1]) { 
          dummy = datas[j];
          datas[j] = datas[j-1];
          datas[j-1] = dummy;
          destiLoc.insert(j-1,LatLng(data['results'][j-1]['lat'], data['results'][j-1]['lon']));
        }
      }
      // kode di sini
    }
    // debugPrint(datas);

    return datas;
  }

  Future<String> getLocation() async { // mendapatkan semua titik lokasi, jarak ke current lokasi dan buat marker yg memenuhi syarat
    List<double> listDistance = [];
    // int nummarkers = 0;
    // List<LatLng> latlngmarker = [];
    List<LatLng> destiLoc = [];


    response = await rootBundle.loadString('assets/daftar.json');
    data = await json.decode(response!.toString());
    double dummy;
    LatLng dummy2;

    final Uint8List iconMarker2 = await getBytesFromAsset('assets/marker-motorcycle.png', 75);
    
    for (var i=0; i<data['results'].length; i++) {
      listDistance.add(
        getDistance(LatLng(latt!.toDouble(),lonn!.toDouble()),
          LatLng(data['results'][i]['lat'],
          data['results'][i]['lon']))
      );
      destiLoc.add(LatLng(data['results'][i]['lat'], data['results'][i]['lon']));
    }

    for (var i = 0; i<listDistance.length; i++) {
      for (var j = listDistance.length-1; j>i; j--) {
        if (listDistance[j] < listDistance[j-1]) { 
          dummy = listDistance[j];
          // listDistance.insert(j, listDistance[j-1]);
          listDistance[j] = listDistance[j-1];
          // listDistance.insert(j-1, dummy);
          listDistance[j-1] = dummy;
          dummy2 = destiLoc[j]; 
          destiLoc[j] = destiLoc[j-1];
          // destiLoc[j] = destiLoc[j-1];
          destiLoc[j-1] = dummy2;
          // destiLoc.removeAt(j-1);
        }
      }
    }

    /* debugPrint('DESTILOC: ' + destiLoc.toString());
    debugPrint('JUMLAH: ' + destiLoc.length.toString());
    debugPrint('LIST DISTANCE: ' + listDistance.toString());
    */

    for (var k=0; k<=4; k++) {
      _markers.add(
        Marker(
          markerId: MarkerId('aa' + k.toString()),
          onTap: () {
            markerOnTap(context, destiLoc[k].latitude, destiLoc[k].longitude, latt!.toDouble(), lonn!.toDouble());
          },
          icon: BitmapDescriptor.fromBytes(iconMarker2),
          position: LatLng(destiLoc[k].latitude, destiLoc[k].longitude)
        )
      );
    }

    /* for (var j=0; j<listDistance.length; j++) {
      debugPrint('j: ' + j.toString());
      if(listDistance[j] <= 500) { 
        // latlngmarker.insert(nummarkers,LatLng(data['results'][j]['lat'],data['results'][j]['lon']));
        _markers.add(
          Marker(
            markerId: MarkerId('aa' + j.toString()),
            onTap: () {
              markerOnTap(context, data['results'][j]['lat'], data['results'][j]['lon'], latt!.toDouble(), lonn!.toDouble());
            },
            icon: BitmapDescriptor.fromBytes(iconMarker2),
            position: LatLng(data['results'][j]['lat'], data['results'][j]['lon']),
          )
        );

        nummarkers += nummarkers;
        debugPrint('LATLNGMARKER: ' + latlngmarker.toString());
      }
    } // end for j

    for (var k=0; k<listDistance.length; k++) {
        // latlngmarker[k] = LatLng(data['results'][k]['lat'],data['results'][k]['lon']);
        if((nummarkers >= 5)) {
          break;
        }
        else {
          for (var k=nummarkers; k<=4; k++) {
            _markers.add(
              Marker(
                markerId: MarkerId('aa' + k.toString()),
                onTap: () {
                  markerOnTap(context, data['results'][k]['lat'], data['results'][k]['lon'], latt!.toDouble(), lonn!.toDouble());
                },
                icon: BitmapDescriptor.fromBytes(iconMarker2),
                position: LatLng(data['results'][k]['lat'], data['results'][k]['lon']),
              )
            );
          }      
        }
        debugPrint('LATLNGMARKER JAUH: ' + latlngmarker.toString());
      }
    */

    return 'Sukses';
  }
  /* Buat Marker Tambal Ban terdekat */
  
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
              style: OutlinedButton.styleFrom(primary: Colors.orange, side: const BorderSide(color: Colors.orange)),
              child: const Text("SEGARKAN LOKASI"),
              onPressed: () async {
                Uint8List iconMarker = await getBytesFromAsset('assets/motorcycle-icon.png', 75);

                var a = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                setState(() {
                  /* Mengubah posisi marker current */
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