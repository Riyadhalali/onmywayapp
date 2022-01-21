import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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

  FloatingSearchBarController _floatingSearchBarController =
      new FloatingSearchBarController(); // to make action for the floating search action bar

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

  // void PrintText() {
  //   print("Print Hello Mr. Riyad");
  // }

  //-> get the location of this device
  void getDeviceLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double longitude_data = position.longitude;
    double latitude_data = position.latitude;
    // print("google maps is loading ...");

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
    //  PrintText();
    rootBundle.loadString('assets/resources/mapStyle/mapstyle.txt').then((string) {
      _mapStyle = string;
      log(string);
      // print(_mapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: null,
        extendBodyBehindAppBar: true, // to set the

        body: Stack(
          fit: StackFit.expand,
          children: [buildMap(), buildFloatingActionBar()],
        ));
  }

  //------------------------Map----------------------------------------------------
  Widget buildMap() {
    return lat == null || long == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            // mapType: MapType.terrain,  // if your using styles you must delete this line because it will override the styles
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
          );
  }

  //-------------------------Floating Action Bar------------------------------------
  Widget buildFloatingActionBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      automaticallyImplyBackButton: false, // to hide back button
      hint: 'search'.tr().toString() + ' ...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      leadingActions: [
        IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu))
      ],
      width: isPortrait ? 400 : 300,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        ///when user start typing show an icon button for closing
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        /*Build the stack you want     */
        return Text("Hello Riyad");
      },
    );
  }
}
//TODO: ADD MARKERS ARRAY TO PAGE
