import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  static const id = 'maps_page';
  double latitudePassed, longitudePassed;
  String appointmentId;

  Maps({this.appointmentId, this.latitudePassed, this.longitudePassed});
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
  double lat, long;
  List<Marker> _markers = <Marker>[];
  GoogleMapController
      mapController; // create an intsance of google map controller for changing style
  String _mapStyle;

  //-> get location from api
  /// void getLocation() async {
  ///   GetServiceLocation getServiceLocation =
  ///       await WebServices.Get_Service_Location(widget.appointmentId);
  ///   setState(() {
  ///     lat = getServiceLocation.lat;
  ///     long = getServiceLocation.lon;
  ///   });

  ///   _markers.add(Marker(
  ///       markerId: MarkerId('Location'.tr().toString()),
  ///       position: LatLng(lat, long),
  ///       infoWindow: InfoWindow(title: 'Location'.tr().toString())));
  /// }
  ///

  void PrintText() {
    print("Print Hello Mr. Riyad");
  }

  //-> get the location of this device
  void getDeviceLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double longitude_data = position.longitude;
    double latitude_data = position.latitude;
    print("google maps is loading ...");

    setState(() {
      lat = latitude_data;
      long = longitude_data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceLocation();
    PrintText();
    rootBundle.loadString('assets/resources/mapStyle/mapstyle.txt').then((string) {
      _mapStyle = string;
      log(string);
      // print(_mapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBodyBehindAppBar: true, // to set the

      body: lat == null || long == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              // mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(_markers),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // change style of controller

                controller.setMapStyle(_mapStyle);
              },
            ),
    );
  }
}
