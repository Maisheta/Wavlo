import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chat/screens/Welcome_Screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // وظيفة لتأخير الانتقال لصفحة التطبيق
  _navigateToHome() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(),
        ), // انتقل إلى الصفحة الرئيسية هنا
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/wavlo.png'), // إضافة الصورة هنا
      ),
    );
  }
}
