import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:phonecall/Notes.dart';
import 'package:phonecall/View/Widgets/FloatingMenu.dart';
import 'package:phonecall/View/Widgets/NotesWidget.dart';
import 'package:phonecall/View/Widgets/SideMenu.dart';
import 'package:phonecall/main.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

/// Stateful root of the APP
class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

/// Add a state to the root widget
class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  // Counter
  int _counter = 0;

  // All the notes (ChangeNotifier)
  Notes notes = Notes();

  void _likeContent(Content item) {
    setState(() {
      item.favorite = !item.favorite;
    });
  }

  void _removeContent(Content item) {
    setState(() {
      notes.remove(item);
    });
  }

  void _addItem(Content item) {
    setState(() {
      notes.add(item);
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Add folder
  void _addContent(String name) {

    /// Update the counter and refresh the vue
    setState(() {

      _counter++;

      // Factory
      switch(name) {

        case "Folder": {
          notes.add(Folder(
              "Folder title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          ));
          break;
        }

        case "Note": {
          notes.add(Note(
              "Note title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          ));
          break;
        }

        case "CheckList": {
          notes.add(CheckList(
              "CheckList title N°$_counter",
              false,
              false,
              null,
              "description N°$_counter",
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
          ));
          break;
        }
      }
    });
  }

  /// The refresh method for the main page
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => notes,
      child: Scaffold(

        drawer: SideMenu(),

        body: NotesWidget(
          removeContent: (Content item) {
            setState(() {
              _removeContent(item);
            });
          },
          likeContent: (Content item) {
            setState(() {
              _likeContent(item);
            });
          },
        ),


        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return ui.Gradient.linear(
                    Offset(4.0, 24.0),
                    Offset(24.0, 4.0),
                    [
                      Colors.blue[900],
                      Colors.greenAccent,
                    ],
                  );
                },
                child: Icon(Icons.favorite_border),
              ),
              title: Container(
                child: Text(
                  'Restore',
                  style: TextStyle(
                      color: Colors.pink
                  ),
                ),
              ),
            ),

            BottomNavigationBarItem(
              icon: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return ui.Gradient.linear(
                    Offset(4.0, 24.0),
                    Offset(24.0, 4.0),
                    [
                      Colors.blue[900],
                      Colors.greenAccent,
                    ],
                  );
                },
                child: Icon(Icons.add_circle_outline),
              ),
              title: Container(),
            ),

            BottomNavigationBarItem(
              icon: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return ui.Gradient.linear(
                    Offset(4.0, 24.0),
                    Offset(24.0, 4.0),
                    [
                      Colors.blue[900],
                      Colors.greenAccent,
                    ],
                  );
                },
                child: Icon(Icons.restore_from_trash),
              ),
              title: Container(
                child: Text(
                  'Restore',
                  style: TextStyle(
                    color: Colors.pink
                  ),
                ),
              ),
            ),

          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),

        floatingActionButton: FloatingMenu(
          addContent: (String name) {
            setState(() {
              _addContent(name);
            });
          },
          addItem: (Content item) {
            setState(() {
              _addItem(item);
            });
          },
        ),
      ),
    );
  }
}