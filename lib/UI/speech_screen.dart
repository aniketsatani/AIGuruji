import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/Controller/speech_controller.dart';
import 'package:aiguruji/UI/speech_bgvideo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SpeechScreen extends StatelessWidget {
  SpeechController controller = Get.put(SpeechController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Video Background
          VideoBackground(),

          // Main Content
          Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 40.h, left: 15.w),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: white.withValues(alpha: 0.7),
                        width: 1.w,
                      ),
                    ),
                    child: Icon(Icons.arrow_back, color: white, size: 20),
                  ),
                ),
              ),

              // Center Display Area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Center(
                    child: // Center Text or Response
                        Obx(() {
                      centerText.value;
                      print('hello center text obx --- ${centerText.value}');
                      return AnimatedSwitcher(
                        key: ValueKey('${centerText.value}'),
                        duration: Duration(milliseconds: 300),
                        child:
                            controller.showResponse.value ? ResponseDisplay() : CenterTextDisplay(),
                      );
                    }),
                  ),
                ),
              ),

              // Bottom Control Area
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Main Control Button

                        // Close Button Container
                        Obx(() {
                          if (isListening.value == true) {
                            return SizedBox.shrink();
                          }
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.clearData();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(25.r),
                                    border: Border.all(color: white, width: 1.w),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: white,
                                  ),
                                ),
                              ),
                              widthBox(15),
                            ],
                          );
                        }),

// Mic Button Container
                        Obx(() {
                          isListening.value;
                          controller.isLastResponse.value;
                          return GestureDetector(
                            onTap: controller.isAvailable.value
                                ? ((isListening.value || controller.isLastResponse.value)
                                    ? null
                                    : controller.startListening)
                                : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: white, width: 1.w),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.mic,
                                    color: white,
                                  ),
                                  widthBox(8.w),
                                  TextWidget(
                                    text: (controller.isLastResponse.value || isListening.value)
                                        ? 'Listening'
                                        : 'Start to Speak',
                                    color: white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget CenterTextDisplay() {
    return TextWidget(
      text: centerText.value,
      color: white,
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      textAlign: TextAlign.center,
    );
  }

  Widget ResponseDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: ValueKey(controller.response.value),
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: white.withValues(alpha: 0.3),
              width: 1.w,
            ),
          ),
          child: TextWidget(
            text: controller.response.value,
            color: white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        TextWidget(
          text: 'Talk to interrupt',
          color: white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
