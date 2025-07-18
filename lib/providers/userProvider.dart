import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = "";
  String userEmail = "";
  String userId = "";

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch user data from Firestore and update state
  Future<void> fetchUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print("Không tìm thấy người dùng đã đăng nhập.");
        return;
      }

      final doc = await _db.collection("users").doc(currentUser.uid).get();

      final data = doc.data();
      if (data != null) {
        userName = data["name"] ?? "";
        userEmail = data["email"] ?? "";
        userId = data["id"] ?? "";
        notifyListeners();
        print("Thông tin người dùng đã được load vào Provider.");
      } else {
        print("Không có dữ liệu người dùng trong Firestore.");
      }
    } catch (e) {
      print("Lỗi khi load thông tin người dùng: $e");
    }
  }
}
