/* FILE NAME: methodchannel.dart */
/* methodchannel with KOTLIN */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(const MyAppUtama());
}

class MyAppUtama extends StatelessWidget {
  const MyAppUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Method Channel with Kotlin',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyApp(title:'Flutter-Kotlin'),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  static const platform = MethodChannel('com.example.tutorialflutter');
  String? receivedString = "";

  Future<void> callNativeFunction() async {
    String msg = "Hello from Flutter",data="";
    try {
      final String temp = await platform.invokeMethod('callSendStringFun',{"arg":msg});
      data = temp;
    } on PlatformException catch (e) {
      data = "Failed with Error" + e.toString();
    }
    setState(() {
      receivedString = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CallNative"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: callNativeFunction, //callNativeFunction is called on button pressed
              child: const Text("Call Native"),
            ),
            Text('$receivedString'),
          ],
        ),
      ),
    );
  }
}