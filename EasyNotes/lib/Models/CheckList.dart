import 'package:flutter/material.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/CheckBox.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:share/share.dart';

class CheckList extends Content {

  List<CheckBox> checkboxes;

  CheckList(title,favorite,secured,password,description,color): super(title, favorite, secured, password, description, Icons.format_list_bulleted,color) {
    this.checkboxes = List<CheckBox>();
  }

  @override
  String getDescription() {

    // Check if it's secured
    if(secured == true) {
      return "Secured todo list";
    }

    // How many done ?
    int counterDone = this.checkboxes.where((cb) => cb.checked == true).toList().length;

    return "$counterDone of ${this.checkboxes.length} tasks done";
  }

  @override
  IconData getIcon() {

    // Check if it's secured
    if(secured == true) {
      return AddIcons.lock;
    }

    return AddIcons.checklist;
  }

  /// Share the Content
  @override
  void share(BuildContext context) {

    final RenderBox box = context.findRenderObject();

    String mailContent = "${this.title} \n\n";

    this.checkboxes.forEach((cb) {
      mailContent += cb.checked ? "✔️" : "❌";
      mailContent += "\t ${cb.title} \n\n";
    });

    Share.share(
      mailContent,
      subject: this.title,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}