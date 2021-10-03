// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:senior_project/screens/Home.dart';
import 'package:senior_project/screens/Login.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isLogged = pref?.getBool('isLogged');
  String userID = pref?.getString('userID');
  runApp(MaterialApp(
    home: isLogged == true
        ? HomeScreen(
            userId: userID,
          )
        : const LoginScreen(),
  ));
}
