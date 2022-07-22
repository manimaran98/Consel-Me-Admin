// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/buttons/addPsy.dart';
import 'package:consel_me_admin/buttons/viewBooking.dart';
import 'package:consel_me_admin/buttons/viewPsyDetails.dart';
import 'package:consel_me_admin/buttons/viewUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../admin_home.dart';

class viewPsy extends StatefulWidget {
  const viewPsy({Key? key}) : super(key: key);

  @override
  State<viewPsy> createState() => _viewPsyState();
}

class _viewPsyState extends State<viewPsy> {
  int _selectedIndex = 2;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();
  String psyId = "";

  Future getPhycologistList() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot psychologist =
        await fireStore.collection("psychologists").get();

    return psychologist.docs;
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
        _selectedIndex = index;
      }

      if (index == 3) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const viewBooking()));
        _selectedIndex = index;
      }
    });
  }

  catchDetail(String psychologist) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => viewPsyDetails(
                  psychologist: psychologist,
                )));
  }

  showAlertDialog(BuildContext context, psyId) {
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

        final storageRef = FirebaseStorage.instance.ref();
        final desertRef = storageRef.child("psychologistImages/${psyId}");

        // Delete the file
        await desertRef.delete();

        FirebaseFirestore.instance
            .collection("psychologists")
            .doc(psyId)
            .delete();
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

  void onSelected(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => addPsychology()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        elevation: 0,
        title: const Text('Psychologist'),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
              onSelected: (item) => onSelected(context),
              itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text("Add Psychologist")),
                  ])
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getPhycologistList(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                    Column(children: [
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data[index]
                                                .data()["psychologyName"],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 50,
                                            height: 50,
                                          ),
                                          Text(
                                            'RM ' +
                                                snapshot.data[index]
                                                    .data()["price"],
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.greenAccent,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  catchDetail(snapshot
                                                      .data[index]
                                                      .data()["psychologyId"]
                                                      .toString());
                                                },
                                                child: const Text(
                                                  "Check Details",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.red,
                                              child: MaterialButton(
                                                onPressed: () {
                                                  psyId = snapshot.data[index]
                                                      .data()["psychologyId"];
                                                  showAlertDialog(
                                                      context, psyId);
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                        });
                  }
                }),
          ],
        ),
      )),
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
