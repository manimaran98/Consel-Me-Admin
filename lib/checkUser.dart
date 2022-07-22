import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_home.dart';
import 'package:consel_me_admin/admin_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class checkUser extends StatefulWidget {
  const checkUser({Key? key}) : super(key: key);

  @override
  State<checkUser> createState() => _checkUserState();
}

class _checkUserState extends State<checkUser> {
  String role = 'user';

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    if (snap.exists) {
      setState(() {
        role = snap['role'];
      });

      if (role == 'User') {
        navigateNext(admin_login());
        Fluttertoast.showToast(msg: "Unauthorised Access");
      } else if (role == 'Admin') {
        navigateNext(admin_home());
        Fluttertoast.showToast(msg: "Welcome Admin");
      }
    } else {
      navigateNext(admin_login());
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
