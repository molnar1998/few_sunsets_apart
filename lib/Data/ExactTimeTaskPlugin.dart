import 'package:flutter/services.dart';

class MidnightTaskPlugin {
  static const MethodChannel _channel =
  MethodChannel('midnight_task_plugin');

  static Future<void> scheduleTask() async {
    try {
      // Calculate the time until midnight
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
      final durationUntilMidnight = midnight.difference(now);

      // Schedule the task
      await Future.delayed(durationUntilMidnight);
      await _executeCommand(); // Replace with your actual command execution

      print('Task executed at midnight!');
    } on PlatformException catch (e) {
      print('Error scheduling task: ${e.message}');
    }
  }

  static Future<void> _executeCommand() async {
    // Implement your command execution logic here
    // For example, send a notification, update data, etc.
    print('Executing the command...');
  }
}
