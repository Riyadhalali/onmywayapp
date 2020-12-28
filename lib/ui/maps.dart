import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

class Maps extends StatefulWidget {
  static const id = 'maps_page';

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  static double latLocation;
  static double langLocation;
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.1365364, 36.7870555),
    zoom: 30.0,
  );

  static final CameraPosition _kLake =
      CameraPosition(target: LatLng(latLocation, langLocation), zoom: 15.0);

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    latLocation = position.latitude;
    langLocation = position.longitude;
    print(position);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    // _determinePosition();
  }

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
