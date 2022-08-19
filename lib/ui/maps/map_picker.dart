import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class MapPicker extends StatefulWidget {
  static const id = 'map_picker';
  double latitudePassed, longitudePassed;
  String appointmentId;

  MapPicker({this.appointmentId, this.latitudePassed, this.longitudePassed});
  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  LatLng SOURCE_LOCATION = LatLng(35.1367571, 36.787285); // المنطقة الصناعية - حماه
  Completer<GoogleMapController> _controller = Completer();
  Position currentPosition;
  double lat, long;
  List<Marker> _markers = <Marker>[];
  GoogleMapController
      mapController; // create an intsance of google map controller for changing style
  String _mapStyle;
  BitmapDescriptor icon; // for custom marker
  FloatingSearchBarController _floatingSearchBarController = new FloatingSearchBarController();
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  Future<Position> getDeviceLocation() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
            forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;

      print(position.longitude);
    }).catchError((e) {
      print(e);
    });
    return currentPosition;
  }

//--------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    //-> load the map customize
    rootBundle.loadString('assets/resources/mapStyle/mapstyle.txt').then((string) {
      _mapStyle = string;
    });

    // getDeviceLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDeviceLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return buildMap();
          } else if (snapshot.hasData) {
            return Text("Something wrong!");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  //------------------------Map----------------------------------------------------
  Widget buildMap() {
    return GoogleMap(
      // mapType: MapType.terrain,  // if your using styles you must delete this line because it will override the styles
      initialCameraPosition: CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 15.0,
      ),
      markers: Set<Marker>.of(_markers),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      zoomControlsEnabled: false, // to delete the minus and plus control in map

      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        // change style of controller
        controller.setMapStyle(_mapStyle);
      },
    );
  }
} // end class

//Library used : custom_info_window
