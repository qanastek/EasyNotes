import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';

class Note extends Content {

  Note(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.note,color);

  @override
  String getDescription() {

    // Check if it's secured
    if(secured == true) {
      return "Secured note";
    }

    if(this.expiredDate != null) {
      return "${expiredDate.difference(DateTime.now()).inHours} hours left";
    } else {
      return "Edited: ${DateFormat.yMMMd().format(this.lastModification)}";
    }
  }

  @override
  IconData getIcon() {

    // Check if it's secured
    if(secured == true) {
      return AddIcons.lock;
    }

    return AddIcons.document;
  }
}