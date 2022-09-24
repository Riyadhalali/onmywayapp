import 'package:flutter/cupertino.dart';

// this class to sav
class MapProvider extends ChangeNotifier {
  final addServicePageFrom = TextEditingController(); // from
  final addServicePageTo = TextEditingController(); // to
  String destinationLat;
  String destinationLng;
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
} // end  class
