import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
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
              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)],
              null
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

//        drawer: SideMenu(),

        /// Body
        body: NotesWidget(
          addItem: (Content item) {
            setState(() {
              _addItem(item);
            });
          },
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

        /// NavigationBar
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[

            /// Bookmarks
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
                child: Icon(Icons.collections_bookmark),
              ),
              title: Container(),
            ),

            /// Add modal
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

            /// Garbage
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

        /// Floating menu
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

                /// Separator
                Center(
                  child: Container(
                    height: 8,
                    width: 80,
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.CUSTOM_RED,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),

                /// Folder
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 20,
                  ),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: new Icon(
                      AddIcons.folder,
                      color: MyColors.CUSTOM_RED,
                      size: 30,
                    ),
                    title: new Text(
                      'New folder',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFE15A61),
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                      top: 7,
                      bottom: 7,
                    ),
                    subtitle: new Text(
                      'Create a new folder where you can add notes to.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFFF8C8E),
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => {
                      Navigator.pop(context),
                      _addContent("Folder"),
                    },
                  ),
                ),

                /// Note
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 5,
                    bottom: 20,
                  ),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: new Icon(
                      AddIcons.note,
                      color: MyColors.CUSTOM_RED,
                      size: 30,
                    ),

                    title: Text(
                      'New text note',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFE15A61),
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                      top: 7,
                      bottom: 7,
                    ),

                    subtitle: Text(
                      'Quickly add a task to your notes.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFFF8C8E),
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),

                    onTap: () => {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => AddNote(
                        addItem: _addItem,
                        item: Note("",false,false,null,"",Colors.greenAccent,null),
                      ))),
                    },
                  ),
                ),

                /// TodoList
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 5,
                    bottom: 20,
                  ),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 2,
                    bottom: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: new Icon(
                      AddIcons.checklist,
                      color: MyColors.CUSTOM_RED,
                      size: 30,
                    ),
                    title: new Text(
                      'New todo list',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFE15A61),
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                      top: 7,
                      bottom: 7,
                    ),
                    subtitle: new Text(
                      'Create a list to store your ideas.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFFF8C8E),
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => {
                      Navigator.pop(context),
                      _addContent("CheckList"),
                    },
                  ),
                ),

              ],
            ),
          );
        }
    );
  }
}