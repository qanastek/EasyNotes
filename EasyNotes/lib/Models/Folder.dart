import 'package:flutter/material.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';

class Folder extends Content {

  List<Content> content;

  Folder(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.folder,color) {
    this.content = List<Content>();
  }
}