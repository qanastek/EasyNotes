import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:phonecall/MyHomePageState.dart';
import 'package:phonecall/Notes.dart';
import 'package:phonecall/View/Widgets/AddNote.dart';
import 'package:provider/provider.dart';

typedef ContentCallback = void Function(String name);

class FloatingMenu extends StatelessWidget {

  final ContentCallback addContent;

  FloatingMenu({this.addContent});

  @override
  Widget build(BuildContext context) {

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      overlayColor: Colors.white,
      overlayOpacity: 0.60,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: CircleBorder(),
      children: [

        SpeedDialChild(
            child: Icon(Icons.folder, color: Colors.white),
            label: "Add folder",
            backgroundColor: Colors.pink,
            onTap: () => addContent("Folder")),

        SpeedDialChild(
            child: Icon(Icons.format_list_bulleted, color: Colors.white),
            label: "Add checklist",
            backgroundColor: Colors.pinkAccent,
            onTap: () => addContent("CheckList")),

        SpeedDialChild(
            child: Icon(Icons.note, color: Colors.white),
            label: "Add note",
            backgroundColor: Colors.green,
            onTap: () {
//              main.addContent("Note");
              Navigator.push(context,MaterialPageRoute(builder: (context) => AddNote()));
            }),
      ],
    );
  }
}
