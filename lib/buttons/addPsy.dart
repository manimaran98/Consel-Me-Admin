import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../admin_home.dart';
import '../model/psycology_model.dart';

class addPsychology extends StatefulWidget {
  const addPsychology({Key? key}) : super(key: key);

  @override
  State<addPsychology> createState() => _addPsychologyState();
}

class _addPsychologyState extends State<addPsychology> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  // string for displaying the error Message

  // form key
  final formKey = GlobalKey<FormState>();

  late String selectedGender = '';
  TextEditingController pyschologyNameEditingController =
      TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController specialEditingController = TextEditingController();
  TextEditingController genderEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController =
      TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  late String errorMessage;
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
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

  void signUp(String email, String password) async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {uploadImage()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      }
    }
  }

  Future uploadImage() async {
    if (formKey.currentState!.validate()) {
      User? user = auth.currentUser;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      psychologyModel PsychologyModel = psychologyModel();

      // writing all the values

      final document =
          firebaseFirestore.collection("psychologists").doc(user!.uid);

      PsychologyModel.psychologyId = user.uid;

      Reference ref = FirebaseStorage.instance
          .ref()
          .child("psychologistImages/${user.uid}");

      if (_image == null) {
        Fluttertoast.showToast(
            msg: "Error!!! Please Upload the psychologist Image");
        return ("Please Upload the Image");
      }

      await ref.putFile(_image!);

      downloadURL = await ref.getDownloadURL();
      PsychologyModel.psychologyName = pyschologyNameEditingController.text;
      PsychologyModel.email = user.email;
      PsychologyModel.imgUrl = downloadURL;
      PsychologyModel.price = priceEditingController.text;
      PsychologyModel.gender = selectedGender;
      PsychologyModel.special = specialEditingController.text;

      await document.set(PsychologyModel.toMap());

      Fluttertoast.showToast(msg: "Successfully Add Psychologist");

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const admin_home()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email Address");
          }

          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid Email");
          }

          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.mail),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is Required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Password Min. 6 Characters");
          }
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    //Confirm Password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password did not match.";
          }
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

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
          if (_image != null) {
            signUp(emailEditingController.text, passwordEditingController.text);
          }
          if (_image == null) {
            Fluttertoast.showToast(
                msg: "Error!!! Please Upload the psychologist Image");
          }
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
              MaterialPageRoute(builder: (context) => const admin_home()));
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
          title: const Text('Add Psychologist'),
          centerTitle: true,
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
                            ? const Center(
                                child: Icon(
                                  Icons.add,
                                  size: 100,
                                ),
                              )
                            : Image.file(_image!),
                      ),
                    ),
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
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
