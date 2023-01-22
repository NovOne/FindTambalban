// FILE NAME: copy-file.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await rootBundle.load("assets/daftar.json");
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  /* var url = "https://raw.githubusercontent.com/NovOne/FindTambalban/master/assets/daftar.json";
  var res = await http.get(Uri.parse(url), headers: { 'Content-Type':'application/json' });
  var content = json.decode(res.body);
  var items = content["results"];

  // print ('Content: ' + content);
  print ('lat = ' + items[1]['lat'].toString());
  print ('lon = ' + items[1]['lon'].toString());
  */

  Directory appDocDir = await getApplicationDocumentsDirectory();
  // String path = join(appDocDir.path, "data.db");
  String path = appDocDir.path + '/daftar.json';
  print (path);
  try {
    await File(path).writeAsBytes(bytes);
    print ('SUKSES');
  }
  catch (e) {
    print ('Kesalahan: ' + e.toString());
  }
}