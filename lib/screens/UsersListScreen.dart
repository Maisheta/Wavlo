import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ChatScreen.dart';

class UsersListScreen extends StatefulWidget {
  final String token;

  const UsersListScreen({super.key, required this.token});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<dynamic> users = [];
  bool isLoading = true;
  final String baseUrl = "https://fe4c-45-244-133-30.ngrok-free.app";

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse("$baseUrl/api/chat/users");

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
          print("Users data: $users");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" Failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(" Error: $e")));
      }
    }
  }

  String formatNameToTwoParts(
    String? name,
    String? firstName,
    String? lastName,
  ) {
    if (name != null && name.trim().isNotEmpty) {
      final nameParts = name.trim().split(RegExp(r'\s+'));
      if (nameParts.length == 1) {
        return nameParts[0];
      } else if (nameParts.length >= 2) {
        return "${nameParts[0]} ${nameParts[1]}";
      }
    }

    final formattedFirstName = (firstName ?? '').trim();
    final formattedLastName = (lastName ?? '').trim();
    if (formattedFirstName.isEmpty && formattedLastName.isEmpty) {
      return "Unknown User";
    } else if (formattedLastName.isEmpty) {
      return formattedFirstName;
    } else if (formattedFirstName.isEmpty) {
      return formattedLastName;
    }
    return "$formattedFirstName $formattedLastName";
  }

  Future<void> createPrivateChat(
    String targetUserId,
    String targetUserName,
    String userImage,
    String firstName,
    String lastName,
  ) async {
    final url = Uri.parse(
      "$baseUrl/api/chat/create-private-chat?userId=$targetUserId&name=$targetUserName",
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final chatData = jsonDecode(response.body);
        String chatId = chatData['chatId'].toString();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatScreen(
                  chatId: chatId,
                  userName: targetUserName,
                  userImage:
                      userImage.isNotEmpty
                          ? userImage
                          : 'https://randomuser.me/api/portraits/men/1.jpg',
                  targetUserId: targetUserId,
                  firstName: firstName,
                  lastName: lastName,
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" Failed to create chat: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(" Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xfff94e22)),
        title: const Text(
          "Registered Users",
          style: TextStyle(
            fontSize: 22,
            color: Color(0xfff94e22),
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

                  String displayName = formatNameToTwoParts(
                    user['name'],
                    user['firstName'],
                    user['lastName'],
                  );

                  final String userImage =
                      user['profileImage'] != null
                          ? '$baseUrl${user['profileImage'].startsWith('/') ? user['profileImage'] : '/${user['profileImage']}'}'
                          : user['imageUrl'] != null
                          ? '$baseUrl${user['imageUrl'].startsWith('/') ? user['imageUrl'] : '/${user['imageUrl']}'}'
                          : 'https://randomuser.me/api/portraits/men/1.jpg';

                  print("User Image URL: $userImage");

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(userImage),
                      onBackgroundImageError: (exception, stackTrace) {
                        print(
                          "Error loading image for ${user['name']}: $exception",
                        );
                      },
                    ),
                    title: Text(displayName),
                    subtitle: Text(user['email'] ?? "No email"),
                    onTap: () {
                      createPrivateChat(
                        user['id'].toString(),
                        displayName,
                        userImage,
                        user['firstName'] ?? '',
                        user['lastName'] ?? '',
                      );
                    },
                  );
                },
              ),
    );
  }
}
