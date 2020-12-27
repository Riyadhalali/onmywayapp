import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class Maps extends StatefulWidget {
  static const id = 'maps_page';
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 50.0,
  );

  static final CameraPosition _kLake = CameraPosition(
      target: LatLng(37.43296265331129, -122.08832357078792), zoom: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: MapsWidget(),
    );
  } // end build

//------------------------------Widget Tree-------------------------------------
  Widget MapsWidget() {
    return Container(
      height: 50.0.h,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
//------------------------------------------------------------------------------

} // end class

//TODO: use geoloactor
