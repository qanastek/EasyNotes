import 'package:flutter/material.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:phonecall/Notes.dart';

class Folder extends Content {

  Notes content;

  Folder(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.folder,color) {
    this.content = Notes();
  }

  @override
  String getDescription() {

    if(secured == true) {
      return "Secured folder";
    }

    return "${this.content.length} Elements";
  }

  @override
  IconData getIcon() {

    // Check if it's secured
    if(secured == true) {
      return AddIcons.lock;
    }

    if(content.length > 1) {
      return AddIcons.folder;
    }
    else {
      return AddIcons.folder;
    }
  }
}