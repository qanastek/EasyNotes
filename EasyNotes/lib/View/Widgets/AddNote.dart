import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

typedef ContentCallback = void Function(Content item);

/// Stateful root of the APP
class AddNote extends StatefulWidget {

  final ContentCallback addItem;

  AddNote({this.addItem});

  @override
  AddNoteState createState() => AddNoteState();
}

class AddNoteState extends State<AddNote> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();

  // Current Note
  Note item = Note("",false,false,null,"",Colors.greenAccent);

  // Controllers
  final titleText = TextEditingController();
  final descriptionText = TextEditingController();

  /// Like/Dislike
  void like() {
    setState(() {
      item.favorite = !item.favorite;
    });
  }

  /// Destroy the current note
  void destroy() {
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    titleText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  void changeColor(Color color) {
    setState(() {
      item.color = color;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
//        title: Text("Add Note"),
        actions: <Widget>[

          IconButton(
            icon: (item.favorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border)),
            color: Colors.red[500],
            onPressed: () {
              this.like();
            },
          ),

          IconButton(
            icon: (Icon(Icons.color_lens)),
            color: item.color != null ? item.color : Colors.white70,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select a color'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: item.color,
                        onColorChanged: (color) {
                          changeColor(color);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),

          IconButton(
            icon: (Icon(Icons.delete_outline)),
            onPressed: () {
              this.destroy();
            },
          ),

        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            TextFormField(
              controller: titleText,
              decoration: InputDecoration(
                  hintText: "Title"
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the title';
                }
                return null;
              },
            ),

            TextFormField(
              controller: descriptionText,
              decoration: InputDecoration(
                  hintText: "Content"
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the content';
                }
                return null;
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {

                  // Check if valid
                  if (_formKey.currentState.validate()) {

                    print(titleText.text);
                    item.title = titleText.text;

                    print(descriptionText.text);
                    item.description = descriptionText.text;

                    print("Item color: ");
                    print(item.color.toString());

                    // Add the item
                    widget.addItem(item);

                    // Display a snackBar
//                    Scaffold.of(context)
//                    .showSnackBar(SnackBar(content: Text('Saved!')));
                  }
                },
                child: Text('Save'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}