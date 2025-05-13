import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/Controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset('assets/images/splashlogo.png', height: 160.w, width: 160.w),
            heightBox(65),
            TextWidget(
                text: 'Welcome To AI Guruji', fontSize: 32.sp, fontFamily: 'B', color: purpleShad),
            heightBox(16),
            TextWidget(
                text:
                    'The dialogue format makes it possible for AI Guruji to answer followup questions, admit its mistakes, challenge incorrect premises, and reject inappropriate requests.',
                fontSize: 16.sp,
                textAlign: TextAlign.center,
                fontFamily: 'R'),
            Spacer(),
            Obx(() {
              loginController.isLoading.value;
              return InkWell(
                onTap: loginController.isLoading.value == false
                    ? () async {
                        await loginController.googleSignIn();
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  height: 64.w,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  width: loginController.isLoading.value ? 64.w : width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(loginController.isLoading.value ? 100.r : 4.r),
                    color: transparent,
                    border: Border.all(
                      color: purpleShad,
                      width: loginController.isLoading.value ? 2.w : 2.w,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: loginController.isLoading.value
                        ? Padding(
                            key: const ValueKey(2),
                            padding: EdgeInsets.all(4.r),
                            child: CircularProgressIndicator(color: white, strokeWidth: 2.w),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              key: const ValueKey(1),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgView('assets/icons/google.svg', height: 20.w, width: 20.w),
                                SizedBox(width: 10.w),
                                TextWidget(
                                    text: 'Continue with Google',
                                    fontFamily: 'S',
                                    fontSize: 17.sp,
                                    color: purpleShad),
                              ],
                            ),
                          ),
                  ),
                ),
              );
            }),
            heightBox(27)
          ],
        ),
      ),
    );
  }
}
