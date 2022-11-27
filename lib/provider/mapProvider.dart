import 'package:flutter/cupertino.dart';

// this class to sav
class MapProvider extends ChangeNotifier {
  final addServicePageFrom = TextEditingController(); // from
  final addServicePageTo = TextEditingController(); // to
  final searchPageFromController = TextEditingController();
  final searchPageToController = TextEditingController();

  String destinationLat;
  String destinationLng;
  String destinationFromSearchPageLat;
  String destinationFromSearchPageLng;
  String destinationToSearchPageLat;
  String destinationToSearchPageLng;
  final serviceTime = TextEditingController();
//in the add service from text field
  void addServicePageFromPlace(String value) {
    addServicePageFrom.text = value;
    // print(addServicePageFrom.text);
    notifyListeners();
  }

  //in the add service to text field
  void addServicePageToPlace(String value) {
    addServicePageTo.text = value;
    notifyListeners();
  }

  //-> in provide service date controller
  void serviceTimeProvidedService(String value) {
    serviceTime.text = value;
    notifyListeners();
  }

  //-> in search page from controller
  void searchPageFrom(String lat, String lng) {
    //  searchPageFromController.text = value; //
    destinationFromSearchPageLat = lat; //save lat and lng
    destinationFromSearchPageLng = lng; // save lat and lng
    if (lat.isNotEmpty || lat.isNotEmpty) searchPageFromController.text = "place Selected";

    notifyListeners(); // notify listeners
  }

  void searchPageTo(String lat, String lng) {
    destinationToSearchPageLat = lat;
    destinationToSearchPageLng = lng;
    if (lat.isNotEmpty && lng.isNotEmpty) searchPageToController.text = "place selected";
    notifyListeners(); // notify listeners
  }

  // to clear data when we exit
  void clearData() {
    searchPageFromController.text = "";
    searchPageToController.text = "";
    destinationFromSearchPageLat = "";
    destinationFromSearchPageLng = "";
    destinationToSearchPageLat = "";
    destinationToSearchPageLng = "";
  }
} // end  class
