import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/CheckBox.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Folder.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Human.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Note.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Student.dart';

class NotesWidget extends StatelessWidget {

  List<Content> content;

  NotesWidget(this.content);

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: content.length, // How many elements
      itemBuilder: (BuildContext ctxt, int index) {
        Content item = content[index];
        return ListTile(
            title: Text(
                item.title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                )
            ),
            subtitle: Text(item.description),
            leading: Icon(
                item.icon,
                color: item.color
            )
        );
      }
    );
  }
}
//
//ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
//  title: Text(title,
//      style: TextStyle(
//        fontWeight: FontWeight.w500,
//        fontSize: 20,
//      )),
//  subtitle: Text(subtitle),
//  leading: Icon(
//    icon,
//    color: Colors.blue[500],
//  ),
//);