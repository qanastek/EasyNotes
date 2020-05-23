
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Notes.dart';
import 'package:provider/provider.dart';

typedef ContentDeleteCallback = void Function(Content item);

class NotesWidget extends StatelessWidget {

  final ContentDeleteCallback removeContent;
  final ContentDeleteCallback likeContent;

  NotesWidget({this.removeContent, this.likeContent});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: Provider.of<Notes>(context, listen: false).lenght, // How many elements
      itemBuilder: (BuildContext ctxt, int index) {

        /// The current item and list of notes
        Notes notes = Provider.of<Notes>(context, listen: false);
        Content item = notes.get(index);

        return Dismissible(
          key: ValueKey("item_$index"),
          direction: DismissDirection.horizontal,
          movementDuration: Duration(milliseconds: 300),

          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),

          // ignore: missing_return
          confirmDismiss: (direction) async {

            // Delete
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
            } else {
              // TODO: Navigate to edit page;
            }
          },

          child: ListTile(
            title: Text(
                item.title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20
                )
            ),
            subtitle: Text(item.description),
            leading: Icon(
                item.icon,
                color: item.color
            ),
            trailing: IconButton(
                icon: (item.favorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
                color: Colors.red[500],
                onPressed: () {
                  this.likeContent(item);
                },
            ),
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