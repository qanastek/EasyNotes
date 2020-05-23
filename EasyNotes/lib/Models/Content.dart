import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Content {

  String title;
  bool favorite;
  bool secured;
  String password;
  String description;
  IconData icon;
  Color color;

  Content(title,favorite,secured,password,description,icon,color) {
    this.title = title;
    this.favorite = favorite;
    this.secured = secured;
    this.password = password;
    this.description = description;
    this.icon = icon;
    this.color = color;
  }
}