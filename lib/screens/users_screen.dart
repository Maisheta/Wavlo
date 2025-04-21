import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersScreen extends StatefulWidget {
  final String token;

  const UsersScreen({super.key, required this.token});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("🟡 TOKEN in UsersScreen: ${widget.token}");
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

      print("📩 Status Code: ${response.statusCode}");
      print("📩 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          users = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("❌ Failed to fetch users");
      }
    } catch (e) {
      print("🔥 Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
        backgroundColor: const Color(0xffF37C50),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : users.isEmpty
              ? const Center(child: Text("مفيش مستخدمين لعرضهم"))
              : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/1.jpg',
                      ),
                    ),
                    title: Text(user['name'] ?? 'No Name'),
                    subtitle: Text(user['email'] ?? 'No Email'),
                  );
                },
              ),
    );
  }
}
