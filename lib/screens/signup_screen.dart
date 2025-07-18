import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qentdemo/controllers/signup_controller.dart';
import 'package:qentdemo/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  bool _obsecurePass = true;
  bool _rememberMe = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullname = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //KHI QUÁ DÀI THÌ XÀI THG NÀY BỌC LẠI TRÁNH OVERLOAD
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Logo + Qent
              Row(
                children: const [
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

              const SizedBox(height: 35),

              // Welcome Text
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Đăng ký",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 40),

              // Form đăng kys
              Form(
                key: userForm,
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullname,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Cần điền đủ thông tin";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Tên đầy đủ ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email thíu";
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
                    const SizedBox(height: 25),
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
                    const SizedBox(height: 25),

                    TextFormField(
                      controller: country,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Quốc gia";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Quốc gia",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Đăng ký (nút chính)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await SignupController.createAccount(
                      context: context,
                      email: email.text,
                      password: password.text,
                      name: fullname.text,
                      country: country.text,
                    );
                    if (userForm.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      //create account
                      //  await SignupController.createAccount(
                      //     context: context,
                      //     email: email.text,
                      //     password: password.text,
                      //     name: name.text,
                      //     country: country.text,
                      //   );
                      //   isLoading = false;
                      //   setState(() {});
                      //.text là thuộc tính để truy cập nội dung người dùng nhập vào TextField.
                      //Bạn cần .text vì hàm createAccount() yêu cầu dữ liệu kiểu String, không phải TextEditingController.
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21292B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? Expanded(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Text(
                          "Đăng ký",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Hoặc"),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                ],
              ),

              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Đã tạo tài khoản"),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      " Đăng nhập ngay",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
