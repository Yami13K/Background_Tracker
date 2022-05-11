import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import './screens/map_view.dart';
import './carpBackground/carp_location.dart' as CL;
import 'backgroundTasks/background_fetch.dart';
import './config/pemissions.dart';

void main() {

  runApp(const MyApp());

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String logStr = '';

  int i = 0;

  @override
  void initState() {
    super.initState();

    CL.start();
    initPlatformState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (AppLifecycleState.detached == state) {
        BackgroundFetch.start();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: MapView(),
    );
  }
}
