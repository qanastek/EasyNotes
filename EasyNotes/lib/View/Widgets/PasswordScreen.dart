import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phonecall/Icons/add_icons_icons.dart';
import 'package:phonecall/Models/Content.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'dart:io';

class PasswordScreen extends StatefulWidget {

  static const String RESULT_OK = "OK";
  static const String RESULT_WRONG = "WRONG";

  final String password;

  PasswordScreen({this.password});

  @override
  PasswordScreenState createState() => PasswordScreenState();
}

class PasswordScreenState extends State<PasswordScreen> with SingleTickerProviderStateMixin {

  String currentPassword = "";

  /// Normal button
  Container keyBtn(Widget child) {

    return Container(
      alignment: Alignment.center,
//      margin: const EdgeInsets.only(
//        top: 20,
//        left: 18,
//        right: 18,
//        bottom: 10,
//      ),
      width: 60,
      height: 60,
      child: child,
    );
  }

  /// Validation dot
  Widget validationDot(int min) {

    Color color = Colors.black12;

    /// If is ON
    if(currentPassword.length >= min) {

      /// If same length
      if(currentPassword.length == widget.password.length) {

        /// Correct password
        if(currentPassword == widget.password) {

          color = MyColors.CUSTOM_GREEN;

          /// Return OK
          Navigator.pop(context,PasswordScreen.RESULT_OK);
        }
        /// Bad password
        else {
          color = Colors.redAccent;
        }

      } else {
        color = MyColors.CUSTOM_RED;
      }
    }

    return Icon(
      FontAwesomeIcons.solidCircle,
      size: 15,
      color: color,
    );
  }

  /// Digit button
  Container keyBtnDigit(String digit) {

    return keyBtn(
      FlatButton(
        onPressed: () {

          /// Check limit of chars
          if(this.currentPassword.length < 4) {

            /// Update the current entered password
            setState(() {
              this.currentPassword += digit;
            });
          }

        },
        child: Text(
          digit,
          style: TextStyle(
            color: MyColors.CUSTOM_RED,
            fontSize: 50,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {

    if(widget.password == null || widget.password == "") {

      print("widget.password");
      print(widget.password);

      /// Return OK
      Navigator.pop(context,PasswordScreen.RESULT_OK);
    }
  }

  @override
  Widget build(BuildContext context) {

    const double spaceRow = 40;

    return Scaffold(
      body: Container(
//        color: Colors.yellow,
        margin: const EdgeInsets.only(
          top: 75,
          bottom: 40,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            /// Logo & Info
            Container(
//              color: Colors.red,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  /// Logo
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: Icon(
                      currentPassword == widget.password ? AddIcons.unlock : AddIcons.lock,
                      color: MyColors.CUSTOM_RED,
                      size: 60,
                    ),
                  ),

                  /// Sentence
                  Text(
                    "Enter the code",
                    style: TextStyle(
                      color: MyColors.CUSTOM_RED,
                      fontSize: 25,
                    ),
                  ),

                ],
              ),
            ),

            /// Dots
            Container(
//              color: Colors.greenAccent,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  validationDot(1),
                  validationDot(2),
                  validationDot(3),
                  validationDot(4),

                ],
              ),
            ),

            /// Keyboard
            Container(
//              color: Colors.black12,
              alignment: Alignment.center,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[

                   /// Line 1
                   Container(
                     margin: const EdgeInsets.only(
                       bottom: spaceRow,
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[

                         keyBtnDigit("1"),
                         keyBtnDigit("2"),
                         keyBtnDigit("3"),

                       ],
                     ),
                   ),

                   /// Line 2
                   Container(
                     margin: const EdgeInsets.only(
                       bottom: spaceRow,
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[

                         keyBtnDigit("4"),
                         keyBtnDigit("5"),
                         keyBtnDigit("6"),

                       ],
                     ),
                   ),

                   /// Line 3
                   Container(
                     margin: const EdgeInsets.only(
                       bottom: spaceRow,
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[

                         keyBtnDigit("7"),
                         keyBtnDigit("8"),
                         keyBtnDigit("9"),

                       ],
                     ),
                   ),

                   /// Line 4
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[

                       /// Finger-print
                       keyBtn(
                         IconButton(
                           icon: Icon(
                             Icons.fingerprint,
                             size: 45,
                             color: MyColors.CUSTOM_RED,
                           ),
                           onPressed: () {

                             /// TODO: Open modal fingerprint
                             showModalFingerPrint(context);

                           },
                         )
                       ),

                       /// Delete
                       keyBtnDigit("0"),

                       /// Delete
                       keyBtn(
                         IconButton(
                           onPressed: () {

                             /// Check empty
                             if(currentPassword != null && currentPassword != "") {

                               /// Delete last char
                               setState(() {
                                 currentPassword = currentPassword.substring(0, currentPassword.length - 1);
                               });

                               print(currentPassword);
                             }

                           },
                           icon: Icon(
                             Icons.backspace,
                             size: 35,
                             color: MyColors.CUSTOM_RED,
                           ),
                         ),
                       ),

                     ],
                   ),

                 ],
               ),
            ),

          ],
        ),
      ),
    );
  }


  /// Display the modal for the finger print
  void showModalFingerPrint(context) {

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[

                /// Separator
                Center(
                  child: Container(
                    height: 8,
                    width: 80,
                    margin: EdgeInsets.only(
                      top: 20,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.CUSTOM_RED,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
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
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 30,
                        ),
                        child: Text(
                          "Tap to register",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: MyColors.CUSTOM_RED,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      /// Finger print
                      Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.fingerprint,
                          size: 70,
                          color: MyColors.CUSTOM_RED,
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          );
        }
    );
  }

}