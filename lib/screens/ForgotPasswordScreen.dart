import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/screens/ResetPasswordScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendResetCode() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📧 Please enter your email")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://wavlo.azurewebsites.net/api/auth/forget-Password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("🔁 Status: ${response.statusCode}");
      print("💬 Response: ${response.body}");

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email),
          ),
        );

        // تقدر هنا تبعت المستخدم لصفحة كتابة الكود والباسورد الجديد لو عايز.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to send reset code")),
        );
      }
    } catch (e) {
      print("Error sending reset request: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Error sending request")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Enter your email and we’ll send you a password reset code.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: sendResetCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF37C50),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Send Reset Code"),
            ),
          ],
        ),
      ),
    );
  }
}
