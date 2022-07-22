import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_home.dart';
import 'package:consel_me_admin/buttons/addBooking.dart';
import 'package:consel_me_admin/buttons/viewUser.dart';
import 'package:consel_me_admin/buttons/view_appoinment_details.dart';
import 'package:consel_me_admin/psyViewBooking.dart';
import 'package:consel_me_admin/psy_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class psyHome extends StatefulWidget {
  const psyHome({Key? key}) : super(key: key);

  @override
  State<psyHome> createState() => _psyHomeState();
}

class _psyHomeState extends State<psyHome> {
  var userData;
  User? user = FirebaseAuth.instance.currentUser;

  Future getBookingList() async {
    var fireStore = FirebaseFirestore.instance;

    QuerySnapshot booking = await fireStore.collection("booking").get();
    return booking.docs;
  }

  catchDetail(String bookingDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => psyViewBooking(
                  bookingDetails: bookingDetails,
                )));
  }

  Future<void> onSelected(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const psyLogin()));
    Fluttertoast.showToast(msg: "Sucessfully Logout");
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 35, 90, 190),
          elevation: 0,
          title: const Text('Appoinment'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Upcoming',
            ),
            Tab(
              text: 'Completed',
            ),
            Tab(
              text: 'Cancelled',
            ),
          ]),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
                onSelected: (item) => onSelected(context),
                itemBuilder: (context) => [
                      PopupMenuItem(value: 0, child: Text("Logout")),
                    ])
          ],
        ),
        body: TabBarView(children: [
          MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: getBookingList(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.only(top: 250),
                            child: const CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index]
                                            .data()["bookingStatus"]
                                            .toString() ==
                                        "Upcoming" &&
                                    snapshot.data[index]
                                            .data()["psychologyId"]
                                            .toString() ==
                                        user!.uid) {
                                  return GestureDetector(
                                      onTap: () {
                                        catchDetail(snapshot.data[index]
                                            .data()["bookingId"]
                                            .toString());
                                      },
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Row(
                                              //mainAxisAlignment:MainAxisAlignment.spaceAround,
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 120,
                                                  child: Image.network(
                                                    snapshot.data[index]
                                                        .data()["imgUrl"]
                                                        .toString(),
                                                    fit: BoxFit.fill,
                                                    height: 120,
                                                    width: 120,
                                                  ),
                                                ),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "   Book Id : " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingId"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "   Dr Name : " +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "psychologyName"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "   Date : " +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "bookingDate"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "   Time : " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingTime"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            "              " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingStatus"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                }
                                return Container(
                                    color: Colors.white // This is optional
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
                      future: getBookingList(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.only(top: 250),
                            child: const CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index]
                                            .data()["bookingStatus"]
                                            .toString() ==
                                        "Completed" &&
                                    snapshot.data[index]
                                            .data()["psychologyId"]
                                            .toString() ==
                                        user!.uid) {
                                  return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Row(
                                              //mainAxisAlignment:MainAxisAlignment.spaceAround,
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 120,
                                                  child: Image.network(
                                                    snapshot.data[index]
                                                        .data()["imgUrl"]
                                                        .toString(),
                                                    fit: BoxFit.fill,
                                                    height: 120,
                                                    width: 120,
                                                  ),
                                                ),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "   Book Id : " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingId"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "   Dr Name : " +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "psychologyName"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "   Date : " +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "bookingDate"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "   Time : " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingTime"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            "              " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingStatus"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                }
                                return Container(
                                    color: Colors.white // This is optional
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
                      future: getBookingList(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            padding: const EdgeInsets.only(top: 250),
                            child: const CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index]
                                            .data()["bookingStatus"]
                                            .toString() ==
                                        "Cancelled" &&
                                    snapshot.data[index]
                                            .data()["psychologyId"]
                                            .toString() ==
                                        user!.uid) {
                                  return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Column(
                                          children: [
                                            Row(
                                              //mainAxisAlignment:MainAxisAlignment.spaceAround,
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 120,
                                                  child: Image.network(
                                                    snapshot.data[index]
                                                        .data()["imgUrl"]
                                                        .toString(),
                                                    fit: BoxFit.fill,
                                                    height: 120,
                                                    width: 120,
                                                  ),
                                                ),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "   Book Id : " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingId"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            height: 30,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "   Dr Name : " +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "psychologyName"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "   Date : " +
                                                            snapshot.data[index]
                                                                    .data()[
                                                                "bookingDate"],
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "   Time : " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingTime"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            "              " +
                                                                snapshot.data[
                                                                            index]
                                                                        .data()[
                                                                    "bookingStatus"],
                                                            style: const TextStyle(
                                                                fontSize: 15,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        17,
                                                                        0),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                }
                                return Container(
                                    color: Colors.white // This is optional
                                    );
                              });
                        }
                      }),
                ],
              ),
            ),
          ),
        ]),
      ));
}
