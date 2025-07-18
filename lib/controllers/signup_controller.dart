import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/home_screen.dart';
import 'package:qentdemo/screens/welcome_screen.dart';

//đối với controller thì statefull stateless cc, chỉ có class và function thôi
//But instead of creating constructor we can declare this function to be of static type. And now we can directly call this function from any file and pass data directly into the function without having to create constructors.
class SignupController {
  static Future<void> createAccount({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String country,
  }) async {
    //hàm đăng ký với firebase
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var userId = FirebaseAuth
          .instance
          .currentUser!
          .uid; //uid ko ddc null nen buoc phai co !

      var db = FirebaseFirestore.instance; //TAO DATABASE

      Map<String, dynamic> data = {
        //buoc co khi tao DB LUON
        "name": name,
        "email": email,
        "country": country,
        "id": userId.toString(),
      }; //TAO CONSTRUCT THE DATA DE SEND VO DOCUMENT

      // try {
      //  //table where u want to insert data, every user has its own doc --> uID

      // }
      // catch(e) {
      //   print(e);
      // }

      try {
        await db.collection("users").doc(userId.toString()).set(data);
        print("Đã lưu dữ liệu thành công");
                      await Provider.of<UserProvider>(context, listen: false).fetchUserData();

        Navigator.pushAndRemoveUntil(
          //xóa lịch sử chỉ navigate tới đúng trang cần tới và kh có nút quay lại
          //đky tài khoản navigate tứi dashboard mà không chạy qua splash- nơi thực hiện việc cập nhật thông tin người dùng vào state, nên bị lỗi hiển thị ở drawer
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
        
      } catch (e) {
        print("LỖI FIRESTORE: $e");
      }
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
