import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  void getLocation() async {
    // GetServiceLocation getServiceLocation =
    //     await WebServices.Get_Service_Location(widget.appointmentId);
    setState(() {
      lat = widget.latitudePassed;
      long = widget.longitudePassed;
    });

    _markers.add(Marker(
        markerId: MarkerId('Location'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: 'Location')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: lat == null || long == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
