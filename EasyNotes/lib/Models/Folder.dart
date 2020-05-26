import 'package:flutter/material.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';

class Folder extends Content {

  List<Content> content;

  Folder(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.folder,color) {
    this.content = List<Content>();
  }

  @override
  String getDescription() {
    return "${this.content.length} Elements";
  }

  @override
  IconData getIcon() {

    if(content.length > 1) {
      return AddIcons.folder;
    }
    else {
      return AddIcons.folder;
    }
  }
}