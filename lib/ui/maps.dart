import 'dart:async';

import 'package:flutter/cupertino.dart';
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
  Completer<GoogleMapController> controller1;
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPositon = _initialPosition;
  MapType _currentMapType = MapType.normal; // define the map type
  //-----------------------Get User Location------------------------------------
  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print(_initialPosition);
    });
  }

//-----------------------on Map Created-----------------------------------------
  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  //----------------Change Map type using Button--------------------------------
  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  //--------------------------on Camera Move -----------------------------------
  _onCameraMove(CameraPosition position) {
    _lastMapPositon = position.target;
  }

  //-------------------------------Add marker Button----------------------------
  _onAddMarkerButtonPressed() {
    setState(() {
      print('marker is pressed');
      _markers.add(
        Marker(
          markerId: MarkerId(_lastMapPositon.toString()),
          position: _lastMapPositon,
          infoWindow: InfoWindow(title: "Pizza"),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
  }

//----------------------------MapButton-----------------------------------------
  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }
  //-------------------------------Camera Widget--------------------------------

  Widget CameraUI() {
    return Container(
      height: 70.0.h,
      child: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.4746,
            ),
            onCameraMove: _onCameraMove,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true, // very important to get the location
            compassEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
              child: Column(
                children: [
                  mapButton(_onAddMarkerButtonPressed(),
                      Icon(Icons.add_location), Colors.blue),
                  mapButton(
                      _onMapTypeButtonPressed(),
                      Icon(
                        IconData(0xf473,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage),
                      ),
                      Colors.green),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("maps started...");
    getLocation();
  }

//-----------------------------------Build Widget-------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : CameraUI(),
    );
  }
}
