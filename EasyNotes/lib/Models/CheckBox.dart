import 'package:flutter/material.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';

class CheckBox extends Content {

  bool checked;

  CheckBox(title,favorite,secured,password,description,checked,color): super(title, favorite, secured, password, description, Icons.format_list_bulleted,color) {
    this.checked = checked;
  }
}