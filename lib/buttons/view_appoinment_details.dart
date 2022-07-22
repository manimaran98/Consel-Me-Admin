// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:consel_me_admin/admin_home.dart';
import 'package:consel_me_admin/buttons/viewBooking.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:screenshot/screenshot.dart';

import '../model/booking_model.dart';
import '../model/psycology_model.dart';
import '../model/user_model.dart';

// ignore: camel_case_types
class viewAppoinmentDetails extends StatefulWidget {
  const viewAppoinmentDetails({key, required this.bookingDetails});

  final String bookingDetails;

  @override
  State<viewAppoinmentDetails> createState() => _viewAppoinmentDetailsState();
}

class _viewAppoinmentDetailsState extends State<viewAppoinmentDetails> {
  int _selectedIndex = 1;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late Uint8List? _imageFile;

  List data = [];
  int index = 0;
  String selectedTime = '';
  String selectedStatus = "";
  String psyId = "";

  late String option1;
  late String value1;
  late bool availability1;
  late String option2;
  late String value2;
  late bool availability2;
  late String option3;
  late String value3;
  late bool availability3;
  late String option4;
  late String value4;
  late bool availability4;
  late String option5;
  late String value5;
  late bool availability5;

  String psyUrl =
      "https://firebasestorage.googleapis.com/v0/b/consel-me-6938b.appspot.com/o/psychologistImages%2Fuser.png?alt=media&token=192696e8-ec72-4886-889d-0a6fac05ddf8";
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController psychologistNameEditingController =
      TextEditingController();
  TextEditingController bookingStatusEditingController =
      TextEditingController();
  TextEditingController bookingTimeEditingController = TextEditingController();
  TextEditingController bookingDateEditingController = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController psychologistPriceEditingController =
      TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  bookingModel booking = bookingModel();
  UserModel loggedInUser = UserModel();
  psychologyModel chosenPsychologist = psychologyModel();
  final formKey = GlobalKey<FormState>();
  String bookingDate1 = '';

