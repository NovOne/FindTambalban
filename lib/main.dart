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
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/compressor.jpeg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop)
        )
      ),
      child: Stack(
        children: [
          Positioned(
        left: 150,
        bottom: 20,
        child: ElevatedButton(
          style: OutlinedButton.styleFrom(backgroundColor: Colors.orange),
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
          }
        ),
      )

        ],
      )     
    );
  }
}