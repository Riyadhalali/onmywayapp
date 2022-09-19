import 'package:flutter/cupertino.dart';

// this class to sav
class MapProvider extends ChangeNotifier {
  final addServicePageFrom = TextEditingController();

  void addServicePageFromPlace(String value) {
    addServicePageFrom.text = value;
    print(addServicePageFrom.text);
    notifyListeners();
  }
} // end  class
