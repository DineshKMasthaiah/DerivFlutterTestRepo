import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:price_tracker/utils/global_key.dart';

///A logger that is used across the application
class PTLogger {
  static const String logTag = "PriceTracker";

  static void log(String message) {
    if (kDebugMode) {
      debugPrint("$logTag:$message");
    }
  }

  //use it to debug issues
  static showSnackBar(String message) {
    if (kDebugMode) {
      ScaffoldMessenger.of(PTAppGlobalKey.getGlobalContext())
          .showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        duration: const Duration(seconds: 2),
      ));
    }
  }
}
