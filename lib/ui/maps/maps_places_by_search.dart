import 'package:alatareekeh/ui/maps/map_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'maps_utils.dart';

// this class after user select the place in my location and my destination page on confirm the place then he will see the path that he selected
class MapsPlacesBySearch extends StatefulWidget {
  static const id = 'maps_places_search_results';
  final DetailsResult startPosition;
  final DetailsResult endPosition;
  final String placeToGo;
  // final LatLng currentLocation;

  const MapsPlacesBySearch({this.startPosition, this.endPosition, this.placeToGo});

  @override
  State<MapsPlacesBySearch> createState() => _MapsPlacesBySearchState();
}

class _MapsPlacesBySearchState extends State<MapsPlacesBySearch> {
  String kGoogleApiKey = "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys
  CameraPosition _initalPosition;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();
    _initalPosition = CameraPosition(
        target: LatLng(
            widget.startPosition.geometry.location.lat, widget.startPosition.geometry.location.lng),
        zoom: 14.4746);
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        kGoogleApiKey,
        PointLatLng(
            widget.startPosition.geometry.location.lat, widget.startPosition.geometry.location.lng),
        PointLatLng(
            widget.endPosition.geometry.location.lat, widget.endPosition.geometry.location.lng),
        travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> _markers = {
      Marker(
        markerId: MarkerId('start'),
        position: LatLng(
            widget.startPosition.geometry.location.lat, widget.startPosition.geometry.location.lng),
      ),
      Marker(
        markerId: MarkerId('end'),
        position: LatLng(
            widget.endPosition.geometry.location.lat, widget.endPosition.geometry.location.lng),
      )
    };

    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: _initalPosition,
          markers: Set.from(_markers),
          onMapCreated: (GoogleMapController controller) {
            Future.delayed(Duration(milliseconds: 2000), () {
              controller.animateCamera(CameraUpdate.newLatLngBounds(
                  MapUtils.boundsFromLatLngList(_markers.map((loc) => loc.position).toList()), 1));
            });
            _getPolyline();
          },
          polylines: Set<Polyline>.of(polylines.values),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        buildFloatingActionBar(),
      ]),
    );
  }

  //----------------------------------Floating Action Bar-------------------------------
  //-------------------------Floating Action Bar------------------------------------
  Widget buildFloatingActionBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return FloatingSearchBar(
      automaticallyImplyBackButton: true, // to hide back button
      hint: widget.placeToGo,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      leadingActions: [
        Icon(
          Icons.search,
          color: Colors.black,
        )
      ],
      width: isPortrait ? 400 : 300,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
        //TODO: when user start typing must give him results
      },
      // Specify a custom transition to be used for animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              ///Confirm Location and go to the provid service page
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        /*Build the stack you want     */
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, MapPicker.id);
                },
                icon: Icon(Icons.location_on),
                label: Text("edit location".tr().toString()),
              ),
            ],
          ),
        );
      },
    );
  }
}

///TODO: Confirm location button and save the location
