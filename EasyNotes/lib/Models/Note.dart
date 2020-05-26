import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';

class Note extends Content {

  DateTime expiredDate;
  DateTime creationDate;
  DateTime editDate;

  Note(title,favorite,secured,password,description,color, this.expiredDate): super(title, favorite, secured, password, description, Icons.note,color) {
    this.creationDate = DateTime.now();
    this.editDate = DateTime.now();
  }

  @override
  String getDescription() {
    if(this.expiredDate != null) {
      return "${expiredDate.difference(DateTime.now()).inHours} hours left";
    } else {
      return "Edited: ${DateFormat.yMMMd().format(this.editDate)}";
    }
  }

  @override
  IconData getIcon() {
    return AddIcons.document;
  }
}