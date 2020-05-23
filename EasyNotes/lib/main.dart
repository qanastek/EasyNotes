import 'package:flutter/material.dart';
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
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EasyNotes'), // Constructor root
    );
  }
}

/// Stateful root of the APP
class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}