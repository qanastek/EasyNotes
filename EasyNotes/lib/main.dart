import 'package:flutter/material.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:phonecall/MyHomePageState.dart';

void main() {
  runApp(MyApp());
}

/// The APP settings
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.WHITE,
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EasyNotes'), // Constructor root
    );
  }
}