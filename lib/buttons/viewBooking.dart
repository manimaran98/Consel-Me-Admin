import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_home.dart';
import 'package:consel_me_admin/buttons/addBooking.dart';
import 'package:consel_me_admin/buttons/viewUser.dart';
import 'package:consel_me_admin/buttons/view_appoinment_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'viewPsy.dart';

class viewBooking extends StatefulWidget {
  const viewBooking({Key? key}) : super(key: key);

  @override
  State<viewBooking> createState() => _viewBookingState();
}

class _viewBookingState extends State<viewBooking> {
  int _selectedIndex = 3;
  var userData;
  User? user = FirebaseAuth.instance.currentUser;

  Future getBookingList() async {
    var fireStore = FirebaseFirestore.instance;

    QuerySnapshot booking = await fireStore.collection("booking").get();
    return booking.docs;
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const admin_home()));
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
        _selectedIndex = index;
      }
    });
  }

  catchDetail(String bookingDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => viewAppoinmentDetails(
                  bookingDetails: bookingDetails,
                )));
  }

  void onSelected(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => addBooking()));
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 238, 238, 238),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 35, 90, 190),
          elevation: 0,
          title: const Text('Appoinment Booking'),
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
                      const PopupMenuItem(value: 0, child: Text("Add Booking")),
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
                                    "Upcoming") {
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
                                    "Completed") {
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
                                    "Cancelled") {
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
