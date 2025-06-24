import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/Controller/chatroom_controller.dart';
import 'package:aiguruji/UI/drawer_screen.dart';
import 'package:aiguruji/UI/login_screen.dart';
import 'package:aiguruji/UI/messagebubble_screen.dart';
import 'package:aiguruji/UI/speech_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoomScreen({super.key});

  final ChatroomController controller = Get.put(ChatroomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(

          title: TextWidget(text: 'AI Guruji', fontFamily: 'B', fontSize: 24.sp),
          centerTitle: true,
          actionsPadding: EdgeInsets.only(right: 10.w),
          actions: [
            Obx(() {
              return InkWell(
                onTap: () {

                  controller.fetchChatRoomsAndMessages();

                  // if (userId.isNotEmpty)
                  //   Get.dialog(
                  //     barrierDismissible: true,
                  //     Dialog(
                  //       backgroundColor: black.withValues(alpha: 0.9),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20.r),
                  //           side: BorderSide(width: 0.5.w, color: purpleShad)),
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               height: 100.w,
                  //               width: 100.w,
                  //               alignment: Alignment.center,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 border: Border.all(color: white, width: 0.6.w),
                  //               ),
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(100.r),
                  //                 child: ImageView(
                  //                     imageUrl: image.value, height: height, width: width),
                  //               ),
                  //             ),
                  //             heightBox(20),
                  //             TextWidget(text: name.value, fontSize: 24.sp, fontFamily: 'B'),
                  //             heightBox(10),
                  //             TextWidget(
                  //                 text: email.value,
                  //                 fontSize: 18.sp,
                  //                 maxLines: 2,
                  //                 textAlign: TextAlign.center),
                  //             heightBox(30),
                  //             InkWell(
                  //               onTap: () {
                  //                 box.erase();
                  //                 googleSignIn.signOut();
                  //                 Get.offAll(
                  //                   () => LoginScreen(),
                  //                   transition: Transition.fadeIn,
                  //                   duration: Duration(milliseconds: 500),
                  //                 );
                  //               },
                  //               child: Container(
                  //                 height: 50.h,
                  //                 margin: EdgeInsets.symmetric(horizontal: 30.w),
                  //                 width: width,
                  //                 alignment: Alignment.center,
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(15.r),
                  //                   color: transparent,
                  //                   border: Border.all(
                  //                     color: purpleShad,
                  //                     width: 0.5.w,
                  //                   ),
                  //                 ),
                  //                 child: TextWidget(
                  //                     text: 'Log out',
                  //                     fontFamily: 'S',
                  //                     fontSize: 17.sp,
                  //                     color: purpleShad),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   );
                },
                child: Container(
                  height: 35.w,
                  width: 35.w,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(5.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: white.withValues(alpha: 0.7), width: 0.8.w),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: image.value.isNotEmpty
                        ? ImageView(imageUrl: image.value, height: 33.h, width: 35.w)
                        : Image.asset(
                            'assets/images/splashlogo.png',
                            height: 35.w,
                            width: 35.w,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              );
            }),
          ],
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 105.h,
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(width: 1.w, color: white.withValues(alpha: 0.3))),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 5.h),
              child: Column(
                children: [
                  TextField(
                    controller: controller.textController,
                    cursorColor: white,
                    style: TextStyle(color: white),
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      hintStyle: TextStyle(color: white.withValues(alpha: 0.7)),
                      enabledBorder: commonBorder,
                      focusedBorder: commonBorder,
                      disabledBorder: commonBorder,
                      errorBorder: commonBorder,
                      focusedErrorBorder: commonBorder,
                      suffixIcon: InkWell(
                        onTap: () {
                          final text = controller.textController.text.trim();
                          if (text.isNotEmpty) {
                            controller.sendMessage(userId: userId, chatroomId: 'abcd123456', text: text);
                            controller.textController.clear();
                          }
                        },
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedSent,
                          color: white,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ),
                  heightBox(10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      children: [
                        Image.asset('assets/images/splashlogo.png', height: 22.w, width: 22.w),
                        widthBox(10),
                        TextWidget(
                          text: 'Speech Response',
                          fontSize: 14,
                          color: white.withValues(alpha: 0.8),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Get.to(() => SpeechScreen());
                          },
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedMic01,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chatUser')
              .doc(userId)
              .collection('chatRoom')
              .doc('abcd123456')
              .collection('messages')
              .orderBy('time')
              .snapshots(),
          builder: (context, snapshot) {
            // LOADING STATE
            if (!snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: height / 13),
                  child: CircularProgressIndicator(color: white),
                ),
              );
            }

            // ERROR STATE
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: height / 20),
                  child: TextWidget(
                    text: 'Something went wrong!',
                    fontSize: 20,
                  ),
                ),
              );
            }

            // DATA STATE
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: height / 4),
                child: Center(
                  child: Column(
                    spacing: 10,
                    children: [
                      Image.asset('assets/images/splashlogo.png', height: 100.w, width: 100.w),
                      TextWidget(
                        text: 'What can I help you with?',
                        fontSize: 20,
                        fontFamily: 'B',
                      ),
                    ],
                  ),
                ),
              );
            }

            final messages = snapshot.data!.docs;

            controller.scrollToBottom();

            return Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                controller: controller.scrollController,
                physics: BouncingScrollPhysics(),
                child: Obx(() {
                  isAILoading.value;
                  return Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      AnimatedPadding(
                        padding: EdgeInsets.only(bottom: isAILoading.value ? 45.h : 0),
                        duration: Duration(milliseconds: 500),
                        child: ListView.builder(
                          itemCount: messages.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          itemBuilder: (context, index) {
                            final data = messages[index].data() as Map<String, dynamic>;
                            controller.scrollToBottom();
                            return MessageBubble(message: data);
                          },
                        ),
                      ),
                      isAILoading.value
                          ? Padding(
                              key: ValueKey(isAILoading.value),
                              padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                              child: Row(
                                children: [
                                  Container(
                                    height: 32.w,
                                    width: 32.w,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(5.r),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: white.withAlpha(180), width: 0.8.w),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100.r),
                                      child: Image.asset(
                                        'assets/images/splashlogo.png',
                                        height: 32.w,
                                        width: 32.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  TextWidget(
                                      text: 'Guruji is Typing...', color: white, fontSize: 16.sp),
                                ],
                              ),
                            )
                          : SizedBox.shrink(key: ValueKey(isAILoading.value))
                    ],
                  );
                }),
              ),
            );
          },
        ));
  }
}
// Padding(
//   padding: EdgeInsets.symmetric(horizontal: 20.w),
//   child: Center(
//     child: Column(
//       children: [
//         Spacer(),
//         TextWidget(text: 'Under Development Chat Screen', fontSize: 20.sp),
//         Spacer(),
//         InkWell(
//           onTap: () {
//             box.erase();
//             googleSignIn.signOut();
//             Get.offAll(
//               () => LoginScreen(),
//               transition: Transition.fadeIn,
//               duration: Duration(milliseconds: 500),
//             );
//           },
//           child: Container(
//             height: 50.h,
//             margin: EdgeInsets.symmetric(horizontal: 20.w),
//             width: width,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(4.r),
//               color: transparent,
//               border: Border.all(
//                 color: purpleShad,
//                 width: 2.w,
//               ),
//             ),
//             child: TextWidget(
//                 text: 'Log out', fontFamily: 'S', fontSize: 17.sp, color: purpleShad),
//           ),
//         ),
//         heightBox(30)
//       ],
//     ),
//   ),
// ),
