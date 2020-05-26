
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:phonecall/Notes.dart';
import 'package:phonecall/View/Widgets/ShowNote.dart';
import 'package:provider/provider.dart';
import 'package:phonecall/View/Widgets/AddNote.dart';

typedef ContentDeleteCallback = void Function(Content item);

class NotesWidget extends StatelessWidget {

  final ContentDeleteCallback removeContent;
  final ContentDeleteCallback likeContent;
  final ContentDeleteCallback addItem;

  NotesWidget({this.removeContent, this.likeContent, this.addItem});

  @override
  Widget build(BuildContext context) {

    /// Build all the items elements
    return ListView.builder(
      itemCount: Provider.of<Notes>(context, listen: false).length, // How many elements
      itemBuilder: (BuildContext ctxt, int index) {

        /// The current item and list of notes
        Notes notes = Provider.of<Notes>(context, listen: false);
        Content item = notes.get(index);

        /// Slide left and right
        return Dismissible(
          key: ValueKey("item_$index"),
          direction: DismissDirection.horizontal,
          movementDuration: Duration(milliseconds: 300),

          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),

          // ignore: missing_return
          confirmDismiss: (direction) async {

            /// Delete
            if (direction == DismissDirection.endToStart) {

              final bool res = await showDialog(
                  context: context,
                  builder: (BuildContext context) {

                    return AlertDialog(
                      content: Text(
                          "Are you sure you want to delete ${item.title}?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {

                            // Delete the item
                            removeContent(item);

                            // Show a snackbar
//                            Scaffold
//                            .of(context)
//                            .showSnackBar(SnackBar(content: Text("${item.title} archived!")));

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              return res;

            }
            /// TODO: Modify
            else {

              // Edit Note
              if(item is Note) {

                // Go edit activity
                Navigator.push(context,MaterialPageRoute(builder: (context) => AddNote(
                  addItem: addItem,
                  item: item,
                )));
              }
              // Edit Folder
              else if(item is Folder) {

                print("Folder");
              }
              // Edit TodoList
              else if(item is CheckList) {

                print("TodoList");
              }

            }
          },

          /// Item element
          child: ListTile(

            /// Title
            title: Text(
                item.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                )
            ),

            /// SubTitle
            subtitle: Text(
              item.description,
              overflow: TextOverflow.ellipsis,
            ),

            /// Leading icon
            leading: Icon(
                item.icon,
                color: item.color
            ),

            /// Back icon
            trailing: IconButton(
                icon: (item.favorite ? Icon(Icons.bookmark, color: MyColors.CUSTOM_RED,) : Icon(Icons.bookmark_border, color: MyColors.CUSTOM_RED)),
                color: Colors.red[500],
                onPressed: () {
                  this.likeContent(item);
                },
            ),

            /// OnClick
            onTap: () {

              /// Note
              if(item is Note) {

                /// Open the item view
                Navigator.push(context,MaterialPageRoute(builder: (context) => ShowNote(
                  addItem: addItem,
                  item: item,
                )));
              }

              /// TodoList
              else if(item is CheckList) {

                /// Open the item view
                /// TODO: Add view here
              }

              /// Folder
              else if(item is Folder) {

                /// Open the item view
                /// TODO: Add view here
              }

            },

          )
        );
      }
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.archive,
            color: Colors.white,
          ),
          Text(
            " Archive",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}