
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'database_helper.dart';

class funcs {
  funcs._privateConstructor();
  static final funcs instance = funcs._privateConstructor();

  final dbHelper = DatabaseHelper.instance;

  void insert(lat, long, time) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnLat: lat,
      DatabaseHelper.columnLong: long,
      DatabaseHelper.columnTime:time,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
    print(time);
  }

  Future<List<LatLng>> query() async {
    List<LatLng> result = [];

    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    //allRows.forEach(print);
    for (var row in allRows) {
      //print(row['lat'].runtimeType);
      //print(row['long'].runtimeType);
      
      result.add(LatLng(row['lat'], row['long']));
    }

    return result;
  }

  Future<void> fix() async {
    dbHelper.fix();
    final allRows = await dbHelper.queryAllRows();

    for (var r in allRows) {
      Map<String, dynamic> row = {
        DatabaseHelper.columnLong: r['long'],
        DatabaseHelper.columnLat: r['lat']
      };
      final id = await dbHelper.insert(row);
      print('inserted row id: $id');
    }
  }
}
