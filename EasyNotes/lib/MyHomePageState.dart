import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:phonecall/Notes.dart';
import 'package:phonecall/View/Widgets/FloatingMenu.dart';
import 'package:phonecall/View/Widgets/NotesWidget.dart';
import 'package:phonecall/View/Widgets/SideMenu.dart';
import 'package:phonecall/main.dart';
import 'package:provider/provider.dart';

/// Add a state to the root widget
class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  // Counter
  int _counter = 0;

  // All the notes (ChangeNotifier)
  Notes notes = Notes();

  void _removeContent(Content item) {
    setState(() {
      notes.remove(item);
    });
  }

  // Add folder
  void _addContent(String name) {

    /// Update the counter and refresh the vue
    setState(() {

      _counter++;

      // Factory
      switch(name) {

        case "Folder": {
          notes.add(Folder(
              "Folder title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          ));
          break;
        }

        case "Note": {
          notes.add(Note(
              "Note title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          ));
          break;
        }

        case "CheckList": {
          notes.add(CheckList(
              "CheckList title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          ));
          break;
        }
      }
    });
  }

  /// The refresh method for the main page
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => notes,
      child: Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: Text("${widget.title} $_counter"),
        ),
        body: NotesWidget(
          removeContent: (Content item) {
            setState(() {
              _removeContent(item);
            });
          },
        ),
        floatingActionButton: FloatingMenu(
          addContent: (String name) {
            setState(() {
              _addContent(name);
            });
          },
        ),
      ),
    );
  }
}