/* FILENAME: dynamic_link_view.dart */

import 'package:flutter/material.dart';

class TujuanLinkDinamik extends StatefulWidget {
  const TujuanLinkDinamik({Key? key}) : super(key: key);
  
  @override
  TujuanLinkDinamikState createState() => TujuanLinkDinamikState();
}

class TujuanLinkDinamikState extends State<TujuanLinkDinamik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DINAMIK LINK VIEW'),
      ),
      body: const Center(
        child: Text('TUJUAN LINK DINAMIK')
      )
    );
  }
}