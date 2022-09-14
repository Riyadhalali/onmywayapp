import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

class MapMyLocationAndDestination extends StatefulWidget {
// this page is for display the location of the user and his destination and give option to select the location based on map
  static const id = "map_location_destination";

  @override
  State<MapMyLocationAndDestination> createState() => _MapMyLocationAndDestinationState();
}

class _MapMyLocationAndDestinationState extends State<MapMyLocationAndDestination> {
  final myLocation = TextEditingController();

  final myDestination = TextEditingController();
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = []; // create an empty list for holding results
  DetailsResult startPosition;
  DetailsResult endPosition;
  FocusNode myLocationFocusNode;
  FocusNode myDestinationFocusNode;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String kGoogleApiKey =
        "AIzaSyA54WuN4cuPPdhHB5hW-ibaYJGF7ZB_1mE"; // google api keys project named is SARC
    googlePlace = GooglePlace(kGoogleApiKey);
    myLocationFocusNode = FocusNode();
    myDestinationFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myLocationFocusNode.dispose();
    myDestinationFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Select Route"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  focusNode: myLocationFocusNode,
                  textAlign: TextAlign.start,
                  controller: myLocation, // the variable that will contain input user data
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      setState(() {
                        // clear the results
                        predictions = [];
                        startPosition = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true, // to change the color of textinputfilled
                    prefixIcon: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    ),

                    border: InputBorder.none,
                    fillColor: Color(0xFFEFEFF3),
                    hintText: "My Location".tr().toString(),
                    //   helperText: "Please put your password",
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  focusNode: myDestinationFocusNode,
                  textAlign: TextAlign.start,
                  controller: myDestination, // the variable that will contain input user data
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      setState(() {
                        // clear the results
                        predictions = [];
                        endPosition = null;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      filled: true, // to change the color of textinputfilled
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                      border: InputBorder.none,
                      fillColor: Color(0xFFEFEFF3),
                      hintText: "My Destination".tr().toString(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.location_searching,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          ///TOOD: go to screen for picking place
                        },
                      )
                      //   helperText: "Please put your password",
                      ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Divider(
                color: Colors.black,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(predictions[index].description.toString()),
                        onTap: () async {
                          // get the place id from the predictions
                          final placeID = predictions[index].placeId;
                          // pass the place id to get the details
                          final details = await googlePlace.details.get(placeID);
                          //           //-> i think from here we can navigate to the place
                          double latNew = details.result.geometry.location.lat;
                          double lngNew = details.result.geometry.location.lng;
                          // make sure that the mylocation has been selected

                          if (details != null && details.result != null && mounted) {
                            if (myLocationFocusNode.hasFocus) {
                              setState(() async {
                                startPosition = details.result;

                                myLocation.text = details.result.name;

                                // predictions = []; // empty list when done selection
                                ///TODO: we can clear the results when we done selecting the location
                              });
                            } else {
                              endPosition = details.result;
                              myDestination.text = details.result.name;
                            }
                          }
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
