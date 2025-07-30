import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data dummy untuk notifikasi
    final List<Map<String, String>> notifications = [
      {'title': 'Komentar Baru', 'message': 'Kriston Watson mengomentari artikel Anda!', 'time': '1 jam lalu'},
      {'title': 'Like Baru', 'message': 'Sarah Johnson menyukai artikel Anda!', 'time': '2 jam lalu'},
      {'title': 'Mendekati Batas', 'message': 'Hampir kehabisan kuota notifikasi harian!', 'time': '3 jam lalu'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF4A90E2),
                child: Icon(Icons.notifications, color: Colors.white),
              ),
              title: Text(
                notification['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${notification['message']} - ${notification['time']}'),
              onTap: () {
                // TODO: Implement action saat notifikasi diklik
              },
            ),
          );
        },
      ),
    );
  }
}