import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:phonecall/Models/Setting/MyColors.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:share/share.dart';
import 'dart:ui';
import 'dart:async';
import 'package:rxdart/subjects.dart';

abstract class Content {

  final String id = md5.convert(utf8.encode(DateTime.now().toString())).toString();
  String title;
  bool favorite;
  String password;
  String description;
  IconData icon;
  Color color;
  DateTime creationDate;
  DateTime lastModification;
  bool archived;
  final int notificationId = DateTime.now().millisecondsSinceEpoch;
  DateTime expiredDate;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

  NotificationAppLaunchDetails notificationAppLaunchDetails;

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
  );

  InitializationSettings initializationSettings;

  /// Constructor
  Content(title,favorite,secured,password,description,icon,color) {
    this.title = title;
    this.favorite = favorite;
    this.password = password;
    this.description = description;
    this.icon = icon;

    if(color != null) {
      this.color = color;
    } else {
      this.color = MyColors.randomColor();
    }

    this.creationDate = DateTime.now();
    this.lastModification = DateTime.now();
    this.archived = false;

    initializationSettings = InitializationSettings(
        initializationSettingsAndroid,
        initializationSettingsIOS
    );
  }

  String getTitle() {
    return title;
  }

  /// Return the description according to the type
  String getDescription();

  /// Get color
  Color getColor() {
    return this.color;
  }

  /// Get icon color
  Color getIconColor() {
    return this.color.computeLuminance() > 0.7 ? Colors.black54 : Colors.white;
  }

  /// Get icon
  IconData getIcon();

  /// Share the Content
  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();

    Share.share("${this.title} \n ${this.description}",
      subject: this.description,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  /// Secure the content
  void secure(String password) {
    this.password = password;
  }

  /// Delete the content security
  void unSecure() {
    this.password = null;
  }

  Future<void> showNotification() async {

    notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      }
    );

//    await flutterLocalNotificationsPlugin.cancel(notificationId);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'EasyNotes',
      'EasyNotes',
      'EasyNotes notifications',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
      enableLights: true,
      color: MyColors.CUSTOM_RED,
      ledColor: MyColors.CUSTOM_RED,
      ledOnMs: 60 * 60 * 1000,
      ledOffMs: 0,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.schedule(
        0,
        'EasyNote',
        'Coming task: ${this.title}',
        this.expiredDate,
        platformChannelSpecifics
    );
  }
}