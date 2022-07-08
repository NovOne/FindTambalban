/* FILE: fluter_share.dart */
// import 'dart:async';
import 'package:share_plus/share_plus.dart'; // share_plus: ^2.0.1
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = '';
  String subject = '';

  _onShareData(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    {
      await Share.share(text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Share Flutter'),
          backgroundColor: Colors.green[700],
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Share Text',
                  labelStyle: TextStyle(color: Colors.blue),
                  hintText: 'Enter some text'
                ),
                maxLines: 2,
                onChanged: (String value) =>
                  setState(() {
                    text = value;
                  })
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Share Subject',
                  labelStyle: TextStyle(color: Colors.blue),
                  hintText: 'Enter subject to share'
                ),
                maxLines: 2,
                onChanged: (String value) =>
                  setState(() {
                    subject = value;
                  })
              ),
              Builder(
                builder: (BuildContext context) {
                  return RaisedButton(
                    color: Colors.orangeAccent[100],
                    child: const Text('Share'),
                    onPressed: text.isEmpty ? null : () => _onShareData(context)
                  );
                }
              )
            ],
          )
        )
      ),
    );
  }
}