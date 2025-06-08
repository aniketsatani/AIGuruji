import 'package:aiguruji/API/api.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/UI/chatroom_screen.dart';
import 'package:aiguruji/UI/login_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  nextScreen() {
    Future.delayed(const Duration(seconds: 4), () {
      userId.isEmpty
          ? Get.off(
              () => LoginScreen(),
              transition: Transition.fadeIn,
              duration: Duration(milliseconds: 500),
            )
          :
      Get.offAll(
              () => ChatRoomScreen(),
              transition: Transition.fadeIn,
              duration: Duration(milliseconds: 500),
            );
    });
  }

  @override
  void onInit() {
    if (userId.isNotEmpty) {
      Api().getUser();
    }
    super.onInit();
  }
}
