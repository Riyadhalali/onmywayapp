import 'dart:async';

import 'package:alatareekeh/ui/search.dart';
import 'package:alatareekeh/ui/searchresults.dart';
import 'package:custom_info_window/custom_info_window.dart';
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
  BitmapDescriptor icon; // for custom marker
  FloatingSearchBarController _floatingSearchBarController = new FloatingSearchBarController();
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

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
//--------------------------------------------------------------------------------------------------
  //-> get the location of this device
  void getDeviceLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double longitude_data = position.longitude;
    double latitude_data = position.latitude;
    setState(() {
      lat = latitude_data;
      long = longitude_data;
      // print('lat is:$lat');
    });

    //-> creating custom icon for marker
    var iconMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), "assets/ui/icon/person_male.png");
    setState(() {
      this.icon = iconMarker;
      //print('marker is: $iconMarker');
    });

    //add marker to map
    _markers.add(
      Marker(
          // icon: BitmapDescriptor.defaultMarkerWithHue(
          //     BitmapDescriptor.hueYellow), // change color of the marker
          icon: icon,
          markerId: MarkerId('Location'.tr().toString()),
          position: LatLng(lat, long),
          // infoWindow: InfoWindow(
          //   title: 'Location'.tr().toString(),
          // ),
          onTap: () {
            //-> here we add the widget of the custom window
            _customInfoWindowController.addInfoWindow(markerTabInfo(), LatLng(lat, long));
          }),
    );
  }

//--------------------------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //-> load the map customize
    rootBundle.loadString('assets/resources/mapStyle/mapstyle.txt').then((string) {
      _mapStyle = string;
    });

    getDeviceLocation(); //get the location and marker icon
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: null,
        extendBodyBehindAppBar: true, // to set the
        body: Stack(
          fit: StackFit.expand,
          children: [
            buildMap(),
            buildFloatingActionBar(),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.30,
              offset: 100, // the space between the info window and marker
            )
          ],
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
            zoomControlsEnabled: false, // to delete the minus and plus control in map

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
              // change style of controller

              controller.setMapStyle(_mapStyle);
            },
            // hide CustomInfoWindow when clicking on map but not on the marker.
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow();
            },
            //maintain CustomInfoWindow's position relative to marker
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove();
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
        //TODO: when user start typing must give him results
      },
      // Specify a custom transition to be used for animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, SearchResults.id);
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
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, Search.id);
                },
                icon: Icon(Icons.search),
                label: Text("go to search page".tr().toString()),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, Search.id);
                },
                icon: Icon(Icons.location_on),
                label: Text("select location on map".tr().toString()),
              ),
            ],
          ),
        );
      },
    );
  }

  //------------------------- Widget Info Window  Marker--------------------------------------
  Widget markerInfo() {
    return Stack(
        clipBehavior: Clip
            .none, // to make the image visible we can also use Clip.EdgeHard to to make image not visible and get cutted
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          //------------------------------------First child-----------------------------------
          Positioned.fill(
            // to fill the stack
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Name:'),
                      // Expanded(child: Text('Phone: ')),
                      Text('Gender:'),
                      //  Expanded(child: Text('Country:')),
                      Text('City:'),
                      Text('Date:'),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.phone,
                                color: Colors.black,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.message,
                                color: Colors.black,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.black,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          //-----------------------------Second Child-----------------------------------------------
          Positioned(top: -35, child: profileImage()),
        ]);
  }

//-----------------------Profile Picture  ----------------------------------------------
  Widget profileImage() {
    return InkWell(
      onTap: () async {
        //do something
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 75.0, left: 75.0),
        child: Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.50)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: ClipOval(
                child: Image.asset(
                  'assets/ui/icon/icon2.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //-------------------------------Main Tab for opening the custom info window
  Widget markerTabInfo() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                //-> show dialog for opening the container
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        child: markerInfo(),
                      );
                    });
              },
              icon: Icon(Icons.account_circle)),
          IconButton(
              onPressed: () {
                //-> show dialog for opening the container
              },
              icon: Icon(Icons.add_circle))
        ],
      ),
    );
  }

//--------------------
} // end class
//Library used : custom_info_window
