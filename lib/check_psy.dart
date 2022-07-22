import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_home.dart';
import 'package:consel_me_admin/admin_login.dart';
import 'package:consel_me_admin/psyViewBooking.dart';
import 'package:consel_me_admin/psy_home.dart';
import 'package:consel_me_admin/psy_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'model/user_model.dart';

class checkPsy extends StatefulWidget {
  const checkPsy({Key? key}) : super(key: key);

  @override
  State<checkPsy> createState() => _checkPsyState();
}

class _checkPsyState extends State<checkPsy> {
  int index = 0;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List data = [];
  String psyId = "";
  String psyName = "";

  late String fullname = "";

  @override
  void initState() {
    super.initState();
    _checkRole();
    getNotification();
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      print(payload);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => psyViewBooking(
                    bookingDetails: payload.toString(),
                  )));
    });
  }

  getNotification() async {
    final android = AndroidNotificationDetails('0', 'ConSel-Me',
        channelDescription: 'Notification Reminder',
        priority: Priority.high,
        importance: Importance.max,
        icon: '@mipmap/launcher_icon');
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    DateTime? date1 = DateTime.now();
    String date = DateFormat('dd/MM/yyyy').format(date1);
    await FirebaseFirestore.instance
        .collection("booking")
        .get()
        .then((value) async {
      for (var i in value.docs) {
        data.add(i.data());
        String bookDate = data[index]["bookingDate"];
        String psychologyId = data[index]["psychologyId"];
        String bookTime = data[index]["bookingTime"];
        String bookingStatus = data[index]["bookingStatus"];
        String user_id = data[index]["user_id"];
        String bookingId = data[index]["bookingId"];

        FirebaseFirestore.instance
            .collection("users")
            .doc(user_id)
            .get()
            .then((value) async {
          loggedInUser = UserModel.fromMap(value.data());
          fullname = "${loggedInUser.firstName}";

          if ((bookDate == date.toString() &&
              psychologyId == user!.uid &&
              bookingStatus == "Upcoming")) {
            await flutterLocalNotificationsPlugin.show(
                0,
                "Appoinment Reminder",
                "Your appoinment with " + fullname + " is at " + bookTime,
                platform,
                payload: bookingId);
          }
        });

        index++;
      }
    });
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('psychologists')
        .doc(user?.uid)
        .get();

    if (snap.exists) {
      setState(() {
        psyId = snap['psychologyId'];
        psyName = snap['psychologyName'];
      });

      if (psyId != user?.uid) {
        navigateNext((psyLogin()));
        Fluttertoast.showToast(msg: "Unauthorised Access");
      } else if (psyId == user?.uid) {
        navigateNext(psyHome());
        Fluttertoast.showToast(msg: "Welcome " + psyName);
      }
    } else {
      navigateNext((psyLogin()));
      Fluttertoast.showToast(msg: "Unauthorised Access");
    }
  }

  void navigateNext(Widget route) {
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
            child: const CircularProgressIndicator(),
          ),
          color: Colors.white),
    );
  }
}
