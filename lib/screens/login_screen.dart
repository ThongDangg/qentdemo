import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qentdemo/controllers/login_controller.dart';
import 'package:qentdemo/screens/forgot_pass_screen.dart';
import 'package:qentdemo/screens/signup_screen.dart';
import 'package:qentdemo/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  //state thì phải đặt ở đây
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obsecurePass = true;
  bool _rememberMe = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController country = TextEditingController();

  var userForm =
      GlobalKey<FormState>(); //tạo key cho đối tượng nào đó để validate

  bool isLoading = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 50),

              // Logo + Qent
              Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage('assets/images/logo_app_2.png'),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 14),
                  Text(
                    'Qent',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35),

              // chào
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 40),

              // Form đăng nhập
              Form(
                key: userForm,
                child: Column(
                  children: [
                    TextFormField(
                      controller: email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      controller: password,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                      obscureText: _obsecurePass,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obsecurePass = !_obsecurePass;
                            });
                          },
                          icon: Icon(
                            _obsecurePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Remember + Forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(unselectedWidgetColor: Colors.grey[600]),
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          activeColor: Colors.grey[800],
                          checkColor: Colors.white,
                        ),
                      ),
                      Text("Nhớ tài khoản này"),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ForgotPassScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Quên mật khẩu",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Đăng ký (nút chính)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  
                  onPressed: () async {
                    // Xử lý khi nhấn

                    if (userForm.currentState!.validate()) {
                      
                      isLoading = true;
                      setState(() {});

                      await LoginController.login(
                        context: context,
                        email: email.text,
                        password: password.text,
                      );
                    }
                    isLoading = true;
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF21292B),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(color: Colors.white,),
                  ) : Text(
                    "Đăng nhập",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Hoặc"),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                ],
              ),

              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.facebook, color: Colors.black),
                  label: Text(
                    "Facebook",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    side: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.mail, color: Colors.black),
                  label: Text(
                    "Gmail",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    side: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bạn chưa tạo tài khoản?"),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignupScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      " Đăng ký",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomeScreen();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF21292B),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "ádsadasd",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
