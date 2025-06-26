import 'package:flutter/material.dart';
import 'package:qentdemo/screens/get_otp_screen.dart';
import 'package:qentdemo/screens/login_screen.dart';
import 'package:qentdemo/screens/signup_screen.dart';

class ForgotPassNextScreen extends StatefulWidget {
  const ForgotPassNextScreen({super.key});

  @override
  State<ForgotPassNextScreen> createState() => _ForgotPassNextScreenState();
}

class _ForgotPassNextScreenState extends State<ForgotPassNextScreen> {
  final List<String> countryList = [
    '🇻🇳 Việt Nam',
    '🇺🇸 Hoa Kỳ',
    '🇯🇵 Nhật Bản',
    '🇰🇷 Hàn Quốc',
    '🇫🇷 Pháp',
    '🇬🇧 Anh',
  ];

  TextEditingController sdt = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng
      body: Padding(
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Xác minh số điện thoại của bạn",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Chúng tôi đã gửi cho bạn một tin nhắn SMS có mã đến",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF959595),
                      ),
                    ),

                    SizedBox(height: 30),

                    TextFormField(
                      controller: country,
                      readOnly: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Quốc gia là bắt buộc";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Quốc gia",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return ListView.separated(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: countryList.length,
                                  separatorBuilder: (_, __) => const Divider(),
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      title: Text(countryList[index]),
                                      onTap: () {
                                        country.text = countryList[index];
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    TextFormField(
                    controller: sdt,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Số điện thoại",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 40,),
                    //nut
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                         onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return GetOtpScreen();
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21292B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Tiếp tục",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
