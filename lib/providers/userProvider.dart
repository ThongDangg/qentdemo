import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier { //turn to global state need extends ChangeNotifier


  String userName = "";
  String userEmail = "";
  String userId = "";

var db = FirebaseFirestore.instance;

 


  void getUserDetails() { //GET DATA VOI PROVIDER
   var authUser = FirebaseAuth
        .instance
        .currentUser; //vì key của doc là users chúng ta tạo khi authenticate nên phải lấy ID của nó và ID k dc null
    print("Current user id: ${authUser?.uid}");
    db.collection("users").doc(authUser!.uid).get().then((dataSnapshot) {
      
    userName = dataSnapshot.data()?["name"] ?? "";
      userEmail = dataSnapshot.data()?["email"] ?? "";
      userId = dataSnapshot.data()?["id"] ?? "";
      
      notifyListeners(); //SET STATE HANG HIEU
    });
  }
}
