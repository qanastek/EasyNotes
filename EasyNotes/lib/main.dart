import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Folder.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Note.dart';
import 'package:phonecall/Notes.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/View/Widgets/NotesWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

/// Add a state to the root widget
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  // Counter
  int _counter = 0;

  // Starting list
  static List<Content> _content = List<Content>.generate(
      5, (i) => Note(
          "title $i",
          false,
          false,
          null,
          "description $i",
          Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
      )
  );

  // Add folder
  void _addContent(String name) {

    /// Update the counter and refresh the vue
    setState(() {

      _counter++;
      Content item;

      // Factory
      switch(name) {

        case "Folder": {
          item = Folder(
              "Folder title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          );
          break;
        }

        case "Note": {
          item = Note(
              "Note title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          );
          break;
        }

        case "CheckList": {
          item = CheckList(
              "CheckList title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          );
          break;
        }
      }

      _content.add(item);
    });
  }

  /// The refresh method for the main page
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ChangeNotifierProvider(
      create: (_) => new Notes(),
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("${widget.title} $_counter"),
        ),
        body: Center(
          // All the notes
          child: NotesWidget(_content),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayColor: Colors.white,
          overlayOpacity: 0.60,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.folder, color: Colors.white),
              label: "Add folder",
              backgroundColor: Colors.pink,
              onTap: () => _addContent("Folder")),

            SpeedDialChild(
              child: Icon(Icons.format_list_bulleted, color: Colors.white),
              label: "Add checklist",
                backgroundColor: Colors.pinkAccent,
              onTap: () => _addContent("CheckList")),

            SpeedDialChild(
              child: Icon(Icons.note, color: Colors.white),
              label: "Add note",
                backgroundColor: Colors.green,
              onTap: () => _addContent("Note")),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
