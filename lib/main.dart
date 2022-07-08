/* FILE: main_tambal_ban.dart */
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'content.dart';

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
  double? latt;
  double? lonn;
  // String? _currentAddress;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 400,
          ),
          FlatButton(
            child: const Text("MULAI"),
            onPressed: () async {
              Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {
                setState(() {
                  latt = value.latitude;
                  lonn = value.longitude;
                });
                debugPrint('LAT: ' + latt.toString());
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Content(curLat: latt, curLon: lonn)));
              });
              // --> Manggil class lainnya di sini
            },
          ),
        ],
      ),
    );
  }
}