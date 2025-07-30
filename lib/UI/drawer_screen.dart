import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/UI/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('hello userid ----- ${userId}');
    return Drawer(
      backgroundColor: black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightBox(50),
            InkWell(
                onTap: () {
                  chatRoomId.value = uuid.v4();
                  isNewRoom.value = true;
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(width: 0.8.w, color: white)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 5,
                    children: [
                      Icon(Icons.add, color: white),
                      TextWidget(text: 'New Chat', color: white),
                    ],
                  ),
                )),
            heightBox(15),
            TextWidget(text: 'Recent Chats', color: white, fontSize: 18.sp, fontFamily: 'B'),
            heightBox(10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Chats')
                    .doc(userId)
                    .collection('chatRoom')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, chatRoomSnapshot) {
                  if (!chatRoomSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final chatRooms = chatRoomSnapshot.data!.docs;

                  return ListView.separated(
                    itemCount: chatRooms.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) => Divider(
                      color: white,
                    ),
                    itemBuilder: (context, index) {
                      final chatRoomDoc = chatRooms[index];
                      final chatRoomIdDatabase = chatRoomDoc.id;
                      final firstMessage = chatRoomDoc['firstMessage'] ?? '';

                      return Row(
                        spacing: 6.w,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                isNewRoom.value = false;
                                chatRoomId.value = chatRoomIdDatabase;
                              },
                              child: Container(
                                child: TextWidget(
                                  text: firstMessage,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (chatRoomId.value == chatRoomIdDatabase) {
                                chatRoomId.value = uuid.v4();
                                isNewRoom.value = true;
                              } else {
                                isNewRoom.value = false;
                              }
                              await FirebaseFirestore.instance
                                  .collection('Chats')
                                  .doc(userId)
                                  .collection('chatRoom')
                                  .doc(chatRoomIdDatabase)
                                  .delete();
                            },
                            child: Icon(HugeIcons.strokeRoundedDelete02,
                                size: 20.sp, color: Colors.red),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            heightBox(15),
            InkWell(
              onTap: () {
                box.erase();
                googleSignIn.signOut();
                Get.offAll(
                  () => LoginScreen(),
                  transition: Transition.fadeIn,
                  duration: Duration(milliseconds: 500),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: transparent,
                  border: Border.all(
                    color: purpleShad,
                    width: 0.5.w,
                  ),
                ),
                child: TextWidget(
                    text: 'Log out', fontFamily: 'S', fontSize: 17.sp, color: purpleShad),
              ),
            ),
            heightBox(20),
          ],
        ),
      ),
    );
  }
}
