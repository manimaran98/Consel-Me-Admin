import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/buttons/viewUser.dart';
import 'package:consel_me_admin/checkUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../admin_home.dart';
import '../model/user_model.dart';

// ignore: camel_case_types
class viewUserDetails extends StatefulWidget {
  const viewUserDetails({key, required this.userId});

  final String userId;

  @override
  State<viewUserDetails> createState() => _viewUserDetailsState();
}

class _viewUserDetailsState extends State<viewUserDetails> {
  final auth = FirebaseAuth.instance;

  // string for displaying the error Message

  // form key
  final formKey = GlobalKey<FormState>();

  late DateTime date;

  late String selectedRole = '';
  late String selectedGender = '';
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController mobileEditingController = TextEditingController();
  TextEditingController icEditingController = TextEditingController();
  TextEditingController birthDateEditingController = TextEditingController();
  TextEditingController genderEditingController = TextEditingController();
  TextEditingController roleEditingController = TextEditingController();
  TextEditingController occupationEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController confirmPasswordEditingController =
      TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  late String errorMessage;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userId)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      firstNameEditingController.text = "${loggedInUser.firstName}";
      mobileEditingController.text = "${loggedInUser.mobile}";
      icEditingController.text = "${loggedInUser.icNum}";
      birthDateEditingController.text = "${loggedInUser.birthDate}";
      selectedRole = "${loggedInUser.role}";
      selectedGender = "${loggedInUser.gender}";
      occupationEditingController.text = "${loggedInUser.occupation}";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final fullNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name is Required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Name Min. 3 Characters");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_box_outlined),
            contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            labelText: 'First Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final mobileField = TextFormField(
        autofocus: false,
        controller: mobileEditingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{10,}$');
          if (value!.isEmpty) {
            return ("Mobile is Required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Mobile Number");
          }

          return null;
        },
        onSaved: (value) {
          mobileEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.account_box_outlined),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            labelText: 'Mobile Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final icField = TextFormField(
        autofocus: false,
        controller: icEditingController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your IC XXXXXX-XX-XXXX");
          }

          if (!RegExp("\\d{6}\\-\\d{2}\\-\\d{4}").hasMatch(value)) {
            return ("Please Enter a valid IC Number");
          }

          return null;
        },
        onSaved: (value) {
          icEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.perm_identity_rounded),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: 'XXXXXX-XX-XXXX',
            labelText: 'IC Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final birthDateField = TextFormField(
        controller: birthDateEditingController,
        onTap: () async {
          DateTime? date = DateTime(1900);
          //FocusScope.of(context).requestFocus(FocusNode());

          date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          birthDateEditingController.text =
              DateFormat('dd/MM/yyyy').format(date ?? DateTime.now());
        },
        onSaved: (value) {
          occupationEditingController.text = value!;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return ("Date is Required");
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_month),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            labelText: 'Birth Date',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final roleField = DropdownButtonFormField(
        value: selectedRole,
        items: const [
          DropdownMenuItem(
            child: Text(""),
            value: "",
          ),
          DropdownMenuItem(
            child: Text("User"),
            value: "User",
          ),
          DropdownMenuItem(
            child: Text("Admin"),
            value: "Admin",
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedRole = value.toString();
          });
        },
        validator: (value) {
          if (value == "") {
            return ("Role is Required");
          }

          return null;
        },
        onSaved: (value) {
          selectedRole = value.toString();
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.people),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            labelText: 'Role',
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

    final occupationField = TextFormField(
        autofocus: false,
        controller: occupationEditingController,
        keyboardType: TextInputType.text,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Occupation is Required");
          }

          if (!regex.hasMatch(value)) {
            return ("Please Enter Valid Occupation Min. 3 Characters");
          }

          return null;
        },
        onSaved: (value) {
          occupationEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.work),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            labelText: 'Occupation',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final docUser = FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userId);

            docUser.update({
              'firstName': firstNameEditingController.text,
              'mobile': mobileEditingController.text,
              'icNum': icEditingController.text,
              'birthDate': birthDateEditingController.text,
              'gender': selectedGender.toString(),
              'role': selectedRole.toString(),
              'occupation': occupationEditingController.text
            });
            Fluttertoast.showToast(msg: "User Data Have Been Updated");

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const admin_home()));
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const viewUser()));
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
        title: const Text('Edit User Data'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 120,
                        child: Image.asset("assets/user.png",
                            fit: BoxFit.contain)),
                    const SizedBox(height: 10),
                    fullNameField,
                    const SizedBox(height: 10),
                    mobileField,
                    const SizedBox(height: 10),
                    icField,
                    const SizedBox(height: 10),
                    roleField,
                    const SizedBox(height: 10),
                    birthDateField,
                    const SizedBox(height: 10),
                    genderField,
                    const SizedBox(height: 10),
                    occupationField,
                    const SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          cancelButton,
                          const SizedBox(width: 20),
                          saveButton,
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
