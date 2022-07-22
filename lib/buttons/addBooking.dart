import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/buttons/chooseUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class addBooking extends StatefulWidget {
  const addBooking({Key? key}) : super(key: key);

  @override
  State<addBooking> createState() => _addBookingState();
}

class _addBookingState extends State<addBooking> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController searchController = TextEditingController();
  Future getPhycologistList() async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot psychologist =
        await fireStore.collection("psychologists").get();

    return psychologist.docs;
  }

  catchDetail(String psychologist) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => chooseUser(
                  psychologist: psychologist,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        elevation: 0,
        title: const Text('Choose Psychologist'),
        centerTitle: true,
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
                                      MainAxisAlignment.spaceAround,
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
                                      Material(
                                          elevation: 5,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.greenAccent,
                                          child: MaterialButton(
                                            onPressed: () {
                                              catchDetail(snapshot.data[index]
                                                  .data()["psychologyId"]
                                                  .toString());
                                            },
                                            child: const Text(
                                              "Choose Psychologist",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ))
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
    );
  }
}
