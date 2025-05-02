import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/screens/status_screen.dart';
import 'package:chat/screens/call_screen.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:chat/screens/Login_Screen.dart';
import 'package:chat/screens/SettingsScreen.dart';
import 'package:chat/screens/UsersListScreen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  List<dynamic> chats = [];
  bool isLoading = true;
  bool _fabExpanded = false;
  String? token;

  @override
  void initState() {
    super.initState();
    loadTokenAndFetchChats();
  }

  Future<void> loadTokenAndFetchChats() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token == null) {
      print("❗ No token found");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No token found. Please login again.")),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      }
    } else {
      fetchChats();
    }
  }

  Future<void> fetchChats() async {
    final url = Uri.parse("https://wavlo.azurewebsites.net/api/chat/chats");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      setState(() {
        chats = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print("❌ Failed to load chats: ${response.body}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load chats")));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final refreshToken = prefs.getString('refresh_token');

    print("📤 Sending logout request...");
    print("🪪 Access Token: $token");
    print("🔄 Refresh Token: $refreshToken");

    if (token == null ||
        token.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      print("❗ Token is missing");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No token found, please login first")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://wavlo.azurewebsites.net/api/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      print("📡 Logout Status Code: ${response.statusCode}");
      print("📥 Logout Response: ${response.body}");

      if (response.statusCode == 200) {
        await prefs.clear();
        print("✅ Logout successful, token cleared");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      } else {
        print("❌ Logout failed: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Logout failed: ${response.statusCode} - ${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      print("❗ Logout exception: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logout error occurred")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                  children: [
                    buildChatList(),
                    const StatusScreen(),
                    const CallScreen(),
                  ],
                ),
        floatingActionButton: buildFloatingActionButton(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: buildTitle(),
      actions: [
        const Icon(Icons.search, color: Color(0xffF37C50)),
        const SizedBox(width: 10),
        Theme(
          data: ThemeData(
            popupMenuTheme: PopupMenuThemeData(color: Colors.white),
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(-18, 40),
            icon: const Icon(Icons.more_vert, color: Color(0xffF37C50)),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  print("🧑‍💼 Profile selected");
                  break;
                case 'Starred message':
                  print("❓ Help selected");
                  break;
                case 'help':
                  print("❓ Help selected");
                  break;
                case 'Setting':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'profile',
                    child: Text('Profile'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Starred message',
                    child: Text('Starred message'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'help',
                    child: Text('Help'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Setting',
                    child: Text('Setting'),
                  ),
                ],
          ),
        ),

        const SizedBox(width: 10),
      ],
      bottom: buildTabBar(),
    );
  }

  Text buildTitle() {
    return const Text(
      "Wavlo",
      style: TextStyle(
        fontSize: 22,
        color: Color(0xffF37C50),
        fontWeight: FontWeight.bold,
        fontFamily: "ADLaMDisplay",
      ),
    );
  }

  PreferredSize buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicator: BoxDecoration(
            color: Color(0xffF37C50),
            borderRadius: BorderRadius.circular(30),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(child: Center(child: Text("All Chats"))),
            Tab(child: Center(child: Text("Status"))),
            Tab(child: Center(child: Text("Call"))),
          ],
        ),
      ),
    );
  }

  Widget buildChatList() {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/1.jpg',
            ),
          ),
          title: Text(chat['name'] ?? "Chat Name"),
          subtitle: Text(chat['company'] ?? "Company Name"),
          trailing: buildTrailing(chat),
          onTap: () {
            // Navigate to chat screen
          },
        );
      },
    );
  }

  Widget buildTrailing(Map<String, dynamic> chat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(chat['time'] ?? 'No time'),
        if (chat['unread'] != null && chat['unread'] > 0)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xffF37C50),
              shape: BoxShape.circle,
            ),
            child: Text(
              chat['unread'].toString(),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Column buildFloatingActionButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          buildMiniFab(Icons.person_add, 'fab1', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UsersListScreen(token: token!),
              ),
            );
          }),
          buildMiniFab(Icons.group, 'fab2', () {}),
          buildMiniFab(Icons.add, 'fab3', () {}),
          const SizedBox(height: 16),
        ],
        FloatingActionButton(
          backgroundColor: const Color(0xffF37C50),
          onPressed: toggleFab,
          shape: const CircleBorder(),
          child: Icon(
            _fabExpanded ? Icons.close : Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  FloatingActionButton buildMiniFab(
    IconData icon,
    String heroTag, [
    VoidCallback? onPressed,
  ]) {
    return FloatingActionButton(
      heroTag: heroTag,
      mini: true,
      backgroundColor: const Color(0xffF37C50),
      onPressed: onPressed ?? () {},
      child: Icon(icon, color: Colors.white),
    );
  }

  void toggleFab() {
    setState(() {
      _fabExpanded = !_fabExpanded;
    });
  }
}
