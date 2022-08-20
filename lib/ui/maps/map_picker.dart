import 'dart:async';

import 'package:alatareekeh/provider/global.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

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
  LatLng DESTINATION_LOCATION;
  List<Marker> _markers = <Marker>[];
  GoogleMapController
      mapController; // create an intsance of google map controller for changing style
  String _mapStyle;
  BitmapDescriptor icon; // for custom marker
  FloatingSearchBarController _floatingSearchBarController = new FloatingSearchBarController();
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  bool showProgressIndicator = false;

  Future<Position> getDeviceLocation() async {
    // rootBundle.loadString('assets/resources/mapStyle/mapstyle.txt').then((string) {
    //   _mapStyle = string;
    // });
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
            forceAndroidLocationManager: true, desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      //-> wrong to say set state because it will keep updating
      currentPosition = position;

      print(position.longitude);
    }).catchError((e) {
      print(e);
    });

    _markers.add(Marker(
        //  icon: Icon(Icons.location_on),
        onTap: () {
          //todo: set location here
        },
        infoWindow: InfoWindow(title: 'set location'),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        markerId: MarkerId("Location".tr().toString())));
    return currentPosition;
  }

//--------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    //
    //-> load the map customize
    // rootBundle.loadString('assets/resources/mapStyle/mapstyle.txt').then((string) {
    //   _mapStyle = string;
    // });

    // getDeviceLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDeviceLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return buildMap();
          } else if (snapshot.hasError) {
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
    return LayoutBuilder(builder: (context, constraints) {
      Global globalProvider = Provider.of<Global>(context);

      var maxWidth = constraints.biggest.width;
      var maxHeight = constraints.biggest.height;
      return Stack(
        children: [
          GoogleMap(
            onTap: (latlng) {},
            // mapType: MapType.terrain,  // if your using styles you must delete this line because it will override the styles
            initialCameraPosition: CameraPosition(
              target: LatLng(currentPosition.latitude, currentPosition.longitude),
              zoom: 15.0,
            ),
            markers: Set<Marker>.of(_markers),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            // to delete the minus and plus control in map

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              // change style of controller
              controller.setMapStyle(_mapStyle);
            },
            onCameraMove: (CameraPosition newPosition) {
              DESTINATION_LOCATION = newPosition.target;
              //   print("destination new is : ${DESTINATION_LOCATION}");
            },
            padding: const EdgeInsets.all(0),
            buildingsEnabled: true,
            cameraTargetBounds: CameraTargetBounds.unbounded,
            compassEnabled: true,
            indoorViewEnabled: false,
            mapToolbarEnabled: true,
            minMaxZoomPreference: MinMaxZoomPreference.unbounded,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            trafficEnabled: false,
          ),
          Positioned(
            bottom: maxHeight / 2,
            right: (maxWidth - 30) / 2,
            child: const Icon(
              Icons.location_on,
              size: 30,
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  //-> i used the consumer widget so i can update just widget not all application
                  Consumer<Global>(builder: (context, showIndicator, _) {
                    return Visibility(
                      visible: showIndicator.showProgressInMap,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }),
                  IconButton(
                    onPressed: () async {
                      //  var positionNew = await _determinePosition();
                      globalProvider.showProgress(true);
                      final GoogleMapController controller = await _controller.future;
                      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target:
                              LatLng(DESTINATION_LOCATION.latitude, DESTINATION_LOCATION.longitude),
                          zoom: 15.0)));
                      // print(
                      //     "new position is ${DESTINATION_LOCATION.latitude} and ${DESTINATION_LOCATION.longitude} ");

                      //-> get the place from cordinates using geocoding but must use vpn to work
                      List<Placemark> placemarks = await placemarkFromCoordinates(
                          DESTINATION_LOCATION.latitude, DESTINATION_LOCATION.longitude);

                      print("placemarks : ${placemarks}");

                      globalProvider.showProgress(false);
                    },
                    icon: const Icon(Icons.done),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
} // end class

//Library used : custom_info_window
//https://stackoverflow.com/questions/69443353/how-to-pick-an-address-from-map-in-flutter/69443524#69443524
