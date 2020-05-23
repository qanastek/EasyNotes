import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Notes.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/CheckBox.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Content.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Folder.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Human.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Note.dart';
import 'file:///C:/xampp2/htdocs/other_things/EasyNotes/EasyNotes/lib/Models/Student.dart';
import 'package:provider/provider.dart';

class NotesWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: Provider.of<Notes>(context, listen: false).lenght, // How many elements
      itemBuilder: (BuildContext ctxt, int index) {

        /// The current item
        Content item = Provider.of<Notes>(context, listen: false).get(index);

        return Dismissible(
          key: ValueKey("item_$index"),
          direction: DismissDirection.horizontal,
          movementDuration: Duration(milliseconds: 300),
          onDismissed: (direction) {
            print("delete");
            Provider.of<Notes>(context, listen: false).remove(item);
          },
          child: ListTile(
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
            ),
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