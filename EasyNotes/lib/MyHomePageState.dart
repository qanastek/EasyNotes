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
import 'package:phonecall/View/Widgets/AddNote.dart';

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
      print(_selectedIndex);

      switch(_selectedIndex) {

        case 1:
          print("middle");
          showAddModal(context);
          break;
      }

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
                      MyColors.START_FADE,
                      MyColors.END_FADE,
                    ],
                  );
                },
                child: Icon(Icons.favorite_border),
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
                      MyColors.START_FADE,
                      MyColors.END_FADE,
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
                      MyColors.START_FADE,
                      MyColors.END_FADE,
                    ],
                  );
                },
                child: Icon(Icons.restore_from_trash),
              ),
              title: Container(),
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

  /// Display the adding modal
  void showAddModal(context) {

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[

                new ListTile(
                    leading: new Icon(Icons.note_add),
                    title: new Text('Note'),
                    onTap: () => {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => AddNote(addItem: _addItem,))),
                    }
                ),

                new ListTile(
                  leading: new Icon(Icons.playlist_add_check),
                  title: new Text('CheckList'),
                  onTap: () => {
                    Navigator.pop(context),
                    _addContent("CheckList"),
                  },
                ),

                new ListTile(
                  leading: new Icon(Icons.create_new_folder),
                  title: new Text('Folder'),
                  onTap: () => {
                    Navigator.pop(context),
                    _addContent("Folder"),
                  },
                ),

              ],
            ),
          );
        }
    );
  }
}