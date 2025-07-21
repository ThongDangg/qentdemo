import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qentdemo/screens/my_booking_screen.dart';



class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedFilter = 'Tất cả';

  final List<String> filterOptions = ['Tất cả', 'Đặt xe', 'Hệ thống'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông báo')),
      body: Column(
        children: [
          // Dropdown lọc
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
              items: filterOptions.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
            ),
          ),

          // Danh sách thông báo
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;

                // Áp dụng bộ lọc
                final filtered = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final type = data['type'] ?? 'Hệ thống';
                  if (selectedFilter == 'Tất cả') return true;
                  return selectedFilter == 'Đặt xe' && type == 'booking' ||
                      selectedFilter == 'Hệ thống' && type != 'booking';
                }).toList();

                if (filtered.isEmpty) {
                  return Center(child: Text('Không có thông báo'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final doc = filtered[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final title = data['title'] ?? 'Thông báo';
                    final content = data['message'] ?? '';
                    final isRead = data['isRead'] ?? false;
                    final type = data['type'] ?? 'system';

                    return ListTile(
                      title: Text(
                        title,
                        style: TextStyle(
                          fontWeight: isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(content),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      tileColor: isRead ? Colors.white : Colors.grey.shade200,
                      onTap: () async {
                        // Đánh dấu đã đọc
                        await FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(doc.id)
                            .update({'isRead': true});

                        if (type == 'booking') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MyBookingsScreen(),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
