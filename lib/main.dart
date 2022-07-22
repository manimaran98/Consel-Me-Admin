import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'admin_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consel-Me Admin App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: const admin_login(),
    );
  }
}
