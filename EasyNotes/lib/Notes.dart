import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckBox.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:phonecall/Models/Setting/AppSettings.dart';

class Notes with ChangeNotifier {

  /// General counter
  static int counter = 0;

  /// Parent
  Notes parent;

  /// Fill up the list for test
  List<Content> _notes = List<Content>();

  /// Current view mode
  String mode = AppSettings.DEFAULT;


  List<Content> getContentFiltered(String filter) {

    List<Content> res;

    if(mode == AppSettings.BOOKMARKS) {
      res = this.bookmarks;
    }
    else if(mode == AppSettings.ARCHIVED) {
      res = this.archives;
    }
    else {
      res = this.notes;
    }

    res = res.where((element) => element.title.toLowerCase().contains(filter.toLowerCase())).toList();

    return res.length <= 0 ? this.content : res.toList();
  }

  int contentLengthFiltered(String filter) {
    return filter == null || filter == "" ? this.contentLength : this.getContentFiltered(filter).length;
  }

  /// Get the content
  Content getFiltered(String filter, int index) {
    return filter == null || filter == "" ? this.content[index] : this.getContentFiltered(filter)[index];
  }

  /// Return the content
  get content {

    if(mode == AppSettings.BOOKMARKS) {
      return this.bookmarks;
    }
    else if(mode == AppSettings.ARCHIVED) {
      return this.archives;
    }
    else {
      return this.notes;
    }
  }

  /// Return the length
  get contentLength {

    if(mode == AppSettings.BOOKMARKS) {
      return this.bookmarksLength;
    }
    else if(mode == AppSettings.ARCHIVED) {
      return this.archivesLength;
    }
    else {
      return this.length;
    }
  }

  /// Get the content
  Content get(int index) {

    if(mode == AppSettings.BOOKMARKS) {
      return this.bookmarks[index];
    }
    else if(mode == AppSettings.ARCHIVED) {
      return this.archives[index];
    }
    else {
      return this.notes[index];
    }
  }

  void sortByLastEdit() {
    _notes.sort((b, a) => a.lastModification.compareTo(b.lastModification));
  }

  // Getter non archived notes
  get notes {
    sortByLastEdit();
    return _notes.where((e) => e.archived == false).toList();
  }

  // Getter non archived notes
  get bookmarks {
    sortByLastEdit();
    return _notes.where((e) => (e.favorite == true) && (e.archived == false)).toList();
  }

  // Getter archived notes
  get archives {
    sortByLastEdit();
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
    item.archived = true;
    notifyListeners();
  }

  // Erase item
  void erase(Content item) {
    _notes.remove(item);
    notifyListeners();
  }

  // Restore item
  void restore(Content item) {
    item.archived = false;
    notifyListeners();
  }

  /// Fill up the datas
  void fillUp() {

    Folder folderSummer = Folder(
        "Summer ${DateTime.now().year + 1} holidays ideas",
        false,
        false,
        null,
        "",
        Color(0xFFF1B9A3),
    );

    /// Folder
    this.add(folderSummer);

    /// Note in the Folder
    CheckList todoListSummer = CheckList(
        "Dream destinations",
        false,
        false,
        null,
        "",
        Color(0xFFFFD18B),
    );

    /// To-do's
    todoListSummer.checkboxes.add(CheckBox("Calanque de Sormiou, Marseille France",true));
    todoListSummer.checkboxes.add(CheckBox("Goa, India",true));
    todoListSummer.checkboxes.add(CheckBox("Helsinki, Finland",true));
    todoListSummer.checkboxes.add(CheckBox("Wacken, Germany",true));
    todoListSummer.checkboxes.add(CheckBox("The Highlands , Scotland",true));
    todoListSummer.checkboxes.add(CheckBox("Wall of China",true));
    todoListSummer.checkboxes.add(CheckBox("Iceland",true));
    todoListSummer.checkboxes.add(CheckBox("Seoul, South Korea and Tokyo, Japan",true));
    todoListSummer.checkboxes.add(CheckBox("Sri Lanka",true));
    todoListSummer.checkboxes.add(CheckBox("Paris, France",true));
    todoListSummer.checkboxes.add(CheckBox("Dubai, UAE",true));
    folderSummer.content.add(todoListSummer);

    /// Note
    this.add(
        Note(
            "A Madame D. G. de G.",
            false,
            false,
            null,
            "Jadis je vous disais : -- Vivez, régnez, Madame !\n" +
            "Le salon vous attend ! le succès vous réclame !\n" +
            "Le bal éblouissant pâlit quand vous partez !\n" +
            "Soyez illustre et belle ! aimez ! riez ! chantez !\n" +
            "Vous avez la splendeur des astres et des roses !\n" +
            "Votre regard charmant, où je lis tant de choses,\n" +
            "Commente vos discours légers et gracieux.\n" +
            "Ce que dit votre bouche étincelle en vos yeux.\n" +
            "Il semble, quand parfois un chagrin vous alarme,\n" +
            "Qu'ils versent une perle et non pas une larme.\n" +
            "Même quand vous rêvez, vous souriez encor,\n" +
            "Vivez, fêtée et fière, ô belle aux cheveux d'or !\n" +
            "Maintenant vous voilà pâle, grave, muette,\n" +
            "Morte, et transfigurée, et je vous dis : -- Poëte !\n" +
            "Viens me chercher ! Archange ! être mystérieux !\n" +
            "Fais pour moi transparents et la terre et les cieux !\n" +
            "Révèle-moi, d'un mot de ta bouche profonde,\n" +
            "La grande énigme humaine et le secret du monde !\n" +
            "Confirme en mon esprit Descarte ou Spinosa !\n" +
            "Car tu sais le vrai nom de celui qui perça,\n" +
            "Pour que nous puissions voir sa lumière sans voiles,\n" +
            "Ces trous du noir plafond qu'on nomme les étoiles !\n" +
            "Car je te sens flotter sous mes rameaux penchants ;\n" +
            "Car ta lyre invisible a de sublimes chants !\n" +
            "Car mon sombre océan, où l'esquif s'aventure,\n" +
            "T'épouvante et te plaît ; car la sainte nature,\n" +
            "La nature éternelle, et les champs, et les bois,\n" +
            "Parlent de ta grande âme avec leur grande voix !\n\n\n"
            "Victor HUGO (1802 - 1885)",
            Color(0xFFFDEABF),
            null,
        )
    );

    /// Note
    CheckList todoList = CheckList(
        "What can I do ?",
        false,
        false,
        null,
        "",
        Color(0xFFFFD18B),
    );

    /// To-do's
    todoList.checkboxes.add(CheckBox("Run the app",true));
    todoList.checkboxes.add(CheckBox("Create a Pink Folder called 'Flowers'",false));
    todoList.checkboxes.add(CheckBox("Create a Yellow Note for my daily routine",false));
    todoList.checkboxes.add(CheckBox("Set a remainder on an important Note",false));
    todoList.checkboxes.add(CheckBox("Add a password/footprint to a Note",false));
    todoList.checkboxes.add(CheckBox("Look at my Bookmarks",false));
    todoList.checkboxes.add(CheckBox("Delete a Note by holding it and drop it in the section on top",false));
    todoList.checkboxes.add(CheckBox("Restore a deleted Note",false));

    this.add(todoList);

  }
}