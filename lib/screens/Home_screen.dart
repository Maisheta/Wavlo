import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:chat/screens/status_screen.dart';
import 'package:chat/screens/call_screen.dart';
import 'package:chat/screens/SettingsScreen.dart';
import 'package:chat/screens/UsersListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _fabExpanded = false;

  void toggleFab() {
    setState(() {
      _fabExpanded = !_fabExpanded;
    });
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  Future<void> navigateToUsersList(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    print(" FAB1 Pressed - Token: $token");

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" Please log in to access users list")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UsersListScreen(token: token)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(),
        body: const TabBarView(
          children: [ChatList(), StatusScreen(), CallScreen()],
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
            popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(-18, 40),
            icon: const Icon(Icons.more_vert, color: Color(0xffF37C50)),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  print("Profile selected");
                  break;
                case 'Starred message':
                  print(" Help selected");
                  break;
                case 'help':
                  print(" Help selected");
                  break;
                case 'Setting':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                  break;
                case 'logout':
                  logout(context);
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
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
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
    return const PreferredSize(
      preferredSize: Size.fromHeight(68),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: TabBar(
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black87,
          indicator: BoxDecoration(
            color: Color(0xffF37C50),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(child: Center(child: Text("All Chats"))),
            Tab(child: Center(child: Text("Status"))),
            Tab(child: Center(child: Text("Call"))),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          buildMiniFab(Icons.person_add, 'fab1', () {
            navigateToUsersList(context);
          }),
          buildMiniFab(Icons.group, 'fab2', () {
            print("Group FAB pressed");
          }),
          buildMiniFab(Icons.add, 'fab3', () {
            print("Add FAB pressed");
          }),
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
}

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.message_outlined,
            size: 80,
            color: Color(0xffF37C50),
          ),
          const SizedBox(height: 20),
          const Text(
            "Start a New Chat",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xffF37C50),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You can start a conversation with anyone here.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
