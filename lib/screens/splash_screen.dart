import 'package:flutter/material.dart';
import 'package:qentdemo/providers/userProvider.dart';
import 'package:qentdemo/screens/home_screen.dart';
import 'package:qentdemo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    //phải sử dụng init state ở đây bởi vì chức năng này sẽ được gọi duy nhất lần đầu khi tạo (mounted), sau đó có thể chuyển hướng người dùng với splash screen

    //Đầu tiên là check user login status
    Future.delayed(Duration(seconds: 3), () {
      if (user == null) {
        openLogin();
      } else {
        openHomescreen();
      }
      // openDashboard();
    });

    super.initState();
  }

  void openHomescreen() {
    Provider.of<UserProvider>(
      context,
      listen: false,
    ).fetchUserData(); //khi viết provider ngoài hàm build thì phải khai báo thêm listen false

    Navigator.pushReplacement(
      //để cho ko có nút quay lại
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ),
    );
  }

  void openLogin() {
    user == null ?
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    ): HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Splash Screen")));
  }
}
