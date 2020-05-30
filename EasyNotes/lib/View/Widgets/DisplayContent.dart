
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonecall/Models/CheckList.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Folder.dart';
import 'package:phonecall/Models/Note.dart';
import 'package:phonecall/Models/Setting/AppSettings.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'package:phonecall/View/Widgets/PasswordScreen.dart';
import 'package:phonecall/View/Widgets/ShowNote.dart';
import 'package:provider/provider.dart';
import 'package:phonecall/View/Widgets/AddNote.dart';
import 'package:dotted_border/dotted_border.dart';

typedef ContentDeleteCallback = void Function(Content item);
typedef CheckListShowCallback = void Function(BuildContext context, Content item);
typedef InsideCallback = void Function(Folder notes);

class DisplayContent extends StatefulWidget {

  final Folder notes;
  final ContentDeleteCallback removeContent;
  final ContentDeleteCallback likeContent;
  final ContentDeleteCallback addItem;
  final CheckListShowCallback showAddTodoListModal;
  final InsideCallback inside;
  final ContentDeleteCallback delete;
  final ContentDeleteCallback erase;
  final ContentDeleteCallback restore;

  DisplayContent({this.notes, this.removeContent, this.likeContent, this.addItem, this.showAddTodoListModal, this.inside, this.delete, this.restore, this.erase});

  @override
  DisplayContentState createState() => DisplayContentState();

}

class DisplayContentState extends State<DisplayContent> with SingleTickerProviderStateMixin {

  bool _dropAreaStatus = false;

  TextEditingController searchBarController = new TextEditingController();
  String filter;

  toggleDropArea() {
    setState(() {
      this._dropAreaStatus = !this._dropAreaStatus;
    });
  }

