import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isUser = message['sender'] == 'user';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isUser)
          Container(
            height: 32.w,
            width: 32.w,
            alignment: Alignment.center,
            margin: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: white.withValues(alpha: 0.7), width: 0.8.w),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Image.asset(
                'assets/images/splashlogo.png',
                height: 30.w,
                width: 30.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
        // if (!isUser) SizedBox(width: 8.w),
        Flexible(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
              margin: EdgeInsets.only(
                  left: isUser ? 70.w : 5.w, right: isUser ? 5.w : 70.w, top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isUser
                  ? TextWidget(text: message['text'], color: white,fontSize: 17.sp,maxLines: null)
                  : TextResponseWidget(text: message['response_text'])),
        ),
        // if (isUser) SizedBox(width: 8.w),
        if (isUser)
          Container(
            height: 32.w,
            width: 32.w,
            alignment: Alignment.center,
            margin: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: white.withValues(alpha: 0.7), width: 0.8.w),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: ImageView(imageUrl: image.value, height: 32.w, width: 32.w)),
          ),
      ],
    );
  }
}

class TextResponseWidget extends StatelessWidget {
  final String text;

  const TextResponseWidget({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final richText = _buildRichText(text);

    return richText;
  }

  Text _buildRichText(String text) {
    final spans = <TextSpan>[];

    // Split the text at newlines to preserve them
    final segments = text.split('\n');
    for (var segment in segments) {
      final boldSegments = _getBoldText(segment);
      spans.add(TextSpan(children: boldSegments));

      // Add a newline after each segment
      spans.add(TextSpan(text: '\n'));
    }

    return Text.rich(
      TextSpan(children: spans),
    );
  }

  List<TextSpan> _getBoldText(String text) {
    final spans = <TextSpan>[];

    // Regular expression to match bold text surrounded by **
    final parts = text.split(RegExp(r'(\*\*.*?\*\*)')); // Split on **bold** markers
    for (var part in parts) {
      if (part.startsWith('**') && part.endsWith('**')) {
        // Apply bold styling
        spans.add(TextSpan(
          text: part.substring(2, part.length - 2), // Remove the ** markers
          style: TextStyle(color: black, fontSize: 16.sp / MediaQuery.of(Get.context!).textScaler.scale(1)),
        ));
      } else {
        // Regular text
        spans.add(TextSpan(
          text: part,
          style: TextStyle(color: black, fontSize: 16.sp / MediaQuery.of(Get.context!).textScaler.scale(1)),
        ));
      }
    }

    return spans;
  }
}
