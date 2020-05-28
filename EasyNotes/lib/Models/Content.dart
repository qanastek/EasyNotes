import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

abstract class Content {

  final String id = md5.convert(utf8.encode(DateTime.now().toString())).toString();
  String title;
  bool favorite;
  bool secured;
  String password;
  String description;
  IconData icon;
  Color color;
  DateTime creationDate;
  DateTime lastModification;
  bool archived;

  /// Constructor
  Content(title,favorite,secured,password,description,icon,color) {
    this.title = title;
    this.favorite = favorite;
    this.secured = secured;
    this.password = password;
    this.description = description;
    this.icon = icon;

    if(color != null) {
      this.color = color;
    } else {
      this.color = MyColors.randomColor();
    }

    this.creationDate = DateTime.now();
    this.lastModification = DateTime.now();
    this.archived = false;
  }

  String getTitle() {
    return title;
  }

  /// Return the description according to the type
  String getDescription();

  /// Get color
  Color getColor() {
    return this.color;
  }

  /// Get icon
  IconData getIcon();
}