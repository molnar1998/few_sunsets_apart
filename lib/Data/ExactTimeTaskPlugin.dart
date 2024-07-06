import 'dart:async';
import 'package:few_sunsets_apart/Data/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ExactTimeTaskPlugin {

  static Future<void> resetMissYou(DateTime executionTime) async {
    try {
      final now = DateTime.now();
      final timeUntilExecution = executionTime.isAfter(now)
          ? executionTime.difference(now)
          : Duration.zero;

      Timer(timeUntilExecution, () async {
        FirebaseService().resetCounterValues();
        debugPrint('Task executed at $executionTime');
      });
    } on PlatformException catch (e) {
      debugPrint('Error scheduling task: ${e.message}');
    }
  }
}
