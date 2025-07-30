import 'package:aiguruji/API/api.dart';
import 'package:aiguruji/Constant/colors.dart';
import 'package:aiguruji/Constant/constant.dart';
import 'package:aiguruji/UI/splash_screen.dart';
import 'package:aiguruji/firebase_crashlytics.dart';
import 'package:aiguruji/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// phone orientation

  userId = box.read('userId') ?? '';

  if (userId.isNotEmpty) await Api().getUser();

  await firebaseCrashytics();

  /// app crash detect

  await getAppVersion();

  /// app version
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: isTab(context) ? const Size(585, 812) : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'AI Guruji',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: false,
            appBarTheme: AppBarTheme(backgroundColor: scaffoldColor, elevation: 0),
            colorScheme: ColorScheme.fromSwatch().copyWith(secondary: scaffoldColor),
            scaffoldBackgroundColor: scaffoldColor,
            splashColor: transparent,
            highlightColor: transparent,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
