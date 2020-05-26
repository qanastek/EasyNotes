import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:intl/intl.dart';

typedef ContentCallback = void Function(Content item);

/// Stateful root of the APP
class ShowNote extends StatefulWidget {

  final Note item;

  final ContentCallback addItem;

  ShowNote({this.addItem, this.item});

  @override
  ShowNoteState createState() => ShowNoteState();
}

class ShowNoteState extends State<ShowNote> with SingleTickerProviderStateMixin {

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

    // Go back
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
            icon: (widget.item.favorite ? Icon(Icons.lock_outline) : Icon(Icons.lock_open)),
            color: MyColors.CUSTOM_RED,
            onPressed: () {
              /// TODO: Open password modal
              this.like();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 15,
            left: 30,
            right: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              /// Title
              Text(
                widget.item.title.substring(0,1).toUpperCase() + widget.item.title.substring(1),
                style: TextStyle(
                  color: Color(0xFFF2A8AB),
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                ),
              ),

              /// Date expired
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  DateFormat.yMMMd().format(widget.item.creationDate),
                  style: TextStyle(
                    color: Color(0xFFDDBFB8),
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),

              /// Content
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  widget.item.description,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFFDEC1BA),
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}