import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatsListScreen extends StatefulWidget {
  final String token;

  const ChatsListScreen({super.key, required this.token});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<dynamic> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  Future<void> fetchChats() async {
    final url = Uri.parse("https://wavlo.azurewebsites.net/api/chat/chats");
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        chats = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print("❌ Failed to load chats: ${response.body}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load chats")));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Chats"),
        backgroundColor: const Color(0xffF37C50),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ListTile(
                    title: Text("Chat ID: ${chat['id']}"),
                    subtitle: Text("Created: ${chat['createdAt']}"),
                    onTap: () {
                      // لما نضغط عليه نروح لصفحة المحادثة (هتضيفيها لاحقًا)
                    },
                  );
                },
              ),
    );
  }
}
