import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersListScreen extends StatefulWidget {
  final String token;

  const UsersListScreen({super.key, required this.token});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse("https://wavlo.azurewebsites.net/api/chat/users");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          users = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print("❌ Failed to load users: ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to load users")));
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("❗ Error fetching users: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error fetching users")));
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Registered Users",
          style: TextStyle(
            fontSize: 22,
            color: Color(0xffF37C50),
            fontWeight: FontWeight.bold,
            fontFamily: "ADLaMDisplay",
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : users.isEmpty
              ? const Center(child: Text("No users found"))
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/1.jpg',
                      ),
                    ),
                    title: Text(user['name'] ?? "Unknown User"),
                    subtitle: Text(user['email'] ?? "No email"),
                  );
                },
              ),
    );
  }
}
