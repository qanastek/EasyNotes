import 'package:flutter/material.dart';
import 'package:phonecall/Models/Content.dart';

class Note extends Content {

  DateTime expiredDate;

  Note(title,favorite,secured,password,description,color, this.expiredDate): super(title, favorite, secured, password, description, Icons.note,color);
}