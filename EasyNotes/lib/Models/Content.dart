import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:uuid/uuid.dart';

abstract class Content {

  String id;
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
    this.id = Uuid().toString();
    this.title = title;
    this.favorite = favorite;
    this.secured = secured;
    this.password = password;
    this.description = description;
    this.icon = icon;
    this.color = color;
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

    if(this.color == null) {

      return MyColors.randomColor();
    }

    return this.color;
  }

  /// Get icon
  IconData getIcon();
}