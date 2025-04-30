import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

final box = GetStorage();
String userId = '';

String versionApp = '';
int buildNumberApp = 0;

double width = MediaQuery.sizeOf(Get.context!).width;
double height = MediaQuery.sizeOf(Get.context!).height;

final GoogleSignIn googleSignIn = GoogleSignIn();

bool isTab(BuildContext c) {
  return MediaQuery.sizeOf(c).width >= 600 && MediaQuery.sizeOf(c).width < 2048;
}

Future getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  versionApp = packageInfo.version;
  buildNumberApp = int.parse(packageInfo.buildNumber);
  //print('hello version --- ${version} ---- ${buildNumber}');
}

heightBox(double height){
  return SizedBox(height: height.h);
}

weightBox(double width){
  return SizedBox(width: width.h);
}