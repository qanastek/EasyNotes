import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/CheckBox.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';

typedef ContentCallback = void Function(Content item);

/// Stateful root of the APP
class AddCheckList extends StatefulWidget {

  final CheckList item;

  final ContentCallback addItem;

  AddCheckList({this.addItem, this.item});

  @override
  AddCheckListState createState() => AddCheckListState();
}

class AddCheckListState extends State<AddCheckList> with SingleTickerProviderStateMixin {

  final _formKeyTodoList = GlobalKey<FormState>();

  // Controllers
  final titleText = TextEditingController();
  final descriptionText = TextEditingController();

  final titleTextTodoList = TextEditingController();
  final currentElementTextTodoList = TextEditingController();

  final _formKeyTodoListInsertion = GlobalKey<FormState>();

  /// Like/Dislike
  void like() {
    setState(() {
      widget.item.favorite = !widget.item.favorite;
    });
  }
  /// Secure the content
  void secure() {
    setState(() {
      widget.item.secured = !widget.item.secured;
    });
  }

  /// Destroy the current note
  void destroy() {
    setState(() {
      Navigator.pop(context);
    });
  }

  void changeColor(Color color) {
    setState(() {
      widget.item.color = color;
    });
  }

  /// Save
  void save() {

    widget.item.title = titleText.text;

    widget.item.description = descriptionText.text;

    // Add the item
    widget.addItem(widget.item);

    // Go back
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    titleText.text = widget.item.title;
    descriptionText.text = widget.item.description;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,

        /// Back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: MyColors.CUSTOM_RED),
          onPressed: () => Navigator.of(context).pop(),
        ),

        /// Others buttons
        actions: <Widget>[

          /// Choose color
          IconButton(
            icon: (FaIcon(FontAwesomeIcons.solidCircle)),
            color: widget.item.color != null ? widget.item.color : Colors.white70,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50)
                      ),
                    ),
                    content: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        textDirection: TextDirection.ltr,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          /// Title
                          Text(
                            'Colors',
                            style: TextStyle(
                              fontSize: 30,
                              color: MyColors.CUSTOM_RED,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          /// Colors palette
                          SingleChildScrollView(
                            padding: EdgeInsets.only(
                              top: 25,
                              bottom: 0,
                            ),
                            child: BlockPicker(
                              availableColors: MyColors.COLORS_PALLETTE,
                              pickerColor: widget.item.color,
                              onColorChanged: (color) {
                                changeColor(color);
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          /// Bookmark
          IconButton(
            icon: (widget.item.favorite ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border)),
            color: MyColors.CUSTOM_RED,
            onPressed: () {
              this.like();
            },
          ),

          /// Secure
          IconButton(
            icon: (widget.item.secured ? Icon(AddIcons.lock) : Icon(AddIcons.unlock)),
            color: MyColors.CUSTOM_RED,
            onPressed: () {
              /// TODO: Open password modal
              this.secure();
            },
          ),

          /// Cancel
          IconButton(
            icon: (Icon(Icons.delete_outline, color: MyColors.CUSTOM_RED,)),
            onPressed: () {
              this.destroy();
            },
          ),

          /// Save
          IconButton(
            icon: (Icon(Icons.check,color: Colors.green,)),
            onPressed: () {
              this.save();
            },
          ),

        ],
      ),
      body: handleChecklist(),
    );
  }

  /// CheckList view
  Form handleChecklist() {

    CheckList todoList = widget.item;

    /// Fill up the fields
    titleTextTodoList.text = todoList.title;

    return Form(
      key: _formKeyTodoList,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[

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
          StatefulBuilder(
            builder: (context, setState) {
              return Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
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
                            Expanded(
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

                                  currentElementTextTodoList.clear();
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

                  ],
                ),
              );
            },
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
                        widget.addItem(todoList);
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
    );
  }
}