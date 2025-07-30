import 'package:aiguruji/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

final box = GetStorage();
var uuid = Uuid();

RxString chatRoomId = ''.obs;
RxBool isNewRoom = false.obs;

String userId = '';
RxString name = ''.obs;
RxString email = ''.obs;
RxString image = ''.obs;

String baseUrl = '';
String apiKey = '';

String privacy = '';
String terms = '';
String appLink = '';
String appRate = '';

String version = '';
int buildNumber = 0;

String versionApp = '';
int buildNumberApp = 0;

RxBool isAILoading = false.obs;

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

heightBox(double height) {
  return SizedBox(height: height.h);
}

widthBox(double width) {
  return SizedBox(width: width.h);
}

OutlineInputBorder commonBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15.r),
  borderSide: BorderSide(
    width: 1.w,
    color: white.withValues(alpha: 0.3),
  ),
);

class UserModel {
  String id;
  String name;
  String email;
  String image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'image': image};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      image: map['image'] ?? '',
    );
  }
}
