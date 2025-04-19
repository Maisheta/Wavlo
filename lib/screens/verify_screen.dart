import 'package:flutter/material.dart';
import 'package:chat/screens/Home_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/Orange_Circle.dart'; // دي ديكور الدائرة اللي عندك

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => VerifyScreenState();
}

class VerifyScreenState extends State<VerifyScreen> {
  String otp = '';
  TextEditingController otpController =
      TextEditingController(); // كنترولر لحقل OTP

  void verifyOtp() {
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 4-digit OTP")),
      );
      return;
    }
  }

  void resetOtp() {
    setState(() {
      otp = '';
      otpController.clear(); // يمسح الخانات
    });
  }

  @override
  void dispose() {
    otpController.dispose(); // نفضي الكنترولر لما نخلص
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const OrangeCircleDecoration(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ListView(
              children: [
                const SizedBox(height: 80),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Verification Code",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffF37C50),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "We have sent the verification code to your email address",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                PinCodeTextField(
                  appContext: context,
                  controller: otpController, // ربط الكنترولر هنا
                  length: 4,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xffF37C50),
                  textStyle: const TextStyle(fontSize: 20),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(20),
                    fieldHeight: 65,
                    fieldWidth: 65,
                    inactiveColor:
                        Colors.grey, // لون البوردر لما الخانة مش متفاعلة
                    inactiveFillColor: Color(
                      0xffF37C50,
                    ).withOpacity(0.08), // لون الخلفية لما الخانة مش متفاعلة
                    selectedColor: Color(
                      0xffF37C50,
                    ), // لون البوردر لما الخانة عليها فوكس
                    selectedFillColor:
                        Colors.white, // لون الخلفية لما الخانة عليها فوكس

                    activeFillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      otp = value;
                    });
                  },
                  onCompleted: (value) {
                    otp = value;
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF37C50),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: resetOtp, // إعادة تعيين الكود عند الضغط
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Didn't receive code? ",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(
                              color: Color(0xffF37C50), // اللون البرتقالي بتاعك
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold, // لو عايزها تخينة شوية
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
