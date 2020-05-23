import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Folder.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';
import 'package:phonecall/Models/Note.dart';

class Notes with ChangeNotifier {

  static int counter = 0;

  // Starting list
  static List<Content> _notes = List<Content>.generate(
      3, (i) => Note(
      "title $i",
      false,
      false,
      null,
      "description $i",
      Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
  ));

  // Getter
  get notes {
    return _notes;
  }

  // Getter
  get lenght {
    return _notes.length;
  }

  // Add item
  Content get(int index) {
    return _notes[index];
  }

  // Add item
  void add(Content item) {
    _notes.add(item);
    notifyListeners();
  }

  // Remove item
  void remove(Content item) {
    _notes.remove(item);
    notifyListeners();
  }

  // Add type
//  void addContent(String name) {
//
//    /// Update the counter and refresh the vue
//    counter++;
//
//    // Factory
//    switch(name) {
//
//      case "Folder": {
//        notes.add(Folder(
//            "Folder title N°$counter",
//            false,
//            false,
//            null,
//            "description N°$counter",
//            Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
//        ));
//        break;
//      }
//
//      case "Note": {
//        notes.add(Note(
//            "Note title N°$counter",
//            false,
//            false,
//            null,
//            "description N°$counter",
//            Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
//        ));
//        break;
//      }
//
//      case "CheckList": {
//        notes.add(CheckList(
//            "CheckList title N°$counter",
//            false,
//            false,
//            null,
//            "description N°$counter",
//            Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
//        ));
//        break;
//      }
//    }
//
//    print(counter);
//    print(_notes);
//
//    notifyListeners();
//  }

}