import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';

class GetOtpScreen extends StatefulWidget {
  const GetOtpScreen({super.key});

  @override
  State<GetOtpScreen> createState() => _GetOtpScreenState();
}

class _GetOtpScreenState extends State<GetOtpScreen> with CodeAutoFill {
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();

  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();

  Timer? _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    listenForCode();
    _startCountdown();
  }

  @override
  void dispose() {
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    final code = this.code ?? '';
    if (code.length >= 4) {
      setState(() {
        otp1.text = code[0];
        otp2.text = code[1];
        otp3.text = code[2];
        otp4.text = code[3];
      });
    }
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            children: [
              // Logo + Qent
              Row(
                children: const [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.directions_car, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Qent",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                "Nhập mã xác minh",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),
              const Text(
                "Chúng tôi đã gửi mã xác nhận đến :\n+84 94***",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 32),

              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _otpBox(controller: otp1, focus: focus1, nextFocus: focus2),
                  const SizedBox(width: 16),
                  _otpBox(controller: otp2, focus: focus2, nextFocus: focus3),
                  const SizedBox(width: 16),
                  _otpBox(controller: otp3, focus: focus3, nextFocus: focus4),
                  const SizedBox(width: 16),
                  _otpBox(controller: otp4, focus: focus4, nextFocus: null),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final otp = otp1.text + otp2.text + otp3.text + otp4.text;
                    print("OTP: $otp");
                    // Gửi OTP để xác thực tại đây
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21292B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
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

              const SizedBox(height: 20),

              _canResend
                  ? TextButton(
                      onPressed: () {
                        print("Gửi lại OTP...");
                        _startCountdown();
                      },
                      child: const Text(
                        "Chưa nhận được OTP? Gửi lại.",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  : Text(
                      "Gửi lại sau $_secondsRemaining giây",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox({
    required TextEditingController controller,
    required FocusNode focus,
    FocusNode? nextFocus,
  }) {
    return SizedBox(
      width: 67,
      height: 63,
      child: TextField(
        controller: controller,
        focusNode: focus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
      ),
    );
  }
}
