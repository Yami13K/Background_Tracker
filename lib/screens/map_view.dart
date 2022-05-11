import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../database/funcs.dart';
import 'package:carp_background_location/carp_background_location.dart';

final f = funcs.instance;

class MapView extends StatefulWidget {
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Set<Polyline> polyline = {};
  List<LatLng> dpoints = [];
  GoogleMapController _controller;
  static const LatLng _center = const LatLng(33.5255936, 36.2771937);

  Future<void> draw() async {
    dpoints = await f.query();
    print('done');
    print(dpoints);
    setState(() {
      polyline.clear();
      polyline.add(Polyline(
          polylineId: PolylineId('Droute'),
          points: dpoints,
          visible: true,
          color: Colors.purple,
          width: 2));
    });
  }

  void getFirst() async {
    LocationDto first = await LocationManager().getCurrentLocation();
    setState(() {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(first.latitude, first.longitude),
        zoom: 18.0,
      )));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    print('createddddddddddd');
    _controller = controller;
    //start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            polylines: polyline,
            initialCameraPosition: const CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                      onPressed: draw,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: Text("Draw")))),
        ]));
  }
}
