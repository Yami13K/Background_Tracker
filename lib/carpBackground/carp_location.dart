import 'dart:async';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:flutter/foundation.dart';
import '../database/funcs.dart';
import 'package:permission_handler/permission_handler.dart';

final f = funcs.instance;

LocationDto lastLocation;
DateTime lastTimeLocation;
Stream<LocationDto> locationStream;
StreamSubscription<LocationDto> locationSubscription;

void CarpLocationSettings() {
  LocationManager().interval = 1;
  LocationManager().distanceFilter = 0;
  LocationManager().notificationTitle = 'CARP Location Example';
  LocationManager().notificationMsg = 'CARP is tracking your location';
  locationStream = LocationManager().locationStream;
}

String dtoToString(LocationDto dto) =>
    'Location ${dto.latitude}, ${dto.longitude} at ${DateTime.fromMillisecondsSinceEpoch(dto.time ~/ 1)}';

void getCurrentLocation() async =>
    onData(await LocationManager().getCurrentLocation());

void onData(LocationDto dto) {
  // print(dtoToString(dto));
  /* LatLng p = new LatLng(dto.latitude, dto.longitude);
    if (p != null) {
      points.add(p);
    }*/

  if (kDebugMode) {
    print("inside");
  }
  // print(dto);
  f.insert(dto.latitude, dto.longitude,
      '${DateTime.fromMillisecondsSinceEpoch(dto.time ~/ 1)}');

  //print(points);

  lastLocation = dto;
  lastTimeLocation = DateTime.now();
}

Future<bool> askForLocationAlwaysPermission() async {
  bool granted = await Permission.locationAlways.isGranted;

  if (!granted) {
    granted =
        await Permission.locationAlways.request() == PermissionStatus.granted;
  }

  return granted;
}

/// Start listening to location events.
void start() async {
  stop();
  // ask for location permissions, if not already granted
  if (kDebugMode) {
    print('startedddddddddddd');
  }
  CarpLocationSettings();
  locationSubscription?.cancel();
  if (kDebugMode) {
    print('startedddddddddddd');
  }
  locationSubscription = locationStream?.listen(onData);
  await LocationManager().start();
}

void stop() {
  locationSubscription?.cancel();
  LocationManager().stop();
}

