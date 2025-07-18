import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/home_screen.dart';
import 'package:qentdemo/screens/welcome_screen.dart';

class LoginController {
 static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
              await Provider.of<UserProvider>(context, listen: false).fetchUserData();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ),
        (route) {
          return false;
        },
      );
      print("Login Succefully");
    } catch (e) {
      //simple message provided by scaffold used for provide feedback to the user
      SnackBar messageSnackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(messageSnackBar);
      print(e);
    }
  }
}
