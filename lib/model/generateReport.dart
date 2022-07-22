import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_home.dart';
import 'package:consel_me_admin/buttons/reportDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:screenshot/screenshot.dart';

import '../buttons/viewBooking.dart';
import '../buttons/viewPsy.dart';
import '../buttons/viewUser.dart';

class generateReport extends StatefulWidget {
  const generateReport({key, required this.bookDate});
  final bookDate;

  @override
  State<generateReport> createState() => _generateReport();
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
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {
    if (payload != null) OpenFile.open(payload);
  });
}

class _generateReport extends State<generateReport> {
  int _selectedIndex = 3;
  var userData;
  int Count = 1;
  late Uint8List? _imageFile;

  User? user = FirebaseAuth.instance.currentUser;
  ScreenshotController screenshotController = ScreenshotController();

  var _globalKey;

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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const viewBooking()));
        _selectedIndex = index;
      }
    });
  }

  catchDetail(String bookingDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => reportDetails(
                  bookingDetails: bookingDetails,
                )));
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future getPdf(Uint8List screenShot) async {
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
            child: pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.fill),
          );
        },
      ),
    );

    await [Permission.storage].request();

    Random random = new Random();
    int code = random.nextInt(99999);

    final filename = 'Booking Receipt_$code.pdf';

    String filePath = '/storage/emulated/0/Download/$filename';

    File pdfFile = File(filePath);

    pdfFile.writeAsBytesSync(await pdf.save());
    Fluttertoast.showToast(msg: "PDF file have been downloaded");
    final android = AndroidNotificationDetails('0', 'ConSel-Me',
        channelDescription: 'Save Download',
        priority: Priority.high,
        importance: Importance.max,
        icon: '@mipmap/launcher_icon');
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      0,
      filename,
      'Download complete.',
      platform,
      payload: filePath,
    );

    OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final printButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
        onPressed: () async {
          final image = await screenshotController.capture();
          _imageFile = image;
          getPdf(_imageFile!);
        },
        child: const Text(
          "Generate Report",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
        elevation: 0,
        title: const Text('Search'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Screenshot(
            controller: screenshotController,
            key: _globalKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Booking Record",
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: getBookingList(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                              if (widget.bookDate == 'ALL') {
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
                                            children: <Widget>[
                                              SizedBox(
                                                height: 150,
                                                child: Image.network(
                                                  snapshot.data[index]
                                                      .data()["imgUrl"]
                                                      .toString(),
                                                  fit: BoxFit.fill,
                                                  height: 150,
                                                  width: 120,
                                                ),
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                              color:
                                                                  Colors.black,
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
                                                      "   Appoinment Fee : " +
                                                          "RM " +
                                                          snapshot.data[index]
                                                                  .data()[
                                                              "bookingFee"],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
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
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "   Appoinment Status : " +
                                                          snapshot.data[index]
                                                                  .data()[
                                                              "bookingStatus"],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                              FontWeight.bold),
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                              }
                              if (snapshot.data[index]
                                      .data()["bookingDate"]
                                      .toString() ==
                                  widget.bookDate) {
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
                                            children: <Widget>[
                                              SizedBox(
                                                height: 150,
                                                child: Image.network(
                                                  snapshot.data[index]
                                                      .data()["imgUrl"]
                                                      .toString(),
                                                  fit: BoxFit.fill,
                                                  height: 150,
                                                  width: 120,
                                                ),
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                              color:
                                                                  Colors.black,
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
                                                      "   Appoinment Fee : " +
                                                          "RM " +
                                                          snapshot.data[index]
                                                                  .data()[
                                                              "bookingFee"],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
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
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "   Appoinment Status : " +
                                                          snapshot.data[index]
                                                                  .data()[
                                                              "bookingStatus"],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                              FontWeight.bold),
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
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ));
                              } else {
                                return Container();
                              }
                            });
                      }
                    }),
              ],
            )),
        SizedBox(
          height: 20,
        ),
        printButton,
        SizedBox(
          height: 20,
        ),
      ])),
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

class CustomSearchDelegate extends SearchDelegate {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("booking");

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs
              .where((QueryDocumentSnapshot<Object?> element) =>
                  element['bookingDate']
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase()))
              .isEmpty) {
            return Center(child: Text('No search query found'));
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element['bookingDate']
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  String bookingDate = data.get('bookingDate');
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => generateReport(
                                    bookDate: bookingDate,
                                  )));
                    },
                    title: Text(bookingDate),
                  );
                })
              ],
            );
          }
        });

    /* List<String> matchQuery = [];
    for (var fruits in searchTerms) {
      if (fruits.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruits);
      }}*/

    /* return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(title: Text(result));
        });*/
  }

  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search by Date: DD/MM/YYYY"),
    );
  }
}
