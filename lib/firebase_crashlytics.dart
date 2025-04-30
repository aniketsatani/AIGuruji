import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future firebaseCrashytics() async {
  FirebaseCrashlytics.instance.setUserIdentifier('');

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  /// This data can help you understand basic interactions, such as how many times your app was opened, and how many users were active in a chosen time period.
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
}