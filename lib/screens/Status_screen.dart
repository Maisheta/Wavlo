import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  final List<Map<String, String>> statuses = const [
    {
      'name': 'Jerome Bell',
      'image': 'https://randomuser.me/api/portraits/women/10.jpg',
    },
    {
      'name': 'Cody Fisher',
      'image': 'https://randomuser.me/api/portraits/men/11.jpg',
    },
    {
      'name': 'Arlene McCoy',
      'image': 'https://randomuser.me/api/portraits/women/12.jpg',
    },
    {
      'name': 'Jenny Wilson',
      'image': 'https://randomuser.me/api/portraits/men/13.jpg',
    },
    {
      'name': 'Bessie Cooper',
      'image': 'https://randomuser.me/api/portraits/women/14.jpg',
    },
    {
      'name': 'Cameron Williamson',
      'image': 'https://randomuser.me/api/portraits/men/15.jpg',
    },
    {
      'name': 'Leslie Alexander',
      'image': 'https://randomuser.me/api/portraits/women/16.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // My Status
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/1.jpg',
                    ),
                  ),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor:Color(0xffF37C50),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ],
              ),
              title: const Text("My Status"),
              subtitle: const Text("Tap To Add Status"),
            ),
            const SizedBox(height: 16),

            const Text(
              "Recent Status",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // List of Statuses
            ...statuses.map((status) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color:Color(0xffF37C50), width: 3),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(status['image']!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(status['name']!, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              );
            }),
            const SizedBox(height: 80), // مساحة للزرار تحت
          ],
        ),
        // زرار refresh
        //   Positioned(
        //     bottom: 20,
        //     right: 20,
        //     child: FloatingActionButton(
        //       mini: true,
        //       backgroundColor: Colors.deepOrange,
        //       onPressed: () {},
        //       child: const Icon(Icons.refresh, color: Colors.white),
        //     ),
        //   ),
        //
      ],
    );
  }
}