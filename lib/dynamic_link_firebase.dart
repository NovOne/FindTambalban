/* FILENAME: dynamic_link_firebase.dart */
// import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:dynamic_links/homepage.dart';
// import 'package:dynamic_links/loginpage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'dynamic_link_view.dart';
void main() {
  runApp(const MyAppUtama());
}

class MyAppUtama extends StatelessWidget {
  const MyAppUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Dynamic Link',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyApp(title:'COBA'),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    // this.initDynamicLinks();
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
    onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      debugPrint("deeplink found");
      if (deepLink != null) {
        debugPrint(deepLink.toString());
        print ('Dinamik Link: $dynamicLink');
        if(deepLink.toString() == 'https://cires.id/signin') {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const TujuanLinkDinamik()));
        }
        else {
          debugPrint('BUKAN SIGNIN');
        }
        // Get.to(() => LogInPage(title: 'firebase_dynamic_link  navigation'));
      }
    }, onError: (OnLinkErrorException e) async {
      print("deeplink error");
      print(e.message);
    });
  }
  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyApp(title: 'Demo Home Page'),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(child: Text('Halaman ini dari Dynamic Link Firebase')),
    );
  }
}