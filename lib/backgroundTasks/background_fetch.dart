import 'dart:async';
import 'dart:convert';

import '../carpBackground/carp_location.dart' as CL;
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


const EVENTS_KEY = "fetch_events";

void backgroundFetchHeadlessTask( HeadlessTask task) async {
  var taskId = task.taskId;
  var timeout = task.timeout;
  if (timeout) {
    if (kDebugMode) {
      print("[BackgroundFetch] Headless task timed-out: $taskId");
    }
    BackgroundFetch.finish(taskId);
    return;
  }

  if (kDebugMode) {
    print("[BackgroundFetch] Headless event received: $taskId");
  }

  var timestamp = DateTime.now();

  var prefs = await SharedPreferences.getInstance();
  if (taskId == "com.dawwar.yami") {
    CL.start();
  }
  var events = <String>[];
  var json = prefs.getString(EVENTS_KEY);
  if (json != null) {
    events = jsonDecode(json).cast<String>();
  }
  events.insert(0, "$taskId@$timestamp [Headless]");
  prefs.setString(EVENTS_KEY, jsonEncode(events));


  if (taskId == 'flutter_background_fetch') {
    CL.start();
    print('bobobobobo');
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "com.dawwar.yami",
        delay: 69420,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: false,
        enableHeadless: true
    ));
  }
  BackgroundFetch.finish(taskId);
}


Future<void> initPlatformState() async {
  var prefs = await SharedPreferences.getInstance();
  var json = prefs.getString(EVENTS_KEY);
  if (json != null) {

  }

  // Configure BackgroundFetch.
  try {
    var status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 5,
        forceAlarmManager: false,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), _onBackgroundFetch, _onBackgroundFetchTimeout);
    print('[BackgroundFetch] configure success: $status');



  } on Exception catch(e) {
    print("[BackgroundFetch] configure ERROR: $e");
  }


}

void _onBackgroundFetch(String taskId) async {
  var prefs = await SharedPreferences.getInstance();
  var timestamp = DateTime.now();


  BackgroundFetch.finish(taskId);
}

/// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
void _onBackgroundFetchTimeout(String taskId) {
  print("[BackgroundFetch] TIMEOUT: $taskId");
  BackgroundFetch.finish(taskId);
}