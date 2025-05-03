import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/UI/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(text: 'AI Guruji', fontFamily: 'B', fontSize: 24.sp),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 10.w),
        actions: [
          Obx(() {
            return InkWell(
              onTap: () {
                if (userId.value.isNotEmpty)
                  Get.dialog(
                    barrierDismissible: true,
                    Dialog(
                      backgroundColor: black.withValues(alpha: 0.9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          side: BorderSide(width: 0.5.w, color: purpleShad)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100.w,
                              width: 100.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: white, width: 0.6.w),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.r),
                                child:
                                ImageView(imageUrl: image.value, height: height, width: width),
                              ),
                            ),
                            // ClipRRect(
                            //     borderRadius: BorderRadius.circular(100.r),
                            //     child: Container(
                            //         decoration:
                            //             BoxDecoration(border: Border.all(width: 0.6, color: white)),
                            //         child:
                            //         ImageView(imageUrl: image.value, height: 100.w, width: 100.w))),
                            heightBox(20),
                            TextWidget(text: name.value, fontSize: 24.sp, fontFamily: 'B'),
                            heightBox(10),
                            TextWidget(
                                text: email.value,
                                fontSize: 18.sp,
                                maxLines: 2,
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Column(
            children: [
              Spacer(),
              TextWidget(text: 'Under Development Chat Screen', fontSize: 20.sp),
              Spacer(),
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
                  height: 50.h,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  width: width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: transparent,
                    border: Border.all(
                      color: purpleShad,
                      width: 2.w,
                    ),
                  ),
                  child: TextWidget(
                      text: 'Log out', fontFamily: 'S', fontSize: 17.sp, color: purpleShad),
                ),
              ),
              heightBox(30)
            ],
          ),
        ),
      ),
    );
  }
}
