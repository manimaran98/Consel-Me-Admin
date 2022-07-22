import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consel_me_admin/admin_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../model/user_model.dart';

class addUser extends StatefulWidget {
  const addUser({Key? key}) : super(key: key);

  @override
  State<addUser> createState() => _addUserState();
}

class _addUserState extends State<addUser> {
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
  }

  @override
  Widget build(BuildContext context) {
    //name field
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

    final saveButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.green,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
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
        title: const Text('User Profile'),
        centerTitle: true,
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
                    emailField,
                    const SizedBox(height: 10),
                    passwordField,
                    const SizedBox(height: 10),
                    confirmPasswordField,
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

  void signUp(String email, String password) async {
    if (formKey.currentState!.validate()) {
      try {
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
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

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.mobile = mobileEditingController.text;
    userModel.icNum = icEditingController.text;
    userModel.birthDate = birthDateEditingController.text;
    userModel.gender = selectedGender.toString();
    userModel.occupation = occupationEditingController.text;
    userModel.role = selectedRole.toString();

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const admin_home()),
        (route) => false);
  }
}
