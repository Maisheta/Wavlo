import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chat/screens/Account_Screen.dart';
import 'package:chat/screens/Home_screen.dart';
import '../components/Orange_Circle.dart';
import '../components/TextField.dart';
import 'package:http/http.dart' as http;
import 'package:chat/screens/ForgotPasswordScreen.dart';
import 'ChatsListScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  String email = '';
  String password = '';

  Future<void> login() async {
    print("Login function called ✅");

    try {
      final response = await http.post(
        Uri.parse('https://wavlo.azurewebsites.net/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("📡 Status Code: ${response.statusCode}");
      print(
        "📥 Sent Body: ${jsonEncode({'email': email, 'password': password})}",
      );
      print("📤 Response Body: ${response.body}");

      // Login response sample
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final token = decoded['token'];
        final refreshToken = decoded['refreshToken'];

        // 🧠 Save tokens locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', decoded['token']);
        await prefs.setString('refreshToken', decoded['refreshToken']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatsListScreen(token: token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error: $e");
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
                    "Login here",
                    textAlign: TextAlign.center,
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
                    "Good to see you again!\nLog in and start chatting",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Email
                CustomTextField(
                  label: "Email",
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),

                const SizedBox(height: 15),

                // Password
                CustomTextField(
                  label: "Password",
                  isPassword: true,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Color(0xffF37C50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login button
                ElevatedButton(
                  onPressed: () {
                    login();
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
                    "Sign in",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 20),

                // Create account link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create new account",
                      style: TextStyle(color: Colors.black87, fontSize: 16),
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
