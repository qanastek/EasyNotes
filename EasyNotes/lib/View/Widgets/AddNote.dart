import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';

typedef ContentCallback = void Function(Content item);

/// Stateful root of the APP
class AddNote extends StatefulWidget {

  final Note item;

  final ContentCallback addItem;

  AddNote({this.addItem, this.item});

  @override
  AddNoteState createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  // Current Note
//  Note item = Note("",false,false,null,"",Colors.greenAccent);

  // Controllers
  final titleText = TextEditingController();
  final descriptionText = TextEditingController();

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

  /// Pick the date/time of the remainder
  void remainder() {

    print(widget.item.expiredDate);

    setState(() {

      /// If empty get the date
      if(widget.item.expiredDate == null) {

        /// TODO: Open remainder modal and collect the value.

        /// Open the modal
        showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {

            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      color: MyColors.CUSTOM_RED,
                    ),
                  ),
                  primaryColor: MyColors.CUSTOM_RED,
                  primaryContrastingColor: MyColors.CUSTOM_RED,
                  scaffoldBackgroundColor: MyColors.CUSTOM_RED,
                  barBackgroundColor: MyColors.CUSTOM_RED,
                  brightness: Brightness.light,
                ),
                child: CupertinoDatePicker(
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      widget.item.expiredDate = newDate;
                    });
                  },
                  initialDateTime: DateTime.now().add(Duration(minutes: 1)),
                  use24hFormat: true,
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime.now().add(Duration(days: 365*30)),
                  minimumYear: DateTime.now().year,
                  maximumYear: DateTime.now().year+20,
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.dateAndTime,
                  backgroundColor: CupertinoColors.white,
                ),
              ),
            );
          }
        );

      } else {
        widget.item.expiredDate = null;
      }
    });
  }

  void changeColor(Color color) {
    setState(() {
      widget.item.color = color;
    });
  }

  /// Save
  void save() {

    print(titleText.text);
    widget.item.title = titleText.text;

    print(descriptionText.text);
    widget.item.description = descriptionText.text;

    print("Item color: ");
    print(widget.item.color.toString());

    // Add the item
    widget.addItem(widget.item);

    // Change edition date
    widget.item.editDate = DateTime.now();

    // Go back
    Navigator.pop(context);
    Navigator.pop(context);

    // Display a snackBar
//                    Scaffold.of(context)
//                    .showSnackBar(SnackBar(content: Text('Saved!')));

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

          /// Clock
          IconButton(
            icon: (widget.item.expiredDate != null ? Icon(Icons.alarm) : Icon(Icons.add_alarm)),
            color: MyColors.CUSTOM_RED,
            onPressed: () {
              this.remainder();
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 15,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              /// Title
              Container(
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
                    hintText: "Title...",
                    hintStyle: TextStyle(
                      fontSize: 23,
                      color: Colors.pinkAccent[100],
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Title...';
                    }
                    return null;
                  },
                ),
              ),

              /// Content
              Expanded(
                child:
                Container(
                  margin: EdgeInsets.only(
                    top: 25,
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
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: descriptionText,
                    decoration: InputDecoration(
                      hintText: "Write yours ideas here...",
                      hintStyle: TextStyle(
                        fontSize: 23,
                        color: Colors.pinkAccent[100],
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Write yours ideas here...';
                      }
                      return null;
                    },
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

                        /// Cancel
                        this.destroy();
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
                          this.save();
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
        ),
      ),
    );
  }
}