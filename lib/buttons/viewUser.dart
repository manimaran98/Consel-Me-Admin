// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_home.dart';
import 'package:consel_me_admin/buttons/addUser.dart';
import 'package:consel_me_admin/buttons/viewBooking.dart';
import 'package:consel_me_admin/buttons/viewPsy.dart';
import 'package:consel_me_admin/buttons/viewUserDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class viewUser extends StatefulWidget {
  const viewUser({Key? key}) : super(key: key);

  @override
  State<viewUser> createState() => _viewUserState();
}

class _viewUserState extends State<viewUser> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();
  String userId = "";
  String image = "";
  int _selectedIndex = 1;

  Future getUserList() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot user = await fireStore.collection("users").get();

    return user.docs;
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const admin_home()));
        _selectedIndex = index;
      }

      if (index == 1) {
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

  catchDetail(String userId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => viewUserDetails(
                  userId: userId,
                )));
  }

  showAlertDialog(BuildContext context, userId) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = FlatButton(
      child: const Text("Yes"),
      onPressed: () async {
// Create a reference to the file to delete

        FirebaseFirestore.instance.collection("users").doc(userId).delete();
        Navigator.of(context).pop();
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content:
          const Text("Are you sure you want to delete this screening result?"),
      actions: [
        yesButton,
        noButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  userAndAdmin(role) {
    if (role == "User") {
      return image = "assets/userData.jpg";
    }

    if (role == "Admin") {
      return image = "assets/adminData.png";
    }
  }

  void onSelected(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => addUser()));
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 35, 90, 190),
          elevation: 0,
          title: const Text('View User'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'User',
            ),
            Tab(
              text: 'Admin',
            ),
          ]),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context),
                itemBuilder: (context) => [
                      PopupMenuItem(value: 0, child: Text("Add User")),
                    ])
          ],
        ),
        body: TabBarView(
          children: [
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: getUserList(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data[index]
                                          .data()["role"]
                                          .toString() ==
                                      "User") {
                                    return Card(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 120,
                                                child: Image.asset(
                                                  userAndAdmin(snapshot
                                                      .data[index]
                                                      .data()["role"]),
                                                  fit: BoxFit.fill,
                                                  height: 120,
                                                  width: 120,
                                                ),
                                              ),
                                              Column(children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "Name : " +
                                                      snapshot.data[index]
                                                          .data()["firstName"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  'Email : ' +
                                                      snapshot.data[index]
                                                          .data()["email"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Material(
                                                        elevation: 5,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            Colors.greenAccent,
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            catchDetail(snapshot
                                                                .data[index]
                                                                .data()[
                                                                    "user_id"]
                                                                .toString());
                                                          },
                                                          child: const Text(
                                                            "Check Details",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Material(
                                                        elevation: 5,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.red,
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            userId = snapshot
                                                                    .data[index]
                                                                    .data()[
                                                                "user_id"];
                                                            showAlertDialog(
                                                                context,
                                                                userId);
                                                          },
                                                          child: const Text(
                                                            "Delete",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                  ],
                                                )
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container(
                                    color: Colors.white,
                                  );
                                });
                          }
                        }),
                  ],
                ),
              ),
            ),
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: getUserList(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data[index]
                                          .data()["role"]
                                          .toString() ==
                                      "Admin") {
                                    return Card(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 120,
                                                child: Image.asset(
                                                  userAndAdmin(snapshot
                                                      .data[index]
                                                      .data()["role"]),
                                                  fit: BoxFit.fill,
                                                  height: 120,
                                                  width: 120,
                                                ),
                                              ),
                                              Column(children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  "Name : " +
                                                      snapshot.data[index]
                                                          .data()["firstName"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Text(
                                                  'Email : ' +
                                                      snapshot.data[index]
                                                          .data()["email"],
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Material(
                                                        elevation: 5,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            Colors.greenAccent,
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            catchDetail(snapshot
                                                                .data[index]
                                                                .data()[
                                                                    "user_id"]
                                                                .toString());
                                                          },
                                                          child: const Text(
                                                            "Check Details",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Material(
                                                        elevation: 5,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.red,
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            userId = snapshot
                                                                    .data[index]
                                                                    .data()[
                                                                "user_id"];
                                                            showAlertDialog(
                                                                context,
                                                                userId);
                                                          },
                                                          child: const Text(
                                                            "Delete",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                  ],
                                                )
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Container(
                                    color: Colors.white,
                                  );
                                });
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      ));
}
