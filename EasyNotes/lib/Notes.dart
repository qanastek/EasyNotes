import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';

class Notes with ChangeNotifier {

  /// General counter
  static int counter = 0;

  /// Parent
  Notes parent;

  /// Fill up the list for test
  List<Content> _notes = List<Content>();

  // Getter non archived notes
  get notes {
    return _notes.where((e) => e.archived == false).toList();
  }

  // Getter non archived notes
  get bookmarks {
    return _notes.where((e) => e.favorite == true).toList();
  }

  // Getter archived notes
  get archives {
    return _notes.where((e) => e.archived == true).toList();
  }

  // Getter normal
  get length {
    return notes.length;
  }

  // Getter bookmarks
  get bookmarksLength {
    return bookmarks.length;
  }

  // Getter
  get archivesLength {
    return archives.length;
  }

  // Add item
  Content get(int index) {
    return notes[index];
  }

  // Add item
  Content geArchived(int index) {
    return archives[index];
  }

  // Add item
  void add(Content item) {

    /// Search if there is any occurrence of the item
    Content found;

    /// If not empty
    if(_notes != null && _notes.length > 0) {

      /// Identical
      _notes.forEach((element) {
        if(element.id == item.id) {
          found = element;
        }
      });
    }

    /// If already in
    if(found != null) {

      found = item;

    } else {

      /// If it's a Folder
      if(item is Folder) {

        /// Set the parent
        item.content.parent = this;
        print("item.content.parent");
        print(item.content.parent);
      }

      _notes.add(item);
    }

    notifyListeners();
  }

  // Remove item
  void remove(Content item) {
//    _notes.remove(item);
    item.archived = true;
    print(archivesLength);
    notifyListeners();
  }

  /// Fill up the datas
  void fillUp() {
    _notes = List<Content>.generate(
        3, (i) => Note(
        "Recipe Lemonade $i",
        false,
        false,
        null,
        '''
          Lemonade: sugar, water, lemon juice. Easy, right?
    
          Well, the problem is that if you just stir all of these together the sugar will sink to the bottom. So the best way to make lemonade is to make a simple syrup first, by heating water and sugar together until the sugar is completely dissolved, and then mix that with the lemon juice.
    
    
      The proportions will vary depending on how sweet and strong you like your lemonade, and how sour your lemons are to begin with. Late season lemons are less sour than early season lemons. Meyer lemons are sweeter than standard lemons.
    
      Start with the proportions of 1 cup of sugar, 1 cup of water, 1 cup of lemon juice. Reduce the sugar amount if you are using Meyer lemons or if you like your lemonade less sweet. (I usually use 3/4 cup of lemon juice.)
    
          Make the simple syrup, combine with the lemon juice, and then add more water (and ice) to dilute the lemonade to your taste.
    
      Simple syrup you can easily make ahead and chill for later use. If you have a bunch of lemons you need to process, you can juice them and freeze the juice too. $i
      ''',
        null,
        null
    ));
  }
}