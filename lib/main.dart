import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iremember/ui/pages/add.dart';
import 'package:iremember/ui/pages/create_account.dart';
import 'package:iremember/ui/pages/home.dart';
import 'package:iremember/ui/pages/post_screen.dart';

/* 
Please complete the tasks listed in TODOs in different files
  
  In this app user should be able to Save a list of items
  with image (should be able to take a picture or select existing one from gallery), 
  title and description in firestore database, with image being uploaded to firebase storage.

  TODO 1. Integrate a firebase firestore and storage
  TODO 2. Integrate a state management solution you know best

  (optional) -> Theme and style as you prefer to show quality work

  Checkout home.dart and add.dart for TODOs.

 */

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    print('Timestamp is Enabled in Snapshot\n');
  }, onError: (_) {
    print('Timestamp Error Enabled in Snapshot\n');
  });
  runApp(IRememberApp());
}

class IRememberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IRemember',
      theme: ThemeData(primaryColor: Colors.deepOrange),
      routes: {
        "/": (_) => Home(),
        "posts": (_) => PostScreen(),
        "createAccount": (_) => CreateAccount(),
        "addPosts": (_) => AddPage(),
      },
    );
  }
}
