import 'dart:async';

import 'package:alatareekeh/provider/global.dart';
import 'package:alatareekeh/provider/mapProvider.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/maps/map_mylocationanddestination.dart';
import 'package:alatareekeh/utils/utils.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

// map picker search page to

class MapPickerSearchTo extends StatefulWidget {
  static const id = 'map_picker_to';
  double latitudePassed, longitudePassed;
  bool placeFromOrTo;
  String appointmentId;

  MapPickerSearchTo(
      {this.appointmentId, this.latitudePassed, this.longitudePassed, this.placeFromOrTo});
  @override
  _MapPickerSearchToState createState() => _MapPickerSearchToState();
}

class _MapPickerSearchToState extends State<MapPickerSearchTo> {
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
  GooglePlace googlePlace;
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();
  List<AutocompletePrediction> predictions = []; // create an empty list for holding results
  DetailsResult startPosition;
  DetailsResult endPosition;
  FocusNode startFocusNode;
  FocusNode endFocusNode;
  LatLng currentLocation;
  LatLng destinationLocation;
  final wheretoGo = TextEditingController();
  FocusNode focusNode;
  String placeId, placeName;

  //-----------------------Functions----------------------------------------
  Future<Position> getDeviceLocation() async {
    // rootBundle.loadString('assets/resources/mapStyle/mapstyle.txt').then((string) {
    //   _mapStyle = string;
    // });
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //-> method 1 : when i tried to use this method on i get errors
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
    //     .then((Position position) {
    //   //-> wrong to say set state because it will keep updating
    //   currentPosition = position;
    //
    //   print("PRINTING LOCATION:${position.longitude} , ${position.latitude}");
    // }).catchError((e) {
    //   print(e);
    // });

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    currentPosition = position; // must update this line

    _markers.add(Marker(
        //  icon: Icon(Icons.location_on),
        onTap: () {
          //todo: set location here
        },
        infoWindow: InfoWindow(title: 'set location'),
        position: LatLng(position.latitude, position.longitude),
        markerId: MarkerId("Location".tr().toString())));

    return position;
  }

  // function to search in google places
  void autoCompleteSearch(String value) async {
    var results = await googlePlace.autocomplete.get(value);
    if (results != null && results.predictions != null && mounted) {
      setState(() {
        // print(results.predictions!.first.description);
        predictions = results.predictions; // to make sure it is not null
      });
    }
  }

//--------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    String kGoogleApiKey =
        "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys project named is SARC
    googlePlace = GooglePlace(kGoogleApiKey);
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
    focusNode = FocusNode();

    //-> init show modal bottom sheet
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 55.0, right: 55.0),
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        // do something when text field is selected
                        Navigator.pushReplacementNamed(context, MapMyLocationAndDestination.id);
                        //TODO: pass my location to the page
                      },
                      child: TextFormField(
                        focusNode: focusNode, //  autofocus: true,
                        textAlign: TextAlign.start,
                        controller: wheretoGo, // the variable that will contain input user data
                        decoration: InputDecoration(
                          filled: true, // to change the color of textinputfilled

                          border: InputBorder.none,
                          fillColor: Color(0xFFEFEFF3),
                          hintText: "wheretogo".tr().toString(),
                          //   helperText: "Please put your password",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // mapController.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
    focusNode.dispose();
  }

  final _controllerPush =
      ScrollController(); // controller for pushing content up when user selects the text field

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDeviceLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildMap();
            // } else if (snapshot.hasError) {
            //   return Center(child: Text("Something wrong!${snapshot.error}"));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  //------------------------Map----------------------------------------------------
  Widget buildMap() {
    MapProvider mapProvider = Provider.of<MapProvider>(context);
    return LayoutBuilder(builder: (context, constraints) {
      Global globalProvider = Provider.of<Global>(context);
      var maxWidth = constraints.biggest.width;
      var maxHeight = constraints.biggest.height;
      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    onTap: (latlng) {},
                    mapType: MapType
                        .terrain, // if your using styles you must delete this line because it will override the styles
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
                      //   controller.setMapStyle(_mapStyle);
                    },
                    onCameraMove: (CameraPosition newPosition) {
                      DESTINATION_LOCATION = newPosition.target;
                      //    print("destination new is : ${DESTINATION_LOCATION}");
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
                    // the icon on screen
                    bottom: maxHeight / 2,
                    right: (maxWidth - 30) / 2,
                    child: const Icon(
                      Icons.location_on,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    left: 10,
                    // right: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                        onPressed: () async {
                          //TODO: save the location to provider,and pass of user that wants to go to
                          print(DESTINATION_LOCATION);
                          Utils utils = new Utils();
                          //must use vpn to work
                          //-> using Google APi geocoding
                          try {
                            placeId = await WebServices.getAddressFromCordinates(
                                "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE",
                                DESTINATION_LOCATION.latitude.toString(),
                                DESTINATION_LOCATION.longitude.toString());
                            //  print(placeId);
                            //-> get the place name using google api place id but we must get the place id
                            placeName = await WebServices.getPlaceNameBasedInPlaceId(
                                placeId, "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE");
                            //-> here i already saved the lat and long and i get the place id
                            utils.toastMessage(placeName);
                          } catch (error) {
                            utils.toastMessage(error); // display the error message
                          }
                          //-> this method is using geocoding package
//                           try {
//                             List<Placemark> placemarks = await placemarkFromCoordinates(
//                               DESTINATION_LOCATION.latitude,
//                               DESTINATION_LOCATION.longitude,
//                             );
//                             print(placemarks[0]);
//                             //    utils.toastMessage(placemarks[0].name.toString());
//                           } catch (error) {
//                             utils.toastMessage(error);
//                           }

                          mapProvider.searchPageTo(placeName);

                          Navigator.of(context).pop(); // to be in the provide service page
                        },
                        child: Text("Confirm Location")),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

//-> didn't used it
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
