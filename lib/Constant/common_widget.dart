import 'package:aiguruji/Constant/colors.dart';
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