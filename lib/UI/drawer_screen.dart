import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('hello userid ----- ${userId}');
    return Drawer(
      backgroundColor: iconGrey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          heightBox(50),
          InkWell(
              onTap: () {
                chatRoomId.value = uuid.v4();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Icon(Icons.add, color: black),
                  TextWidget(text: 'New ChatRoom',color: black),
                ],
              )),
          Expanded(
            child: SingleChildScrollView(
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

                  print('hello length chatrooms ---- ${chatRooms.length}');

                  // if (chatRooms.isEmpty) {
                  //   return Center(child: Text("No chat rooms found"));
                  // }

                  return ListView.separated(
                    itemCount: chatRooms.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 5.h);
                    },
                    itemBuilder: (context, index) {
                      final chatRoomDoc = chatRooms[index];
                      final chatRoomId = chatRoomDoc.id;

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatUser')
                            .doc(userId)
                            .collection('chatRoom')
                            .doc(chatRoomId)
                            .collection(
                                'messages') // 👈 collection name should match your structure
                            .orderBy('time', descending: true)
                            // .limit(1)
                            .snapshots(),
                        builder: (context, messageSnapshot) {
                          String latestMessage = 'Loading...';

                          if (messageSnapshot.hasData && messageSnapshot.data!.docs.isNotEmpty) {
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
            ),
          ),
        ],
      ),
    );
  }
}
