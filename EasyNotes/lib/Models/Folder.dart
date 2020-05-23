import 'package:flutter/material.dart';
import 'package:phonecall/Models/Content.dart';

class Folder extends Content {

  List<Content> content;

  Folder(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.folder,color) {
    this.content = List<Content>();
  }
}