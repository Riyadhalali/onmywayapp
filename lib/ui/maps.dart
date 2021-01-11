import 'dart:async';

import 'package:alatareekeh/services/GetServiceLocation.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
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
    GetServiceLocation getServiceLocation =
        await WebServices.Get_Service_Location(widget.appointmentId);
    setState(() {
      lat = getServiceLocation.lat;
      long = getServiceLocation.lon;
    });

    _markers.add(Marker(
        markerId: MarkerId('Location'),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: 'Location'.tr().toString())));
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
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, long),
                zoom: 15.0,
              ),
              markers: Set<Marker>.of(_markers),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
