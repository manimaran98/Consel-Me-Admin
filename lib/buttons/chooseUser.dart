import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'confirm_booking.dart';

class chooseUser extends StatefulWidget {
  const chooseUser({key, required this.psychologist});
  final String psychologist;

  @override
  State<chooseUser> createState() => _chooseUserState();
}

class _chooseUserState extends State<chooseUser> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();
  String userId = "";
  String image = "";

  Future getUserList() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot user = await fireStore.collection("users").get();

    return user.docs;
  }

  catchDetail(String userId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => confirmBooking(
                user: userId, psychologist: widget.psychologist)));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        elevation: 0,
        title: const Text('User Data'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: getUserList(),
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
                          if (snapshot.data[index].data()["role"] == "User") {
                            return Card(
                              margin: const EdgeInsets.only(top: 20),
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
                                          userAndAdmin(snapshot.data[index]
                                              .data()["role"]),
                                          fit: BoxFit.fill,
                                          height: 120,
                                          width: 120,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 230,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
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
                                              Material(
                                                  elevation: 5,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.greenAccent,
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      catchDetail(snapshot
                                                          .data[index]
                                                          .data()["user_id"]
                                                          .toString());
                                                    },
                                                    child: const Text(
                                                      "Choose User",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        });
                  }
                }),
          ],
        ),
      )),
    );
  }
}
