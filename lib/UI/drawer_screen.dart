
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
            .collection('chat')
            .doc(userId)
            .collection('chatRoom')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final chatRooms = snapshot.data!.docs;
          print("chatRooms ::::: ${chatRooms.map((e) => e.id).toList()}");

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoomDoc = chatRooms[index];
              final chatRoomId = chatRoomDoc.id;

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('chat')
                    .doc(userId)
                    .collection('chatRoom')
                    .doc(chatRoomId)
                    .collection('message')
                    .orderBy('timestamp')
                    .limit(1)
                    .get(),
                builder: (context, messageSnapshot) {
                  String firstMessage = 'Loading...';

                  if (messageSnapshot.hasData && messageSnapshot.data!.docs.isNotEmpty) {
                    firstMessage = messageSnapshot.data!.docs.first['text'] ?? '';
                  }

                  return ListTile(
                    title: Text("ChatRoom: $chatRoomId"),
                    subtitle: Text(firstMessage),
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
