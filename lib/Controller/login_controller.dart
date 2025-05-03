import 'package:aiguruji/API/api.dart';
import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/common_widget.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/UI/chatroom_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  Future<UserCredential?> googleSignIn() async {
    isLoading.value = false;
    isLoading.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        UserCredential result = await FirebaseAuth.instance.signInWithCredential(authCredential);

        box.write('userId', result.user!.uid.toString());
        userId.value = box.read('userId');

        UserModel userModel = UserModel(
          id: userId.value,
          name: result.user!.displayName.toString(),
          email: result.user!.email.toString(),
          image: result.user!.photoURL.toString(),
        );
        bool userExists = await Api().checkUserExists();
        if (userExists == true) {
          Get.offAll(() => ChatRoomScreen(), transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
        } else {
          await Api().addUserData(userModel: userModel);
          Get.offAll(() => ChatRoomScreen(), transition: Transition.fadeIn, duration: Duration(milliseconds: 500));
        }
        await Api().getUser();
        showCustomSnackBar(
          context: Get.context!,
          iconWidget: Icon(Icons.check_circle_rounded, color: green, size: 30.sp),
          textWidget: TextWidget(text: "Login Successfully!", fontSize: 16.sp),
        );
        isLoading.value = false;
        return result;
      } else {
        isLoading.value = false;
        return null;
      }
    } catch (e, t) {
      isLoading.value = false;
      print('hello googleSignIn error ----- ${e}');
      print('hello googleSignIn trace ----- ${t}');
    }
    return null;
  }
}
