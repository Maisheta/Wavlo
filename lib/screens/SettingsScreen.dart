import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat/screens/Account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _profileImageUrl = '';
  final String baseUrl = "https://fe4c-45-244-133-30.ngrok-free.app";
  final String defaultImage = "https://randomuser.me/api/portraits/men/1.jpg";
  String? token;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getString('userId');

    setState(() {
      _firstName = prefs.getString('firstName') ?? '';
      _lastName = prefs.getString('lastName') ?? '';
      _email = prefs.getString('email') ?? 'No data available';
      String? profileImage = prefs.getString('profileImage');
      _profileImageUrl =
          profileImage != null && profileImage.isNotEmpty
              ? profileImage.startsWith('http')
                  ? profileImage
                  : '$baseUrl${profileImage.startsWith('/') ? profileImage : '/$profileImage'}'
              : defaultImage;
    });

    if (token != null && userId != null) {
      try {
        final response = await http.get(
          Uri.parse("$baseUrl/api/auth/me"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          String? profileImage = userData['profileImage'];
          await prefs.setString('profileImage', profileImage ?? '');
          setState(() {
            _profileImageUrl =
                profileImage != null && profileImage.isNotEmpty
                    ? profileImage.startsWith('http')
                        ? profileImage
                        : '$baseUrl${profileImage.startsWith('/') ? profileImage : '/$profileImage'}'
                    : defaultImage;
          });
        } else {
          print(
            "Failed to fetch user data: Status ${response.statusCode}, ${response.body}",
          );
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }

    print(" First Name: $_firstName");
    print(" Last Name: $_lastName");
    print(" Profile Image: ${prefs.getString('profileImage')}");
    print(" Profile Image URL: $_profileImageUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xfff94e22),
        elevation: 0,
        title: const Text(
          'Setting',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 16),
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage(_profileImageUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  print("Error loading image: $exception");
                  setState(() {
                    _profileImageUrl = defaultImage;
                  });
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_firstName $_lastName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your Caption here',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.qr_code, color: Color(0xfff94e22)),
            ],
          ),
          const SizedBox(height: 20),

          _buildSettingsItem(
            Icons.person,
            'Account',
            'Security, Change number',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),

          _buildSettingsItem(
            Icons.lock,
            'Privacy',
            'Personal info, Read receipts',
          ),
          _buildSettingsItem(Icons.chat, 'Chats', 'Theme, wallpapers'),
          _buildSettingsItem(
            Icons.notifications,
            'Notification',
            'Message, call tones',
          ),
          _buildSettingsItem(
            Icons.storage,
            'Storage and data',
            'Network usage',
          ),
          _buildSettingsItem(
            Icons.language,
            'App Language',
            "(device's language)",
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: const Color(0xfff94e22)),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(subtitle),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
