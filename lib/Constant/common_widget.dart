import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required this.text,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.height,
    this.fontFamily,
    this.textDecoration,
  });

  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 1,
      overflow: overflow,
      softWrap: true,
      style: TextStyle(
        fontSize: fontSize ?? 14.sp / MediaQuery.of(context).textScaler.scale(1),
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? white,
        letterSpacing: letterSpacing,
        height: height ?? 0,
        fontFamily: fontFamily ?? "R",
        decoration: textDecoration,
      ),
    );
  }
}

class SvgView extends StatelessWidget {
  const SvgView(this.svg, {Key? key, this.color, this.height, this.width, this.onTap, this.fit})
      : super(key: key);
  final String svg;
  final Color? color;
  final double? height, width;
  final BoxFit? fit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        svg,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  ImageView({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
    this.radius,
    this.memCacheHeight,
    this.fit,
  }) : super(key: key);

  final String imageUrl;
  final double? width;
  final double? height;
  final double? radius;
  final BoxFit? fit;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0.r),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        memCacheHeight: memCacheHeight,
        fadeInDuration: const Duration(milliseconds: 375),
        placeholderFadeInDuration: const Duration(milliseconds: 375),
        placeholder:
            (context, url) => Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: transparent,
            border: Border.all(color: iconGrey.withValues(alpha: 0.3), width: 0.7.w),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Image.asset(
            'assets/images/splashlogo.png',
            height: 35.w,
            width: 35.w,
            fit: BoxFit.cover,
          ),
        ),
        errorWidget:
            (context, url, error) => Container(
          height: height,
          width: width,
          color: transparent,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/splashlogo.png',
            height: 35.w,
            width: 35.w,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

showCustomSnackBar({
  required BuildContext context,
  required Widget iconWidget,
  required Widget textWidget,
}) {
  final snackBar = SnackBar(
    margin: EdgeInsets.only(
        bottom: height - 90,
        left: 10,
        right: 10),
    behavior: SnackBarBehavior.floating,
    backgroundColor: black.withValues(alpha: 0.7),
    dismissDirection: DismissDirection.none,
    duration: Duration(seconds: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
    content: Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [iconWidget, SizedBox(width: 15.w), Expanded(child: textWidget)],
      ),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}