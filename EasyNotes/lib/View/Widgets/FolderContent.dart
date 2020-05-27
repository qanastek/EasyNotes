//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:phonecall/Models/Content.dart';
//import 'package:phonecall/Notes.dart';
//import 'package:phonecall/View/Widgets/NotesWidget.dart';
//
//typedef ContentDeleteCallback = void Function(Content item);
//typedef CheckListShowCallback = void Function(BuildContext context, Content item);
//
///// Stateful root of the APP
//class FolderContent extends StatefulWidget {
//
//  final Notes notes;
//  final ContentDeleteCallback removeContent;
//  final ContentDeleteCallback likeContent;
//  final ContentDeleteCallback addItem;
//  final CheckListShowCallback showAddTodoListModal;
//
//  FolderContent({this.notes, this.removeContent, this.likeContent, this.addItem, this.showAddTodoListModal});
//
//  @override
//  FolderContentState createState() => FolderContentState();
//}
//
//class FolderContentState extends State<FolderContent> with SingleTickerProviderStateMixin {
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: DisplayContent(
//        notes: notes,
//        addItem: (Content item) {
//          setState(() {
//            addItem(item);
//          });
//        },
//        removeContent: (Content item) {
//          setState(() {
//            removeContent(item);
//          });
//        },
//        likeContent: (Content item) {
//          setState(() {
//            likeContent(item);
//          });
//        },
//        showAddTodoListModal: (context,Content item) {
//          setState(() {
//            showAddTodoListModal(context,item);
//          });
//        },
//      ),
//    );
//  }
//}