  @override
  void initState() {
    super.initState();

    option1 = ' 10.00 AM';
    value1 = '10.00 AM';
    availability1 = true;
    option2 = ' 12.00 PM';
    value2 = '12.00 PM';
    availability2 = true;
    option3 = ' 2.00 PM';
    value3 = '2.00 PM';
    availability3 = true;
    option4 = ' 4.00 PM';
    value4 = '4.00 PM';
    availability4 = true;
    option5 = ' 6.00 PM';
    value5 = '6.00 PM';
    availability5 = true;

    FirebaseFirestore.instance
        .collection("booking")
        .doc(widget.bookingDetails)
        .get()
        .then((value) {
      booking = bookingModel.fromMap(value.data());

      psychologistNameEditingController.text = "${booking.psychologyName}";
      psyId = booking.psychologyId!;
      psyUrl = "${booking.imgUrl}";
      selectedTime = "${booking.bookingTime}";
      bookingDateEditingController.text = "${booking.bookingDate}";
      psychologistPriceEditingController.text = "${booking.bookingFee}";
      selectedStatus = "${booking.bookingStatus}";

      FirebaseFirestore.instance
          .collection("users")
          .doc(booking.user_id)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        firstNameEditingController.text = "${loggedInUser.firstName}";
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: firstNameEditingController,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final psycologistNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: psychologistNameEditingController,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final bookingStatusField = DropdownButtonFormField(
        value: selectedStatus,
        items: [
          DropdownMenuItem(
            child: Text(""),
            value: "",
          ),
          DropdownMenuItem(
            child: Text("Upcoming"),
            value: "Upcoming",
          ),
          DropdownMenuItem(
            child: Text("Completed"),
            value: "Completed",
          ),
          DropdownMenuItem(
            child: Text("Cancelled"),
            value: "Cancelled",
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedStatus = value.toString();
          });
        },
        validator: (option) {
          if (option == "") {
            Fluttertoast.showToast(msg: "Booking Status Should not be Empty");
            return ("Booking Status Should not be Empty");
          }
          return null;
        },
        onSaved: (value) {
          selectedTime = value.toString();
        },
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          errorStyle: (TextStyle(
            fontSize: 10.0,
          )),
        ));

    final psycologistPriceNameField = TextFormField(
        readOnly: true,
        autofocus: false,
        controller: psychologistPriceEditingController,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 5),
          border: InputBorder.none,
        ));

    final bookingDateField = TextFormField(
        controller: bookingDateEditingController,
        onTap: () async {
          DateTime? date = DateTime(1900);
          //FocusScope.of(context).requestFocus(FocusNode());

          date = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: DateTime.now(),
              lastDate: DateTime(2100));
          bookingDateEditingController.text =
              DateFormat('dd/MM/yyyy').format(date ?? DateTime.now());

          option1 = ' 10.00 AM';
          value1 = '10.00 AM';
          availability1 = true;
          option2 = ' 12.00 PM';
          value2 = '12.00 PM';
          availability2 = true;
          option3 = ' 2.00 PM';
          value3 = '2.00 PM';
          availability3 = true;
          option4 = ' 4.00 PM';
          value4 = '4.00 PM';
          availability4 = true;
          option5 = ' 6.00 PM';
          value5 = '6.00 PM';
          availability5 = true;

          await firebaseFirestore.collection("booking").get().then((value) {
            for (var i in value.docs) {
              data.add(i.data());
              String bookDate = data[index]["bookingDate"];
              String bookTime = data[index]["bookingTime"];
              String psychologyId = data[index]["psychologyId"];

              if ((bookDate == bookingDateEditingController.text &&
                  bookTime == value1 &&
                  psychologyId == psyId)) {
                option1 = ' 10.00 AM (Not Available)';
                value1 = '10.00 AM';
                availability1 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value2 &&
                  psychologyId == psyId) {
                option2 = ' 12.00 PM (Not Available)';
                value2 = '12.00 PM';
                availability2 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value3 &&
                  psychologyId == psyId) {
                option3 = ' 2.00 PM (Not Available)';
                value3 = '2.00 PM';
                availability3 = false;
              }
              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value4 &&
                  psychologyId == psyId) {
                option4 = ' 4.00 PM (Not Available)';
                value4 = '4.00 PM';
                availability4 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value5 &&
                  psychologyId == psyId) {
                option5 = ' 6.00 PM (Not Available)';
                value5 = '6.00 PM';
                availability5 = false;
              }
              index++;
            }
          });

          setState(() {});
        },
        onSaved: (value) {
          bookingDateEditingController.text = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            Fluttertoast.showToast(msg: "Booking Date Should not be Empty");
            return ("Booking Date is Required for Booking");
          }

          return null;
        },
        textInputAction: TextInputAction.next,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
            errorStyle: (TextStyle(
          fontSize: 10.0,
        ))));

    final timeField = DropdownButtonFormField(
        value: selectedTime,
        items: [
          DropdownMenuItem(
            child: Text(""),
            value: "",
          ),
          DropdownMenuItem(
            child: Text(option1),
            value: value1,
            enabled: availability1,
          ),
          DropdownMenuItem(
            child: Text(option2),
            value: value2,
            enabled: availability2,
          ),
          DropdownMenuItem(
            child: Text(option3),
            value: value3,
            enabled: availability3,
          ),
          DropdownMenuItem(
            child: Text(option4),
            value: value4,
            enabled: availability4,
          ),
          DropdownMenuItem(
            child: Text(option5),
            value: value5,
            enabled: availability5,
          ),
        ],
        onTap: () async {
          option1 = ' 10.00 AM';
          value1 = '10.00 AM';
          availability1 = true;
          option2 = ' 12.00 PM';
          value2 = '12.00 PM';
          availability2 = true;
          option3 = ' 2.00 PM';
          value3 = '2.00 PM';
          availability3 = true;
          option4 = ' 4.00 PM';
          value4 = '4.00 PM';
          availability4 = true;
          option5 = ' 6.00 PM';
          value5 = '6.00 PM';
          availability5 = true;

          await firebaseFirestore.collection("booking").get().then((value) {
            for (var i in value.docs) {
              data.add(i.data());
              String bookDate = data[index]["bookingDate"];
              String bookTime = data[index]["bookingTime"];
              String psychologyId = data[index]["psychologyId"];

              if ((bookDate == bookingDateEditingController.text &&
                  bookTime == value1 &&
                  psychologyId == psyId)) {
                option1 = ' 10.00 AM (Not Available)';
                value1 = '10.00 AM';
                availability1 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value2 &&
                  psychologyId == psyId) {
                option2 = ' 12.00 PM (Not Available)';
                value2 = '12.00 PM';
                availability2 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value3 &&
                  psychologyId == psyId) {
                option3 = ' 2.00 PM (Not Available)';
                value3 = '2.00 PM';
                availability3 = false;
              }
              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value4 &&
                  psychologyId == psyId) {
                option4 = ' 4.00 PM (Not Available)';
                value4 = '4.00 PM';
                availability4 = false;
              }

              if (bookDate == bookingDateEditingController.text &&
                  bookTime == value5 &&
                  psychologyId == psyId) {
                option5 = ' 6.00 PM (Not Available)';
                value5 = '6.00 PM';
                availability5 = false;
              }
              index++;
            }
          });
          setState(() {});
        },
        onChanged: (value) {
          setState(() {
            selectedTime = value.toString();
          });
        },
        validator: (option) {
          if (option == "") {
            Fluttertoast.showToast(msg: "Booking Time Should not be Empty");
            return ("Booking Time Should not be Empty");
          }
          return null;
        },
        onSaved: (value) {
          selectedTime = value.toString();
        },
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),
        decoration: const InputDecoration(
          errorStyle: (TextStyle(
            fontSize: 10.0,
          )),
        ));

    final printButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const viewBooking()));
        },
        child: const Text(
          "Back",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    final cancelButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 30),
        onPressed: () {
          showAlertDialog(context);
        },
        child: const Text(
          "Update",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: const Text('Booking'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 35, 90, 190),
      ),
      body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: Column(
                      children: [
                        Container(
                            width: 300,
                            margin: const EdgeInsets.only(top: 30),
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 90, right: 90),
                            child: const Text(
                              'Booking Details',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(186, 255, 255, 255),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ))),
                        Container(
                            width: 300,
                            height: 310,
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                )),
                            child: Column(
                              children: [
                                Row(children: [
                                  SizedBox(
                                      height: 90,
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(
                                              48), // Image radius
                                          child: Image.network(psyUrl,
                                              fit: BoxFit.fill),
                                        ),
                                      )),
                                  const SizedBox(width: 20),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                          height: 50,
                                          width: 100,
                                          child: psycologistNameField),
                                      const Text(
                                        'Psychologist',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  )
                                ]),
                                Row(
                                  children: [
                                    const Text(
                                      'Patient Name: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: fullNameField),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Date: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: bookingDateField),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Time: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: timeField),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Booking Status: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Expanded(child: bookingStatusField),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(height: 20),
                        Container(
                          width: 300,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              )),
                          child: Row(
                            children: [
                              const Text(
                                'Consultation Fee :',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                              const SizedBox(width: 25),
                              Row(
                                children: [
                                  const Text(
                                    "RM ",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(
                                      height: 50,
                                      width: 64,
                                      child: psycologistPriceNameField),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      cancelButton,
                      const SizedBox(width: 20),
                      printButton
                    ],
                  )
                ],
              ))),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget noButton = FlatButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget yesButton = FlatButton(
      child: const Text("Yes"),
      onPressed: () {
        final docBooking = FirebaseFirestore.instance
            .collection('booking')
            .doc(widget.bookingDetails);

        docBooking.update({
          'bookingStatus': selectedStatus,
          'bookingDate': bookingDateEditingController.text,
          'bookingTime': selectedTime,
        });
        Fluttertoast.showToast(msg: "Your Booking have Been Updated");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const viewBooking()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Are you sure you want to update this Appoinment?"),
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
}
