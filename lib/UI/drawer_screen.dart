
import 'package:aiguruji/Constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('hello userid ----- ${userId}');
    return Drawer(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatUser') // 👈 Make sure this is your actual path
            .doc(userId)
            .collection('chatRoom')
            .snapshots(),
        builder: (context, chatRoomSnapshot) {
          if (!chatRoomSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final chatRooms = chatRoomSnapshot.data!.docs;
          if (chatRooms.isEmpty) {
            return Center(child: Text("No chat rooms found"));
          }

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoomDoc = chatRooms[index];
              final chatRoomId = chatRoomDoc.id;

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatUser')
                    .doc(userId)
                    .collection('chatRoom')
                    .doc(chatRoomId)
                    .collection('messages') // 👈 collection name should match your structure
                    .orderBy('time', descending: true)
                   // .limit(1)
                    .snapshots(),
                builder: (context, messageSnapshot) {
                  String latestMessage = 'Loading...';

                  if (messageSnapshot.hasData &&
                      messageSnapshot.data!.docs.isNotEmpty) {
                    latestMessage = messageSnapshot.data!.docs.first['text'] ?? '';
                  }

                  return ListTile(
                    title: Text('ChatRoom: $chatRoomId'),
                    subtitle: Text(latestMessage),
                    onTap: () {
                      // Navigate or open chat
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
