import 'package:flutter/cupertino.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';

class Notes with ChangeNotifier {

  // Content
  List<Content> _notes = new List();

  // Getter
  get notes {
    return _notes;
  }

  // Add item
  set notes(Content item) {
    _notes.add(item);
    notifyListeners();
  }
}