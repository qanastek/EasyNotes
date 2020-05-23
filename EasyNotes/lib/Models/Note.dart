import 'package:flutter/material.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';

class Note extends Content {

  Note(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.note,color);
}