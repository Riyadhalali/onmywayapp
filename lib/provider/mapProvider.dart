import 'package:flutter/cupertino.dart';

// this class to sav
class MapProvider extends ChangeNotifier {
  final addServicePageFrom = TextEditingController(); // from
  final addServicePageTo = TextEditingController(); // to
  final searchPageFromController = TextEditingController();
  final searchPageToController = TextEditingController();

  String destinationLat;
  String destinationLng;
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
  void searchPageFrom(String value) {
    searchPageFromController.text = value;
    notifyListeners(); // notify listners
  }

  void searchPageTo(String value) {
    searchPageToController.text = value;
    notifyListeners(); // notify listners
  }
} // end  class