  @override
  void initState() {

    /// When typing in the searchBar
    searchBarController.addListener(() {
      setState(() {
        filter = searchBarController.text;
      });
    });
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final _dropKey = GlobalKey<FormState>();
    final _dropKeyDelete = GlobalKey<FormState>();

    return Column(
      children: <Widget>[

        /// Drop area archived
        Visibility(
          visible: _dropAreaStatus,
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: (widget.notes.mode == AppSettings.ARCHIVED) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
              children: <Widget>[

                /// Delete
                Visibility(
                  visible: _dropAreaStatus && (widget.notes.mode == AppSettings.ARCHIVED),
                  child:  DragTarget<Content>(
                    key: _dropKeyDelete,
                    onWillAccept: (data) => data is Content,
                    onAccept: (data) {

                      /// Delete the item for ever
                      widget.erase(data);

                    },
                    onLeave: (data) {
                      print("Do nothing!");
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                          bottom: 0,
                        ),
                        child: DottedBorder(
                          color: MyColors.CUSTOM_RED,
                          dashPattern: [8, 4],
                          strokeWidth: 2,
                          borderType: BorderType.Circle,
                          child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(500),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.delete,
                                    color: MyColors.CUSTOM_RED,
                                  ),
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ),

                /// Restore
                Visibility(
                  visible: _dropAreaStatus,
                  child: DragTarget<Content>(
                    key: _dropKey,
                    onWillAccept: (data) => data is Content,
                    onAccept: (data) {

                      if(widget.notes.mode == AppSettings.ARCHIVED) {

                        /// Delete the item
                        widget.restore(data);

                      } else {

                        /// Delete the item
                        widget.delete(data);
                      }
                    },
                    onLeave: (data) {
                      print("Do nothing!");
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 40,
                          bottom: 0,
                        ),
                        child: DottedBorder(
                          color: MyColors.CUSTOM_RED,
                          dashPattern: [8, 4],
                          strokeWidth: 2,
                          borderType: BorderType.Circle,
                          child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(500),
                                ),
                                child: Center(
                                  child: Icon(
                                    widget.notes.mode == AppSettings.ARCHIVED ? Icons.restore_from_trash : Icons.delete,
                                    color: MyColors.CUSTOM_RED,
                                  ),
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),

        /// SearchBar
        Container(
          margin: EdgeInsets.only(
            left: 0,
            right: 0,
            top: 40,
            bottom: 0,
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 0,
            bottom: 0,
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
                color: Colors.grey.withOpacity(0.10),
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
                  controller: searchBarController,
                  style: TextStyle(
                    color: MyColors.CUSTOM_RED,
                  ),
                  cursorColor: MyColors.CUSTOM_RED.withOpacity(0.75),
                  decoration: InputDecoration(
                    hintText: "Search for a note...",
                    hintStyle: TextStyle(
                      fontSize: 23,
                      color: MyColors.CUSTOM_RED.withOpacity(0.50),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              /// Add
              IconButton(
                alignment: Alignment.center,
                onPressed: () {

                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: MyColors.CUSTOM_RED,
                ),
                padding: EdgeInsets.all(15),
              ),

            ],
          ),
        ),

        /// Grid view
        Expanded(
          child: GridView.count(
            // Row width
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            padding: const EdgeInsets.only(
              top: 20,
            ),
            // Generate 100 widgets that display their index in the List.
            children: List.generate(widget.notes.contentLengthFiltered(filter), (index) {

              /// Current element
              Content item = widget.notes.getFiltered(filter,index);

              /// Return the card for the Content
              return Draggable<Content>(
                data: item,
                child: GestureDetector(
                  onTap: () {
                    this.clickContent(item);
                  },
                  child: GridTile(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      elevation: 1.5,
                      child: Column(
                        children: <Widget>[

                          /// Icon
                          Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              bottom: 10,
                            ),
                            decoration: new BoxDecoration(
                                color: item.getColor(),
                                borderRadius: new BorderRadius.all(Radius.circular(50))
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Icon(
                              item.getIcon(),
                              color: item.getIconColor(),
                              size: 25,
                            ),
                          ),

                          /// Title
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: 5,
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                item.getTitle(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.CUSTOM_RED,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1,1),
                                      blurRadius: 5,
                                      color: Color.fromARGB(50, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// Description
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 10,
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                item.getDescription(),
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: MyColors.CUSTOM_RED,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1,1),
                                      blurRadius: 5,
                                      color: Color.fromARGB(50, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                    ),
                  ),
                ),
                feedback: GridTile(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    elevation: 1.5,
                    child: Column(
                      children: <Widget>[

                        /// Icon
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                          ),
                          decoration: new BoxDecoration(
                              color: item.getColor(),
                              borderRadius: new BorderRadius.all(Radius.circular(50))
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Icon(
                            item.getIcon(),
                            color: Colors.white,
                            size: 25,
                          ),
                        ),

                        /// Title
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 5,
                          ),
                          child: Flexible(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                item.getTitle(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(
                                  backgroundColor: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: MyColors.CUSTOM_RED,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1,1),
                                      blurRadius: 5,
                                      color: Color.fromARGB(50, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Description
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              item.getDescription(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                backgroundColor: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: MyColors.CUSTOM_RED,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1,1),
                                    blurRadius: 5,
                                    color: Color.fromARGB(50, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                  ),
                ),
                childWhenDragging: GridTile(
                  child: Card(
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    elevation: 0,
                    child: Column(
                      children: <Widget>[

                        /// Icon
                        Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                          ),
                          decoration: new BoxDecoration(
                              color: item.getColor().withOpacity(0.5),
                              borderRadius: new BorderRadius.all(Radius.circular(50))
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Icon(
                            item.getIcon(),
                            color: Colors.white,
                            size: 25,
                          ),
                        ),

                        /// Title
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 5,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              item.getTitle(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                              style: TextStyle(
                                backgroundColor: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: MyColors.CUSTOM_RED,
                              ),
                            ),
                          ),
                        ),

                        /// Description
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              item.getDescription(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                backgroundColor: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: MyColors.CUSTOM_RED,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1,1),
                                    blurRadius: 5,
                                    color: Color.fromARGB(50, 0, 0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                  ),
                ),
                onDragStarted: () {
                  /// Show
                  toggleDropArea();
                },
                onDragEnd: (details) {
                  /// Hide
                  toggleDropArea();
                },
                maxSimultaneousDrags: 1,
                affinity: Axis.horizontal,
              );

            }),
          ),
        ),

      ],
    );
  }

  void clickContent(Content item) async {
    /// Note
    if(item is Note) {

//                      Navigator.push(context,MaterialPageRoute(builder: (context) => PasswordScreen(
//                        item: item,
//                        callback: Builder(
//                          builder: (context) {
//                            return ShowNote(
//                              addItem: widget.addItem,
//                              removeItem: widget.removeContent,
//                              item: item,
//                              likeItem: widget.likeContent,
//                            );
//                          },
//                        ),
//                      )));

      final response = await Navigator.push(context,MaterialPageRoute(builder: (context) => PasswordScreen(
        password: item.password,
      )));

      print("----------");
      print(response);

      /// Password screen
      if(response == PasswordScreen.RESULT_OK) {

        /// Open the item view
        Navigator.push(context,MaterialPageRoute(builder: (context) => ShowNote(
          addItem: widget.addItem,
          removeItem: widget.removeContent,
          item: item,
          likeItem: widget.likeContent,
        )));

      }
    }
    /// TodoList
    else if(item is CheckList) {

      /// Open the item view
      widget.showAddTodoListModal(
          context,
          item
      );

    }
    /// Folder
    else if(item is Folder) {

      /// Open the item view
      widget.inside(item);

    }
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