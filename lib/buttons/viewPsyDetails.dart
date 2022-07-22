import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/buttons/viewPsy.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../admin_home.dart';
import '../model/psycology_model.dart';

class viewPsyDetails extends StatefulWidget {
  const viewPsyDetails({key, required this.psychologist});
  final String psychologist;

  @override
  State<viewPsyDetails> createState() => _viewPsyDetailsState();
}

class _viewPsyDetailsState extends State<viewPsyDetails> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  // string for displaying the error Message

  // form key
  final formKey = GlobalKey<FormState>();

  psychologyModel PsychologyModel = psychologyModel();

  late String selectedGender = '';
  TextEditingController pyschologyNameEditingController =
      TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController specialEditingController = TextEditingController();
  TextEditingController genderEditingController = TextEditingController();
  late String errorMessage;
  late String psyImg =
      "https://firebasestorage.googleapis.com/v0/b/consel-me-6938b.appspot.com/o/psychologistImages%2Fuser.png?alt=media&token=192696e8-ec72-4886-889d-0a6fac05ddf8";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("psychologists")
        .doc(widget.psychologist)
        .get()
        .then((value) {
      PsychologyModel = psychologyModel.fromMap(value.data());
      pyschologyNameEditingController.text =
          "${PsychologyModel.psychologyName}";
      psyImg = "${PsychologyModel.imgUrl}";
      priceEditingController.text = "${PsychologyModel.price}";
      selectedGender = "${PsychologyModel.gender}";
      specialEditingController.text = "${PsychologyModel.special}";

      setState(() {});
    });
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No File is Selected", Duration(milliseconds: 400));
      }
    });
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future uploadImage() async {
    if (formKey.currentState!.validate()) {
      if (_image == null) {
        final docPsy = FirebaseFirestore.instance
            .collection('psychologists')
            .doc(widget.psychologist);

        docPsy.update({
          'gender': selectedGender,
          'price': priceEditingController.text,
          'psychologyName': pyschologyNameEditingController.text,
          'special': specialEditingController.text,
        });
      } else {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child("psychologistImages/${widget.psychologist}");
        await ref.putFile(_image!);
        downloadURL = await ref.getDownloadURL();

        final docPsy = FirebaseFirestore.instance
            .collection('psychologists')
            .doc(widget.psychologist);

        docPsy.update({
          'gender': selectedGender,
          'imgUrl': downloadURL,
          'price': priceEditingController.text,
          'psychologyName': pyschologyNameEditingController.text,
          'special': specialEditingController.text,
        });
      }

      Fluttertoast.showToast(msg: "Psychologist details is updated.");

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const admin_home()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final psyNameField = TextFormField(
        autofocus: false,
        controller: pyschologyNameEditingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Psychology Name is Required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Name Min. 3 Characters");
          }
          return null;
        },
        onSaved: (value) {
          pyschologyNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_box_outlined),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            labelText: 'Psychology Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final price = TextFormField(
        autofocus: false,
        controller: priceEditingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Price is Required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Price");
          }
          return null;
        },
        onSaved: (value) {
          priceEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_box_outlined),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            labelText: 'Price',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final specialField = TextFormField(
        autofocus: false,
        controller: specialEditingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Psychology Special is Required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Min. 3 Characters");
          }
          return null;
        },
        onSaved: (value) {
          specialEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_box_outlined),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            labelText: 'Psychology Speciality',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final genderField = DropdownButtonFormField(
        value: selectedGender,
        items: const [
          DropdownMenuItem(
            child: Text(""),
            value: "",
          ),
          DropdownMenuItem(
            child: Text("Male"),
            value: "Male",
          ),
          DropdownMenuItem(
            child: Text("Female"),
            value: "Female",
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedGender = value.toString();
          });
        },
        validator: (value) {
          if (value == "") {
            return ("Gender is Required");
          }

          return null;
        },
        onSaved: (value) {
          selectedGender = value.toString();
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.people),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            labelText: 'Gender',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          uploadImage();
        },
        child: const Text(
          "Save",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    final cancelButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.red,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const viewPsy()));
        },
        child: const Text(
          "Back",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 35, 90, 190),
          elevation: 0,
          title: const Text('View Psychologist'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        imagePickerMethod();
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.black,
                              width: 5,
                            )),
                        child: _image == null
                            ? Center(
                                child: Image.network(psyImg, fit: BoxFit.fill),
                              )
                            : Image.file(_image!),
                      ),
                    ),
                    SizedBox(height: 30),
                    psyNameField,
                    SizedBox(height: 20),
                    price,
                    SizedBox(height: 20),
                    specialField,
                    SizedBox(height: 20),
                    genderField,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        cancelButton,
                        SizedBox(width: 20),
                        saveButton,
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
