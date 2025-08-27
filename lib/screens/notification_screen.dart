import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Postingan Anda Disukai',
      'message': 'Sarah menyukai artikel "Review buku: ATOMIC HABITS"',
      'time': '2 menit lalu',
      'isRead': false,
      'type': 'like',
      'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150&h=150&fit=crop&crop=face',
    },
    {
      'title': 'Komentar Baru',
      'message': 'John Doe mengomentari postingan Anda',
      'time': '15 menit lalu',
      'isRead': false,
      'type': 'comment',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    },
    {
      'title': 'Follower Baru',
      'message': 'Alex Johnson mulai mengikuti Anda',
      'time': '1 jam lalu',
      'isRead': true,
      'type': 'follow',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
    },
    {
      'title': 'Artikel Trending',
      'message': 'Artikel Anda masuk ke trending hari ini!',
      'time': '3 jam lalu',
      'isRead': true,
      'type': 'trending',
      'avatar': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in notifications) {
                  notification['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua notifikasi telah ditandai sebagai dibaca'),
                  backgroundColor: Color(0xFF7ED6A8),
                ),
              );
            },
            child: const Text(
              'Tandai Semua',
              style: TextStyle(
                color: Color(0xFF7ED6A8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: notification['isRead'] ? Colors.white : const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: notification['isRead'] ? Colors.grey[200]! : const Color(0xFF7ED6A8).withOpacity(0.3),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: notification['avatar'] != null
                    ? NetworkImage(notification['avatar'])
                    : null,
                backgroundColor: const Color(0xFF7ED6A8),
                child: notification['avatar'] == null
                    ? Icon(
                        _getNotificationIcon(notification['type']),
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
              title: Text(
                notification['title'],
                style: TextStyle(
                  fontWeight: notification['isRead'] ? FontWeight.w500 : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'],
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: notification['isRead']
                  ? null
                  : Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7ED6A8),
                        shape: BoxShape.circle,
                      ),
                    ),
              onTap: () {
                setState(() {
                  notification['isRead'] = true;
                });
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.chat_bubble;
      case 'follow':
        return Icons.person_add;
      case 'trending':
        return Icons.trending_up;
      default:
        return Icons.notifications;
    }
  }
}