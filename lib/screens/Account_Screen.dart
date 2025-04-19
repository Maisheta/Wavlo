import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/Orange_Circle.dart';
import '../components/TextField.dart';
import 'Home_screen.dart';

class Account_Screen extends StatefulWidget {
  const Account_Screen({super.key});

  @override
  State<Account_Screen> createState() => _Account_ScreenState();
}

class _Account_ScreenState extends State<Account_Screen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  Future<void> register() async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://wavlo.azurewebsites.net/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'profileImage': '',
        }),
      );

      print("📡 Status Code: ${response.statusCode}");
      print(
        "📥 Body Sent: ${jsonEncode({'firstName': firstName, 'lastName': lastName, 'email': email, 'password': password, 'confirmPassword': confirmPassword, 'profileImage': ''})}",
      );
      print("📤 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Registration failed';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ $errorMessage")));
      }
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error connecting to server")),
      );
    }
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
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffF37C50),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: "First Name",
                  onChanged: (value) => setState(() => firstName = value),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: "Last Name",
                  onChanged: (value) => setState(() => lastName = value),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: "Email",
                  onChanged: (value) => setState(() => email = value),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: "Password",
                  isPassword: true,
                  onChanged: (value) => setState(() => password = value),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: "Confirm Password",
                  isPassword: true,
                  onChanged: (value) => setState(() => confirmPassword = value),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF37C50),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
