import 'package:flutter/material.dart';

class Global extends ChangeNotifier {
  bool showProgressInMap = false;
  int indexToggleButtonMalefemale = 0;
  int indexToggleButtonPersonPackage = 0;
  int indexToggleButtonPublicPrivate = 0;
  void showProgress(bool value) {
    showProgressInMap = value;
    notifyListeners();
  }

//-> toggle button index in pages provide service and seek service for male and female
  void changeIndexToggleButton(int value) {
    indexToggleButtonMalefemale = value;
    notifyListeners();
  }

  //-> toggle button index in pages provide service and seek service for person and package
  void changeIndexToggleButtonPersonPackage(int value) {
    indexToggleButtonPersonPackage = value;
    notifyListeners();
  }

  //-> toggle btton index in pages provide service for public and private
  void changeIndexToggleButtonPublicPrivate(int value) {
    indexToggleButtonPublicPrivate = value;
    notifyListeners();
  }
}
