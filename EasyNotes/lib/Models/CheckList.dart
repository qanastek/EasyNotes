import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckBox.dart';
import 'package:phonecall/Models/Content.dart';

class CheckList extends Content {

  List<CheckBox> checkboxes;

  CheckList(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.format_list_bulleted,color) {
    this.checkboxes = List<CheckBox>();
  }
}