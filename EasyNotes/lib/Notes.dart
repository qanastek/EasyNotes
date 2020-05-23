import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/Content.dart';
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

  // Getter non archived notes
  get notes {
    return _notes.where((e) => e.archived == false).toList();
  }
  // Getter archived notes
  get archivedNotes {
    return _notes.where((e) => e.archived == true).toList();
  }

  // Getter
  get lenght {
    return notes.length;
  }

  // Getter
  get lenghtArchived {
    return archivedNotes.length;
  }

  // Add item
  Content get(int index) {
    return notes[index];
  }

  // Add item
  Content geArchived(int index) {
    return archivedNotes[index];
  }

  // Add item
  void add(Content item) {
    _notes.add(item);
    notifyListeners();
  }

  // Remove item
  void remove(Content item) {
//    _notes.remove(item);
    item.archived = true;
    print(lenghtArchived);
    notifyListeners();
  }
}