import 'package:flutter/material.dart';
import 'package:phonecall/Models/Content.dart';

class Note extends Content {

  Note(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.note,color);
}