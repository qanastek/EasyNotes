import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';
import 'package:phonecall/Models/Note.dart';

class Notes with ChangeNotifier {

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
}