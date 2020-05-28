import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/CheckBox.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:phonecall/Notes.dart';
import 'package:phonecall/View/Widgets/FloatingMenu.dart';
import 'package:phonecall/View/Widgets/DisplayContent.dart';
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

  // Current display mode
  String _mode = "normal";

  // All the notes (ChangeNotifier)
  Notes notes = Notes();

  /// Constructor
  MyHomePageState() {
    /// Fill up the data
    notes.fillUp();
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

  /// Override the default handling of the back button
  Future<bool> _onBackPressed() {

    /// If have ancestor
    if(notes.parent != null) {

      /// Go to them
      _inside(notes.parent);
    }
    else {
      print("No ancestor");
      print(notes.length);
      print(notes.parent);
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
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: DisplayContent(
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
                  showAddTodoListModal(context,item);
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
                    child: Icon(Icons.collections_bookmark),
                  ),
                ),

                /// Garbage
                IconButton(
                  onPressed: () {
                    print("Garbage");
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
                    child: Icon(Icons.restore_from_trash),
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
                      Navigator.pop(context),
                      showAddTodoListModal(
                        context,
                          CheckList(
                              "",
                              false,
                              false,
                              null,
                              "",
                              Colors.primaries[new Random().nextInt(Colors.primaries.length-1)]
                          )
                      ),
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
        Colors.primaries[Random().nextInt(Colors.primaries.length-1)]
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
            child: new Wrap(
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
                        color: Colors.pinkAccent[100],
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Folder title...';
                      }
                      return null;
                    },
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

                            /// Print title
                            print(titleText.text);

                            /// Set title
                            folder.title = titleText.text;

                            /// Add item
                            _addItem(folder);

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
                              'CREATE',
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
          );
        }
    );
  }

  /// Display the add TodoList modal
  void showAddTodoListModal(context, CheckList todoList) {

    // Check empty
    if(todoList == null) return;

    final _formKeyTodoList = GlobalKey<FormState>();
    final _formKeyTodoListInsertion = GlobalKey<FormState>();

    final titleTextTodoList = TextEditingController();
    final currentElementTextTodoList = TextEditingController();

    /// Fill up the fields
    titleTextTodoList.text = todoList.title;

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc){
          return Form(
            key: _formKeyTodoList,
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
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
                    controller: titleTextTodoList,
                    decoration: InputDecoration(
                      hintText: "Folder title...",
                      hintStyle: TextStyle(
                        fontSize: 23,
                        color: Colors.pinkAccent[100],
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Folder title...';
                      }
                      return null;
                    },
                  ),
                ),

                /// CheckBoxes
                Flexible(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return ListView.builder(
                          itemCount: todoList.checkboxes.length, // How many elements
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Theme(
                              data: ThemeData(
                                primaryColor: MyColors.CUSTOM_RED,
                                unselectedWidgetColor: MyColors.CUSTOM_RED,
                                backgroundColor: Colors.white,
                              ),
                              child: CheckboxListTile(
                                title: Text(
                                  todoList.checkboxes[index].title.substring(0,1).toUpperCase() + todoList.checkboxes[index].title.substring(1),
                                  style: TextStyle(
                                    color: Color(0xFFFF8C8E),
                                    fontSize: 20,
                                  ),
                                ),
                                value: todoList.checkboxes[index].checked,
                                controlAffinity: ListTileControlAffinity.leading,
                                checkColor: Colors.white,
                                activeColor: MyColors.CUSTOM_RED,
                                onChanged: (bool value) {
                                  setState(() {
                                    todoList.checkboxes[index].checked = value;
                                  });
                                },
                              ),
                            );
                          }
                      );
                    },
                  ),
                ),

                /// Add element
                Form(
                  key: _formKeyTodoListInsertion,
                  child: Container(
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
                    child: Row(
                      children: <Widget>[

                        /// Current element field
                        Flexible(
                          child: TextFormField(
                            controller: currentElementTextTodoList,
                            decoration: InputDecoration(
                              hintText: "Add element...",
                              hintStyle: TextStyle(
                                fontSize: 23,
                                color: Colors.pinkAccent[100],
                              ),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Add element...';
                              }
                              return null;
                            },
                          ),
                        ),

                        /// Add
                        IconButton(
                          alignment: Alignment.center,
                          onPressed: () {

                            /// Check if the field is filled up
                            if (_formKeyTodoListInsertion.currentState.validate()) {

                              setState(() {

                                // Add Checkbox
                                todoList.checkboxes.add(CheckBox(
                                  currentElementTextTodoList.text,
                                  false,
                                ));

                              });

                              print(currentElementTextTodoList.text);
                              print(todoList.checkboxes);
                            }

                          },
                          icon: Icon(
                            Icons.add,
                            size: 30,
                            color: MyColors.CUSTOM_RED,
                          ),
                          padding: EdgeInsets.all(15),
                        ),

                      ],
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
                          if (_formKeyTodoList.currentState.validate()) {

                            /// Print title
                            print(titleTextTodoList.text);

                            /// Add item
                            setState(() {

                              /// Set title
                              todoList.title = titleTextTodoList.text;

                              /// Insertion
                              _addItem(todoList);
                            });

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
                              'CREATE',
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
          );
        }
    );
  }

}