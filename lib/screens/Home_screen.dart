import 'package:flutter/material.dart';
import 'package:chat/screens/Status_screen.dart';
import 'package:chat/screens/call_screen.dart';
import 'package:chat/screens/Login_Screen.dart';

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
      actions: const [
        Icon(Icons.search, color: Color(0xffF37C50)),
        SizedBox(width: 10),
        Icon(Icons.more_vert, color: Color(0xffF37C50)),
        SizedBox(width: 10),
      ],
      bottom: buildTabBar(),
    );
  }

  Text buildTitle() {
    return Text(
      "WAVLO",
      style: TextStyle(
        fontSize: 22,
        color: Color(0xffF37C50),
        fontWeight: FontWeight.bold,
      ),
    );
    SizedBox(height: 10);
  }

  PreferredSize buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black87,
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

  Widget buildFloatingActionButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          buildMiniFab(Icons.person_add, 'fab1'),
          buildMiniFab(Icons.group, 'fab2'),
          buildMiniFab(Icons.add, 'fab3'),
          const SizedBox(height: 16),
        ],
        FloatingActionButton(
          backgroundColor: Color(0xffF37C50),
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

  FloatingActionButton buildMiniFab(IconData icon, String heroTag) {
    return FloatingActionButton(
      heroTag: heroTag,
      mini: true,
      backgroundColor: Color(0xffF37C50),
      onPressed: () {},
      child: Icon(icon, color: Colors.white),
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'name': 'Jerome Bell',
        'company': 'The Walt Disney Company',
        'time': '2:18 PM',
        'unread': '2',
        'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      },
      {
        'name': 'Cody Fisher',
        'company': 'Starbucks',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      },
      {
        'name': 'Arlene McCoy',
        'company': 'Gillette',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      },
      {
        'name': 'Jenny Wilson',
        'company': 'McDonald\'s',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/women/4.jpg',
      },
      {
        'name': 'Bessie Cooper',
        'company': 'Mitsubishi',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/women/5.jpg',
      },
      {
        'name': 'Cameron Williamson',
        'company': 'Bank of America',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/men/6.jpg',
      },
      {
        'name': 'Leslie Alexander',
        'company': 'IBM',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/men/7.jpg',
      },
      {
        'name': 'Leslie Alexander',
        'company': 'Mitsubishi',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/women/8.jpg',
      },
      {
        'name': 'Leslie Alexander',
        'company': 'See you Tomorrow',
        'time': '2:18 PM',
        'image': 'https://randomuser.me/api/portraits/women/9.jpg',
      },
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(chat['image']!),
          ),
          title: Text(chat['name']!),
          subtitle: Text(chat['company']!),
          trailing: buildTrailing(chat),
        );
      },
    );
  }

  Widget buildTrailing(Map<String, String> chat) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(chat['time']!),
        if (chat.containsKey('unread'))
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xffF37C50),
              shape: BoxShape.circle,
            ),
            child: Text(
              chat['unread']!,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
