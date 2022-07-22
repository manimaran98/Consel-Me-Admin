import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_login.dart';

import 'package:consel_me_admin/buttons/viewPsy.dart';
import 'package:consel_me_admin/buttons/viewUser.dart';
import 'package:consel_me_admin/model/generateReport.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'buttons/viewBooking.dart';

class admin_home extends StatefulWidget {
  const admin_home({Key? key}) : super(key: key);

  @override
  State<admin_home> createState() => _admin_homeState();
}

class _admin_homeState extends State<admin_home> {
  int _selectedIndex = 0;

  List data = [];
  int userCounter = 0;
  int adminCounter = 0;
  int psyCounter = 0;
  int index = 0;
  int bookingIdCounter = 0;

  int cancelledCounter = 0;

  int completedCounter = 0;
  int upcomingCounter = 0;

  void initState() {
    super.initState();
    countUser();
    countAdmin();
    countPsy();
    countUpcoming();
    countCompleted();
    countCancelled();
    countReport();
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        _selectedIndex = index;
      }

      if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const viewUser()));
        _selectedIndex = index;
      }

      if (index == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const viewPsy()));
        _selectedIndex = index;
      }

      if (index == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const viewBooking()));
        _selectedIndex = index;
      }
    });
  }

  countUser() {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var i in value.docs) {
        data.add(i.data());
        String role = data[index]["role"];

        if ((role == "User")) {
          userCounter++;
        }

        index++;
      }
      setState(() {});
    });
  }

  countAdmin() {
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var i in value.docs) {
        data.add(i.data());
        String role = data[index]["role"];

        if ((role == "Admin")) {
          adminCounter++;
        }

        index++;
      }
      setState(() {});
    });
  }

  countPsy() {
    FirebaseFirestore.instance.collection("psychologists").get().then((value) {
      for (var i in value.docs) {
        data.add(i.data());
        String psyId = data[index]["psychologyId"];
        index++;
        if (psyId == psyId) {
          psyCounter++;
        }
        ;
      }
      setState(() {});
    });
  }

  countUpcoming() {
    FirebaseFirestore.instance.collection("booking").get().then((value) {
      for (var i in value.docs) {
        data.add(i.data());
        String bookingStatus = data[index]["bookingStatus"];
        index++;
        if (bookingStatus == "Upcoming") {
          upcomingCounter++;
        }
        ;
      }
      setState(() {});
    });
  }

  countCompleted() {
    FirebaseFirestore.instance.collection("booking").get().then((value) {
      for (var i in value.docs) {
        data.add(i.data());
        String bookingStatus = data[index]["bookingStatus"];
        index++;
        if (bookingStatus == "Completed") {
          completedCounter++;
        }
        ;
      }
      setState(() {});
    });
  }

  countCancelled() {
    FirebaseFirestore.instance.collection("booking").get().then((value) {
      for (var i in value.docs) {
        data.add(i.data());
        String bookingStatus = data[index]["bookingStatus"];
        index++;
        if (bookingStatus == "Cancelled") {
          cancelledCounter++;
        }
        ;
      }
      setState(() {});
    });
  }

  countReport() {
    FirebaseFirestore.instance.collection("booking").get().then((value) {
      for (var i in value.docs) {
        data.add(i.data());

        index++;
        bookingIdCounter++;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final logoutButton = Material(
      elevation: 5,
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(54, 15, 54, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const admin_login()));
          Fluttertoast.showToast(msg: "Sucessfully Logout");
        },
        child: const Text(
          "Logout",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        elevation: 0,
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 248, 248, 248),
              child: Column(children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const viewUser()));
                    },
                    child: Container(
                        color: Colors.white,
                        child: Column(children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "APP USER",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    child: Icon(
                                      Icons.people,
                                      color: Colors.indigo,
                                      size: 100.0,
                                      textDirection: TextDirection.ltr,
                                      semanticLabel:
                                          'Icon', // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                    ),
                                  ),
                                  Text(
                                    "USER",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //countUser(),
                                  Text(
                                    userCounter.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    child: Icon(
                                      Icons.admin_panel_settings,
                                      color: Colors.purpleAccent,
                                      size: 100.0,
                                      textDirection: TextDirection.ltr,
                                      semanticLabel:
                                          'Icon', // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                    ),
                                  ),
                                  //countAdmin(),
                                  Text(
                                    "ADMIN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    adminCounter.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.purpleAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ]))),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const viewPsy()));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              child: Icon(
                                Icons.work_rounded,
                                color: Colors.amberAccent,
                                size: 100.0,
                                textDirection: TextDirection.ltr,
                                semanticLabel: 'Icon',
                              ),
                            ),
                            Text(
                              "PSYCHOLOGIST",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              psyCounter.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => generateReport(
                                        bookDate: "ALL",
                                      )));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              child: Icon(
                                Icons.read_more,
                                color: Colors.green,
                                size: 100.0,
                                textDirection: TextDirection.ltr,
                                semanticLabel: 'Icon',
                              ),
                            ),
                            Text(
                              "REPORT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              bookingIdCounter.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const viewBooking()));
                    },
                    child: Container(
                      color: Color.fromARGB(255, 235, 233, 233),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "APPOINMENT STATUS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    child: Icon(
                                      Icons.upcoming,
                                      color: Colors.brown,
                                      size: 100.0,
                                      textDirection: TextDirection.ltr,
                                      semanticLabel:
                                          'Icon', // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                    ),
                                  ),
                                  Text(
                                    "Upcoming",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.brown,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //countUser(),
                                  Text(
                                    upcomingCounter.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.brown,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.green,
                                      size: 100.0,
                                      textDirection: TextDirection.ltr,
                                      semanticLabel:
                                          'Icon', // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                    ),
                                  ),
                                  Text(
                                    "Completed",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //countUser(),
                                  Text(
                                    completedCounter.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 100.0,
                                      textDirection: TextDirection.ltr,
                                      semanticLabel:
                                          'Icon', // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                    ),
                                  ),
                                  Text(
                                    "Cancelled",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //countUser(),
                                  Text(
                                    cancelledCounter.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          logoutButton
                        ],
                      ),
                    ))
              ]))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined, color: Colors.black),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work, color: Colors.black),
            label: 'Psychologist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: Colors.black),
            label: 'Booking',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
