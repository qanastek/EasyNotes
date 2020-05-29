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
  bool secured;
  String password;
  String description;
  IconData icon;
  Color color;
  DateTime creationDate;
  DateTime lastModification;
  bool archived;
  DateTime oldExpiredDate;
  DateTime expiredDate;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  final BehaviorSubject<Content> didReceiveLocalNotificationSubject = BehaviorSubject<Content>();

  final BehaviorSubject<String> selectNotificationSubject =
  BehaviorSubject<String>();

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
    this.secured = secured;
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

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker'
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