import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:intl/intl.dart';
import 'package:phonecall/View/Widgets/AddNote.dart';

typedef ContentCallback = void Function(Content item);

/// Stateful root of the APP
class ShowNote extends StatefulWidget {

  final Note item;

  final ContentCallback addItem;
  final ContentCallback removeItem;
  final ContentCallback likeItem;

  ShowNote({this.addItem, this.removeItem, this.likeItem, this.item});

  @override
  ShowNoteState createState() => ShowNoteState();
}

class ShowNoteState extends State<ShowNote> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

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

      // Delete the item
      widget.removeItem(widget.item);

      // Go back
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

          /// Bookmark
          IconButton(
            icon: (widget.item.favorite ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border)),
            color: MyColors.CUSTOM_RED,
            onPressed: () {
              this.like();
            },
          ),

          /// Share
          IconButton(
            icon: Icon(AddIcons.plane, color: MyColors.CUSTOM_RED,),
            color: MyColors.CUSTOM_RED,
            onPressed: () {
              widget.item.share(context);
            },
          ),

          /// Edit
          IconButton(
            icon: (Icon(Icons.edit,color: MyColors.CUSTOM_RED,)),
            onPressed: () {

              // Go edit activity
              Navigator.push(context,MaterialPageRoute(builder: (context) => AddNote(
                addItem: widget.addItem,
                item: widget.item,
              )));
            },
          ),

          /// Delete
          IconButton(
            icon: (Icon(Icons.delete_outline, color: MyColors.CUSTOM_RED,)),
            onPressed: () {
              this.destroy();
            },
          ),

        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
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
              SelectableText(
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
                child: SelectableText(
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
                child: SelectableText(
                  widget.item.description,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFFDEC1BA),
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                  ),
                  cursorColor: MyColors.CUSTOM_RED,
                  cursorWidth: 3,
                  showCursor: true,
                  scrollPhysics: BouncingScrollPhysics(),
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    cut: false,
                    paste: false,
                    selectAll: true,
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