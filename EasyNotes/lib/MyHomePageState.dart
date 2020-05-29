import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:phonecall/Models/Setting/AppSettings.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:phonecall/Notes.dart';
import 'package:phonecall/View/Widgets/AddCheckList.dart';
import 'package:phonecall/View/Widgets/DisplayContent.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:phonecall/View/Widgets/AddNote.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// Stateful root of the APP
class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

/// Add a state to the root widget
class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int counter = 0;

  // Counter
  Future<int> _counter;

  // Current display mode
  String _mode = "normal";

  // All the notes (ChangeNotifier)
  Notes notes = Notes();

  /// Constructor
  MyHomePageState() {
    /// Fill up the data
    notes.fillUp();
  }

  Future<void> _incrementCounter() async {

    final SharedPreferences prefs = await _prefs;

    counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  void _likeContent(Content item) {
    setState(() {
      item.favorite = !item.favorite;
    });
  }

  void _inside(Notes n) {
    setState(() {
      notes = n;
    });
  }

  void _delete(Content item) {
    setState(() {
      notes.remove(item);
    });
  }

  void _restore(Content item) {
    setState(() {
      notes.restore(item);
    });
  }

  void _removeContent(Content item) {
    setState(() {
      notes.remove(item);
    });
  }

  void _eraseContent(Content item) {
    setState(() {
      notes.erase(item);
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

  void _changeMode(String newMode) {
    setState(() {
      notes.mode = newMode;
    });
  }

  /// Override the default handling of the back button
  Future<bool> _onBackPressed() {

    /// If have ancestor
    if(notes.parent != null) {

      /// Go to them
      _inside(notes.parent);
    }
  }

  /// The refresh method for the main page
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => notes,
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(

          /// Main background color
          backgroundColor: Color(0xFFFEEBDF),

//        drawer: SideMenu(),

          /// Body
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFFFECE0),Color(0xFFF6E4D8)],
              ),
            ),
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 0,
              left: 20,
              right: 20,
            ),
            child: notes.contentLength <= 0 ? displayEmpty() : DisplayContent(
              notes: notes,
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
              showAddTodoListModal: (context,Content item) {
                setState(() {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => AddCheckList(
                    addItem: _addItem,
                    item: item,
                  )));
                });
              },
              inside: (Notes notes) {
                setState(() {
                  _inside(notes);
                });
              },
              delete: (Content item) {
                setState(() {
                  _delete(item);
                });
              },
              restore: (Content item) {
                setState(() {
                  _restore(item);
                });
              },
              erase: (Content item) {
                setState(() {
                  _eraseContent(item);
                });
              },
            ),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          /// NavigationBar
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.white,
            notchMargin: -5.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                /// Bookmarks
                IconButton(
                  onPressed: () {
                    print("Bookmarks");
                    if(notes.mode == AppSettings.BOOKMARKS) {
                      this._changeMode(AppSettings.DEFAULT);
                    } else {
                      this._changeMode(AppSettings.BOOKMARKS);
                    }
                  },
                  icon: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return ui.Gradient.linear(
                        Offset(4.0, 24.0),
                        Offset(24.0, 4.0),
                        [Color(0xFFE58981), Color(0xFFF8D6B2)],
                      );
                    },
                    child: notes.mode == AppSettings.BOOKMARKS ? Icon(Icons.format_list_bulleted) : Icon(Icons.collections_bookmark),
                  ),
                ),

                /// Archived
                IconButton(
                  onPressed: () {
                    print("Archived");
                    if(notes.mode == AppSettings.ARCHIVED) {
                      this._changeMode(AppSettings.DEFAULT);
                    } else {
                      this._changeMode(AppSettings.ARCHIVED);
                    }
                  },
                  icon: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return ui.Gradient.linear(
                        Offset(4.0, 24.0),
                        Offset(24.0, 4.0),
                        [Color(0xFFE58981), Color(0xFFF8D6B2)],
                      );
                    },
                    child: notes.mode == AppSettings.ARCHIVED ? Icon(Icons.format_list_bulleted) : Icon(Icons.restore_from_trash),
                  ),
                ),

              ],
            ),
          ),

          /// Floating menu centered
          floatingActionButton: Container(
            width: 70.0,
            height: 70.0,
            margin: const EdgeInsets.all(15),
            child: ClipOval(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xFFF8D6B2), Color(0xFFE58981)])
                ),
                child: IconButton(
                  onPressed: () {
                    print("open");
                    showAddModal(context);
                  },
                  icon: Icon(
                      Icons.add
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ),

          /// Floating menu right
//        floatingActionButton: FloatingMenu(
//          addContent: (String name) {
//            setState(() {
//              _addContent(name);
//            });
//          },
//          addItem: (Content item) {
//            setState(() {
//              _addItem(item);
//            });
//          },
//        ),


        ),
      ),
    );
  }

  Column displayEmpty() {

    AssetImage blankImage;
    String blankImageDescription;

    /// Define the empty illustration
    if (notes.mode == AppSettings.ARCHIVED) {

      blankImage = AssetImage('images/empty.png');
      blankImageDescription = "No archive found !";

    } else if (notes.mode == AppSettings.BOOKMARKS) {

      blankImage = AssetImage('images/empty2.png');
      blankImageDescription = "No bookmarks found !";

    } else {
      blankImage = AssetImage('images/empty1.png');
      blankImageDescription = "No content found !";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: blankImage,
              repeat: ImageRepeat.noRepeat,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.65,
            ),
          ],
        ),

        SizedBox(height: 25),

        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                blankImageDescription,
                style: TextStyle(
                  color: Color(0xFF3F3D56),
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ],
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
                    /// OnCLick
                    onTap: () => {
                      Navigator.pop(context),
                      showAddFolderModal(context),
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
                      Navigator.push(context,MaterialPageRoute(builder: (context) => AddCheckList(
                        addItem: _addItem,
                        item: CheckList(
                            "",
                            false,
                            false,
                            null,
                            "",
                            Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
                        ),
                      ))),
                    },
                  ),
                ),

              ],
            ),
          );
        }
    );
  }

  /// Display the add folder modal
  void showAddFolderModal(context) {

    final _formKey = GlobalKey<FormState>();

    final titleText = TextEditingController();

    /// Current folder
    Folder folder = Folder(
        null,
        false,
        false,
        null,
        "No description",
        MyColors.randomColor()
    );

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc){
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                spacing: 20,
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

                  /// Colors palette
                  Container(
                    height: 55,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 2,
                      ),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: BlockPicker(
                        layoutBuilder: (context, colors, child) {

                          Orientation orientation = MediaQuery.of(context).orientation;

                          return Container(
                            width: orientation == Orientation.portrait ? 340.0 : 300.0,
                            height: orientation == Orientation.portrait ? 360.0 : 200.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: colors.map((Color color) => child(color)).toList(),
                            ),
                          );
                        },
                        availableColors: MyColors.COLORS_PALLETTE,
                        pickerColor: folder.color,
                        onColorChanged: (color) {
                          setState(() {
                            folder.color = color;
                          });
                        },
                      ),
                    ),
                  ),

                  /// Title
                  Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 10,
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
                    child: TextFormField(
                      controller: titleText,
                      decoration: InputDecoration(
                        hintText: "Folder title...",
                        hintStyle: TextStyle(
                          fontSize: 23,
                          color: MyColors.CUSTOM_RED.withOpacity(0.50),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  /// Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      /// Cancel
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xfffb6c72), Color(0xffff988d)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(50.0)
                            ),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'CANCEL',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Create
                      Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: RaisedButton(
                          onPressed: () {

                            // Check if valid
                            if (_formKey.currentState.validate()) {

                              /// Set title
                              folder.title = titleText.text.isEmpty ? "New folder $counter" : titleText.text;

                              /// Add item
                              _addItem(folder);

                              /// Increase counter of folders
                              _incrementCounter();

                              /// Go back
                              Navigator.pop(context);
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xff69d9cc), Color(0xff50ff8c)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(50.0)
                            ),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          );
        }
    );
  }

}