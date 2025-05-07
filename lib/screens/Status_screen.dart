import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<Map<String, String>> statuses = [];

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  Future<void> fetchStories() async {
    final url = Uri.parse("https://wavlo.azurewebsites.net/api/Story/stories");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> storyData = jsonDecode(response.body);

        setState(() {
          statuses =
              storyData.map<Map<String, String>>((story) {
                final storyMap = story as Map<String, dynamic>;
                return {
                  'name': storyMap['name']?.toString() ?? 'No Name',
                  'image': storyMap['image']?.toString() ?? '',
                };
              }).toList();
        });
      } else {
        print("Failed to fetch stories: ${response.body}");
      }
    } catch (e) {
      print("Error fetching stories: $e");
    }
  }

  Future<void> uploadStory() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      final url = Uri.parse("https://wavlo.azurewebsites.net/api/Story/upload");

      var request =
          http.MultipartRequest('POST', url)
            ..headers['Content-Type'] = 'application/x-www-form-urlencoded'
            ..fields['MediaFile'] =
                await file
                    .readAsString(); 
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Story uploaded successfully");
        fetchStories();
      } else {
        print("Failed to upload story: ${response.statusCode}");
      }
    }
  }

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
                    backgroundColor: Color(0xffF37C50),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ],
              ),
              title: const Text(
                "My Status",
                style: TextStyle(fontSize: 19, color: Color(0xFF1B222C)),
              ),
              subtitle: const Text(
                "Tap To Add Status",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              onTap: uploadStory, 
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
                        border: Border.all(color: Color(0xffF37C50), width: 3),
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
            }).toList(),
            const SizedBox(height: 80), 
          ],
        ),
      ],
    );
  }
}
